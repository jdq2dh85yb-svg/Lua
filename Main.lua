-- SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

_G.UISound = true
_G.KillSoundOn = false
_G.KillSoundId = 4612365796
_G.KillVolume = 0.7
_G.Unlocked = false

------------------------------------------------
-- RESPONSIVE
------------------------------------------------
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local isTablet = UIS.TouchEnabled and UIS.KeyboardEnabled

local GUI_W  = isMobile and 300 or isTablet and 360 or 410
local GUI_H  = isMobile and 470 or isTablet and 520 or 560
local FONT_L = isMobile and 11 or 13
local FONT_S = isMobile and 9  or 10
local CARD_H = isMobile and 40 or 46
local CARD_HD= isMobile and 50 or 56

------------------------------------------------
-- VALID KEYS (hier kannst du eigene Keys eintragen)
------------------------------------------------
local VALID_KEYS = {
    ["GODVALLEY-V5-FREE"]  = true,
    ["ONEPIECE-TSB-2024"]  = true,
    ["LUFFY-KING-777"]     = true,
}

-- Key Website (Linkvertise Style — ersetze mit deiner echten URL)
local KEY_WEBSITE = "https://link-hub.net/5076357/RRaG4BQseIme"

------------------------------------------------
-- SOUND
------------------------------------------------
local function playUI(pitch)
    if not _G.UISound then return end
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://6042053626"
    s.Volume = 0.3
    s.PlaybackSpeed = pitch or 1
    s.Parent = SoundService
    s:Play()
    game:GetService("Debris"):AddItem(s, 3)
end

local function playSound(id, vol, pitch)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Volume = vol or 1
    s.PlaybackSpeed = pitch or 1
    s.Parent = SoundService
    s:Play()
    game:GetService("Debris"):AddItem(s, 6)
end

------------------------------------------------
-- KILL SOUND
------------------------------------------------
local function setupKillSound(on, id)
    _G.KillSoundOn = on
    _G.KillSoundId = id or 4612365796
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            if _G.KillSoundOn and plr ~= LocalPlayer then
                playSound(_G.KillSoundId, _G.KillVolume, 1)
            end
        end)
    end)
end)
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                if _G.KillSoundOn then playSound(_G.KillSoundId, _G.KillVolume, 1) end
            end)
        end
    end
end

------------------------------------------------
-- GRAFIK PRESETS
------------------------------------------------
local function clearPostFX()
    for _, c in ipairs(Lighting:GetChildren()) do
        if c:IsA("PostEffect") or c:IsA("Atmosphere") then c:Destroy() end
    end
end

local GrafixPresets = {
    ["POTATO"] = function()
        clearPostFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material=Enum.Material.Plastic v.Reflectance=0 v.CastShadow=false end
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false end
        end
    end,
    ["LOW"] = function()
        clearPostFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level03
        Lighting.GlobalShadows = false
    end,
    ["MEDIUM"] = function()
        clearPostFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level07
        Lighting.GlobalShadows = true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=0.3 b.Size=20 b.Threshold=0.98
    end,
    ["HIGH"] = function()
        clearPostFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level14
        Lighting.GlobalShadows = true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=0.6 b.Size=36 b.Threshold=0.93
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.2 cc.Contrast=0.1
        local sr=Instance.new("SunRaysEffect",Lighting) sr.Intensity=0.08 sr.Spread=0.4
    end,
    ["ULTRA"] = function()
        clearPostFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
        Lighting.GlobalShadows = true
        Lighting.Brightness = 2.5
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=1.2 b.Size=56 b.Threshold=0.85
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.4 cc.Contrast=0.2 cc.Brightness=0.05
        local sr=Instance.new("SunRaysEffect",Lighting) sr.Intensity=0.15 sr.Spread=0.6
        local a=Instance.new("Atmosphere",Lighting) a.Density=0.35 a.Haze=0.4 a.Glare=0.6 a.Color=Color3.fromRGB(199,210,255)
    end,
    ["CINEMATIC"] = function()
        clearPostFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
        Lighting.GlobalShadows = true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=2 b.Size=80 b.Threshold=0.75
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.6 cc.Contrast=0.3 cc.TintColor=Color3.fromRGB(210,220,255)
        local sr=Instance.new("SunRaysEffect",Lighting) sr.Intensity=0.25 sr.Spread=0.8
    end,
    ["ANIME"] = function()
        clearPostFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level14
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=3 b.Size=100 b.Threshold=0.6
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.8 cc.Contrast=0.25 cc.TintColor=Color3.fromRGB(255,210,230)
    end,
}

------------------------------------------------
-- FARBEN
------------------------------------------------
local C = {
    bg      = Color3.fromRGB(7,7,14),
    panel   = Color3.fromRGB(13,13,24),
    card    = Color3.fromRGB(19,19,34),
    cardHov = Color3.fromRGB(27,27,48),
    accent  = Color3.fromRGB(255,185,50),
    accent2 = Color3.fromRGB(255,75,45),
    green   = Color3.fromRGB(75,215,125),
    red     = Color3.fromRGB(255,75,75),
    off     = Color3.fromRGB(42,42,62),
    text    = Color3.fromRGB(238,232,218),
    sub     = Color3.fromRGB(135,125,105),
    white   = Color3.new(1,1,1),
    black   = Color3.fromRGB(5,5,10),
}

local IMG = {
    luffy  = "rbxassetid://7072085162",
    zoro   = "rbxassetid://7072086105",
    jolly  = "rbxassetid://6031075938",
    bolt   = "rbxassetid://6034284934",
    eye    = "rbxassetid://6034768450",
    tool   = "rbxassetid://6034769670",
    music  = "rbxassetid://6034686678",
    gem    = "rbxassetid://6034684949",
    key    = "rbxassetid://6034682716",
    lock   = "rbxassetid://6031294871",
    globe  = "rbxassetid://6034500615",
}

------------------------------------------------
-- SCREENUI
------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GodValleyV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------
-- PARTIKEL HINTERGRUND ANIMATION
------------------------------------------------
local function spawnParticle()
    local p = Instance.new("Frame", ScreenGui)
    local size = math.random(2, 5)
    p.Size = UDim2.new(0, size, 0, size)
    p.Position = UDim2.new(math.random(0,100)/100, 0, 1, 0)
    p.BackgroundColor3 = math.random(1,2) == 1 and C.accent or C.accent2
    p.BackgroundTransparency = 0.4
    p.BorderSizePixel = 0
    p.ZIndex = 1
    Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)

    local targetY = math.random(-100, -10) / 100
    TweenService:Create(p, TweenInfo.new(math.random(4,9), Enum.EasingStyle.Linear), {
        Position = UDim2.new(math.random(0,100)/100, 0, targetY, 0),
        BackgroundTransparency = 1,
    }):Play()
    game:GetService("Debris"):AddItem(p, 10)
end

task.spawn(function()
    while true do
        spawnParticle()
        task.wait(0.3)
    end
end)

------------------------------------------------
-- KEY SYSTEM SCREEN
------------------------------------------------
local KeyScreen = Instance.new("Frame", ScreenGui)
KeyScreen.Size = UDim2.new(1, 0, 1, 0)
KeyScreen.BackgroundColor3 = C.black
KeyScreen.ZIndex = 50
KeyScreen.BorderSizePixel = 0

