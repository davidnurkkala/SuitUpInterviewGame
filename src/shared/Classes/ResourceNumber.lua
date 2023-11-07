local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.Packages.Signal)
local ResourceNumber = {}
ResourceNumber.__index = ResourceNumber

function ResourceNumber.new(max: number)
	local self = setmetatable({
		Max = max,
		Amount = max,
		Changed = Signal.new(),
	}, ResourceNumber)

	return self
end

function ResourceNumber:Set(amount: number)
	amount = math.clamp(amount, 0, self:GetMax())

	if amount == self.Amount then return end

	self.Amount = amount
	self.Changed:Fire(self.Amount)
end

function ResourceNumber:Get()
	return self.Amount
end

function ResourceNumber:GetMax()
	return self.Max
end

function ResourceNumber:Has(amount: number)
	return self:Get() >= amount
end

function ResourceNumber:Adjust(delta: number)
	self:Set(self:Get() + delta)
end

function ResourceNumber:Observe(callback)
	local connection = self.Changed:Connect(callback)
	callback(self:Get())
	return function()
		connection:Disconnect()
	end
end

function ResourceNumber:Destroy() end

return ResourceNumber
