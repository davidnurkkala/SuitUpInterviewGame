local Players = game:GetService("Players")

return function(point: Vector3, range): (Model?, number?)
	local bestTarget = nil
	local bestDistance = range or math.huge

	for _, player in Players:GetPlayers() do
		if not player.Character then continue end
		if not player.Character.PrimaryPart then continue end

		local distance = (player.Character.PrimaryPart.Position - point).Magnitude
		if distance <= bestDistance then
			bestTarget = player.Character
			bestDistance = distance
		end
	end

	if bestTarget then
		return bestTarget, bestDistance
	else
		return nil, nil
	end
end