-- Dunkler Overlay Gradient
local KSGrad = Instance.new("UIGradient", KeyScreen)
KSGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10,5,20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5,5,12)),
})
KSGrad.Rotation = 135

-- Animierter Titel oben
local KSTitle = Instance.new("TextLabel", KeyScreen)
KSTitle.Size = UDim2.new(1, 0, 0, 50)
KSTitle.Position = UDim2.new(0, 0, 0, isMobile and 60 or 80)
KSTitle.BackgroundTransparency = 1
KSTitle.Text = "⚓ GOD VALLEY HUB"
KSTitle.TextColor3 = C.accent
KSTitle.Font = Enum.Font.GothamBold
KSTitle.TextSize = isMobile and 22 or 28
KSTitle.ZIndex = 51

local KSTGrad = Instance.new("UIGradient", KSTitle)
KSTGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.accent),
    ColorSequenceKeypoint.new(1, C.accent2),
})

-- Titel Bounce Animation
task.spawn(function()
    while KeyScreen.Visible do
        TweenService:Create(KSTitle, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0, 0, 0, (isMobile and 60 or 80) + 6)
        }):Play()
        task.wait(1.2)
        TweenService:Create(KSTitle, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0, 0, 0, isMobile and 60 or 80)
        }):Play()
        task.wait(1.2)
    end
end)

-- Untertitel
local KSSub = Instance.new("TextLabel", KeyScreen)
KSSub.Size = UDim2.new(1, 0, 0, 20)
KSSub.Position = UDim2.new(0, 0, 0, isMobile and 118 or 138)
KSSub.BackgroundTransparency = 1
KSSub.Text = "The Strongest Battleground  |  One Piece Edition"
KSSub.TextColor3 = C.sub
KSSub.Font = Enum.Font.Gotham
KSSub.TextSize = isMobile and 10 or 12
KSSub.ZIndex = 51

-- Luffy Bild links, Zoro rechts (dekorativ)
local KSLuffy = Instance.new("ImageLabel", KeyScreen)
KSLuffy.Size = UDim2.new(0, isMobile and 80 or 120, 0, isMobile and 80 or 120)
KSLuffy.Position = UDim2.new(0, isMobile and 10 or 30, 0.5, isMobile and -100 or -80)
KSLuffy.BackgroundTransparency = 1
KSLuffy.Image = IMG.luffy
KSLuffy.ZIndex = 51

local KSZoro = Instance.new("ImageLabel", KeyScreen)
KSZoro.Size = UDim2.new(0, isMobile and 80 or 120, 0, isMobile and 80 or 120)
KSZoro.Position = UDim2.new(1, isMobile and -90 or -150, 0.5, isMobile and -100 or -80)
KSZoro.BackgroundTransparency = 1
KSZoro.Image = IMG.zoro
KSZoro.ZIndex = 51

-- Float Animation für Bilder
task.spawn(function()
    while KeyScreen.Visible do
        TweenService:Create(KSLuffy, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0, isMobile and 10 or 30, 0.5, isMobile and -110 or -92)
        }):Play()
        TweenService:Create(KSZoro, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1, isMobile and -90 or -150, 0.5, isMobile and -88 or -68)
        }):Play()
        task.wait(1.8)
        TweenService:Create(KSLuffy, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0, isMobile and 10 or 30, 0.5, isMobile and -100 or -80)
        }):Play()
        TweenService:Create(KSZoro, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1, isMobile and -90 or -150, 0.5, isMobile and -100 or -80)
        }):Play()
        task.wait(1.8)
    end
end)

-- KEY BOX (Haupt Container)
local KeyBox = Instance.new("Frame", KeyScreen)
KeyBox.Size = UDim2.new(0, isMobile and 290 or 380, 0, isMobile and 220 or 250)
KeyBox.Position = UDim2.new(0.5, isMobile and -145 or -190, 0.5, isMobile and -80 or -90)
KeyBox.BackgroundColor3 = C.panel
KeyBox.BorderSizePixel = 0
KeyBox.ZIndex = 52
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 16)

local KBStroke = Instance.new("UIStroke", KeyBox)
KBStroke.Thickness = 1.5
KBStroke.Color = C.accent
KBStroke.Transparency = 0.3

-- Animierter Rahmen
task.spawn(function()
    local t = 0
    while KeyScreen.Visible do
        t = t + 0.025
        KBStroke.Color = C.accent:Lerp(C.accent2, (math.sin(t)+1)/2)
        task.wait(0.04)
    end
end)

-- Schloss Icon oben
local LockIcon = Instance.new("ImageLabel", KeyBox)
LockIcon.Size = UDim2.new(0, 36, 0, 36)
LockIcon.Position = UDim2.new(0.5, -18, 0, -18)
LockIcon.BackgroundColor3 = C.panel
LockIcon.BorderSizePixel = 0
LockIcon.Image = IMG.lock
LockIcon.ImageColor3 = C.accent
LockIcon.ZIndex = 54
Instance.new("UICorner", LockIcon).CornerRadius = UDim.new(1, 0)
local LIStroke = Instance.new("UIStroke", LockIcon) LIStroke.Color=C.accent LIStroke.Thickness=1.5

-- Schloss Dreh-Animation
task.spawn(function()
    while KeyScreen.Visible do
        TweenService:Create(LockIcon, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 40, 0, 40),
            Position = UDim2.new(0.5, -20, 0, -20)
        }):Play()
        task.wait(0.5)
        TweenService:Create(LockIcon, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 36, 0, 36),
            Position = UDim2.new(0.5, -18, 0, -18)
        }):Play()
        task.wait(2)
    end
end)

local KBHeader = Instance.new("TextLabel", KeyBox)
KBHeader.Size = UDim2.new(1, 0, 0, 26)
KBHeader.Position = UDim2.new(0, 0, 0, 14)
KBHeader.BackgroundTransparency = 1
KBHeader.Text = "KEY REQUIRED"
KBHeader.TextColor3 = C.text
KBHeader.Font = Enum.Font.GothamBold
KBHeader.TextSize = isMobile and 14 or 16
KBHeader.ZIndex = 53

local KBDesc = Instance.new("TextLabel", KeyBox)
KBDesc.Size = UDim2.new(1, -24, 0, 28)
KBDesc.Position = UDim2.new(0, 12, 0, 44)
KBDesc.BackgroundTransparency = 1
KBDesc.Text = "Hol dir deinen Key auf der Website\nund gib ihn unten ein."
KBDesc.TextColor3 = C.sub
KBDesc.Font = Enum.Font.Gotham
KBDesc.TextSize = isMobile and 9 or 11
KBDesc.TextWrapped = true
KBDesc.ZIndex = 53

-- GET KEY BUTTON (Website Link)
local GetKeyBtn = Instance.new("TextButton", KeyBox)
GetKeyBtn.Size = UDim2.new(1, -24, 0, isMobile and 28 or 32)
GetKeyBtn.Position = UDim2.new(0, 12, 0, 78)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 8)
GetKeyBtn.TextColor3 = C.accent
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = isMobile and 10 or 12
GetKeyBtn.Text = "🌐  Key holen → Website öffnen"
GetKeyBtn.ZIndex = 53
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)
local GKStroke = Instance.new("UIStroke", GetKeyBtn) GKStroke.Color=C.accent GKStroke.Thickness=1 GKStroke.Transparency=0.5

