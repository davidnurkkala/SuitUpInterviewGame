local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local InitializeBlocking = require(ReplicatedStorage.Shared.Util.InitializeBlocking)

InitializeBlocking(ServerScriptService.Server.Services)
