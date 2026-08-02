-- LocalScript, z.B. in StarterPlayerScripts

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============ POST-PROCESSING EFFEKTE ERSTELLEN ============
local function getOrCreate(className, name)
    local existing = Lighting:FindFirstChild(name)
    if existing then return existing end
    local obj = Instance.new(className)
    obj.Name = name
    obj.Parent = Lighting
    return obj
end

local bloom = getOrCreate("BloomEffect", "MainBloom")
local colorCorrection = getOrCreate("ColorCorrectionEffect", "MainColorCorrection")
local sunRays = getOrCreate("SunRaysEffect", "MainSunRays")
local depthOfField = getOrCreate("DepthOfFieldEffect", "MainDOF")
local atmosphere = getOrCreate("Atmosphere", "MainAtmosphere")

-- ============ HIMMEL ============
local sky = getOrCreate("Sky", "MainSky")
sky.SkyboxBk = "rbxasset://sky/sky512_bk.tex"
sky.SkyboxDn = "rbxasset://sky/sky512_dn.tex"
sky.SkyboxFt = "rbxasset://sky/sky512_ft.tex"
sky.SkyboxLf = "rbxasset://sky/sky512_lf.tex"
sky.SkyboxRt = "rbxasset://sky/sky512_rt.tex"
sky.SkyboxUp = "rbxasset://sky/sky512_up.tex"
sky.CelestialBodiesShown = true
sky.StarCount = 3000

-- ============ QUALITÄTS-PRESETS ============
local presets = {
    Ultra = function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
        Lighting.Technology = Enum.Technology.Future -- beste Beleuchtung (Schatten, Reflexionen)
        Lighting.GlobalShadows = true
        Lighting.Brightness = 3
        Lighting.ExposureCompensation = 0.2

        bloom.Intensity = 0.6
        bloom.Size = 24
        bloom.Threshold = 1.2

        colorCorrection.Saturation = 0.15
        colorCorrection.Contrast = 0.1
        colorCorrection.TintColor = Color3.fromRGB(255, 250, 240)

        sunRays.Intensity = 0.15
        sunRays.Spread = 0.5

        depthOfField.FarIntensity = 0.3
        depthOfField.FocusDistance = 50
        depthOfField.InFocusRadius = 30
        depthOfField.NearIntensity = 0

        atmosphere.Density = 0.35
        atmosphere.Offset = 0.2
        atmosphere.Color = Color3.fromRGB(199, 199, 199)
        atmosphere.Decay = Color3.fromRGB(92, 60, 13)
        atmosphere.Glare = 0.2
        atmosphere.Haze = 1.2

        workspace.StreamingTargetRadius = 1024
    end,

    Standard = function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        Lighting.Technology = Enum.Technology.ShadowMap
        Lighting.GlobalShadows = true
        Lighting.Brightness = 2

        bloom.Intensity = 0.3
        bloom.Size = 16
        bloom.Threshold = 1.5

        colorCorrection.Saturation = 0.05
        colorCorrection.Contrast = 0.05

        sunRays.Intensity = 0.05
        sunRays.Spread = 0.3

        depthOfField.FarIntensity = 0.1
        depthOfField.NearIntensity = 0

        atmosphere.Density = 0.2
        atmosphere.Haze = 0.5

        workspace.StreamingTargetRadius = 512
    end,
}

-- ============ TAGESZEIT ============
local function setTimeOfDay(clockTime)
    Lighting.ClockTime = clockTime
end

-- ============ REGEN-SYSTEM ============
local rainFolder = Instance.new("Folder")
rainFolder.Name = "RainEffect"
rainFolder.Parent = workspace

local rainEmitter -- ParticleEmitter für Regen
local rainSound

