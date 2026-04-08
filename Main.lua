-- Shared state
print("67")
getgenv().CONFIG = getgenv().CONFIG

getgenv().STATE = loadstring(game:HttpGet("https://raw.githubusercontent.com/tetsunem671/PeeLarden/refs/heads/main/Others/State.lua"))()

print("67")

-- Load modules
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/tetsunem671/PeeLarden/refs/heads/main/Others/RayfieldUI.lua"))()
local Logic = loadstring(game:HttpGet("https://raw.githubusercontent.com/tetsunem671/PeeLarden/refs/heads/main/Others/Logic.lua"))()

print("67")
-- Init
getgenv().STATE.Init()
UI.Init()
Logic.Init()
print("67")
