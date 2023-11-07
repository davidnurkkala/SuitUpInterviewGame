local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local CollisionGroupService = require(ServerScriptService.Server.Services.CollisionGroupService)
local Cooldown = require(ReplicatedStorage.Shared.Classes.Cooldown)
local EffectService = require(ServerScriptService.Server.Services.EffectService)
local EnemyProjectile = require(ServerScriptService.Server.Classes.Enemies.EnemyProjectile)
local Floater = require(ServerScriptService.Server.Classes.Floater)
local GetNearestPlayerCharacter = require(ServerScriptService.Server.Util.GetNearestPlayerCharacter)
local Trove = require(ReplicatedStorage.Packages.Trove)

local EnemyReflect = {}
EnemyReflect.__index = EnemyReflect

local AttackDamage = 25
local Range = 28

function EnemyReflect.new(cframe: CFrame)
	local self = setmetatable({
		Trove = Trove.new(),
		Active = true,
		AttackCooldown = Cooldown.new(4),
	}, EnemyReflect)

	local model = ReplicatedStorage.Assets.EnemyModels.Reflect:Clone()
	model:AddTag("Enemy")
	model.Destroying:Connect(function()
		self:Destroy()
	end)
	self.Model = model

	local root = model.PrimaryPart
	self.Trove:Connect(root.Touched, function(part: BasePart)
		if not part:HasTag("MageProjectile") then return end
		if part:GetAttribute("State") ~= "Reflect" then return end
		self:Destroy()
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
			Color = Color3.new(0, 0, 1),
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

function EnemyReflect:Update()
	local target, distance = GetNearestPlayerCharacter(self.Root.Position)
	if target then
		if distance > Range then
			self.Floater:MoveTowards(target.PrimaryPart.Position)
		else
			local here = target.PrimaryPart.Position
			local there = self.Root.Position

			local delta = (there - here)
			delta = Vector3.new(delta.X, math.max(4, delta.Y), delta.Z)
			delta = delta.Unit * Range

			self.Floater:MoveTo(CFrame.lookAt(here + delta, here))

			if self.AttackCooldown:IsReady() then
				self.AttackCooldown:Use()
				EnemyProjectile.new(self.Root.Position, self.Root.CFrame.LookVector * 32, AttackDamage)
				EffectService:All("Sound", { Name = "EnemyProjectile", Target = self.Root })
			end
		end
	end
end

function EnemyReflect:Destroy()
	self.Trove:Clean()
end

return EnemyReflect