GetKeyBtn.MouseButton1Click:Connect(function()
    playUI(1.3)
    -- Roblox öffnet externe URLs
    setclipboard(KEY_WEBSITE)
    -- Visuelles Feedback
    local orig = GetKeyBtn.Text
    GetKeyBtn.Text = "✓  Link kopiert!"
    GetKeyBtn.TextColor3 = C.green
    task.wait(2)
    GetKeyBtn.Text = orig
    GetKeyBtn.TextColor3 = C.accent
end)

-- KEY INPUT FELD
local InputBg = Instance.new("Frame", KeyBox)
InputBg.Size = UDim2.new(1, -24, 0, isMobile and 34 or 38)
InputBg.Position = UDim2.new(0, 12, 0, isMobile and 116 or 124)
InputBg.BackgroundColor3 = C.card
InputBg.BorderSizePixel = 0
InputBg.ZIndex = 53
Instance.new("UICorner", InputBg).CornerRadius = UDim.new(0, 9)

local InputStroke = Instance.new("UIStroke", InputBg)
InputStroke.Color = C.off
InputStroke.Thickness = 1.5

local KeyInput = Instance.new("TextBox", InputBg)
KeyInput.Size = UDim2.new(1, -16, 1, 0)
KeyInput.Position = UDim2.new(0, 8, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.PlaceholderText = "Key hier eingeben..."
KeyInput.PlaceholderColor3 = C.sub
KeyInput.Text = ""
KeyInput.TextColor3 = C.text
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = isMobile and 10 or 12
KeyInput.ClearTextOnFocus = false
KeyInput.ZIndex = 54

-- Focus Glow
KeyInput.Focused:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color=C.accent}):Play()
end)
KeyInput.FocusLost:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color=C.off}):Play()
end)

-- Status Label
local StatusLbl = Instance.new("TextLabel", KeyBox)
StatusLbl.Size = UDim2.new(1, -24, 0, 14)
StatusLbl.Position = UDim2.new(0, 12, 0, isMobile and 156 or 168)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = ""
StatusLbl.TextColor3 = C.red
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextSize = FONT_S
StatusLbl.ZIndex = 53

-- ENTER / BESTÄTIGEN BUTTON
local EnterBtn = Instance.new("TextButton", KeyBox)
EnterBtn.Size = UDim2.new(1, -24, 0, isMobile and 32 or 36)
EnterBtn.Position = UDim2.new(0, 12, 0, isMobile and 176 or 192)
EnterBtn.BackgroundColor3 = C.accent2
EnterBtn.TextColor3 = C.white
EnterBtn.Font = Enum.Font.GothamBold
EnterBtn.TextSize = isMobile and 11 or 13
EnterBtn.Text = "  ENTER"
EnterBtn.ZIndex = 53
Instance.new("UICorner", EnterBtn).CornerRadius = UDim.new(0, 9)

-- Enter Button Glow Animation
task.spawn(function()
    while KeyScreen.Visible do
        TweenService:Create(EnterBtn, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(200, 60, 35)
        }):Play()
        task.wait(0.8)
        TweenService:Create(EnterBtn, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = C.accent2
        }):Play()
        task.wait(0.8)
    end
end)

-- KEY VALIDIERUNG
local function tryKey(keyText)
    keyText = keyText:upper():gsub("%s", "")
    if VALID_KEYS[keyText] then
        -- ERFOLG
        playSound(4590662766, 0.8, 1.2)
        StatusLbl.TextColor3 = C.green
        StatusLbl.Text = "✓  Key akzeptiert!"

        -- Unlock Animation
        TweenService:Create(LockIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            ImageColor3 = C.green,
            Size = UDim2.new(0, 46, 0, 46),
            Position = UDim2.new(0.5, -23, 0, -23)
        }):Play()

        task.wait(0.8)

        -- Flash Weiß
        local flash = Instance.new("Frame", KeyScreen)
        flash.Size = UDim2.new(1, 0, 1, 0)
        flash.BackgroundColor3 = Color3.new(1,1,1)
        flash.BackgroundTransparency = 0
        flash.ZIndex = 100
        flash.BorderSizePixel = 0
        TweenService:Create(flash, TweenInfo.new(0.5), {BackgroundTransparency=1}):Play()
        task.wait(0.5)

        -- KeyScreen wegfaden
        TweenService:Create(KeyScreen, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {BackgroundTransparency=1}):Play()
        for _, d in ipairs(KeyScreen:GetDescendants()) do
            if d:IsA("GuiObject") then
                TweenService:Create(d, TweenInfo.new(0.4), {
                    BackgroundTransparency = 1,
                    TextTransparency = d:IsA("TextLabel") and 1 or nil,
                    ImageTransparency = d:IsA("ImageLabel") and 1 or nil,
                }):Play()
            end
        end
        task.wait(0.7)
        KeyScreen.Visible = false
        _G.Unlocked = true

        -- Open Button einblenden mit Animation
        OpenOuter.Visible = true
        OpenOuter.Size = UDim2.new(0, 0, 0, 0)
        OpenOuter.Position = UDim2.new(0, 0, 0.5, 0)
        TweenService:Create(OpenOuter, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 54, 0, 54),
            Position = UDim2.new(0, 10, 0.5, -27),
        }):Play()

    else
        -- FEHLER
        playUI(0.6)
        StatusLbl.TextColor3 = C.red
        StatusLbl.Text = "✗  Ungültiger Key!"
        -- Shake Animation
        local origPos = InputBg.Position
        for i = 1, 4 do
            TweenService:Create(InputBg, TweenInfo.new(0.06), {
                Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + (i%2==0 and 6 or -6), origPos.Y.Scale, origPos.Y.Offset)
            }):Play()
            task.wait(0.07)
        end
        TweenService:Create(InputBg, TweenInfo.new(0.1), {Position = origPos}):Play()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color=C.red}):Play()
        task.wait(2)
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color=C.off}):Play()
        StatusLbl.Text = ""
    end
end

EnterBtn.MouseButton1Click:Connect(function()
    tryKey(KeyInput.Text)
end)

KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then tryKey(KeyInput.Text) end
end)

-- KeyScreen Intro Animation
KeyScreen.BackgroundTransparency = 1
KeyBox.Position = UDim2.new(0.5, isMobile and -145 or -190, 0.6, isMobile and -80 or -90)
task.wait(0.3)
TweenService:Create(KeyScreen, TweenInfo.new(0.5), {BackgroundTransparency=0}):Play()
TweenService:Create(KeyBox, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, isMobile and -145 or -190, 0.5, isMobile and -80 or -90)
}):Play()

------------------------------------------------
-- OPEN BUTTON (versteckt bis Key eingegeben)
------------------------------------------------
local OpenOuter = Instance.new("Frame", ScreenGui)
OpenOuter.Size = UDim2.new(0, 54, 0, 54)
OpenOuter.Position = UDim2.new(0, 10, 0.5, -27)
OpenOuter.BackgroundColor3 = C.bg
OpenOuter.BorderSizePixel = 0
OpenOuter.ZIndex = 10
OpenOuter.Visible = false
Instance.new("UICorner", OpenOuter).CornerRadius = UDim.new(1, 0)

local OBStroke = Instance.new("UIStroke", OpenOuter)
OBStroke.Thickness = 2.5
OBStroke.Color = C.accent

