local Events = loadstring(game:HttpGet("https://raw.githubusercontent.com/tetsunem671/PeeLarden/refs/heads/main/Others/Logics/EggBuyer.lua"))()
local EggBuyer = loadstring(game:HttpGet("https://raw.githubusercontent.com/tetsunem671/PeeLarden/refs/heads/main/Others/Logics/Events.lua"))()

local Logic = {
    Init = function()
        Events.Init()
        EggBuyer.Init()
    end
}

return Logic