local function createRain()
    local part = Instance.new("Part")
    part.Name = "RainEmitterPart"
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(200, 1, 200)
    part.Parent = rainFolder

    rainEmitter = Instance.new("ParticleEmitter")
    rainEmitter.Texture = "rbxasset://textures/particles/rain_drop_01.dds"
    rainEmitter.Rate = 0
    rainEmitter.Lifetime = NumberRange.new(1.2, 1.5)
    rainEmitter.Speed = NumberRange.new(60, 60)
    rainEmitter.SpreadAngle = Vector2.new(0, 0)
    rainEmitter.Rotation = NumberRange.new(180, 180)
    rainEmitter.Size = NumberSequence.new(0.3)
    rainEmitter.Transparency = NumberSequence.new(0.6)
    rainEmitter.Acceleration = Vector3.new(0, -40, 0)
    rainEmitter.Parent = part

    rainSound = Instance.new("Sound")
    rainSound.SoundId = "rbxasset://sounds/rain.mp3"
    rainSound.Looped = true
    rainSound.Volume = 0
    rainSound.Parent = part

    -- Emitter folgt der Kamera, damit Regen immer über dem Spieler ist
    game:GetService("RunService").RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam then
            part.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 40, 0))
        end
    end)
end

createRain()

local rainOn = false
local function setRain(state)
    rainOn = state
    if state then
        rainEmitter.Rate = 400
        rainSound.Volume = 0.4
        if not rainSound.IsPlaying then rainSound:Play() end
        atmosphere.Density = 0.5
        Lighting.Brightness = math.min(Lighting.Brightness, 1.5)
    else
        rainEmitter.Rate = 0
        rainSound.Volume = 0
        rainSound:Stop()
    end
end

-- ============ GUI ============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GraphicsGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 340)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "🌤 Grafik-Einstellungen"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.LayoutOrder = 0
title.Parent = frame

local function createButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = text
    btn.LayoutOrder = order
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    btn.Parent = frame
    return btn
end

-- Qualität
local qualityBtn = createButton("Qualität: Ultra 🌟", 1)
local isUltra = true
presets.Ultra() -- Standardmäßig Ultra aktiv

qualityBtn.MouseButton1Click:Connect(function()
    isUltra = not isUltra
    if isUltra then
        presets.Ultra()
        qualityBtn.Text = "Qualität: Ultra 🌟"
    else
        presets.Standard()
        qualityBtn.Text = "Qualität: Standard"
    end
end)

-- Tageszeit
local timeBtn = createButton("Zeit: Mittag ☀", 2)
local times = {{6, "Morgen 🌅"}, {12, "Mittag ☀"}, {18, "Abend 🌇"}, {0, "Nacht 🌙"}}
local timeIndex = 2
setTimeOfDay(times[timeIndex][1])

timeBtn.MouseButton1Click:Connect(function()
    timeIndex = (timeIndex % #times) + 1
    setTimeOfDay(times[timeIndex][1])
    timeBtn.Text = "Zeit: " .. times[timeIndex][2]
end)

-- Regen
local rainBtn = createButton("Regen: AUS 🌦", 3)
rainBtn.MouseButton1Click:Connect(function()
    setRain(not rainOn)
    rainBtn.Text = "Regen: " .. (rainOn and "AN 🌧" or "AUS 🌦")
end)

-- Bloom Intensität
local bloomBtn = createButton("Bloom: Stark", 4)
local bloomOn = true
bloomBtn.MouseButton1Click:Connect(function()
    bloomOn = not bloomOn
    bloom.Enabled = bloomOn
    bloomBtn.Text = "Bloom: " .. (bloomOn and "Stark" or "AUS")
end)

-- Tiefenschärfe
local dofBtn = createButton("Tiefenschärfe: AN", 5)
local dofOn = true
dofBtn.MouseButton1Click:Connect(function()
    dofOn = not dofOn
    depthOfField.Enabled = dofOn
    dofBtn.Text = "Tiefenschärfe: " .. (dofOn and "AN" or "AUS")
end)

-- GUI ein/ausblenden mit Taste G
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        frame.Visible = not frame.Visible
    end
end)