local OBImg = Instance.new("ImageLabel", OpenOuter)
OBImg.Size = UDim2.new(1, -6, 1, -6)
OBImg.Position = UDim2.new(0, 3, 0, 3)
OBImg.BackgroundTransparency = 1
OBImg.Image = IMG.luffy
OBImg.ScaleType = Enum.ScaleType.Fit
OBImg.ZIndex = 11
Instance.new("UICorner", OBImg).CornerRadius = UDim.new(1, 0)

local OBClick = Instance.new("TextButton", OpenOuter)
OBClick.Size = UDim2.new(1, 0, 1, 0)
OBClick.BackgroundTransparency = 1
OBClick.Text = ""
OBClick.ZIndex = 12

-- Ring Farb-Animation
task.spawn(function()
    local t = 0
    while true do
        t = t + 0.03
        OBStroke.Color = C.accent:Lerp(C.accent2, (math.sin(t)+1)/2)
        task.wait(0.04)
    end
end)

-- OPEN BUTTON DRAG (bewegbar)
local obDragging, obDragStart, obStartPos
OBClick.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        obDragging = true
        obDragStart = i.Position
        obStartPos = OpenOuter.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if obDragging and (
        i.UserInputType == Enum.UserInputType.MouseMovement
     or i.UserInputType == Enum.UserInputType.Touch
    ) then
        local d = i.Position - obDragStart
        OpenOuter.Position = UDim2.new(
            obStartPos.X.Scale,
            obStartPos.X.Offset + d.X,
            obStartPos.Y.Scale,
            obStartPos.Y.Offset + d.Y
        )
    end
end)

local obDragMoved = false
UIS.InputChanged:Connect(function(i)
    if obDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        obDragMoved = true
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        if not obDragMoved then
            -- war kein Drag → war ein Click → öffnen/schließen
        end
        obDragging = false
        obDragMoved = false
    end
end)

------------------------------------------------
-- MAIN FRAME
------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, GUI_W, 0, GUI_H)
MainFrame.Position = UDim2.new(0.5, -GUI_W/2, 0.5, -GUI_H/2)
MainFrame.BackgroundColor3 = C.bg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Visible = false
MainFrame.ZIndex = 20
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local MFStroke = Instance.new("UIStroke", MainFrame)
MFStroke.Thickness = 1.5
MFStroke.Color = C.accent
MFStroke.Transparency = 0.25

task.spawn(function()
    local t = 0
    while true do
        t = t + 0.025
        MFStroke.Color = C.accent:Lerp(C.accent2, (math.sin(t)+1)/2)
        task.wait(0.04)
    end
end)

------------------------------------------------
-- OPEN / CLOSE
------------------------------------------------
local isOpen = false

local function openHub()
    isOpen = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Visible = true
    playUI(1.3)
    TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, GUI_W, 0, GUI_H),
        Position = UDim2.new(0.5, -GUI_W/2, 0.5, -GUI_H/2),
    }):Play()
end

local function closeHub()
    isOpen = false
    playUI(0.85)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }):Play()
    task.wait(0.33)
    if not isOpen then MainFrame.Visible = false end
end

OBClick.MouseButton1Click:Connect(function()
    if not obDragMoved then
        if isOpen then closeHub() else openHub() end
    end
end)

------------------------------------------------
-- HEADER
------------------------------------------------
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = C.panel
Header.BorderSizePixel = 0
Header.ZIndex = 21
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local HGrad = Instance.new("UIGradient", Header)
HGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22,8,6)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,20)),
})
HGrad.Rotation = 90

local HJolly = Instance.new("ImageLabel", Header)
HJolly.Size = UDim2.new(0, 44, 0, 44)
HJolly.Position = UDim2.new(0, 9, 0.5, -22)
HJolly.BackgroundTransparency = 1
HJolly.Image = IMG.jolly
HJolly.ImageColor3 = C.accent
HJolly.ZIndex = 22

local HTitle = Instance.new("TextLabel", Header)
HTitle.Size = UDim2.new(0, 195, 0, 22)
HTitle.Position = UDim2.new(0, 59, 0, 10)
HTitle.BackgroundTransparency = 1
HTitle.Text = "GOD VALLEY HUB"
HTitle.Font = Enum.Font.GothamBold
HTitle.TextSize = isMobile and 13 or 15
HTitle.TextXAlignment = Enum.TextXAlignment.Left
HTitle.ZIndex = 22
Instance.new("UIGradient", HTitle).Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.accent),
    ColorSequenceKeypoint.new(1, C.accent2),
})

local HSub = Instance.new("TextLabel", Header)
HSub.Size = UDim2.new(0, 210, 0, 13)
HSub.Position = UDim2.new(0, 59, 0, 36)
HSub.BackgroundTransparency = 1
HSub.Text = "TSB | v5.0 | One Piece"
HSub.TextColor3 = C.sub
HSub.Font = Enum.Font.Gotham
HSub.TextSize = FONT_S
HSub.TextXAlignment = Enum.TextXAlignment.Left
HSub.ZIndex = 22

-- Minimize (–/+)
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -60, 0.5, -12)
MinBtn.BackgroundColor3 = C.accent
MinBtn.Text = "–"
MinBtn.TextColor3 = Color3.fromRGB(10,8,4)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.ZIndex = 23
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

-- Close (X)
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
CloseBtn.BackgroundColor3 = C.red
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = C.white
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.ZIndex = 23
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(closeHub)

-- Hover Effekte für Buttons
for _, btn in ipairs({MinBtn, CloseBtn}) do
    local origColor = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {Size=UDim2.new(0,27,0,27)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {Size=UDim2.new(0,24,0,24)}):Play()
    end)
end

-- Minimize Logik
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    playUI(isMinimized and 0.9 or 1.2)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = isMinimized and UDim2.new(0, GUI_W, 0, 60) or UDim2.new(0, GUI_W, 0, GUI_H)
    }):Play()
    MinBtn.Text = isMinimized and "+" or "–"
end)

-- Drag Header
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        dragging=true dragStart=i.Position startPos=MainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-dragStart
        MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

------------------------------------------------
-- TAB BAR
------------------------------------------------
local HEADER_H = isMobile and 36 or 40
local TOP_OFFSET = 64 + HEADER_H + 6

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -16, 0, HEADER_H)
TabBar.Position = UDim2.new(0, 8, 0, 64)
TabBar.BackgroundColor3 = C.panel
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 21
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)

local TabInner = Instance.new("Frame", TabBar)
TabInner.Size = UDim2.new(1, -8, 1, -8)
TabInner.Position = UDim2.new(0, 4, 0, 4)
TabInner.BackgroundTransparency = 1
TabInner.ZIndex = 22

local TabLayout = Instance.new("UIListLayout", TabInner)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 3)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Content Area
local ContentHolder = Instance.new("Frame", MainFrame)
ContentHolder.Size = UDim2.new(1, -16, 1, -(TOP_OFFSET + 8))
ContentHolder.Position = UDim2.new(0, 8, 0, TOP_OFFSET)
ContentHolder.BackgroundTransparency = 1
ContentHolder.ClipsDescendants = true
ContentHolder.BorderSizePixel = 0
ContentHolder.ZIndex = 21

