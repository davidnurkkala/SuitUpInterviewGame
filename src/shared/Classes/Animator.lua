local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AnimationDefs = require(ReplicatedStorage.Shared.Defs.AnimationDefs)
local Animator = {}
Animator.__index = Animator

function Animator.new(controller: Humanoid | AnimationController)
	local self = setmetatable({
		Controller = controller,
		Tracks = {},
	}, Animator)

	return self
end

function Animator:Play(name, ...)
	if not self.Tracks[name] then
		local animation = AnimationDefs[name]
		assert(animation, `Missing animation {name}`)

		self.Tracks[name] = self.Controller:LoadAnimation(animation)
	end

	self.Tracks[name]:Play(...)
end

function Animator:Stop(name, ...)
	if not self.Tracks[name] then return end

	self.Tracks[name]:Stop(...)
end

function Animator:StopHard(name)
	local track = self.Tracks[name]

	if not track then return end

	track:Stop(0)
	track:AdjustWeight(0)
end

function Animator:StopHardAll()
	for name in self.Tracks do
		self:StopHard(name)
	end
end

function Animator:Destroy()
	self:StopHardAll()
end

return Animator
