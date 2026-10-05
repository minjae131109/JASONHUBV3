--// JASON HUB - Rayfield Version

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

local Window = Rayfield:CreateWindow({
    Name = "JASON HUB",
    LoadingTitle = "JASON HUB",
    LoadingSubtitle = "Sword Fight",

    ConfigurationSaving = {
        Enabled = false
    },

    Discord = {
        Enabled = false
    },

    KeySystem = true,

    KeySettings = {
        Title = "JASON HUB",
        Subtitle = "Key System",
        Note = "키를 입력하세요.",
        FileName = "JASONHUB_V3_KEY",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {
            "JASONHUB V3 secret"
        }
    }
})

--==================================================
-- MAIN
--==================================================

local grabOn = false
local rupKillOn = false
local noclipOn = false
local flyOn = false
local xrayOn = false
local fullbrightOn = false
local wallClimbOn = false
local clickTpOn = false

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Basic")

local grabConnection

local function equipTool(tool)
    if not grabOn then return end
    if not tool:IsA("Tool") then return end
    if not tool:FindFirstChild("Handle") then return end

    local char = player.Character
    if not char then return end

    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end

    pcall(function()
        humanoid:EquipTool(tool)
    end)
end

local function grabTools()
    if not grabOn then return end

    for _, tool in ipairs(workspace:GetChildren()) do
        if not grabOn then break end

        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            equipTool(tool)
        end
    end
end

MainTab:CreateToggle({
    Name = "Grab Tools",
    CurrentValue = false,

    Callback = function(Value)
        grabOn = Value

        if grabConnection then
            grabConnection:Disconnect()
            grabConnection = nil
        end

        if not Value then
            return
        end

        task.spawn(function()
            while grabOn do
                grabTools()
                RunService.Heartbeat:Wait()
            end
        end)

        grabConnection = workspace.ChildAdded:Connect(function(obj)
            if grabOn and obj:IsA("Tool") then
                task.spawn(function()
                    equipTool(obj)
                end)
            end
        end)
    end
})

MainTab:CreateButton({
    Name = "투명화",

    Callback = function()
        pcall(function()
            loadstring(game:HttpGet(
                "https://pastebin.com/raw/fzx5knqe"
            ))()
        end)
    end
})

local rupKillThread

local function runRupKill()
    local success = pcall(function()
        local source = game:HttpGet(
            "https://pastebin.com/raw/dncT3TEh"
        )

        local func = loadstring(source)

        if func then
            func()
        end
    end)

    return success
end

MainTab:CreateToggle({
    Name = "뤂킬",
    CurrentValue = false,

    Callback = function(Value)
        rupKillOn = Value

        if Value then
            if rupKillThread then
                task.cancel(rupKillThread)
            end

            rupKillThread = task.spawn(function()
                while rupKillOn do
                    runRupKill()
                    task.wait(1)
                end
            end)
        else
            if rupKillThread then
                task.cancel(rupKillThread)
                rupKillThread = nil
            end
        end
    end
})

--==================================================
-- XRAY
--==================================================

local xrayOriginalTransparency = {}

local function applyXRayToPart(part)
    if not part:IsA("BasePart") then return end

    if xrayOriginalTransparency[part] == nil then
        xrayOriginalTransparency[part] =
            part.LocalTransparencyModifier
    end

    part.LocalTransparencyModifier = 0.65
end

local function enableXRay()
    xrayOn = true

    for _, obj in ipairs(workspace:GetDescendants()) do
        applyXRayToPart(obj)
    end
end

local function disableXRay()
    xrayOn = false

    for obj, originalValue in pairs(xrayOriginalTransparency) do
        if obj and obj.Parent then
            obj.LocalTransparencyModifier = originalValue
        end
    end

    table.clear(xrayOriginalTransparency)
end

MainTab:CreateToggle({
    Name = "Xray",
    CurrentValue = false,

    Callback = function(Value)
        if Value then
            enableXRay()
        else
            disableXRay()
        end
    end
})

workspace.DescendantAdded:Connect(function(obj)
    if xrayOn and obj:IsA("BasePart") then
        task.wait()
        applyXRayToPart(obj)
    end
end)

--==================================================
-- FULLBRIGHT
--==================================================

local originalLighting = {}

local function saveOriginalLighting()
    originalLighting.Brightness = Lighting.Brightness
    originalLighting.ClockTime = Lighting.ClockTime
    originalLighting.FogEnd = Lighting.FogEnd
    originalLighting.FogStart = Lighting.FogStart
    originalLighting.GlobalShadows = Lighting.GlobalShadows
    originalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
    originalLighting.Ambient = Lighting.Ambient
end

local function enableFullbright()
    fullbrightOn = true
    saveOriginalLighting()

    Lighting.Brightness = 10
    Lighting.ClockTime = 12
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
end

local function disableFullbright()
    fullbrightOn = false

    if originalLighting.Brightness then
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.FogStart = originalLighting.FogStart
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.Ambient = originalLighting.Ambient
    end
end

MainTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,

    Callback = function(Value)
        if Value then
            enableFullbright()
        else
            disableFullbright()
        end
    end
})

--==================================================
-- ESP
--==================================================

local espSettings = {
    Enabled = false,
    Box = true,
    BoxFilled = false,
    Tracer = true,
    Name = true,
    Distance = true,
    Health = true,
    Skeleton = false,
    TeamCheck = false,
    MaxDistance = 1000,
    BoxColor = Color3.fromRGB(255, 0, 0),
    TracerColor = Color3.fromRGB(255, 255, 255),
    TextColor = Color3.fromRGB(255, 255, 255)
}

local espObjects = {}

