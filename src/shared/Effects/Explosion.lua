local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function(args: {
	Position: Vector3,
	Color: Color3,
})
	local attachment = Instance.new("Attachment")
	attachment.Position = args.Position
	attachment.Parent = workspace.Terrain

	local rays = ReplicatedStorage.Assets.Emitters.Rays:Clone()
	rays.Color = ColorSequence.new(args.Color)
	rays.Parent = attachment
	rays:Emit(1)

	local smoke = ReplicatedStorage.Assets.Emitters.Smoke:Clone()
	smoke.Color = ColorSequence.new(args.Color)
	smoke.Parent = attachment
	smoke:Emit(3)

	task.delay(1, attachment.Destroy, attachment)
end
