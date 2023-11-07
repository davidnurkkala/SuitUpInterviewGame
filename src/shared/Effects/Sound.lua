local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Packages.Promise)
local SoundDefs = require(ReplicatedStorage.Shared.Defs.SoundDefs)
local Trove = require(ReplicatedStorage.Packages.Trove)

return function(args: {
	Name: string,
	Target: Part | Attachment | Vector3,
})
	local trove = Trove.new()

	local sound = SoundDefs[args.Name]
	assert(sound, `No sound by name {args.Name}`)
	sound = trove:Clone(sound)

	local target = args.Target

	if typeof(target) == "Vector3" then
		local point = trove:Construct(Instance, "Attachment")
		point.Position = target
		point.Parent = workspace.Terrain
		target = point
	end

	sound.Parent = target
	sound:Play()

	Promise.new(function(resolve, _, onCancel)
		while sound.TimeLength == 0 do
			task.wait()
			if onCancel() then return end
		end
		resolve(sound.TimeLength)
	end)
		:timeout(5)
		:andThen(function(timeLength)
			return Promise.delay(timeLength)
		end, function()
			--no op
		end)
		:finallyCall(trove.Clean, trove)
end