local function getCharacterSize(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end

    local head = character:FindFirstChild("Head")

    if head then
        return (head.Position - hrp.Position).Magnitude + 3
    end

    return 5
end

local function createESPObject(targetPlayer)
    if targetPlayer == player then return nil end

    local espData = {
        Player = targetPlayer,
        Box = nil,
        BoxFill = nil,
        Tracer = nil,
        Name = nil,
        Distance = nil,
        Health = nil,
        SkeletonLines = {}
    }

    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1
    box.Color = espSettings.BoxColor
    box.Transparency = 1
    box.Filled = false
    espData.Box = box

    local boxFill = Drawing.new("Square")
    boxFill.Visible = false
    boxFill.Thickness = 1
    boxFill.Color = espSettings.BoxColor
    boxFill.Transparency = 0.3
    boxFill.Filled = true
    espData.BoxFill = boxFill

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1
    tracer.Color = espSettings.TracerColor
    tracer.Transparency = 1
    espData.Tracer = tracer

    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Size = 14
    nameText.Color = espSettings.TextColor
    nameText.Outline = true
    nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameText.Center = true
    espData.Name = nameText

    local distText = Drawing.new("Text")
    distText.Visible = false
    distText.Size = 12
    distText.Color = espSettings.TextColor
    distText.Outline = true
    distText.OutlineColor = Color3.fromRGB(0, 0, 0)
    distText.Center = true
    espData.Distance = distText

    local healthText = Drawing.new("Text")
    healthText.Visible = false
    healthText.Size = 12
    healthText.Color = Color3.fromRGB(0, 255, 0)
    healthText.Outline = true
    healthText.OutlineColor = Color3.fromRGB(0, 0, 0)
    healthText.Center = true
    espData.Health = healthText

    local skeletonParts = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }

    for _, pair in ipairs(skeletonParts) do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1
        line.Color = espSettings.BoxColor
        line.Transparency = 1

        table.insert(espData.SkeletonLines, {
            Line = line,
            Part1 = pair[1],
            Part2 = pair[2]
        })
    end

    return espData
end

local function removeESPObject(espData)
    if not espData then return end

    if espData.Box then espData.Box:Remove() end
    if espData.BoxFill then espData.BoxFill:Remove() end
    if espData.Tracer then espData.Tracer:Remove() end
    if espData.Name then espData.Name:Remove() end
    if espData.Distance then espData.Distance:Remove() end
    if espData.Health then espData.Health:Remove() end

    for _, skeletonData in ipairs(espData.SkeletonLines) do
        if skeletonData.Line then
            skeletonData.Line:Remove()
        end
    end
end

local function hideESP(espData)
    espData.Box.Visible = false
    espData.BoxFill.Visible = false
    espData.Tracer.Visible = false
    espData.Name.Visible = false
    espData.Distance.Visible = false
    espData.Health.Visible = false

    for _, skeletonData in ipairs(espData.SkeletonLines) do
        skeletonData.Line.Visible = false
    end
end

local function updateESP()
    if not espSettings.Enabled then return end

    local camera = workspace.CurrentCamera
    local localChar = player.Character
    local localHRP = localChar and
        localChar:FindFirstChild("HumanoidRootPart")

    if not camera or not localHRP then
        return
    end

    for _, espData in pairs(espObjects) do
        local targetPlayer = espData.Player
        local character = targetPlayer.Character

        if not character then
            hideESP(espData)
            continue
        end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if not hrp or not head then
            hideESP(espData)
            continue
        end

        local distance =
            (hrp.Position - localHRP.Position).Magnitude

        if distance > espSettings.MaxDistance then
            hideESP(espData)
            continue
        end

        if espSettings.TeamCheck and
            targetPlayer.Team == player.Team then
            hideESP(espData)
            continue
        end

        local headPos, headOnScreen =
            camera:WorldToViewportPoint(head.Position)

        local hrpPos, hrpOnScreen =
            camera:WorldToViewportPoint(hrp.Position)

        if not headOnScreen or not hrpOnScreen then
            hideESP(espData)
            continue
        end

        local charHeight = getCharacterSize(character)
        local boxHeight = charHeight * 35
        local boxWidth = boxHeight * 0.6

        local boxPosition = Vector2.new(
            headPos.X - boxWidth / 2,
            headPos.Y - boxHeight * 0.1
        )

        if espSettings.Box then
            espData.Box.Visible = true
            espData.Box.Size =
                Vector2.new(boxWidth, boxHeight)
            espData.Box.Position = boxPosition
            espData.Box.Color = espSettings.BoxColor
        else
            espData.Box.Visible = false
        end

        if espSettings.BoxFilled then
            espData.BoxFill.Visible = true
            espData.BoxFill.Size =
                Vector2.new(boxWidth, boxHeight)
            espData.BoxFill.Position = boxPosition
            espData.BoxFill.Color = espSettings.BoxColor
        else
            espData.BoxFill.Visible = false
        end

        if espSettings.Tracer then
            espData.Tracer.Visible = true
            espData.Tracer.From = Vector2.new(
                camera.ViewportSize.X / 2,
                camera.ViewportSize.Y
            )
            espData.Tracer.To =
                Vector2.new(hrpPos.X, hrpPos.Y)
            espData.Tracer.Color = espSettings.TracerColor
        else
            espData.Tracer.Visible = false
        end

        if espSettings.Name then
            espData.Name.Visible = true
            espData.Name.Text = targetPlayer.DisplayName
            espData.Name.Position = Vector2.new(
                boxPosition.X + boxWidth / 2,
                boxPosition.Y - 15
            )
        else
            espData.Name.Visible = false
        end

        if espSettings.Distance then
            espData.Distance.Visible = true
            espData.Distance.Text =
                math.floor(distance) .. "m"
            espData.Distance.Position = Vector2.new(
                boxPosition.X + boxWidth / 2,
                boxPosition.Y + boxHeight + 2
            )
        else
            espData.Distance.Visible = false
        end

        if espSettings.Health and humanoid then
            espData.Health.Visible = true
            espData.Health.Text =
                math.floor(humanoid.Health) ..
                "/" ..
                math.floor(humanoid.MaxHealth)

            espData.Health.Position = Vector2.new(
                boxPosition.X + boxWidth / 2,
                boxPosition.Y + boxHeight + 15
            )

            local healthPercent =
                humanoid.Health / humanoid.MaxHealth

            if healthPercent > 0.7 then
                espData.Health.Color =
                    Color3.fromRGB(0, 255, 0)
            elseif healthPercent > 0.3 then
                espData.Health.Color =
                    Color3.fromRGB(255, 255, 0)
            else
                espData.Health.Color =
                    Color3.fromRGB(255, 0, 0)
            end
        else
            espData.Health.Visible = false
        end

        for _, skeletonData in
            ipairs(espData.SkeletonLines) do

            if espSettings.Skeleton then
                local part1 =
                    character:FindFirstChild(
                        skeletonData.Part1
                    )

                local part2 =
                    character:FindFirstChild(
                        skeletonData.Part2
                    )

                if part1 and part2 then
                    local pos1, onScreen1 =
                        camera:WorldToViewportPoint(
                            part1.Position
                        )

                    local pos2, onScreen2 =
                        camera:WorldToViewportPoint(
                            part2.Position
                        )

                    if onScreen1 and onScreen2 then
                        skeletonData.Line.Visible = true
                        skeletonData.Line.From =
                            Vector2.new(pos1.X, pos1.Y)
                        skeletonData.Line.To =
                            Vector2.new(pos2.X, pos2.Y)
                    else
                        skeletonData.Line.Visible = false
                    end
                else
                    skeletonData.Line.Visible = false
                end
            else
                skeletonData.Line.Visible = false
            end
        end
    end
