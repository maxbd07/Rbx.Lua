-- Rope Constraint Floating Body Parts; exploiting network ownership.
-- Author: maxbd (maxbd07, maxbd123, 0xEB)

-- Rig Type R6 Support: true
-- Rig Type R15 Support: true



local options = {
	RopeLength = 6,
	UpwardForceOffset = 3,
	RopeLocallyVisible = false,
	HumanoidRootPartLocallyVisible = false,
	
	
	HotKeys = {
		Lengthen = Enum.KeyCode.E,
		Shorten = Enum.KeyCode.Q
	}
}



local Players = game:GetService("Players")


local PLAYER = Players.LocalPlayer



local function fA(pA)
	for lvA, lvB in next, pA.Character:GetDescendants() do
		if lvB:IsA("BasePart") then
			if lvB.Name ~= "HumanoidRootPart" then
				lvB.CanCollide = true

				local tvA = Instance.new("BodyForce")
				tvA.Parent = lvB
				tvA.Force = Vector3.new(0, lvB:GetMass() * workspace.Gravity + options.UpwardForceOffset, 0)
			elseif options.HumanoidRootPartLocallyVisible then
				lvB.Transparency = 0
			end
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



UserInputService.InputBegan:Connect(function(UserInputInformation, IsTyping)
	if not IsTyping and UserInputInformation.UserInputType == Enum.UserInputType.Keyboard then
        	if UserInputInformation.KeyCode == Options.HotKeys.Lengthen then
            		for lvA = 1, #vA do
                		vA[lvA].Length = vA[lvA].Length + Options.RopeLengthIncrementValue
            		end
        	end
        
        	if UserInputInformation.KeyCode == Options.HotKeys.Shorten then
            		for lvA = 1, #vA do
                		if vA[lvA].Length - Options.RopeLengthIncrementValue >= 0 then
                    			vA[lvA].Length = vA[lvA].Length - Options.RopeLengthIncrementValue
                		end
            		end
        	end
    	end
end)


settings().Physics.AllowSleep = false
setsimulationradius(math.huge)
