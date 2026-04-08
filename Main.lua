-- Helper loader
local function loadModule(url)
    local raw = game:HttpGet(url)
    local fn, err = loadstring(raw)
    if not fn then warn("Loadstring failed:", err) return nil end
    local ok, result = pcall(fn)
    if not ok then warn("Runtime error:", result) return nil end
    return result
end

-- Load modules
local STATE = loadModule("https://raw.githubusercontent.com/tetsunem671/PeeLarden/main/Others/State.lua")
local UI = loadModule("https://raw.githubusercontent.com/tetsunem671/PeeLarden/main/Others/RayfieldUI.lua")
loadModule("https://raw.githubusercontent.com/tetsunem671/PeeLarden/main/Others/Logics/EggBuyer.lua") -- auto-run
local Events = loadModule("https://raw.githubusercontent.com/tetsunem671/PeeLarden/main/Others/Logics/Events.lua")

getgenv().STATE = STATE

print("Modules loaded ✅")

-- Init modules that have Init
if STATE and STATE.Init then STATE.Init() end
if UI and UI.Init then UI.Init() end
if Events and Events.Init then Events.Init() end

print("All modules initialized ✅")