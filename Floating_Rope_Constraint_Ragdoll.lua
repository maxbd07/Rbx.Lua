-- Floating Rope Constraint Ragdoll; exploiting network ownership.
-- Author: maxbd (maxbd07, maxbd123, 0xEB)

-- Rig Type R6 Support: true
-- Rig Type R15 Support: false

-- Floating Rope Constraint Ragdoll; exploiting network ownership.
-- Author: maxbd (maxbd07, maxbd123, 0xEB)

-- Rig Type R6 Support: true
-- Rig Type R15 Support: false



local options = {
        RopeLength = 6,
        UpwardForceOffset = 3,
        RopeLocallyVisible = false,
        BodyPartConnectionRopeLength = 0.1,
        BodyPartConnectionRopeLocallyVisible = false,
        HumanoidRootPartLocallyVisible = false
}



local Players = game:GetService("Players")


local PLAYER = Players.LocalPlayer
local CHARACTER = PLAYER.Character or PLAYER.CharacterAdded:Wait()
local HUMANOID = CHARACTER:WaitForChild("Humanoid")


local vA, vB = {}, {}


if HUMANOID.RigType == Enum.HumanoidRigType.R6 then
        vA = {
                CHARACTER:FindFirstChild("Torso"),
                CHARACTER:FindFirstChild("Right Arm"),
                CHARACTER:FindFirstChild("Left Arm"),
        	CHARACTER:FindFirstChild("Right Leg"),
        	CHARACTER:FindFirstChild("Left Leg")
    	}

    	vB = {
        	{vA[1]:FindFirstChild("Right Shoulder"), vA[1]:FindFirstChild("RightCollarAttachment"), vA[2]:FindFirstChild("RightShoulderAttachment")},
        	{vA[1]:FindFirstChild("Left Shoulder"), vA[1]:FindFirstChild("LeftCollarAttachment"), vA[3]:FindFirstChild("LeftShoulderAttachment")},
        	{vA[1]:FindFirstChild("Right Hip"), vA[1]:FindFirstChild("WaistCenterAttachment"), vA[4]:FindFirstChild("RightFootAttachment"), Vector3.new(0.5, -1, 0), Vector3.new(0, 1, 0)},
        	{vA[1]:FindFirstChild("Left Hip"), vA[1]:FindFirstChild("WaistCenterAttachment"), vA[5]:FindFirstChild("LeftFootAttachment"), Vector3.new(-0.5, -1, 0), Vector3.new(0, 1, 0)}
    	}	
end



local function fA(pA)
    	if pA[1] and pA[2] and pA[3] then
        	local tvA, tvB = pA[2]:Clone(), pA[3]:Clone()
        	tvA.Parent, tvB.Parent = pA[2].Parent, pA[3].Parent
        	tvA.Position, tvB.Position = pA[4] or pA[2].Position, pA[5] or pA[3].Position

        	local tvC = Instance.new("RopeConstraint")
        	tvC.Parent = pA[1].Parent
        	tvC.Attachment0 = tvA
        	tvC.Attachment1 = tvB
	
	        tvC.Length = options.BodypartConnectionRopeLength
	        tvC.Visible = options.BodyPartConnectionRopeLocallyVisible

		
		pA[1]:Destroy()
	    end
	end
end

local function fB(pA)
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
end



for lvA, lvB in next, vB do
	fA(lvB)
end


fB(PLAYER)



settings().Physics.AllowSleep = false
setsimulationradius(math.huge)
