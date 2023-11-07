local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local EnemyDirect = require(ServerScriptService.Server.Classes.Enemies.EnemyDirect)
local EnemyReflect = require(ServerScriptService.Server.Classes.Enemies.EnemyReflect)
local EnemyRicochet = require(ServerScriptService.Server.Classes.Enemies.EnemyRicochet)
local Mage = require(ServerScriptService.Server.Classes.Mage)
local Observers = require(ReplicatedStorage.Packages.Observers)
local PickRandom = require(ReplicatedStorage.Shared.Util.PickRandom)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Sift = require(ReplicatedStorage.Packages.Sift)

local GameService = {
	Priority = 0,
	Score = 0,
	HighScore = 0,
}

type GameService = typeof(GameService)

local EnemyClasses = { EnemyDirect, EnemyRicochet, EnemyReflect }

function GameService:Start()
	local level = ReplicatedStorage.Assets.Levels.Level1:Clone()
	level:PivotTo(CFrame.new())

	local enemySpawnPoints = Sift.Array.map(level.Spawns:GetChildren(), function(part)
		local position = part.Position
		part:Destroy()
		return position
	end)

	level.Parent = workspace

	-- spawn players
	Observers.observePlayer(function(player)
		local promise = self:SpawnPlayer(player):catch(warn)

		return function()
			promise:cancel()
		end
	end)

	-- count up the score
	task.spawn(function()
		while true do
			self.Score += 1
			self.HighScore = math.max(self.HighScore, self.Score)

			-- would really prefer to do this with a comm, but
			-- this is fast for the "game jam" attitude of this test
			workspace:SetAttribute("Score", self.Score)
			workspace:SetAttribute("HighScore", self.HighScore)

			task.wait(1)
		end
	end)

	-- spawn enemies
	task.spawn(function()
		task.wait(5)

		while true do
			local position = PickRandom(enemySpawnPoints)
			local cframe = CFrame.Angles(0, math.pi * 2 * math.random(), 0) + position

			PickRandom(EnemyClasses).new(cframe)

			task.wait(self:GetSpawnTime())
		end
	end)
end

function GameService:GetSpawnTime()
	return math.max(2, 5 - (self.Score / 60))
end

function GameService:SpawnPlayer(player)
	if not player:IsDescendantOf(game) then return Promise.reject("Player left game") end

	return Mage.promised(player):andThen(function(mage)
		mage.Destroyed:Connect(function()
			self.Score = 0

			-- would probably be better to have a central registry of all
			-- enemies that I can read from and call `Destroy` on directly,
			-- but this will work fine enough since strapped for time
			for _, enemyModel in CollectionService:GetTagged("Enemy") do
				enemyModel:Destroy()
			end

			Promise.delay(3)
				:andThen(function()
					return self:SpawnPlayer(player)
				end)
				:catch(warn)
		end)
	end)
end

return GameService
