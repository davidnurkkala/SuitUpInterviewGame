return function(root: BasePart, point: Vector3)
	local delta = (point - root.Position) * Vector3.new(1, 0, 1)
	if math.max(math.abs(delta.X), math.abs(delta.Z)) < 0.01 then return end
	root.CFrame = CFrame.lookAt(root.Position, root.Position + delta)
end
