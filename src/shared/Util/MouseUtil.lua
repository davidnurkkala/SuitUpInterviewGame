local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local MouseUtil = {}

function MouseUtil.Raycast(): { Instance: Instance?, Position: Vector3, Normal: Vector3 }
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = { Players.LocalPlayer.Character }

	local mousePosition = UserInputService:GetMouseLocation()
	local ray = workspace.CurrentCamera:ViewportPointToRay(mousePosition.X, mousePosition.Y)

	local origin = ray.Origin
	local direction = ray.Direction
	local length = 512

	local result = workspace:Raycast(origin, direction * length, params)

	if result then
		return {
			Instance = result.Instance,
			Position = result.Position,
			Normal = result.Normal,
		}
	else
		return {
			Instance = nil,
			Position = origin + direction * length,
			Normal = -direction,
		}
	end
end

return MouseUtil