end

local espConnection

local function enableESP()
    espSettings.Enabled = true

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and
            not espObjects[targetPlayer] then

            espObjects[targetPlayer] =
                createESPObject(targetPlayer)
        end
    end

    if not espConnection then
        espConnection =
            RunService.RenderStepped:Connect(updateESP)
    end
end

local function disableESP()
    espSettings.Enabled = false

    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end

    for _, espData in pairs(espObjects) do
        removeESPObject(espData)
    end

    table.clear(espObjects)
end

MainTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,

    Callback = function(Value)
        if Value then
            enableESP()
        else
            disableESP()
        end
    end
})

MainTab:CreateSection("ESP Settings")

MainTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = true,

    Callback = function(Value)
        espSettings.Box = Value
    end
})

MainTab:CreateToggle({
    Name = "ESP Filled Box",
    CurrentValue = false,

    Callback = function(Value)
        espSettings.BoxFilled = Value
    end
})

MainTab:CreateToggle({
    Name = "ESP Tracer",
    CurrentValue = true,

    Callback = function(Value)
        espSettings.Tracer = Value
    end
})

MainTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = true,

    Callback = function(Value)
        espSettings.Name = Value
    end
})

MainTab:CreateToggle({
    Name = "ESP Distance",
    CurrentValue = true,

    Callback = function(Value)
        espSettings.Distance = Value
    end
})

MainTab:CreateToggle({
    Name = "ESP Health",
    CurrentValue = true,

    Callback = function(Value)
        espSettings.Health = Value
    end
})

MainTab:CreateToggle({
    Name = "ESP Skeleton",
    CurrentValue = false,

    Callback = function(Value)
        espSettings.Skeleton = Value
    end
})

MainTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,

    Callback = function(Value)
        espSettings.TeamCheck = Value
    end
})

MainTab:CreateSlider({
    Name = "ESP Max Distance",
    Range = {100, 5000},
    Increment = 100,
    Suffix = "m",
    CurrentValue = 1000,

    Callback = function(Value)
        espSettings.MaxDistance = Value
    end
})

Players.PlayerAdded:Connect(function(targetPlayer)
    if espSettings.Enabled then
        espObjects[targetPlayer] =
            createESPObject(targetPlayer)
    end
end)

Players.PlayerRemoving:Connect(function(targetPlayer)
    if espObjects[targetPlayer] then
        removeESPObject(espObjects[targetPlayer])
        espObjects[targetPlayer] = nil
    end
end)

--==================================================
-- AIMBOT
--==================================================

local AimTab =
    Window:CreateTab(
        "Aim",
        4483362458
    )

AimTab:CreateSection("Aimbot")

local AimSettings = {
    Enabled = false,
    FOV = 150,
    MaxDistance = 1000,
    Smoothness = 0.15,
    TeamCheck = true,
    WallCheck = false
}

local AimScreenGui =
    Instance.new("ScreenGui")

AimScreenGui.Name =
    "JASON_AIM_FOV"

AimScreenGui.ResetOnSpawn =
    false

AimScreenGui.IgnoreGuiInset =
    true

AimScreenGui.Parent =
    game.CoreGui

local FOVCircle =
    Instance.new("Frame")

FOVCircle.Name =
    "FOVCircle"

FOVCircle.Parent =
    AimScreenGui

FOVCircle.BackgroundColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

FOVCircle.BackgroundTransparency =
    1

FOVCircle.BorderSizePixel =
    0

FOVCircle.Size =
    UDim2.new(
        0,
        AimSettings.FOV * 2,
        0,
        AimSettings.FOV * 2
    )

FOVCircle.Position =
    UDim2.new(
        0.5,
        -AimSettings.FOV,
        0.5,
        -AimSettings.FOV
    )

FOVCircle.Visible =
    false

local FOVCorner =
    Instance.new("UICorner")

FOVCorner.CornerRadius =
    UDim.new(
        1,
        0
    )

FOVCorner.Parent =
    FOVCircle

local FOVOutline =
    Instance.new("UIStroke")

FOVOutline.Parent =
    FOVCircle

FOVOutline.Color =
    Color3.fromRGB(
        0,
        255,
        0
    )

FOVOutline.Thickness =
    2

