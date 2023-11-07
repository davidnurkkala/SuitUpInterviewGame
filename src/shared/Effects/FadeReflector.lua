local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Animate = require(ReplicatedStorage.Shared.Util.Animate)
return function(args: {
	Reflector: BasePart,
})
	local part = args.Reflector:Clone()
	part.Parent = workspace

	args.Reflector:Destroy()

	local size = part.Size
	local smaller = size * 0.9

	Animate(0.2, function(scalar)
		part.Transparency = scalar
		part.Size = size:Lerp(smaller, scalar)
	end):finally(function()
		part:Destroy()
	end)
end
