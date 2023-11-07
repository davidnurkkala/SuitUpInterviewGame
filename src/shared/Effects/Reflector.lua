local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Animate = require(ReplicatedStorage.Shared.Util.Animate)

return function(args: {
	Reflector: BasePart,
})
	local part = args.Reflector

	local zero = Vector3.zero
	local size = part.Size
	local bigger = size * 1.1

	Animate(0.1, function(scalar)
		part.Size = zero:Lerp(size, scalar)
	end):andThenCall(Animate, 0.4, function(scalar)
		part.Size = size:Lerp(bigger, scalar)
	end)
end
