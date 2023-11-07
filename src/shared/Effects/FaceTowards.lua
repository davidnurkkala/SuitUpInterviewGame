local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Animate = require(ReplicatedStorage.Shared.Util.Animate)
local FaceTowardsHelper = require(ReplicatedStorage.Shared.Util.FaceTowardsHelper)

local Promise = nil

return function(args: {
	Root: BasePart,
	Point: Vector3,
})
	if Promise then
		Promise:cancel()
		Promise = nil
	end

	Promise = Animate(0.25, function()
		FaceTowardsHelper(args.Root, args.Point)
	end):andThen(function()
		Promise = nil
	end)
end