local function GetClosestPlayer()

    local camera =
        workspace.CurrentCamera

    if not camera then
        return nil
    end

    local Closest =
        nil

    local ShortestDistance =
        AimSettings.FOV

    local viewportCenter =
        Vector2.new(
            camera.ViewportSize.X / 2,
            camera.ViewportSize.Y / 2
        )

    for _, targetPlayer in
        ipairs(Players:GetPlayers()) do

        if targetPlayer ~= player and
            targetPlayer.Character then

            local character =
                targetPlayer.Character

            local humanoid =
                character:FindFirstChildOfClass(
                    "Humanoid"
                )

            local head =
                character:FindFirstChild(
                    "Head"
                )

            if humanoid and
                humanoid.Health > 0 and
                head then

                if AimSettings.TeamCheck and
                    targetPlayer.Team == player.Team then
                    continue
                end

                local screenPos, onScreen =
                    camera:WorldToViewportPoint(
                        head.Position
                    )

                if onScreen then

                    local screenDistance =
                        (
                            Vector2.new(
                                screenPos.X,
                                screenPos.Y
                            ) -
                            viewportCenter
                        ).Magnitude

                    if screenDistance <
                        ShortestDistance then

                        local worldDistance =
                            (
                                head.Position -
                                camera.CFrame.Position
                            ).Magnitude

                        if worldDistance <=
                            AimSettings.MaxDistance then

                            if not AimSettings.WallCheck then

                                Closest =
                                    targetPlayer

                                ShortestDistance =
                                    screenDistance

                            else

                                local rayParams =
                                    RaycastParams.new()

                                rayParams.FilterDescendantsInstances =
                                    {
                                        player.Character
                                    }

                                rayParams.FilterType =
                                    Enum.RaycastFilterType.Blacklist

                                local direction =
                                    head.Position -
                                    camera.CFrame.Position

                                local result =
                                    workspace:Raycast(
                                        camera.CFrame.Position,
                                        direction,
                                        rayParams
                                    )

                                if not result or
                                    result.Instance:IsDescendantOf(
                                        targetPlayer.Character
                                    ) then

                                    Closest =
                                        targetPlayer

                                    ShortestDistance =
                                        screenDistance
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return Closest
end

RunService.RenderStepped:Connect(function()

    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    FOVCircle.Size =
        UDim2.new(
            0,
            AimSettings.FOV * 2,
            0,
            AimSettings.FOV * 2
        )

    FOVCircle.Position =
        UDim2.new(
            0.5,
            -AimSettings.FOV,
            0.5,
            -AimSettings.FOV
        )

    FOVCircle.Visible =
        AimSettings.Enabled

    if not AimSettings.Enabled then
        return
    end

    local Target =
        GetClosestPlayer()

    if Target and
        Target.Character and
        Target.Character:FindFirstChild(
            "Head"
        ) then

        FOVOutline.Color =
            Color3.fromRGB(
                255,
                0,
                0
            )

        local targetHead =
            Target.Character:FindFirstChild(
                "Head"
            )

        if targetHead then

            local targetPosition =
                targetHead.Position

            local cameraCF =
                camera.CFrame

            local targetCF =
                CFrame.new(
                    cameraCF.Position,
                    targetPosition
                )

            camera.CFrame =
                cameraCF:Lerp(
                    targetCF,
                    AimSettings.Smoothness
                )
        end

    else

        FOVOutline.Color =
            Color3.fromRGB(
                0,
                255,
                0
            )
    end
end)

AimTab:CreateToggle({
    Name = "에임봇",
    CurrentValue = false,

    Callback = function(Value)
        AimSettings.Enabled = Value
    end
})

AimTab:CreateSlider({
    Name = "FOV",
    Range = {30, 300},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 150,

    Callback = function(Value)
        AimSettings.FOV = Value
    end
})

AimTab:CreateSlider({
    Name = "감지 거리",
    Range = {100, 5000},
    Increment = 100,
    Suffix = "m",
    CurrentValue = 1000,

    Callback = function(Value)
        AimSettings.MaxDistance = Value
    end
})

AimTab:CreateSlider({
    Name = "부드러움",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.15,

    Callback = function(Value)
        AimSettings.Smoothness = Value
    end
})

AimTab:CreateToggle({
    Name = "팀원 제외",
    CurrentValue = true,

    Callback = function(Value)
        AimSettings.TeamCheck = Value
    end
})

AimTab:CreateToggle({
    Name = "벽 체크",
    CurrentValue = false,

    Callback = function(Value)
        AimSettings.WallCheck = Value
    end
})

AimTab:CreateToggle({
    Name = "FOV 표시",
    CurrentValue = false,

    Callback = function(Value)
        FOVCircle.Visible =
            Value and AimSettings.Enabled
    end
})

--==================================================
-- TELEPORT
--==================================================

local TeleportTab =
    Window:CreateTab(
        "텔레포트",
        4483362458
    )

TeleportTab:CreateSection(
    "클릭 텔레포트"
)

TeleportTab:CreateToggle({
    Name = "클릭 이동 (Ctrl + 클릭)",
    CurrentValue = false,

    Callback = function(Value)
        clickTpOn = Value
    end
})

local function teleportToPosition(
    screenPosition
)

    if not clickTpOn then
        return
    end

    local char =
        player.Character

    if not char then
        return
    end

    local hrp =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    if not hrp then
        return
    end

    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    local ray =
        camera:ViewportPointToRay(
            screenPosition.X,
            screenPosition.Y
        )

    local rayParams =
        RaycastParams.new()

    rayParams.FilterDescendantsInstances =
        {
            char
        }

    rayParams.FilterType =
        Enum.RaycastFilterType.Exclude

    local result =
        workspace:Raycast(
            ray.Origin,
            ray.Direction * 2000,
            rayParams
        )

    if result then

        local targetPosition =
            result.Position +
            Vector3.new(
                0,
                3,
                0
            )

        pcall(function()
            char:PivotTo(
                CFrame.new(
                    targetPosition
                )
            )
        end)

        hrp.CFrame =
            CFrame.new(
                targetPosition
            )
    end
end

