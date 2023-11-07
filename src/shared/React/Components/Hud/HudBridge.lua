local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Comm = require(ReplicatedStorage.Packages.Comm)
local Hud = require(ReplicatedStorage.Shared.React.Components.Hud.Hud)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Promise = require(ReplicatedStorage.Packages.Promise)
local React = require(ReplicatedStorage.Packages.React)
local Trove = require(ReplicatedStorage.Packages.Trove)

return function()
	local manaMax, setManaMax = React.useState(1)
	local mana, setMana = React.useState(0)

	React.useEffect(function()
		return Observers.observeTag("Mage", function(char: Model)
			local trove = Trove.new()

			trove
				:AddPromise(Promise.try(function()
					return trove:Construct(Comm.ClientComm, char, true)
				end))
				:andThen(function(comm)
					comm:GetProperty("ManaMax"):Observe(setManaMax)
					comm:GetProperty("Mana"):Observe(setMana)
				end)

			return function()
				trove:Clean()
			end
		end, { workspace })
	end, {})

	return React.createElement(Hud, {
		ManaPercent = mana / manaMax,
	})
end
