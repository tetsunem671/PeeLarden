-- Shared state
getgenv().STATE = loadstring(game:HttpGet("https://raw.githubusercontent.com/tetsunem671/PeeLarden/refs/heads/main/Others/State.lua"))()


-- Load modules
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/tetsunem671/PeeLarden/refs/heads/main/Others/RayfieldUI.lua"))()
local Logic = loadstring(game:HttpGet("https://raw.githubusercontent.com/tetsunem671/PeeLarden/refs/heads/main/Others/Logic.lua"))()

-- Init
getgenv().STATE.Init()
UI.Init()
Logic.Init()