UserInputService.InputBegan:Connect(
    function(
        input,
        gameProcessed
    )

        if gameProcessed then
            return
        end

        if not clickTpOn then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            if UserInputService:IsKeyDown(
                Enum.KeyCode.LeftControl
            ) then

                local position =
                    UserInputService:GetMouseLocation()

                teleportToPosition(
                    position
                )
            end
        end
    end
)

UserInputService.TouchTap:Connect(
    function(
        touchPositions,
        gameProcessed
    )

        if gameProcessed then
            return
        end

        if not clickTpOn then
            return
        end

        local position =
            touchPositions[1]

        if position then
            teleportToPosition(
                position
            )
        end
    end
)

TeleportTab:CreateSection(
    "플레이어 텔레포트"
)

local selectedPlayer = nil

local playerDropdown =
    TeleportTab:CreateDropdown({
        Name = "플레이어 선택",
        Options = {},
        CurrentOption = {},
        MultipleOptions = false,

        Callback = function(Option)

            if type(Option) == "table" then
                selectedPlayer =
                    Option[1]
            else
                selectedPlayer =
                    Option
            end

            if selectedPlayer then
                selectedPlayer =
                    tostring(
                        selectedPlayer
                    )
            end
        end
    })

local function updatePlayerList()

    local playerNames = {}

    for _, p in
        ipairs(
            Players:GetPlayers()
        ) do

        if p ~= player then
            table.insert(
                playerNames,
                p.Name
            )
        end
    end

    table.sort(
        playerNames
    )

    selectedPlayer = nil

    pcall(function()
        playerDropdown:Refresh(
            playerNames
        )
    end)
end

TeleportTab:CreateButton({
    Name = "플레이어 목록 새로고침",

    Callback = function()
        updatePlayerList()
    end
})

TeleportTab:CreateButton({
    Name = "선택한 플레이어에게 이동",

    Callback = function()

        local targetName =
            selectedPlayer

        if type(targetName) ==
            "table" then

            targetName =
                targetName[1]
        end

        if not targetName or
            tostring(targetName) == "" then

            Rayfield:Notify({
                Title = "오류",
                Content =
                    "플레이어를 선택하세요.",
                Duration = 3
            })

            return
        end

        targetName =
            tostring(
                targetName
            )

        local targetPlayer =
            Players:FindFirstChild(
                targetName
            )

        if not targetPlayer then

            Rayfield:Notify({
                Title = "오류",
                Content =
                    "플레이어를 찾을 수 없습니다.",
                Duration = 3
            })

            updatePlayerList()

            return
        end

        local targetChar =
            targetPlayer.Character

        if not targetChar then

            Rayfield:Notify({
                Title = "오류",
                Content =
                    "대상의 캐릭터가 없습니다.",
                Duration = 3
            })

            return
        end

        local targetHRP =
            targetChar:FindFirstChild(
                "HumanoidRootPart"
            )

        if not targetHRP then

            Rayfield:Notify({
                Title = "오류",
                Content =
                    "대상의 위치를 찾을 수 없습니다.",
                Duration = 3
            })

            return
        end

        local char =
            player.Character

        if not char then
            return
        end

        local hrp =
            char:FindFirstChild(
                "HumanoidRootPart"
            )

        if not hrp then
            return
        end

        local targetCFrame =
            targetHRP.CFrame *
            CFrame.new(
                0,
                3,
                0
            )

        pcall(function()
            char:PivotTo(
                targetCFrame
            )
        end)

        hrp.CFrame =
            targetCFrame

        Rayfield:Notify({
            Title = "이동 완료",
            Content =
                targetPlayer.Name ..
                "에게 이동했습니다.",
            Duration = 2
        })
    end
})

Players.PlayerAdded:Connect(
    function()
        task.wait(0.5)
        updatePlayerList()
    end
)

Players.PlayerRemoving:Connect(
    function()
        task.wait(0.5)
        updatePlayerList()
    end
)

task.spawn(function()
    task.wait(1)
    updatePlayerList()
end)

TeleportTab:CreateSection(
    "저장된 위치"
)

local savedPositions = {}

TeleportTab:CreateButton({
    Name = "현재 위치 저장",

    Callback = function()

        local char =
            player.Character

        if not char then
            return
        end

        local hrp =
            char:FindFirstChild(
                "HumanoidRootPart"
            )

        if not hrp then
            return
        end

        local posName =
            "위치_" ..
            tostring(
                #savedPositions + 1
            )

        savedPositions[posName] =
            hrp.CFrame

        Rayfield:Notify({
            Title = "저장 완료",
            Content =
                posName ..
                " 저장됨",
            Duration = 3
        })
    end
})

TeleportTab:CreateButton({
    Name = "저장된 위치로 이동",

    Callback = function()

        local char =
            player.Character

        if not char then
            return
        end

        local hrp =
            char:FindFirstChild(
                "HumanoidRootPart"
            )

        if not hrp then
            return
        end

        for name, cframe in
            pairs(
                savedPositions
            ) do

            pcall(function()
                char:PivotTo(
                    cframe
                )
            end)

            hrp.CFrame =
                cframe

            Rayfield:Notify({
                Title = "이동 완료",
                Content =
                    name ..
                    "으로 이동",
                Duration = 2
            })

            break
        end
    end
})

--==================================================
-- MOVEMENT
--==================================================

MainTab:CreateSection(
    "Movement"
)

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,

    Callback = function(Value)

        noclipOn = Value

        if not Value then

            local char =
                player.Character

            if char then

                for _, part in
                    ipairs(
                        char:GetDescendants()
                    ) do

                    if part:IsA(
                        "BasePart"
                    ) then

                        part.CanCollide =
                            true
                    end
                end
            end
        end
    end
})

RunService.Stepped:Connect(
    function()

        if not noclipOn then
            return
        end

        local char =
            player.Character

        if not char then
            return
        end

        for _, part in
            ipairs(
                char:GetDescendants()
            ) do

            if part:IsA(
                "BasePart"
            ) then

                part.CanCollide =
                    false
            end
        end
    end
)

