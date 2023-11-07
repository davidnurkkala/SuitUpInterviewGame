local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local EffectService = require(ServerScriptService.Server.Services.EffectService)
local Promise = require(ReplicatedStorage.Packages.Promise)
local RandomSpin = require(ReplicatedStorage.Shared.Util.RandomSpin)
local Trove = require(ReplicatedStorage.Packages.Trove)

local MageReflector = {}
MageReflector.__index = MageReflector

local Size = 20

function MageReflector.new(player: Player, position: Vector3)
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
	root:AddTag("MageReflector")
	root.Parent = model

	-- normally I'd have a lookup table of all MageReflector objects,
	-- but in this "game jam" context this is faster and not entirely unsafe
	-- generally don't like having tons of sources of truth in the DataModel
	local tag = Instance.new("ObjectValue")
	tag.Name = "Player"
	tag.Value = player
	tag.Parent = root

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
