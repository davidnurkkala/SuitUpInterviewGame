local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Comm = require(ReplicatedStorage.Packages.Comm)
local MouseUtil = require(ReplicatedStorage.Shared.Util.MouseUtil)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Trove = require(ReplicatedStorage.Packages.Trove)
local TryNow = require(ReplicatedStorage.Shared.Util.TryNow)

local MageController = {
	Priority = 0,
}

type MageController = typeof(MageController)

function MageController:PrepareBlocking()
	Observers.observeTag("Mage", function(char: Model)
		local trove = Trove.new()

		trove
			:AddPromise(Promise.try(function()
				return trove:Construct(Comm.ClientComm, char, true)
			end))
			:andThen(function(comm)
				local attack = comm:GetSignal("Attack")
				local reflect = comm:GetSignal("Reflect")

				ContextActionService:BindAction("Attack", function(_, state)
					if state ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end

					attack:Fire(MouseUtil.Raycast().Position)

					return Enum.ContextActionResult.Sink
				end, false, Enum.UserInputType.MouseButton1)

				ContextActionService:BindAction("Reflect", function(_, state)
					if state ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end

					reflect:Fire(TryNow(function()
						return Players.LocalPlayer.Character.PrimaryPart.Position
					end, Vector3.new()))

					return Enum.ContextActionResult.Sink
				end, false, Enum.KeyCode.E)

				trove:Add(function()
					ContextActionService:UnbindAction("Attack")
					ContextActionService:UnbindAction("Reflect")
				end)
			end)

		return function()
			trove:Clean()
		end
	end, { workspace })
end

return MageController
