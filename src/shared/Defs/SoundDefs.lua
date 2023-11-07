local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)

local Sounds = {
	Cast = "rbxassetid://15289555596",
	EnemyProjectile = "rbxassetid://15289555627",
	Reflect = "rbxassetid://15289555528",
	Bounce = "rbxassetid://15289555657",
	Explosion = "rbxassetid://15289555698",
}

return Sift.Dictionary.map(Sounds, function(id, name)
	local sound = Instance.new("Sound")
	sound.Name = name
	sound.SoundId = id
	return sound, name
end)
