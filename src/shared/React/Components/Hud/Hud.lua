local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Container = require(ReplicatedStorage.Shared.React.Components.Common.Container)
local Label = require(ReplicatedStorage.Shared.React.Components.Common.Label)
local ManaBar = require(ReplicatedStorage.Shared.React.Components.Hud.ManaBar)
local PaddingAll = require(ReplicatedStorage.Shared.React.Components.Common.PaddingAll)
local React = require(ReplicatedStorage.Packages.React)

return function(props: {
	ManaPercent: number,
	Score: number,
	HighScore: number,
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

		HighScore = React.createElement(Label, {
			Size = UDim2.fromScale(0.5, 0.02),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Text = `<stroke color="#000000" thickness="1">Score: <b>{props.Score}</b> | High Score: <b>{props.HighScore}</b></stroke>`,
		}),
	})
end
