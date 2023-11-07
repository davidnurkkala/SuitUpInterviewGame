local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Comm = require(ReplicatedStorage.Packages.Comm)
local Sift = require(ReplicatedStorage.Packages.Sift)
local EffectController = {
	Priority = 0,
}

type EffectController = typeof(EffectController)

function EffectController:PrepareBlocking()
	local effects = Sift.Dictionary.map(ReplicatedStorage.Shared.Effects:GetChildren(), function(moduleScript)
		return require(moduleScript), moduleScript.Name
	end)

	local comm = Comm.ClientComm.new(ReplicatedStorage, true, "Effect")

	comm:GetSignal("EffectRequested"):Connect(function(name, args)
		assert(effects[name], `No effect by name {name}`)
		effects[name](args)
	end)
end

return EffectController
