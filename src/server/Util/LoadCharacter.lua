local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CollisionGroupService = require(ServerScriptService.Server.Services.CollisionGroupService)
local Promise = require(ReplicatedStorage.Packages.Promise)

return function(player: Player)
	return Promise.new(function(resolve, _, onCancel)
		player:LoadCharacter()
		if onCancel() then return end

		local char = player.Character
		while not char:IsDescendantOf(workspace) do
			task.wait()
		end
		if onCancel() then return end

		CollisionGroupService:SetCollisionGroup(char, "Player")

		resolve(char)
	end)
end
