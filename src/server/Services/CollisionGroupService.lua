local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)

local CollisionGroupService = {
	Priority = -2048,
}

local CollisionsByGroup = {
	Level = { "Player" },
	Enemy = { "Player" },
	Player = { "Level", "Enemy" },
}

type CollisionGroupService = typeof(CollisionGroupService)

function CollisionGroupService:PrepareBlocking()
	for name in CollisionsByGroup do
		PhysicsService:RegisterCollisionGroup(name)
	end

	for name, nameList in CollisionsByGroup do
		for _, collidingName in nameList do
			PhysicsService:CollisionGroupSetCollidable(name, collidingName, true)
		end

		local nonCollidingNames = Sift.Array.difference(Sift.Dictionary.keys(CollisionsByGroup), nameList)
		for _, nonCollidingName in nonCollidingNames do
			PhysicsService:CollisionGroupSetCollidable(name, nonCollidingName, false)
		end
	end

	self:SetCollisionGroup(ReplicatedStorage.Assets.EnemyModels, "Enemy")
	self:SetCollisionGroup(ReplicatedStorage.Assets.Levels, "Level")
end

function CollisionGroupService:SetCollisionGroup(instance: Instance, groupName: string)
	assert(CollisionsByGroup[groupName], `Collision group name {groupName} is not registered`)

	for _, object in Sift.Array.append(instance:GetDescendants(), instance) do
		if not object:IsA("BasePart") then continue end

		object.CollisionGroup = groupName
	end
end

return CollisionGroupService
