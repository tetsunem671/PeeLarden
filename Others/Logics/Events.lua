local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-- DEFAULTS
local DEFAULTS = {
    TweenSpeed = 50,
    Interval = 1,
    HoldOverride = 0,
    LerpAlpha = 0.35,
    AttackInterval = 0.2
}

local Events = {}
local running = {}

-- Get nearest ghost according to your Filter
local function getNearest(config)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = character.HumanoidRootPart

    local nearest
    local shortestDistance = math.huge

    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and config.Filter(obj) then
            local ghostHRP = obj:FindFirstChild("HumanoidRootPart") 
                or obj:FindFirstChild("Torso") 
                or obj.PrimaryPart
            if ghostHRP then
                local dist = (hrp.Position - ghostHRP.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    nearest = ghostHRP
                end
            end
        end
    end

    return nearest
end

-- Smooth follow
local currentConnection
local function stick(targetHRP, config)
    local character = player.Character
    if not character then return end
    local hrp = character:WaitForChild("HumanoidRootPart")

    if currentConnection then
        currentConnection:Disconnect()
    end

    currentConnection = RunService.Heartbeat:Connect(function()
        if not targetHRP or not targetHRP.Parent then
            currentConnection:Disconnect()
            currentConnection = nil
            return
        end

        local offset = CFrame.new(0, 0, 3)
        hrp.CFrame = hrp.CFrame:Lerp(targetHRP.CFrame * offset, config.LerpAlpha or 0.35)
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end)
end

-- Non-blocking attack
local attacking = false
local function attack(targetHRP, config)
    if attacking then return end
    attacking = true

    task.spawn(function()
        while targetHRP and targetHRP.Parent do
            VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
            VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
            task.wait(config.AttackInterval or 0.2)
        end
        attacking = false
    end)
end

local function findObjects(config)
    local results = {}
    local source

    -- If folder already exists, use it
    if config.Folder then
        source = config.Folder
    else
        -- Special handling for Arcade
        if config.Name == "ArcadeOrb" then
            source = workspace.Events:FindFirstChild("ArcadeSpheres")
            if not source then
                -- Folder doesn't exist yet, return empty table
                return results
            end
        else
            source = workspace
        end
    end

    for _, obj in ipairs(source:GetDescendants()) do
        if config.Mode == "Name" and obj.Name == config.Name then
            table.insert(results, obj)

        elseif config.Mode == "Pattern" and obj.Name:match(config.Pattern) then
            table.insert(results, obj)

        elseif config.Mode == "Folder" then
            table.insert(results, obj)
        end
    end

    return results
end

local function runCollector(name, config, stateKey)
    running[name] = false

    task.spawn(function()
        while true do
            if not getgenv().STATE[stateKey] then
                task.wait(0.3)
                continue
            end

            running[name] = true

            local character = player.Character or player.CharacterAdded:Wait()

            for _, obj in ipairs(findObjects(config)) do
                if not getgenv().STATE[stateKey] then break end

                local targetPart = config.GetTarget and config.GetTarget(obj) or obj:FindFirstChild("PrimaryPart")
                if not targetPart then continue end

                tweenTo(character, targetPart.Position, config.TweenSpeed or DEFAULTS.TweenSpeed)

                if config.UsePrompt then
                    local prompt = targetPart:FindFirstChildOfClass("ProximityPrompt", true)
                    if prompt then
                        if config.HoldOverride ~= nil then
                            prompt.HoldDuration = config.HoldOverride
                        end
                        task.wait(0.2)
                        triggerPrompt(prompt)
                    end
                end

                if config.OnCollect then
                    config.OnCollect(obj)
                end

                task.wait(config.Interval or DEFAULTS.Interval)
            end

            task.wait(0.2)
        end
    end)
end

local function runTracker(name, config, stateKey)
    task.spawn(function()
        while true do
            if not getgenv().STATE[stateKey] then
                task.wait(0.3)
                continue
            end

            local target = getNearest(config)

            if target then
                stick(target, config)
                attack(target, config)
            end

            task.wait(config.Interval or 0.2)
        end
    end)
end

function Events.Init()
    -- Snowflake
    runCollector("Snowflake", {
        Mode = "Name",
        Name = "SnowflakePickup",
        UsePrompt = true,
        HoldOverride = 0
    }, "AutoSnowflake")

    -- Meteoron
    runCollector("Meteoron", {
        Mode = "Name",
        Name = "MeteoronPickup",
        UsePrompt = true,
        HoldOverride = 0
    }, "AutoMeteoron")

    -- Easter
    runCollector("Easter", {
        Mode = "Pattern",
        Pattern = "^EasterEgg_%d+",
        UsePrompt = true,
        HoldOverride = 0,
        GetTarget = function(obj)
            return obj:FindFirstChild("Colisions")
        end
    }, "AutoEaster")

    -- Arcade
    runCollector("Arcade", {
        Mode = "Name",
        Name = "ArcadeOrb",
        UsePrompt = false,
        GetTarget = function(obj)
            return obj:FindFirstChild("Main")
        end
    }, "AutoArcade")

    -- Ghost
    runTracker("Ghost", {
        Filter = function(obj)
            return obj.Name:match("^(FastGhost_%d+|NormalGhost_%d+|SlowGhost_%d+)")
        end,
        LerpAlpha = 0.35,
        AttackInterval = 0.2,
        Interval = 0.2
    }, "AutoGhost")
end

return Events