------------------------------------------------
-- TABS (EIN SCROLLFRAME PRO TAB)
------------------------------------------------
local TAB_LIST = {
    {name="Perf",  icon=IMG.bolt,  label="Perf"},
    {name="Visual",icon=IMG.eye,   label="Visual"},
    {name="Misc",  icon=IMG.tool,  label="Misc"},
    {name="Sound", icon=IMG.music, label="Sound"},
    {name="Gfx",   icon=IMG.gem,   label="Gfx"},
}

local tabScrolls = {}
local tabs = {}
local layoutOrders = {}
local currentTab = nil
local TAB_W = math.floor((GUI_W - 24) / #TAB_LIST) - 3

for _, t in ipairs(TAB_LIST) do
    layoutOrders[t.name] = 0

    -- Eigener ScrollFrame
    local sf = Instance.new("ScrollingFrame", ContentHolder)
    sf.Name = "SF_"..t.name
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = isMobile and 3 or 4
    sf.ScrollBarImageColor3 = C.accent
    sf.ScrollBarImageTransparency = 0.3
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
    sf.ScrollingEnabled = true
    sf.ScrollingDirection = Enum.ScrollingDirection.Y
    sf.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    sf.Visible = false
    sf.ZIndex = 22

    local ll = Instance.new("UIListLayout", sf)
    ll.Padding = UDim.new(0, 5)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local lp = Instance.new("UIPadding", sf)
    lp.PaddingTop = UDim.new(0, 5)
    lp.PaddingBottom = UDim.new(0, 12)
    lp.PaddingLeft = UDim.new(0, 2)
    lp.PaddingRight = UDim.new(0, 6)

    ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sf.CanvasSize = UDim2.new(0, 0, 0, ll.AbsoluteContentSize.Y + 16)
    end)

    tabScrolls[t.name] = sf

    -- Tab Button
    local btn = Instance.new("Frame", TabInner)
    btn.Size = UDim2.new(0, TAB_W, 1, 0)
    btn.BackgroundTransparency = 1
    btn.ZIndex = 23

    local btnBg = Instance.new("Frame", btn)
    btnBg.Size = UDim2.new(1, 0, 1, 0)
    btnBg.BackgroundColor3 = C.accent2
    btnBg.BackgroundTransparency = 1
    btnBg.BorderSizePixel = 0
    btnBg.ZIndex = 23
    Instance.new("UICorner", btnBg).CornerRadius = UDim.new(0, 7)

    local btnIcon = Instance.new("ImageLabel", btn)
    btnIcon.Size = UDim2.new(0, isMobile and 13 or 15, 0, isMobile and 13 or 15)
    btnIcon.Position = UDim2.new(0.5, isMobile and -6 or -7, 0, isMobile and 3 or 3)
    btnIcon.BackgroundTransparency = 1
    btnIcon.Image = t.icon
    btnIcon.ImageColor3 = C.sub
    btnIcon.ZIndex = 24

    local btnLbl = Instance.new("TextLabel", btn)
    btnLbl.Size = UDim2.new(1, 0, 0, 12)
    btnLbl.Position = UDim2.new(0, 0, 1, -13)
    btnLbl.BackgroundTransparency = 1
    btnLbl.Text = t.label
    btnLbl.TextColor3 = C.sub
    btnLbl.Font = Enum.Font.GothamBold
    btnLbl.TextSize = FONT_S
    btnLbl.ZIndex = 24

    local btnClick = Instance.new("TextButton", btn)
    btnClick.Size = UDim2.new(1, 0, 1, 0)
    btnClick.BackgroundTransparency = 1
    btnClick.Text = ""
    btnClick.ZIndex = 25

    tabs[t.name] = {btnBg=btnBg, btnIcon=btnIcon, btnLbl=btnLbl}

    local cap = t.name
    btnClick.MouseButton1Click:Connect(function()
        if currentTab ~= cap then
            currentTab = cap
            playUI(1.5)
            for _, td in ipairs(TAB_LIST) do
                local sf2 = tabScrolls[td.name]
                local active = (td.name == cap)
                sf2.Visible = active
                if active then sf2.CanvasPosition = Vector2.new(0,0) end
                local tdata = tabs[td.name]
                TweenService:Create(tdata.btnBg, TweenInfo.new(0.18), {
                    BackgroundColor3=active and C.accent2 or Color3.fromRGB(0,0,0),
                    BackgroundTransparency=active and 0 or 1,
                }):Play()
                TweenService:Create(tdata.btnIcon, TweenInfo.new(0.18), {
                    ImageColor3=active and C.white or C.sub,
                }):Play()
                TweenService:Create(tdata.btnLbl, TweenInfo.new(0.18), {
                    TextColor3=active and C.accent or C.sub,
                }):Play()
            end
        end
    end)
    btnClick.MouseEnter:Connect(function()
        if currentTab~=cap then TweenService:Create(btnBg, TweenInfo.new(0.14), {BackgroundTransparency=0.8}):Play() end
    end)
    btnClick.MouseLeave:Connect(function()
        if currentTab~=cap then TweenService:Create(btnBg, TweenInfo.new(0.14), {BackgroundTransparency=1}):Play() end
    end)
end

-- Ersten Tab aktivieren
do
    local first = TAB_LIST[1].name
    currentTab = first
    tabScrolls[first].Visible = true
    tabs[first].btnBg.BackgroundTransparency = 0
    tabs[first].btnIcon.ImageColor3 = C.white
    tabs[first].btnLbl.TextColor3 = C.accent
end

------------------------------------------------
-- ELEMENT HELPER
------------------------------------------------
local function getScroll(tabName) return tabScrolls[tabName] end
local function nextOrder(tabName)
    layoutOrders[tabName] = layoutOrders[tabName] + 1
    return layoutOrders[tabName]
end

local function addSection(tabName, text)
    local f = Instance.new("Frame", getScroll(tabName))
    f.Size = UDim2.new(1, -8, 0, 22)
    f.BackgroundColor3 = Color3.fromRGB(20,10,5)
    f.BorderSizePixel = 0
    f.LayoutOrder = nextOrder(tabName)
    f.ZIndex = 23
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local bar = Instance.new("Frame", f)
    bar.Size=UDim2.new(0,3,0,11) bar.Position=UDim2.new(0,7,0.5,-5)
    bar.BackgroundColor3=C.accent bar.BorderSizePixel=0 bar.ZIndex=24
    Instance.new("UICorner", bar).CornerRadius=UDim.new(1,0)
    local lbl=Instance.new("TextLabel",f)
    lbl.Size=UDim2.new(1,-18,1,0) lbl.Position=UDim2.new(0,16,0,0)
    lbl.BackgroundTransparency=1 lbl.Text=text
    lbl.TextColor3=C.accent lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=FONT_S lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.ZIndex=24
end

