-- Vector3 Hat Orbitter; exploiting network ownership and tool client-server replication.
-- Author: maxbd (maxbd07, maxbd123, 0xEB)



local options = {
	OrbitSpeed = 1,
	OrbitDistanceOffset = 1,
	OrbitSpeedAdjustMultiplier = 1,
	AdjustableSpeed = true,
	AlwaysEquipped = true,
	
	Hotkeys = {
		IncreaseSpeed = Enum.KeyCode.E,
		DecreaseSpeed = Enum.KeyCode.Q
	},
	
	IgnorableAccessories = {}
}



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local PLAYER = Players.LocalPlayer
local CHARACTER = PLAYER.Character or PLAYER.CharacterAdded:Wait()
local BACKPACK = PLAYER.Backpack



local vA, vB, vC = {}, nil, nil

local functions = {
	AccessoryToTool = function(pA)
		if pA:IsA("Accessory") == true and pA:FindFirstChild("Handle") ~= nil then
			local tvA, tvB = pA.Handle, pA.Handle:FindFirstChild("AccessoryWeld")
			if tvB == nil then return nil else tvB:Destroy() end

			tvB = Instance.new("Tool")
			
			tvB.Name, tvB.CanBeDropped, tvB.Parent = pA.Name, false, BACKPACK
			tvA.Parent, tvA.Massless, tvB.Parent = tvB, true, CHARACTER
			
			return tvB
		end

		return nil
	end,
	
	AdjustToolGrip = function(pA, pB)
		pA.Parent = BACKPACK
		pA.Grip = CFrame.new(pB)
		pA.Parent = CHARACTER
	end,

	FindTableValue = function(pA, pB)
		if table.getn(pA) > 0 then
			for lvA, lvB in next, pA do
				if lvB == pB then
					return true
				end
			end
		end

		return false
	end
}



for lvA, lvB in next, CHARACTER:FindFirstChildOfClass("Humanoid"):GetAccessories() do
	if lvB:FindFirstChild("Handle") ~= nil and functions.FindTableValue(options.IgnorableAccessories, lvB.Name) == false then
		table.insert(vA, functions.AccessoryToTool(lvB))
	end
end



vB = table.getn(vA) + options.OrbitDistanceOffset
vC = math.rad(360 / vB)



UserInputService.InputBegan:Connect(function(UserInputInformation, isTyping)
	if isTyping == false and options.AdjustableSpeed == true and UserInputInformation.UserInputType == Enum.UserInputType.Keyboard then
		if UserInputInformation.KeyCode == options.Hotkeys.IncreaseSpeed then options.OrbitSpeed = options.OrbitSpeed + (1 * options.OrbitSpeedAdjustMultiplier) end
        	if UserInputInformation.KeyCode == options.Hotkeys.DecreaseSpeed then options.OrbitSpeed = options.OrbitSpeed - (1 * options.OrbitSpeedAdjustMultiplier) end
    	end
end)

if options.AlwaysEquipped == true then
	for lvA, lvB in next, vA do
		spawn(function()
			while wait() do
				if lvB.Parent ~= CHARACTER then
					lvB.Parent = CHARACTER
				end
			end
		end)
	end
end

for lvA, lvB in next, vA do
	local tvA = vC * math.rad(lvA * 50)
	local tvB = Vector3.new(CHARACTER["Right Arm"].Size.X + (CHARACTER.HumanoidRootPart.Size.X / 2), -(CHARACTER.HumanoidRootPart.Size.Y + lvB.Handle.Size.Y), -(CHARACTER["Right Arm"].Size.Z + lvB.Handle.Size.Z))

    	RunService.RenderStepped:Connect(function()
        	if lvB.Parent == CHARACTER then
				functions.AdjustToolGrip(lvB, Vector3.new(vB * math.cos(vC + tvA), 0, vB * math.sin(vC + tvA)) + tvB)
            			tvA = tvA + math.rad(options.OrbitSpeed)
        	end
    	end)
end
