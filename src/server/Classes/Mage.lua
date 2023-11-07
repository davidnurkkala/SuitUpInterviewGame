local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local Animator = require(ReplicatedStorage.Shared.Classes.Animator)
local Comm = require(ReplicatedStorage.Packages.Comm)
local Cooldown = require(ReplicatedStorage.Shared.Classes.Cooldown)
local EffectService = require(ServerScriptService.Server.Services.EffectService)
local LoadCharacter = require(ServerScriptService.Server.Util.LoadCharacter)
local MageProjectile = require(ServerScriptService.Server.Classes.MageProjectile)
local MageReflector = require(ServerScriptService.Server.Classes.MageReflector)
local Promise = require(ReplicatedStorage.Packages.Promise)
local ResourceNumber = require(ReplicatedStorage.Shared.Classes.ResourceNumber)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)

local Mage = {}
Mage.__index = Mage

local AttackCost = 50
local ProjectileSpeed = 48
local ReflectCost = 30
local RegenRate = 35

function Mage.new(args: {
	Player: Player,
	Char: Model,
	Root: BasePart,
	Human: Humanoid,
	Animator: any,
})
	local self = setmetatable({
		Player = args.Player,
		Char = args.Char,
		Root = args.Root,
		Human = args.Human,
		Animator = args.Animator,
		Mana = ResourceNumber.new(100),
		AttackCooldown = Cooldown.new(1),
		ReflectCooldown = Cooldown.new(1),
		Trove = Trove.new(),
	}, Mage)

	-- set up comm
	self.Comm = self.Trove:Construct(Comm.ServerComm, self.Char)

	self.Comm:CreateProperty("ManaMax", self.Mana:GetMax())

	local manaProp = self.Comm:CreateProperty("Mana", self.Mana:Get())
	self.Trove:Add(self.Mana:Observe(function(amount)
		manaProp:Set(amount)
	end))

	self.Comm:CreateSignal("Attack"):Connect(function(player, targetPosition)
		if player ~= self.Player then return end
		if not t.Vector3(targetPosition) then return end

		self:Attack(targetPosition)
	end)

	self.Comm:CreateSignal("Reflect"):Connect(function(player)
		if player ~= self.Player then return end

		self:Reflect()
	end)

	-- set up updater
	self.Trove:Connect(RunService.Heartbeat, function(dt)
		self:Update(dt)
	end)

	-- add tag now that everything's good to go
	self.Char:AddTag("Mage")

	return self
end

function Mage.promised(player: Player)
	return LoadCharacter(player):andThen(function(char)
		return Promise.new(function(resolve, reject, onCancel)
			local root = char:WaitForChild("HumanoidRootPart", 5)
			if onCancel() then return end
			if not root then reject("Missing root") end

			local human = char:WaitForChild("Humanoid", 5)
			if onCancel() then return end
			if not human then reject("Missing human") end

			resolve(root, human)
		end):andThen(function(root, human)
			return Mage.new({
				Player = player,
				Char = char,
				Root = root,
				Human = human,
				Animator = Animator.new(human),
			})
		end)
	end)
end

function Mage:Attack(position: Vector3)
	if not self.Mana:Has(AttackCost) then return end

	if not self.AttackCooldown:IsReady() then return end

	self.AttackCooldown:Use()
	self.Mana:Adjust(-AttackCost)

	EffectService:Effect(self.Player, "FaceTowards", { Root = self.Root, Point = position })

	self.Animator:Play("Cast", 0)

	Promise.delay(0.05):andThen(function()
		local here = self.Char.RightHand.Position
		local direction = (position - here).Unit
		local velocity = direction * ProjectileSpeed
		MageProjectile.new(self.Player, here, velocity)
	end)
end

function Mage:Reflect()
	if not self.Mana:Has(ReflectCost) then return end

	if not self.ReflectCooldown:IsReady() then return end

	self.ReflectCooldown:Use()
	self.Mana:Adjust(-ReflectCost)

	self.Animator:Play("Reflect", 0)

	MageReflector.new(self.Root.Position)
end

function Mage:Update(dt: number)
	self.Mana:Adjust(RegenRate * dt)
end

function Mage:Destroy()
	self.Trove:Clean()
end

return Mage
