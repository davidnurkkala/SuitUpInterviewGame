local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)

local Animations = {
	Cast = 15288353093,
	Reflect = 15288360191,
}

return Sift.Dictionary.map(Animations, function(id, name)
	local animation = Instance.new("Animation")
	animation.Name = name
	animation.AnimationId = `rbxassetid://{id}`
	return animation, name
end)
