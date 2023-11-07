local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Container = require(ReplicatedStorage.Shared.React.Components.Common.Container)
local ManaBar = require(ReplicatedStorage.Shared.React.Components.Hud.ManaBar)
local PaddingAll = require(ReplicatedStorage.Shared.React.Components.Common.PaddingAll)
local React = require(ReplicatedStorage.Packages.React)

return function(props: {
	ManaPercent: number,
})
	return React.createElement(Container, {
		Size = UDim2.fromScale(1, 1),
	}, {
		Padding = React.createElement(PaddingAll, {
			Padding = UDim.new(0, 16),
		}),

		ManaBar = React.createElement(Container, {
			Size = UDim2.fromScale(0.5, 0.025),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.fromScale(0.5, 1),
		}, {
			BarFrame = React.createElement(ManaBar, {
				Percent = props.ManaPercent,
			}),
		}),
	})
end