------------------------------------------------
-- TOGGLE
------------------------------------------------
local function createToggle(tabName, title, desc, callback)
    local hasDesc = desc and desc ~= ""
    local h = hasDesc and CARD_HD or CARD_H
    local sf = getScroll(tabName)

    local card = Instance.new("Frame", sf)
    card.Size = UDim2.new(1, -8, 0, h)
    card.BackgroundColor3 = C.card
    card.BorderSizePixel = 0
    card.LayoutOrder = nextOrder(tabName)
    card.ZIndex = 23
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 9)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = C.accent stroke.Thickness = 1 stroke.Transparency = 1

    local lbl = Instance.new("TextLabel", card)
    lbl.Size=UDim2.new(0.74,0,0,16) lbl.Position=UDim2.new(0,10,0,hasDesc and 8 or 12)
    lbl.BackgroundTransparency=1 lbl.Text=title
    lbl.TextColor3=C.text lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=FONT_L lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.ZIndex=24

    if hasDesc then
        local sub=Instance.new("TextLabel",card)
        sub.Size=UDim2.new(0.74,0,0,13) sub.Position=UDim2.new(0,10,0,28)
        sub.BackgroundTransparency=1 sub.Text=desc
        sub.TextColor3=C.sub sub.Font=Enum.Font.Gotham
        sub.TextSize=FONT_S sub.TextXAlignment=Enum.TextXAlignment.Left sub.ZIndex=24
    end

    local swBg=Instance.new("Frame",card)
    swBg.Size=UDim2.new(0,40,0,20) swBg.Position=UDim2.new(1,-48,0.5,-10)
    swBg.BackgroundColor3=C.off swBg.BorderSizePixel=0 swBg.ZIndex=24
    Instance.new("UICorner",swBg).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",swBg)
    knob.Size=UDim2.new(0,14,0,14) knob.Position=UDim2.new(0,3,0.5,-7)
    knob.BackgroundColor3=C.white knob.BorderSizePixel=0 knob.ZIndex=25
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local state = false
    local clickBtn=Instance.new("TextButton",card)
    clickBtn.Size=UDim2.new(1,0,1,0) clickBtn.BackgroundTransparency=1
    clickBtn.Text="" clickBtn.ZIndex=26

    clickBtn.MouseEnter:Connect(function()
        TweenService:Create(card,TweenInfo.new(0.14),{BackgroundColor3=C.cardHov}):Play()
        TweenService:Create(stroke,TweenInfo.new(0.14),{Transparency=0.55}):Play()
    end)
    clickBtn.MouseLeave:Connect(function()
        TweenService:Create(card,TweenInfo.new(0.14),{BackgroundColor3=C.card}):Play()
        TweenService:Create(stroke,TweenInfo.new(0.14),{Transparency=1}):Play()
    end)
    clickBtn.MouseButton1Click:Connect(function()
        state = not state
        playUI(state and 1.5 or 1.0)
        TweenService:Create(swBg,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundColor3=state and C.green or C.off}):Play()
        TweenService:Create(knob,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Position=state and UDim2.new(0,23,0.5,-7) or UDim2.new(0,3,0.5,-7)
        }):Play()
        callback(state)
    end)
    return card
end