--==================================================
-- WALL CLIMB
--==================================================

local wallClimbConnection
local wallClimbSpeed = 50

local function stopWallClimb()

    if wallClimbConnection then
        wallClimbConnection:Disconnect()
        wallClimbConnection = nil
    end

    local char =
        player.Character

    if not char then
        return
    end

    local hrp =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    if hrp then

        local velocity =
            hrp.AssemblyLinearVelocity

        hrp.AssemblyLinearVelocity =
            Vector3.new(
                velocity.X,
                0,
                velocity.Z
            )
    end
end

local function startWallClimb()

    stopWallClimb()

    wallClimbConnection =
        RunService.Heartbeat:Connect(
            function()

                if not wallClimbOn then
                    return
                end

                local char =
                    player.Character

                if not char then
                    return
                end

                local hrp =
                    char:FindFirstChild(
                        "HumanoidRootPart"
                    )

                local humanoid =
                    char:FindFirstChildOfClass(
                        "Humanoid"
                    )

                if not hrp or
                    not humanoid then
                    return
                end

                local rayParams =
                    RaycastParams.new()

                rayParams.FilterDescendantsInstances =
                    {
                        char
                    }

                rayParams.FilterType =
                    Enum.RaycastFilterType.Exclude

                local directions = {
                    hrp.CFrame.LookVector,
                    -hrp.CFrame.LookVector,
                    hrp.CFrame.RightVector,
                    -hrp.CFrame.RightVector
                }

                local wallFound =
                    false

                for _, direction in
                    ipairs(
                        directions
                    ) do

                    local result =
                        workspace:Raycast(
                            hrp.Position,
                            direction * 3,
                            rayParams
                        )

                    if result then
                        wallFound = true
                        break
                    end
                end

                if wallFound then

                    local currentVelocity =
                        hrp.AssemblyLinearVelocity

                    hrp.AssemblyLinearVelocity =
                        Vector3.new(
                            currentVelocity.X,
                            wallClimbSpeed,
                            currentVelocity.Z
                        )

                    humanoid:ChangeState(
                        Enum.HumanoidStateType.Climbing
                    )
                end
            end
        )
end

MainTab:CreateToggle({
    Name = "Wall Climb",
    CurrentValue = false,

    Callback = function(Value)

        wallClimbOn = Value

        if Value then
            startWallClimb()
        else
            stopWallClimb()
        end
    end
})

MainTab:CreateSlider({
    Name = "Wall Climb Speed",
    Range = {10, 200},
    Increment = 10,
    Suffix = "Speed",
    CurrentValue = 50,

    Callback = function(Value)
        wallClimbSpeed = Value
    end
})

--==================================================
-- FLY
--==================================================

local flySpeed = 50
local flyConnection

local function stopFly()

    flyOn = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    local char =
        player.Character

    if not char then
        return
    end

    local root =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    local humanoid =
        char:FindFirstChildOfClass(
            "Humanoid"
        )

    if root then

        local bv =
            root:FindFirstChild(
                "JASON_FLY_VELOCITY"
            )

        if bv then
            bv:Destroy()
        end

        local bg =
            root:FindFirstChild(
                "JASON_FLY_GYRO"
            )

        if bg then
            bg:Destroy()
        end
    end

    if humanoid then
        humanoid.PlatformStand =
            false
    end
end

local function startFly()

    stopFly()
    flyOn = true

    local char =
        player.Character

    if not char then
        return
    end

    local root =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    local humanoid =
        char:FindFirstChildOfClass(
            "Humanoid"
        )

    if not root or
        not humanoid then

        flyOn = false
        return
    end

    local bodyVelocity =
        Instance.new(
            "BodyVelocity"
        )

    bodyVelocity.Name =
        "JASON_FLY_VELOCITY"

    bodyVelocity.MaxForce =
        Vector3.new(
            math.huge,
            math.huge,
            math.huge
        )

    bodyVelocity.Velocity =
        Vector3.zero

    bodyVelocity.Parent =
        root

    local bodyGyro =
        Instance.new(
            "BodyGyro"
        )

    bodyGyro.Name =
        "JASON_FLY_GYRO"

    bodyGyro.MaxTorque =
        Vector3.new(
            math.huge,
            math.huge,
            math.huge
        )

    bodyGyro.P =
        9000

    bodyGyro.CFrame =
        workspace.CurrentCamera.CFrame

    bodyGyro.Parent =
        root

    humanoid.PlatformStand =
        true

    flyConnection =
        RunService.RenderStepped:Connect(
            function()

                if not flyOn then
                    return
                end

                local camera =
                    workspace.CurrentCamera

                local currentChar =
                    player.Character

                if not camera or
                    not currentChar then
                    return
                end

                local currentRoot =
                    currentChar:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if not currentRoot then
                    return
                end

                local velocity =
                    currentRoot:FindFirstChild(
                        "JASON_FLY_VELOCITY"
                    )

                local gyro =
                    currentRoot:FindFirstChild(
                        "JASON_FLY_GYRO"
                    )

                if not velocity or
                    not gyro then
                    return
                end

                local moveDirection =
                    Vector3.zero

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.W
                ) then

                    moveDirection +=
                        camera.CFrame.LookVector
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.S
                ) then

                    moveDirection -=
                        camera.CFrame.LookVector
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.A
                ) then

                    moveDirection -=
                        camera.CFrame.RightVector
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.D
                ) then

                    moveDirection +=
                        camera.CFrame.RightVector
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.Space
                ) then

                    moveDirection +=
                        Vector3.new(
                            0,
                            1,
                            0
                        )
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.LeftControl
                ) then

                    moveDirection -=
                        Vector3.new(
                            0,
                            1,
                            0
                        )
                end

                if moveDirection.Magnitude > 0 then
                    moveDirection =
                        moveDirection.Unit
                end

                velocity.Velocity =
                    moveDirection *
                    flySpeed

                gyro.CFrame =
                    camera.CFrame
            end
        )
