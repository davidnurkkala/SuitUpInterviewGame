local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local EffectService = require(ServerScriptService.Server.Services.EffectService)
local Promise = require(ReplicatedStorage.Packages.Promise)
local RandomSpin = require(ReplicatedStorage.Shared.Util.RandomSpin)
local Trove = require(ReplicatedStorage.Packages.Trove)

local MageReflector = {}
MageReflector.__index = MageReflector

local Size = 20

function MageReflector.new(position: Vector3)
	local self = setmetatable({
		Trove = Trove.new(),
	}, MageReflector)

	local model = self.Trove:Construct(Instance, "Model")
	model.Name = "Reflector"
	model.Parent = workspace

	local root = ReplicatedStorage.Assets.Effects.Reflector:Clone()
	root.CFrame = RandomSpin() + position
	root.Size *= Size
	root.CanCollide = false
	root.CollisionGroup = "Player"
	root.Parent = model
	self.Root = root

	self.Trove:AddPromise(Promise.delay(0.5):andThenCall(self.Destroy, self))

	EffectService:All("Reflector", {
		Reflector = root,
	})

	return self
end

function MageReflector:Destroy()
	EffectService:All("FadeReflector", {
		Reflector = self.Root,
	})

	self.Trove:Clean()
end

return MageReflector
