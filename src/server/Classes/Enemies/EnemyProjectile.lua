local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local MageProjectile = require(ServerScriptService.Server.Classes.MageProjectile)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Trove = require(ReplicatedStorage.Packages.Trove)
local TryNow = require(ReplicatedStorage.Shared.Util.TryNow)
local EnemyProjectile = {}
EnemyProjectile.__index = EnemyProjectile

function EnemyProjectile.new(position: Vector3, velocity: Vector3, damage: number)
	local self = setmetatable({
		Trove = Trove.new(),
	}, EnemyProjectile)

	local model = Instance.new("Model")
	model.Name = "EnemyProjectile"
	model.Parent = workspace

	local root = Instance.new("Part")
	root.Position = position
	root.Shape = Enum.PartType.Ball
	root.Size = Vector3.new(1, 1, 1)
	root.Color = Color3.new(1, 0, 1)
	root.Transparency = 0.5
	root.Material = Enum.Material.Neon
	root.CollisionGroup = "Enemy"
	root.CanCollide = false

	self.Trove:Connect(root.Touched, function(part)
		if part:HasTag("MageReflector") then
			self:Destroy()

			local player = TryNow(function()
				return part.Player.Value
			end, nil)
			if not player then return end

			MageProjectile.new(player, root.Position, -velocity):SetState("Reflect")
		else
			local char = part.Parent
			local human = char and char:FindFirstChild("Humanoid")
			if not human then return end

			human:TakeDamage(damage)

			self:Destroy()
		end
	end)

	root.Parent = model

	local center = Instance.new("Attachment")
	center.Parent = root

	local mover = Instance.new("LinearVelocity")
	mover.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	mover.VectorVelocity = velocity
	mover.MaxForce = 1e9
	mover.RelativeTo = Enum.ActuatorRelativeTo.World
	mover.Attachment0 = center
	mover.Parent = root

	local emitter = ReplicatedStorage.Assets.Emitters.EnemyProjectile:Clone()
	emitter.Parent = root

	self.Trove:Add(function()
		mover.VectorVelocity = Vector3.new()
		emitter.Enabled = false
		task.delay(emitter.Lifetime.Max, model.Destroy, model)
	end)

	model.Parent = workspace
	root:SetNetworkOwner(nil)

	self.Trove:AddPromise(Promise.delay(5):andThenCall(self.Destroy, self))

	return self
end

function EnemyProjectile:Destroy()
	self.Trove:Clean()
end

return EnemyProjectile
