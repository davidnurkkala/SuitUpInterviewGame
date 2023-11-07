local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trove = require(ReplicatedStorage.Packages.Trove)

local Floater = {}
Floater.__index = Floater

function Floater.new(root: BasePart, speed: number, turnSpeed: number)
	local self = setmetatable({
		Root = root,
		Trove = Trove.new(),
	}, Floater)

	local attachment = self.Trove:Construct(Instance, "Attachment")
	attachment.Name = "FloaterAttachment"
	attachment.Parent = root

	local mover = self.Trove:Construct(Instance, "AlignPosition") :: AlignPosition
	mover.Mode = Enum.PositionAlignmentMode.OneAttachment
	mover.MaxVelocity = speed
	mover.MaxForce = 1e9
	mover.RigidityEnabled = false
	mover.ApplyAtCenterOfMass = true
	mover.ForceRelativeTo = Enum.ActuatorRelativeTo.World
	mover.Position = root.Position
	mover.Attachment0 = attachment
	mover.Parent = root
	self.Mover = mover

	local turner = self.Trove:Construct(Instance, "AlignOrientation") :: AlignOrientation
	turner.Mode = Enum.OrientationAlignmentMode.OneAttachment
	turner.MaxAngularVelocity = turnSpeed
	turner.MaxTorque = 1e9
	turner.RigidityEnabled = false
	turner.CFrame = root.CFrame.Rotation
	turner.Attachment0 = attachment
	turner.Parent = root
	self.Turner = turner

	return self
end

function Floater:MoveTo(cframe: CFrame)
	self.Mover.Position = cframe.Position
	self.Turner.CFrame = cframe.Rotation
end

function Floater:MoveTowards(position)
	local cframe = CFrame.lookAt(self.Root.Position, position)
	self:MoveTo(cframe.Rotation + position)
end

function Floater:Destroy()
	self.Trove:Clean()
end

return Floater
