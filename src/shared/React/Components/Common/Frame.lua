local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local Sift = require(ReplicatedStorage.Packages.Sift)

local DefaultProps = {
	BorderSizePixel = 0,
}

return function(props)
	return React.createElement("Frame", Sift.Dictionary.merge(DefaultProps, props))
end
