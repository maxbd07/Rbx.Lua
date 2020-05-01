-- Tool handle wall glitch exploit
-- Author: maxbd (maxbd07, maxbd123, 0xEB)

-- Additional Credit: AtomicPhysics (Inferosel) - Showed me this glitch with an autoclicker because I didn't know about it, I made it a script.



local options = {
    Tool = "BoomBox",
    
    HotKeys = {
        Start = Enum.KeyCode.Q
    }
}



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")


local PLAYER = Players.LocalPlayer
local CHARACTER = PLAYER.Character or PLAYER.CharacterAdded:Wait()
local BACKPACK = PLAYER.Backpack


local vA = BACKPACK:FindFirstChild(options.Tool) or CHARACTER:FindFirstChild(options.Tool)



UserInputService.InputBegan:Connect(function(UserInputInformation, isTyping)
    if isTyping == false and UserInputInformation.UserInputType == Enum.UserInputType.Keyboard then
        if UserInputInformation.KeyCode == options.HotKeys.Start then
            for lvA = 1, 100 do
                RunService.RenderStepped:Wait()
                vA.Parent = (lvA % 2 == 0 and BACKPACK or CHARACTER)
            end
        end
    end
end)
