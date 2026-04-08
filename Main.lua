--============================--
-- HELPER LOADER
--============================--
local function loadModule(url)
    local raw
    local success, err = pcall(function()
        raw = game:HttpGet(url)
    end)
    if not success then
        warn("HttpGet failed for", url, ":", err)
        return nil
    end

    local fn, err2 = loadstring(raw)
    if not fn then
        warn("Loadstring compilation failed for", url, ":", err2)
        return nil
    end

    -- Execute the chunk safely
    local ok, result = pcall(fn)
    if not ok then
        warn("Runtime error in module:", url, ":", result)
        return nil
    end

    return result
end

--============================--
-- LOAD MODULES
--============================--
local STATE = loadModule("https://raw.githubusercontent.com/tetsunem671/PeeLarden/main/Others/State.lua")
local UI = loadModule("https://raw.githubusercontent.com/tetsunem671/PeeLarden/main/Others/RayfieldUI.lua")
local Events = loadModule("https://raw.githubusercontent.com/tetsunem671/PeeLarden/main/Others/Logics/Events.lua")

getgenv().STATE = STATE
loadModule("https://raw.githubusercontent.com/tetsunem671/PeeLarden/main/Others/Logics/EggBuyer.lua") -- auto-run, no Init

print("Modules loaded ✅")

--============================--
-- INIT MODULES THAT HAVE Init
--============================--
if STATE and type(STATE.Init) == "function" then
    STATE.Init()
    print("STATE initialized ✅")
else
    warn("STATE.Init missing")
end

if UI and type(UI.Init) == "function" then
    UI.Init()
    print("UI initialized ✅")
else
    warn("UI.Init missing")
end

if Events and type(Events.Init) == "function" then
    Events.Init()
    print("Events initialized ✅")
else
    warn("Events.Init missing")
end

print("All modules initialized ✅")