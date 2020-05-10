local options = {
	RopeLength = 5,
	UpwardForceOffset = 10,
	AccessoryHandlesCanCollide = true,
	RopeLocallyVisible = false,

	IgnorableAccessories = {
		"PeanutbutterSparkletimeHair",
		"VoidScythe"
	}
}



local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")


local PLAYER = Players.LocalPlayer
local CHARACTER = PLAYER.Character or PLAYER.CharacterAdded:Wait()
local HUMANOID = CHARACTER:WaitForChild("Humanoid")



function fA(pA, pB)
	if table.getn(pA) > 0 then
		for lvA, lvB in next, pA do
			if lvB == pB then
				return true
			end
		end
	end

	return false
end



for lvA, lvB in next, HUMANOID:GetAccessories() do
	if not fA(options.IgnorableAccessories, lvB.Name) and lvB:FindFirstChild("Handle") then
		local tvA = lvB.Handle

		tvA.CanCollide = options.AccessoryHandlesCanCollide
		tvA:BreakJoints()

		tvA.Parent = workspace
		lvB.Parent = Lighting

		local tvB = Instance.new("BodyForce")
		tvB.Parent = tvA
		tvB.Force = Vector3.new(0, tvA:GetMass() * workspace.Gravity + options.UpwardForceOffset, 0)

		local tvC = Instance.new("Attachment")
		tvC.Parent = CHARACTER.Head

		local tvD = Instance.new("Attachment")
		tvD.Parent = tvA

		local tvE = Instance.new("RopeConstraint")
		tvE.Parent = CHARACTER.Head
		tvE.Length = options.RopeLength
		tvE.Visible = options.RopeLocallyVisible
		tvE.Attachment0 = tvC
		tvE.Attachment1 = tvD
	end
end



PLAYER.MaximumSimulationRadius = math.huge
PLAYER.SimulationRadius = math.huge