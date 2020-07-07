-- Zero Gravity Tool Handles; exploiting network ownership.
-- Author: maxbd (maxbd07, maxbd123, 0xEB)



local options = {
	CaptureAtMagnitude = 5,
    	EquipToolOnCapture = true,
    	ToolFloatBackSpeed = 500,
    	ToolFloatBackResponsiveness = 20,
    
    	HotKeys = {
		Release = Enum.KeyCode.J,
        	Capture = Enum.KeyCode.K
	}
}



local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")


local PLAYER = Players.LocalPlayer
local CHARACTER = PLAYER.Character or PLAYER.CharacterAdded:Wait()
local BACKPACK = PLAYER.Backpack
local HUMANOID_ROOT_PART = CHARACTER:WaitForChild("HumanoidRootPart")


local vA = {}



local function FolderToolParts(pA)
	local tvA = Instance.new("Folder")
    	tvA.Parent = pA

    	for lvA, lvB in next, pA:GetChildren() do
        	if lvB:IsA("BasePart") then
            		lvB.Parent = tvA
        	end
    	end
	
	return tvA
end

local function FindFirstTool()
	for lvA, lvB in next, CHARACTER:GetDescendants() do
        	if lvB:IsA("Tool") and lvB:FindFirstChildOfClass("Part") then
            		return lvB
        	end
	end
	
	for lvA, lvB in next, BACKPACK:GetDescendants() do
        	if lvB:IsA("Tool") and lvB:FindFirstChildOfClass("Part") then
            		return lvB
        	end
    	end


    	return nil
end

local function Release(pA)
	local tvA = FolderToolParts(pA)


    	if #tvA:GetChildren() > 0 then
        	for lvA, lvB in next, tvA:GetDescendants() do
            		if lvB:IsA("BasePart") then
                		lvB.CanCollide = true

                		local tvB = Instance.new("BodyForce")
                		tvB.Force = Vector3.new(0, lvB:GetMass() * workspace.Gravity, 0)
                		tvB.Parent = lvB
            		end
        	end

        	tvA.Parent = workspace
		
        	table.insert(vA, {tvA, pA})
	end
end

local function Capture(pA)
	if pA and pA[1] and pA[2] then
        	local tvA = pA[1]:GetChildren()


        	for lvA, lvB in next, tvA do
			lvB.CanCollide = false
        	end


        	local tvB = Instance.new("Attachment")
        	tvB.Parent = tvA[1]


        	local tvC = Instance.new("Attachment")
        	tvC.Position = Vector3.new(0, 0, -4)
        	tvC.Parent = HUMANOID_ROOT_PART


        	local tvD = Instance.new("AlignPosition")
        	tvD.RigidityEnabled = false
        	tvD.Responsiveness = options.ToolFloatBackResponsiveness
        	tvD.MaxVelocity = options.ToolFloatBackSpeed
        	tvD.MaxForce = options.ToolFloatBackSpeed

        	tvD.Attachment0 = tvB
        	tvD.Attachment1 = tvC
        	tvD.Parent = tvA[1]


        	repeat
			wait()
		until (tvA[1].Position - HUMANOID_ROOT_PART.Position).Magnitude < options.CaptureAtMagnitude


        	for lvA, lvB in next, pA[1]:GetChildren() do
            		local tvE = lvB:FindFirstChildOfClass("BodyForce")
            
            		if tvE then
                		tvE:Destroy()
            		end

            		lvB.Parent = pA[2]
        	end


        	tvB:Destroy()
        	tvC:Destroy()
        	tvD:Destroy()


        	pA[1]:Destroy()
        	pA[2].Parent = options.EquipToolOnCapture and CHARACTER or BACKPACK


        	return true
	end
	
	return false
end



UserInputService.InputBegan:Connect(function(pA, pB)
	if pB == false and pA.UserInputType == Enum.UserInputType.Keyboard then
        	if pA.KeyCode == options.HotKeys.Release then
            		local tvA = FindFirstTool()

			if tvA then
				if tvA.Parent ~= CHARACTER then
					tvA.Parent = CHARACTER
					wait(0.5)
				end

				Release(tvA)
			end
		elseif pA.KeyCode == options.HotKeys.Capture then
            		if #vA > 0 and Capture(vA[#vA]) then
                		table.remove(vA, #vA)
            		end
        	end
	end
end)



settings().Physics.AllowSleep = false
setsimulationradius(math.huge)