end

MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,

    Callback = function(Value)

        if Value then
            startFly()
        else
            stopFly()
        end
    end
})

MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 500},
    Increment = 10,
    Suffix = "Speed",
    CurrentValue = 50,

    Callback = function(Value)
        flySpeed = Value
    end
})

player.CharacterAdded:Connect(
    function()

        if flyOn then
            task.wait(0.5)
            startFly()
        end

        if wallClimbOn then
            task.wait(0.5)
            startWallClimb()
        end
    end
)

--==================================================
-- OTHER
--==================================================

local OtherTab =
    Window:CreateTab(
        "기타",
        4483362458
    )

OtherTab:CreateSection(
    "도구"
)

local infiniteYieldLoaded =
    false

OtherTab:CreateButton({
    Name = "Infinite Yield",

    Callback = function()

        if infiniteYieldLoaded then
            return
        end

        infiniteYieldLoaded =
            true

        task.spawn(
            function()

                local success =
                    pcall(
                        function()

                            loadstring(
                                game:HttpGetAsync(
                                    "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
                                )
                            )()
                        end
                    )

                if not success then
                    infiniteYieldLoaded =
                        false
                end
            end
        )
    end
})

--==================================================
-- CALCULATOR
--==================================================

local CalculatorGui =
    Instance.new(
        "ScreenGui"
    )

CalculatorGui.Name =
    "JASON_CALCULATOR"

CalculatorGui.ResetOnSpawn =
    false

CalculatorGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

CalculatorGui.Enabled =
    false

CalculatorGui.Parent =
    player:WaitForChild(
        "PlayerGui"
    )

local CalculatorFrame =
    Instance.new(
        "Frame"
    )

CalculatorFrame.Name =
    "CalculatorFrame"

CalculatorFrame.Size =
    UDim2.new(
        0,
        300,
        0,
        410
    )

CalculatorFrame.Position =
    UDim2.new(
        0.5,
        -150,
        0.5,
        -205
    )

CalculatorFrame.BackgroundColor3 =
    Color3.fromRGB(
        25,
        25,
        25
    )

CalculatorFrame.BorderSizePixel =
    0

CalculatorFrame.Parent =
    CalculatorGui

local CalculatorCorner =
    Instance.new(
        "UICorner"
    )

CalculatorCorner.CornerRadius =
    UDim.new(
        0,
        12
    )

CalculatorCorner.Parent =
    CalculatorFrame

local CalculatorTop =
    Instance.new(
        "Frame"
    )

CalculatorTop.Name =
    "Top"

CalculatorTop.Size =
    UDim2.new(
        1,
        0,
        0,
        45
    )

CalculatorTop.BackgroundColor3 =
    Color3.fromRGB(
        35,
        35,
        35
    )

CalculatorTop.BorderSizePixel =
    0

CalculatorTop.Parent =
    CalculatorFrame

local TopCorner =
    Instance.new(
        "UICorner"
    )

TopCorner.CornerRadius =
    UDim.new(
        0,
        12
    )

TopCorner.Parent =
    CalculatorTop

local CalculatorTitle =
    Instance.new(
        "TextLabel"
    )

CalculatorTitle.Size =
    UDim2.new(
        1,
        -50,
        1,
        0
    )

CalculatorTitle.Position =
    UDim2.new(
        0,
        12,
        0,
        0
    )

CalculatorTitle.BackgroundTransparency =
    1

CalculatorTitle.Text =
    "JASON 계산기"

CalculatorTitle.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

CalculatorTitle.TextSize =
    18

CalculatorTitle.Font =
    Enum.Font.SourceSansBold

CalculatorTitle.TextXAlignment =
    Enum.TextXAlignment.Left

CalculatorTitle.Parent =
    CalculatorTop

local CalculatorClose =
    Instance.new(
        "TextButton"
    )

CalculatorClose.Name =
    "Close"

CalculatorClose.Size =
    UDim2.new(
        0,
        40,
        0,
        40
    )

CalculatorClose.Position =
    UDim2.new(
        1,
        -43,
        0,
        2
    )

CalculatorClose.BackgroundTransparency =
    1

CalculatorClose.Text =
    "X"

CalculatorClose.TextColor3 =
    Color3.fromRGB(
        255,
        80,
        80
    )

CalculatorClose.TextSize =
    20

CalculatorClose.Font =
    Enum.Font.SourceSansBold

CalculatorClose.Parent =
    CalculatorTop

CalculatorClose.MouseButton1Click:Connect(
    function()
        CalculatorGui.Enabled =
            false
    end
)

local CalculatorDisplay =
    Instance.new(
        "TextLabel"
    )

CalculatorDisplay.Name =
    "Display"

CalculatorDisplay.Size =
    UDim2.new(
        1,
        -20,
        0,
        65
    )

CalculatorDisplay.Position =
    UDim2.new(
        0,
        10,
        0,
        55
    )

CalculatorDisplay.BackgroundColor3 =
    Color3.fromRGB(
        15,
        15,
        15
    )

CalculatorDisplay.BorderSizePixel =
    0

CalculatorDisplay.Text =
    "0"

CalculatorDisplay.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

CalculatorDisplay.TextSize =
    28

CalculatorDisplay.Font =
    Enum.Font.SourceSansBold

CalculatorDisplay.TextXAlignment =
    Enum.TextXAlignment.Right

CalculatorDisplay.TextYAlignment =
    Enum.TextYAlignment.Center

CalculatorDisplay.ClipsDescendants =
    true

CalculatorDisplay.Parent =
    CalculatorFrame

local DisplayCorner =
    Instance.new(
        "UICorner"
    )

DisplayCorner.CornerRadius =
    UDim.new(
        0,
        8
    )

DisplayCorner.Parent =
    CalculatorDisplay

local calculatorText =
    ""

