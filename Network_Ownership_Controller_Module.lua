-- Network Ownership Controller Module
-- Author: maxbd (maxbd07, maxbd123, 0xEB)



local network = {
    PLAYER = game:GetService("Players").LocalPlayer,
    vA = nil
}


network.Claim = function()
    settings().Physics.AllowSleep = false

    for lvA, lvB in next, game:GetService("Players"):GetPlayers() do
        lvB.MaximumSimulationRadius = lvB ~= network.PLAYER and 0 or math.huge
	lvB.SimulationRadius = lvB ~= network.PLAYER and 0 or math.huge
    end
end

network.Lock = function()
    network.vA = network.vA or game:GetService("RunService").RenderStepped:Connect(function()
        if network.PLAYER.SimulationRadius < math.huge then
            network.Claim()
        end
    end, 1)
end

network.Release = function()
    settings().Physics.AllowSleep = true

    if network.vA then
        network.vA:Disconnect()
    end

    for lvA, lvB in next, game:GetService("Players"):GetPlayers() do
        lvB.SimulationRadius = 0
	lvB.MaximumSimulationRadius = 1000
    end
end



return network
