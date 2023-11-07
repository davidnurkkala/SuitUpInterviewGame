local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ResourceNumber = require(ReplicatedStorage.Shared.Classes.ResourceNumber)
local Trove = require(ReplicatedStorage.Packages.Trove)

local Cooldown = {}
Cooldown.__index = Cooldown

function Cooldown.new(duration: number, charges: number?)
	local self = setmetatable({
		Duration = duration,
		Charge = ResourceNumber.new(duration * (charges or 1)),
		Trove = Trove.new(),
	}, Cooldown)

	self.Trove:Connect(RunService.Heartbeat, function(dt)
		self:Update(dt)
	end)

	return self
end

function Cooldown:IsReady()
	return self.Charge:Get() >= self.Duration
end

function Cooldown:Use()
	self.Charge:Adjust(-self.Duration)
end

function Cooldown:Update(dt)
	self.Charge:Adjust(dt)
end

function Cooldown:Destroy()
	self.Trove:Clean()
end

return Cooldown
