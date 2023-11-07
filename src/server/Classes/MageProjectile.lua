local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local EffectService = require(ServerScriptService.Server.Services.EffectService)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Trove = require(ReplicatedStorage.Packages.Trove)

local MageProjectile = {}
MageProjectile.__index = MageProjectile

function MageProjectile.new(player: Player, position: Vector3, velocity: Vector3)
	local self = setmetatable({
		Trove = Trove.new(),
	}, MageProjectile)

	local model = Instance.new("Model")
	model.Name = "Projectile"
	model.Parent = workspace
	self.Model = model

	local root = Instance.new("Part")
	root.Size = Vector3.one * 0.75
	root.Shape = Enum.PartType.Ball
	root.Material = Enum.Material.Neon
	root.Position = position
	root.CollisionGroup = "Player"
	root.CustomPhysicalProperties = PhysicalProperties.new(1, 0, 1, 100, 100)
	root:AddTag("MageProjectile")

	root.Destroying:Connect(function()
		self:Destroy()
	end)

	root.Touched:Connect(function(part)
		if part.CollisionGroup == "Player" then
			if part:HasTag("MageReflector") and root:GetAttribute("State") == "Ricochet" then
				local direction = (root.Position - part.Position).Unit
				MageProjectile.new(player, root.Position, direction * root.AssemblyLinearVelocity.Magnitude):SetState("Reflect")
				EffectService:All("Sound", { Name = "Bounce", Target = root.Position })

				self:Destroy()
			end
			return
		end

		if part.CollisionGroup == "Enemy" then return end

		EffectService:All("Sound", { Name = "Bounce", Target = root.Position })

		if root:GetAttribute("State") == "Direct" then
			root:SetAttribute("State", "Ricochet")
			root.Color = Color3.new(0, 1, 0)
		end
	end)

	self.Root = root
	self:SetState("Direct")

	root.Parent = model
	model.PrimaryPart = root
	root:SetNetworkOwner(player)
	root.AssemblyLinearVelocity = velocity

	-- lift
	local point = Instance.new("Attachment")
	point.Parent = root

	local lift = Instance.new("VectorForce")
	lift.Attachment0 = point
	lift.RelativeTo = Enum.ActuatorRelativeTo.World
	lift.ApplyAtCenterOfMass = true
	lift.Force = Vector3.new(0, root.Mass * workspace.Gravity, 0)
	lift.Parent = model

	-- trail
	local top = Instance.new("Attachment")
	top.Position = Vector3.new(0, 0.3, 0)
	top.Parent = root

	local bot = Instance.new("Attachment")
	bot.Position = Vector3.new(0, -0.3, 0)
	bot.Parent = root

	local trail = ReplicatedStorage.Assets.Trails.Projectile:Clone()
	trail.Attachment0 = top
	trail.Attachment1 = bot
	trail.Parent = root

	Observers.observeProperty(root, "Color", function(color)
		trail.Color = ColorSequence.new(color)
	end)

	-- timeout
	self.Trove:AddPromise(Promise.delay(3):andThenCall(self.Destroy, self))

	-- fade when destroyed
	self.Trove:Add(function()
		root.Anchored = true
		root.CanCollide = false
		root.CanTouch = false
		root.CanQuery = false
		root.Transparency = 1

		trail.Enabled = false

		task.delay(trail.Lifetime, model.Destroy, model)
	end)

	return self
end

function MageProjectile:SetState(state: "Direct" | "Ricochet" | "Reflect")
	self.Root:SetAttribute("State", state)
	if state == "Direct" then
		self.Root.Color = Color3.new(1, 0, 0)
	elseif state == "Ricochet" then
		self.Root.Color = Color3.new(0, 1, 0)
	else
		self.Root.Color = Color3.new(0, 0, 1)
	end
end

function MageProjectile:Destroy()
	self.Trove:Clean()
end

return MageProjectile
