local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Promise = require(ReplicatedStorage.Packages.Promise)
return function(duration, callback)
	callback(0)

	local timer = 0
	return Promise.fromEvent(RunService.Heartbeat, function(dt)
		timer = math.min(timer + dt, duration)

		callback(timer / duration)

		return timer == duration
	end)
end