------------------------------------------------
-- DROPDOWN
------------------------------------------------
local function createDropdown(tabName, title, options, callback)
    local sf = getScroll(tabName)
    local card=Instance.new("Frame",sf)
    card.Size=UDim2.new(1,-8,0,CARD_H) card.BackgroundColor3=C.card
    card.BorderSizePixel=0 card.ClipsDescendants=false
    card.LayoutOrder=nextOrder(tabName) card.ZIndex=30
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,9)

    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(0.48,0,1,0) lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1 lbl.Text=title
    lbl.TextColor3=C.text lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=FONT_L lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.ZIndex=31

    local dW = isMobile and 100 or 115
    local dBtn=Instance.new("TextButton",card)
    dBtn.Size=UDim2.new(0,dW,0,26) dBtn.Position=UDim2.new(1,-(dW+8),0.5,-13)
    dBtn.BackgroundColor3=C.accent dBtn.TextColor3=Color3.fromRGB(10,8,4)
    dBtn.Font=Enum.Font.GothamBold dBtn.TextSize=FONT_S
    dBtn.Text=options[1].." ▾" dBtn.ClipsDescendants=false dBtn.ZIndex=31
    Instance.new("UICorner",dBtn).CornerRadius=UDim.new(0,7)

    local dList=Instance.new("Frame",card)
    dList.Size=UDim2.new(0,dW,0,#options*26+6)
    dList.Position=UDim2.new(1,-(dW+8),1,3)
    dList.BackgroundColor3=C.panel dList.BorderSizePixel=0
    dList.Visible=false dList.ZIndex=55
    Instance.new("UICorner",dList).CornerRadius=UDim.new(0,8)
    local dlS=Instance.new("UIStroke",dList) dlS.Color=C.accent dlS.Thickness=1

    local dll=Instance.new("UIListLayout",dList) dll.Padding=UDim.new(0,2)
    local dlp=Instance.new("UIPadding",dList)
    dlp.PaddingTop=UDim.new(0,3) dlp.PaddingLeft=UDim.new(0,3) dlp.PaddingRight=UDim.new(0,3)

    for _,opt in ipairs(options) do
        local ob=Instance.new("TextButton",dList)
        ob.Size=UDim2.new(1,0,0,24) ob.BackgroundColor3=C.card
        ob.TextColor3=C.text ob.Font=Enum.Font.Gotham
        ob.TextSize=FONT_S ob.Text=opt ob.ZIndex=56
        Instance.new("UICorner",ob).CornerRadius=UDim.new(0,5)
        ob.MouseEnter:Connect(function() TweenService:Create(ob,TweenInfo.new(0.1),{BackgroundColor3=C.cardHov}):Play() end)
        ob.MouseLeave:Connect(function() TweenService:Create(ob,TweenInfo.new(0.1),{BackgroundColor3=C.card}):Play() end)
        ob.MouseButton1Click:Connect(function()
            dBtn.Text=opt.." ▾" dList.Visible=false playUI(1.3) callback(opt)
        end)
    end
    dBtn.MouseButton1Click:Connect(function() dList.Visible=not dList.Visible playUI(1.2) end)
end

------------------------------------------------
-- SLIDER
------------------------------------------------
local function createSlider(tabName, title, min, max, default, callback)
    local sf = getScroll(tabName)
    local card=Instance.new("Frame",sf)
    card.Size=UDim2.new(1,-8,0,isMobile and 50 or 54)
    card.BackgroundColor3=C.card card.BorderSizePixel=0
    card.LayoutOrder=nextOrder(tabName) card.ZIndex=23
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,9)

    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(0.72,0,0,16) lbl.Position=UDim2.new(0,10,0,7)
    lbl.BackgroundTransparency=1 lbl.Text=title
    lbl.TextColor3=C.text lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=FONT_L lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.ZIndex=24

    local valLbl=Instance.new("TextLabel",card)
    valLbl.Size=UDim2.new(0,40,0,16) valLbl.Position=UDim2.new(1,-46,0,7)
    valLbl.BackgroundTransparency=1 valLbl.Text=tostring(default)
    valLbl.TextColor3=C.accent valLbl.Font=Enum.Font.GothamBold
    valLbl.TextSize=FONT_L valLbl.TextXAlignment=Enum.TextXAlignment.Right valLbl.ZIndex=24

    local track=Instance.new("Frame",card)
    track.Size=UDim2.new(1,-20,0,5) track.Position=UDim2.new(0,10,0,isMobile and 34 or 37)
    track.BackgroundColor3=C.off track.BorderSizePixel=0 track.ZIndex=24
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

    local fill=Instance.new("Frame",track)
    fill.Size=UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3=C.accent fill.BorderSizePixel=0 fill.ZIndex=25
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",track)
    knob.Size=UDim2.new(0,13,0,13) knob.Position=UDim2.new((default-min)/(max-min),-6,0.5,-6)
    knob.BackgroundColor3=C.white knob.BorderSizePixel=0 knob.ZIndex=26
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local draggingSlider=false
    local clickBtn=Instance.new("TextButton",card)
    clickBtn.Size=UDim2.new(1,0,1,0) clickBtn.BackgroundTransparency=1
    clickBtn.Text="" clickBtn.ZIndex=27

    local function doSlider(inputX)
        local ratio=math.clamp((inputX-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
        local val=math.floor(min+(max-min)*ratio)
        fill.Size=UDim2.new(ratio,0,1,0)
        knob.Position=UDim2.new(ratio,-6,0.5,-6)
        valLbl.Text=tostring(val)
        callback(val)
    end

    clickBtn.MouseButton1Down:Connect(function(x) draggingSlider=true doSlider(x) end)
    UIS.InputChanged:Connect(function(i)
        if draggingSlider and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            doSlider(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            draggingSlider=false
        end
    end)
end

------------------------------------------------
-- ═══ PERF TAB ═══
------------------------------------------------
addSection("Perf","PERFORMANCE")
createToggle("Perf","FPS Boost","VFX & Schatten entfernen",function(on)
    Lighting.GlobalShadows=not on
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=not on end
        if v:IsA("BasePart") and on then v.Material=Enum.Material.Plastic v.Reflectance=0 v.CastShadow=false end
    end
end)
createToggle("Perf","Ultra Low Graphics","Level 1 für max FPS",function(on)
    settings().Rendering.QualityLevel=on and Enum.QualityLevel.Level01 or Enum.QualityLevel.Level10
end)
createToggle("Perf","Auto RAM Boost","Grafik nach RAM anpassen",function(on)
    task.spawn(function()
        while on and task.wait(5) do
            local m=Stats:GetTotalMemoryUsageMb()
            settings().Rendering.QualityLevel=m>2000 and Enum.QualityLevel.Level01 or m>1200 and Enum.QualityLevel.Level05 or Enum.QualityLevel.Level10
        end
    end)
end)
createToggle("Perf","No Shadows","Alle Schatten aus",function(on)
    Lighting.GlobalShadows=not on
    for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.CastShadow=not on end end
end)
createToggle("Perf","No Particles","Partikel global aus",function(on)
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") then v.Enabled=not on end
    end
    if on then workspace.DescendantAdded:Connect(function(v) if v:IsA("ParticleEmitter") then v.Enabled=false end end) end
end)
createToggle("Perf","Anti AFK","Verhindert AFK Kick",function(on)
    if on then
        local VU=game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)
    end
end)
addSection("Perf","FPS COUNTER")
createToggle("Perf","FPS Anzeige","FPS Counter einblenden",function(on)
    local fl=ScreenGui:FindFirstChild("_FPS")
    if on then
        if not fl then
            fl=Instance.new("Frame",ScreenGui) fl.Name="_FPS"
            fl.Size=UDim2.new(0,82,0,24) fl.Position=UDim2.new(0,76,0,5)
            fl.BackgroundColor3=C.panel fl.BorderSizePixel=0 fl.ZIndex=100
            Instance.new("UICorner",fl).CornerRadius=UDim.new(0,7)
            local st=Instance.new("UIStroke",fl) st.Color=C.accent st.Thickness=1 st.Transparency=0.5
            local ft=Instance.new("TextLabel",fl)
            ft.Size=UDim2.new(1,0,1,0) ft.BackgroundTransparency=1
            ft.TextColor3=C.green ft.Font=Enum.Font.GothamBold ft.TextSize=11 ft.ZIndex=101
            task.spawn(function()
                local last=tick() local fr=0
                while fl and fl.Parent do
                    fr=fr+1
                    if tick()-last>=1 then ft.Text=fr.." FPS" fr=0 last=tick() end
                    RunService.RenderStepped:Wait()
                end
            end)
        end
    else if fl then fl:Destroy() end end
end)

------------------------------------------------
-- ═══ VISUAL TAB ═══
------------------------------------------------
addSection("Visual","VISUAL")
createToggle("Visual","Full Bright","Maximale Helligkeit",function(on)
    Lighting.Ambient=on and Color3.new(1,1,1) or Color3.fromRGB(70,70,70)
    Lighting.OutdoorAmbient=on and Color3.new(1,1,1) or Color3.fromRGB(100,100,100)
    Lighting.Brightness=on and 10 or 2
end)
createToggle("Visual","No Fog","Nebel entfernen",function(on)
    Lighting.FogEnd=on and 9e9 or 1000 Lighting.FogStart=on and 9e9 or 0
end)
createToggle("Visual","Remove VFX","Partikel, Beams, Lights aus",function(on)
    local function clear(o)
        for _,v in ipairs(o:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=not on end
            if v:IsA("PointLight") or v:IsA("SpotLight") then v.Enabled=not on end
        end
    end
    clear(workspace)
    if on then workspace.DescendantAdded:Connect(function(o) task.wait() clear(o) end) end
end)
createToggle("Visual","Neon Enemies","Gegner leuchten neon",function(on)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            for _,v in ipairs(p.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.Material=on and Enum.Material.Neon or Enum.Material.Plastic end
            end
        end
    end
end)
createToggle("Visual","Enemy Highlight","Roter Rahmen um Gegner",function(on)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local sel=p.Character:FindFirstChild("_EBox")
            if on and not sel then
                local b=Instance.new("SelectionBox",p.Character) b.Name="_EBox"
                b.Adornee=p.Character b.Color3=C.red b.LineThickness=0.04
                b.SurfaceTransparency=0.85 b.SurfaceColor3=C.red
            elseif not on and sel then sel:Destroy() end
        end
    end
end)
createToggle("Visual","Name Tags","Namen über Spielern",function(on)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local root=p.Character:FindFirstChild("HumanoidRootPart")
            if on and root then
                local bb=Instance.new("BillboardGui",root) bb.Name="_NT"
                bb.Size=UDim2.new(0,130,0,24) bb.StudsOffset=Vector3.new(0,3,0) bb.AlwaysOnTop=true
                local tl=Instance.new("TextLabel",bb) tl.Size=UDim2.new(1,0,1,0)
                tl.BackgroundTransparency=1 tl.Text="⚔ "..p.Name
                tl.TextColor3=C.accent tl.Font=Enum.Font.GothamBold tl.TextScaled=true
            elseif not on then
                local tag=root and root:FindFirstChild("_NT") if tag then tag:Destroy() end
            end
        end
    end
end)

------------------------------------------------
-- ═══ MISC TAB (SPEED FIX) ═══
------------------------------------------------
addSection("Misc","PLAYER")

-- Speed Boost Toggle (GEFIXTE VERSION)
createToggle("Misc","Speed Boost","WalkSpeed auf 28",function(on)
    local function applySpeed(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = on and 28 or 16
        end
    end
    -- Direkt anwenden
    applySpeed(LocalPlayer.Character)
    -- Auch nach Respawn
    if on then
        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.1)
            if _G.SpeedOn then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed=28 end
            end
        end)
        _G.SpeedOn = true
    else
        _G.SpeedOn = false
    end
end)

-- Custom Speed Slider (GEFIXTE VERSION — Wert wird direkt und dauerhaft gesetzt)
createSlider("Misc","Custom Speed",16,60,16,function(val)
    _G.CustomSpeed = val
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = val
            -- Verhindert dass das Spiel WalkSpeed zurücksetzt
            task.spawn(function()
                task.wait(0.1)
                if hum and hum.Parent then hum.WalkSpeed = val end
                task.wait(0.1)
                if hum and hum.Parent then hum.WalkSpeed = val end
            end)
        end
    end
    -- Nach Respawn auch anwenden
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.2)
        local h=newChar:FindFirstChildOfClass("Humanoid")
        if h and _G.CustomSpeed then h.WalkSpeed=_G.CustomSpeed end
    end)
end)

createToggle("Misc","Max Camera Zoom","Kamera weit rauszoomen",function(on)
    LocalPlayer.CameraMaxZoomDistance=on and 200 or 30
end)
createToggle("Misc","No Clip","Durch Wände gehen",function(on)
    RunService.Stepped:Connect(function()
        if on and LocalPlayer.Character then
            for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide=false end
            end
        end
    end)
end)
addSection("Misc","EXTRA")
createToggle("Misc","Low HP Alarm","Alarm bei wenig Leben",function(on)
    task.spawn(function()
        while on and task.wait(1) do
            local c=LocalPlayer.Character
            if c then
                local h=c:FindFirstChildOfClass("Humanoid")
                if h and h.Health<30 and h.Health>0 then playSound(131961136,1,1) end
            end
        end
    end)
end)

------------------------------------------------
-- ═══ SOUND TAB ═══
------------------------------------------------
addSection("Sound","KILL SOUNDS")
createToggle("Sound","Kill Sound (Default)","Click bei Kill",function(on) setupKillSound(on,4612365796) end)
createToggle("Sound","Goat Sound","Ziegensound bei Kill",function(on) setupKillSound(on,135017578) end)
createToggle("Sound","Bruh Sound","Bruh bei Kill",function(on) setupKillSound(on,1444622487) end)
createToggle("Sound","MLG Airhorn","MLG Airhorn bei Kill",function(on) setupKillSound(on,135946816) end)
createToggle("Sound","Vine Boom","Vine Boom bei Kill",function(on) setupKillSound(on,5153644985) end)
addSection("Sound","UI SOUNDS")
createToggle("Sound","UI Sounds aus","Click-Sounds deaktivieren",function(on) _G.UISound=not on end)
createSlider("Sound","Kill Lautstärke",1,10,7,function(val) _G.KillVolume=val*0.1 end)

------------------------------------------------
-- ═══ GRAPHICS TAB ═══
------------------------------------------------
addSection("Gfx","PRESET")
createDropdown("Gfx","Grafik Preset",{"POTATO","LOW","MEDIUM","HIGH","ULTRA","CINEMATIC","ANIME"},function(sel)
    if GrafixPresets[sel] then GrafixPresets[sel]() end
end)
addSection("Gfx","EFFEKTE")
createToggle("Gfx","Bloom","Glow-Effekt",function(on)
    local b=Lighting:FindFirstChildOfClass("BloomEffect")
    if on then if not b then b=Instance.new("BloomEffect",Lighting) end b.Intensity=0.8 b.Size=40 b.Threshold=0.9
    elseif b then b:Destroy() end
end)
createSlider("Gfx","Bloom Stärke",1,20,4,function(val)
    local b=Lighting:FindFirstChildOfClass("BloomEffect") if b then b.Intensity=val*0.15 end
end)
createToggle("Gfx","Sun Rays","Sonnenstrahlen",function(on)
    local sr=Lighting:FindFirstChildOfClass("SunRaysEffect")
    if on then if not sr then sr=Instance.new("SunRaysEffect",Lighting) end sr.Intensity=0.15 sr.Spread=0.6
    elseif sr then sr:Destroy() end
end)
createToggle("Gfx","Color Grading","Farb-Korrektur",function(on)
    local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if on then if not cc then cc=Instance.new("ColorCorrectionEffect",Lighting) end cc.Saturation=0.35 cc.Contrast=0.2 cc.Brightness=0.05
    elseif cc then cc:Destroy() end
end)
createSlider("Gfx","Saturation",0,10,3,function(val)
    local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect") if cc then cc.Saturation=val*0.1 end
end)
createToggle("Gfx","Atmosphere","Atmosphären-Effekt",function(on)
    local a=Lighting:FindFirstChildOfClass("Atmosphere")
    if on then if not a then a=Instance.new("Atmosphere",Lighting) end a.Density=0.3 a.Haze=0.5 a.Glare=0.5 a.Color=Color3.fromRGB(199,210,255)
    elseif a then a:Destroy() end
end)
createToggle("Gfx","Depth of Field","Tiefenschärfe",function(on)
    local d=Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
    if on then if not d then d=Instance.new("DepthOfFieldEffect",Lighting) end d.FarIntensity=0.3 d.NearIntensity=0.1 d.FocusDistance=40 d.InFocusRadius=20
    elseif d then d:Destroy() end
end)
createSlider("Gfx","Helligkeit",1,10,2,function(val) Lighting.Brightness=val*0.5 end)
createSlider("Gfx","Quality Level",1,21,10,function(val) settings().Rendering.QualityLevel=val end)

------------------------------------------------
-- TOAST
------------------------------------------------
local tw2 = isMobile and 240 or 265
local toast=Instance.new("Frame",ScreenGui)
toast.Size=UDim2.new(0,tw2,0,54) toast.Position=UDim2.new(0.5,-tw2/2,1,10)
toast.BackgroundColor3=C.panel toast.BorderSizePixel=0 toast.ZIndex=200
Instance.new("UICorner",toast).CornerRadius=UDim.new(0,11)
local tStroke=Instance.new("UIStroke",toast) tStroke.Color=C.accent tStroke.Thickness=1.3 tStroke.Transparency=0.2
local tImg=Instance.new("ImageLabel",toast) tImg.Size=UDim2.new(0,40,0,46) tImg.Position=UDim2.new(0,5,0.5,-23)
tImg.BackgroundTransparency=1 tImg.Image=IMG.luffy tImg.ZIndex=201
local tTitle=Instance.new("TextLabel",toast) tTitle.Size=UDim2.new(1,-52,0,18) tTitle.Position=UDim2.new(0,50,0,8)
tTitle.BackgroundTransparency=1 tTitle.Text="GOD VALLEY HUB v5.0"
tTitle.TextColor3=C.accent tTitle.Font=Enum.Font.GothamBold tTitle.TextSize=isMobile and 11 or 12 tTitle.TextXAlignment=Enum.TextXAlignment.Left tTitle.ZIndex=201
local tSub=Instance.new("TextLabel",toast) tSub.Size=UDim2.new(1,-52,0,13) tSub.Position=UDim2.new(0,50,0,28)
tSub.BackgroundTransparency=1 tSub.Text="Key System aktiv ✓"
tSub.TextColor3=C.green tSub.Font=Enum.Font.Gotham tSub.TextSize=isMobile and 9 or 10 tSub.TextXAlignment=Enum.TextXAlignment.Left tSub.ZIndex=201

task.wait(0.6)
TweenService:Create(toast,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,-tw2/2,1,-64)}):Play()
playSound(4590662766,0.5,1.1)
task.delay(4,function()
    TweenService:Create(toast,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Position=UDim2.new(0.5,-tw2/2,1,10)}):Play()
    task.wait(0.4) pcall(function() toast:Destroy() end)
end)
