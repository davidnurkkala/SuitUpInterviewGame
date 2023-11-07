local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)

return function(props: {
	Padding: UDim,
})
	return React.createElement("UIPadding", {
		PaddingTop = props.Padding,
		PaddingBottom = props.Padding,
		PaddingLeft = props.Padding,
		PaddingRight = props.Padding,
	})
end
