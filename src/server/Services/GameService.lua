local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Mage = require(ServerScriptService.Server.Classes.Mage)
local Observers = require(ReplicatedStorage.Packages.Observers)

local GameService = {
	Priority = 0,
}

type GameService = typeof(GameService)

function GameService:PrepareBlocking() end

function GameService:Start()
	local level = ReplicatedStorage.Assets.Levels.Level1:Clone()
	level:PivotTo(CFrame.new())
	level.Parent = workspace

	Observers.observePlayer(function(player)
		local promise = Mage.promised(player)

		return function()
			promise:cancel()
		end
	end)
end

return GameService
