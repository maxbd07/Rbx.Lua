-- Rope Constraint Floating Body Parts; exploiting network ownership.
-- Author: maxbd (maxbd07, maxbd123, 0xEB)

-- Rig Type R6 Support: true
-- Rig Type R15 Support: false



local options = {
	RopeLength = 6,
	RopeLocallyVisible = false
}



local Players = game:GetService("Players")


local PLAYER = Players.LocalPlayer



local function fA(pA)
	for lvA, lvB in next, pA.Character:GetDescendants() do
		if lvB:IsA("BasePart") and lvB.Name ~= "HumanoidRootPart" then
			lvB.CanCollide = true

			local tvA = Instance.new("BodyForce")
			tvA.Parent = lvB
			tvA.Force = Vector3.new(0, lvB:GetMass() * workspace.Gravity + 1, 0)
		end
	end
	
	for lvA, lvB in next, pA.Character:GetDescendants() do
		if lvB:IsA("Motor6D") then
			local tvA = Instance.new("Attachment")
			tvA.Parent = lvB.Part0
			
			local tvB = Instance.new("Attachment")
			tvB.Parent = lvB.Part1
			
			local tvC = Instance.new("RopeConstraint")
			tvC.Parent = lvB.Part0
			tvC.Attachment0 = tvA
			tvC.Attachment1 = tvB
			tvC.Length = options.RopeLength
			tvC.Visible = options.RopeLocallyVisible
			
			if lvB.Name ~= "Neck" then 
				lvB:Destroy() 
			end
		end
	end
end



fA(PLAYER)



PLAYER.MaximumSimulationRadius = math.huge
PLAYER.SimulationRadius = math.huge