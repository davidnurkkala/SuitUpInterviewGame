local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HudBridge = require(ReplicatedStorage.Shared.React.Components.Hud.HudBridge)
local React = require(ReplicatedStorage.Packages.React)

return function()
	return React.createElement(React.Fragment, nil, {
		Hud = React.createElement(HudBridge),
	})
end
