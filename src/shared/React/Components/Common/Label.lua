local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)

local DefaultProps = {
	TextScaled = true,
	Size = UDim2.fromScale(1, 1),
	RichText = true,
	Font = Enum.Font.Gotham,
	BackgroundTransparency = 1,
	TextColor3 = Color3.new(1, 1, 1),
}

return function(props)
	return React.createElement("TextLabel", Sift.Dictionary.merge(DefaultProps, props))
end
