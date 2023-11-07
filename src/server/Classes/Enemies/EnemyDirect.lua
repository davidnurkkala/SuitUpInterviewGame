local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local CollisionGroupService = require(ServerScriptService.Server.Services.CollisionGroupService)
local EffectService = require(ServerScriptService.Server.Services.EffectService)
local Floater = require(ServerScriptService.Server.Classes.Floater)
local GetNearestPlayerCharacter = require(ServerScriptService.Server.Util.GetNearestPlayerCharacter)
local Trove = require(ReplicatedStorage.Packages.Trove)

local EnemyDirect = {}
EnemyDirect.__index = EnemyDirect

local AttackDamage = 50

function EnemyDirect.new(cframe: CFrame)
	local self = setmetatable({
		Trove = Trove.new(),
		Active = true,
	}, EnemyDirect)

	local model = ReplicatedStorage.Assets.EnemyModels.Direct:Clone()
	model:AddTag("Enemy")
	model.Destroying:Connect(function()
		self:Destroy()
	end)
	self.Model = model

	local root = model.PrimaryPart
	self.Trove:Connect(root.Touched, function(part: BasePart)
		if part:HasTag("MageProjectile") and part:GetAttribute("State") == "Direct" then
			self:Destroy()
		else
			local char = part.Parent
			local human = char and char:FindFirstChild("Humanoid")
			if human then
				human:TakeDamage(AttackDamage)
				self:Destroy()
			end
		end
	end)
	root.Parent = model
	root.CFrame = cframe
	self.Root = root

	local floater = Floater.new(root, 12, 90)
	self.Floater = floater

	model.Parent = workspace

	self.Trove:Add(function()
		EffectService:All("Explosion", {
			Position = root.Position,
			Color = Color3.new(1, 0, 0),
		})

		EffectService:All("Sound", { Name = "Explosion", Target = root })

		floater:Destroy()
		CollisionGroupService:SetCollisionGroup(model, "Debris")
		task.delay(3, model.Destroy, model)
	end)

	self.Trove:Connect(RunService.Heartbeat, function(dt)
		self:Update(dt)
	end)

	return self
end

function EnemyDirect:Update(dt)
	local target = GetNearestPlayerCharacter(self.Root.Position)
	if target then self.Floater:MoveTowards(target.PrimaryPart.Position) end
end

function EnemyDirect:Destroy()
	self.Trove:Clean()
end

return EnemyDirect
