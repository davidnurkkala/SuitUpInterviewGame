local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Comm = require(ReplicatedStorage.Packages.Comm)
local EffectService = {
	Priority = 0,
}

type EffectService = typeof(EffectService)

function EffectService:PrepareBlocking()
	self.Comm = Comm.ServerComm.new(ReplicatedStorage, "Effect")

	self.EffectRemote = self.Comm:CreateSignal("EffectRequested")
end

function EffectService:Effect(player, name, args)
	self.EffectRemote:Fire(player, name, args)
end

function EffectService:All(name, args)
	self.EffectRemote:FireAll(name, args)
end

return EffectService