local function updateCalculatorDisplay()

    CalculatorDisplay.Text =
        calculatorText == "" and
        "0" or
        calculatorText
end

local function calculateExpression(
    expression
)

    if not expression:match(
        "^[%d%+%-%*/%.%s]+$"
    ) then
        return nil
    end

    expression =
        expression:gsub(
            "%s+",
            ""
        )

    if expression == "" then
        return nil
    end

    local numbers = {}
    local operators = {}
    local number = ""

    for i = 1, #expression do

        local char =
            expression:sub(
                i,
                i
            )

        if char:match(
            "[%d%.]"
        ) then

            number =
                number ..
                char

        elseif char == "+" or
            char == "-" or
            char == "*" or
            char == "/" then

            if number == "" then
                return nil
            end

            local value =
                tonumber(
                    number
                )

            if not value then
                return nil
            end

            table.insert(
                numbers,
                value
            )

            table.insert(
                operators,
                char
            )

            number = ""

        else
            return nil
        end
    end

    if number == "" then
        return nil
    end

    local value =
        tonumber(
            number
        )

    if not value then
        return nil
    end

    table.insert(
        numbers,
        value
    )

    local newNumbers = {}
    local newOperators = {}

    local current =
        numbers[1]

    for i = 1, #operators do

        local operator =
            operators[i]

        local nextNumber =
            numbers[i + 1]

        if operator == "*" then

            current =
                current *
                nextNumber

        elseif operator == "/" then

            if nextNumber == 0 then
                return nil
            end

            current =
                current /
                nextNumber

        else

            table.insert(
                newNumbers,
                current
            )

            table.insert(
                newOperators,
                operator
            )

            current =
                nextNumber
        end
    end

    table.insert(
        newNumbers,
        current
    )

    local result =
        newNumbers[1]

    for i = 1, #newOperators do

        if newOperators[i] == "+" then

            result =
                result +
                newNumbers[i + 1]

        else

            result =
                result -
                newNumbers[i + 1]
        end
    end

    return result
end

local function createCalculatorButton(
    text,
    x,
    y
)

    local button =
        Instance.new(
            "TextButton"
        )

    button.Name =
        "Button_" ..
        text

    button.Size =
        UDim2.new(
            0,
            62,
            0,
            52
        )

    button.Position =
        UDim2.new(
            0,
            10 + (x * 70),
            0,
            135 + (y * 58)
        )

    button.BackgroundColor3 =
        Color3.fromRGB(
            45,
            45,
            45
        )

    button.BorderSizePixel =
        0

    button.Text =
        text

    button.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )

    button.TextSize =
        22

    button.Font =
        Enum.Font.SourceSansBold

    button.Parent =
        CalculatorFrame

    local corner =
        Instance.new(
            "UICorner"
        )

    corner.CornerRadius =
        UDim.new(
            0,
            8
        )

    corner.Parent =
        button

    button.MouseButton1Click:Connect(
        function()

            if text == "C" then

                calculatorText =
                    ""

            else

                calculatorText =
                    calculatorText ..
                    text
            end

            updateCalculatorDisplay()
        end
    )
end

createCalculatorButton(
    "7",
    0,
    0
)

createCalculatorButton(
    "8",
    1,
    0
)

createCalculatorButton(
    "9",
    2,
    0
)

createCalculatorButton(
    "/",
    3,
    0
)

createCalculatorButton(
    "4",
    0,
    1
)

createCalculatorButton(
    "5",
    1,
    1
)

createCalculatorButton(
    "6",
    2,
    1
)

createCalculatorButton(
    "*",
    3,
    1
)

createCalculatorButton(
    "1",
    0,
    2
)

createCalculatorButton(
    "2",
    1,
    2
)

createCalculatorButton(
    "3",
    2,
    2
)

createCalculatorButton(
    "-",
    3,
    2
)

createCalculatorButton(
    "0",
    0,
    3
)

createCalculatorButton(
    ".",
    1,
    3
)

createCalculatorButton(
    "C",
    2,
    3
)

createCalculatorButton(
    "+",
    3,
    3
)

local EqualButton =
    Instance.new(
        "TextButton"
    )

EqualButton.Name =
    "Equal"

EqualButton.Size =
    UDim2.new(
        0,
        272,
        0,
        45
    )

EqualButton.Position =
    UDim2.new(
        0,
        14,
        0,
        370
    )

EqualButton.BackgroundColor3 =
    Color3.fromRGB(
        60,
        60,
        60
    )

EqualButton.BorderSizePixel =
    0

EqualButton.Text =
    "="

EqualButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

EqualButton.TextSize =
    24

EqualButton.Font =
    Enum.Font.SourceSansBold

EqualButton.Parent =
    CalculatorFrame

local EqualCorner =
    Instance.new(
        "UICorner"
    )

EqualCorner.CornerRadius =
    UDim.new(
        0,
        8
    )

EqualCorner.Parent =
    EqualButton

EqualButton.MouseButton1Click:Connect(
    function()

        if calculatorText == "" then
            return
        end

        local result =
            calculateExpression(
                calculatorText
            )

        if result == nil then

            CalculatorDisplay.Text =
                "Error"

            task.delay(
                1,
                function()

                    if CalculatorGui.Enabled then

                        calculatorText =
                            ""

                        updateCalculatorDisplay()
                    end
                end
            )

        else

            calculatorText =
                tostring(
                    result
                )

            updateCalculatorDisplay()
        end
    end
)

OtherTab:CreateButton({
    Name = "계산기",

    Callback = function()

        CalculatorGui.Enabled =
            true

        calculatorText =
            ""

        updateCalculatorDisplay()
    end
})

--==================================================
-- INFO
--==================================================

local InfoTab =
    Window:CreateTab(
        "Info",
        4483362458
    )

InfoTab:CreateParagraph({
    Title = "JASON HUB",
    Content = "Sword Fight"
})

Rayfield:Notify({
    Title = "JASON HUB",
    Content = "Loaded!",
    Duration = 3
})
