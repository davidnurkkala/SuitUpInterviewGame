local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Frame = require(ReplicatedStorage.Shared.React.Components.Common.Frame)
local Label = require(ReplicatedStorage.Shared.React.Components.Common.Label)
local PaddingAll = require(ReplicatedStorage.Shared.React.Components.Common.PaddingAll)
local React = require(ReplicatedStorage.Packages.React)

return function(props: {
	Percent: number,
})
	return React.createElement(Frame, {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0),
	}, {
		Padding = React.createElement(PaddingAll, {
			Padding = UDim.new(0, 2),
		}),

		Bar = React.createElement(Frame, {
			Size = UDim2.fromScale(props.Percent, 1),
			BackgroundColor3 = BrickColor.new("Cyan").Color,
		}),

		Text = React.createElement(Label, {
			ZIndex = 4,
			Text = `<stroke color="#000000" thickness="1"><b>Left mouse</b> to cast, <b>E</b> to reflect</stroke>`,
		}),
	})
end
