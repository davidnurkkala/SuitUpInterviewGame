local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local App = require(ReplicatedStorage.Shared.React.Components.App)
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

local GuiController = {
	Priority = 0,
}

type GuiController = typeof(GuiController)

function GuiController:Start()
	local gui = Instance.new("ScreenGui")
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.IgnoreGuiInset = true
	gui.Name = "GameGui"
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	local root = ReactRoblox.createRoot(gui)
	root:render(React.createElement(App))
end

return GuiController
