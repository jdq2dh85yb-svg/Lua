-- SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local AnimService = game:GetService("AnimationService") or nil

local LocalPlayer = Players.LocalPlayer

_G.UISound = true
_G.KillSoundOn = false
_G.KillSoundId = 4612365796
_G.KillVolume = 0.7
_G.SpeedOn = false
_G.CustomSpeed = 16
_G.AntiStunOn = false

------------------------------------------------
-- CUSTOM SYMBOLE (keine normalen Emojis)
-- Diese Zeichen sehen einzigartig aus
------------------------------------------------
local SYM = {
    anchor   = "âŠ•",   -- Anker-artig
    skull    = "â—ˆ",   -- TotenschÃ¤del-artig
    sword    = "âŸ",   -- Schwert-artig
    wave     = "â‰‹",   -- Wellen
    star     = "âœ¦",   -- Stern
    diamond  = "â—†",   -- Diamant
    bolt     = "âš¡",  -- Blitz (kein Emoji, Unicode Symbol)
    eye      = "â—‰",   -- Auge
    cross    = "âœ•",   -- X
    arrow    = "âž¤",   -- Pfeil
    crown    = "â™›",   -- Krone
    shield   = "â¬¡",   -- Schild
    lock     = "âŠž",   -- Schloss-artig
    unlock   = "âŠŸ",   -- Offen
    fire     = "â–²",   -- Feuer-artig
    check    = "âœ”",   -- Check
    music    = "â™ª",   -- Musik
    gem      = "â¬Ÿ",   -- Edelstein
    spin     = "âŸ³",   -- Rotation
    target   = "âŠ›",   -- Ziel
    forbidden= "âŠ˜",   -- Verboten
    power    = "âŒ",   -- Power
    chart    = "âŠŸ",   -- Chart
    world    = "âŠœ",   -- Welt
}

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
-- KEYS
------------------------------------------------
local KEYS = {
    ["GODVALLEY-ADMIN-2024"] = {type="admin", name="Admin"},
    -- Free Keys (Format wie die Website generiert):
    -- FÃ¼ge hier deine generierten Keys ein
    ["FREE_a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6"] = {type="user", name="User"},
    ["FREE_b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7"] = {type="user", name="User"},
    ["FREE_c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8"] = {type="user", name="User"},
    ["ONEPIECE-TSB-OPEN"]    = {type="user",  name="User"},
    ["GODVALLEY-FREE-001"]   = {type="user",  name="User"},
}

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
-- ANTI STUN SYSTEM
-- TSB benutzt Animationen um Stun zu signalisieren
-- Wir unterbrechen diese Animationen
------------------------------------------------
local stunAnimIds = {
    "rbxassetid://10921201888",
    "rbxassetid://10921201234",
    "rbxassetid://10921205678",
    "rbxassetid://10921209012",
}

local function setupAntiStun(on)
    _G.AntiStunOn = on
    if not on then return end
    task.spawn(function()
        while _G.AntiStunOn do
            task.wait(0.05)
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local animator = hum and hum:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        local animId = track.Animation.AnimationId
                        -- Stun Animationen haben oft sehr niedrige Priority oder spezifische IDs
                        -- Wir stoppen Animationen die nicht Laufen/Springen sind
                        if track.Priority == Enum.AnimationPriority.Action4
                        or track.Priority == Enum.AnimationPriority.Action3 then
                            -- PrÃ¼fe ob es eine Stun Animation sein kÃ¶nnte (kurze LooplÃ¤nge)
                            if track.Length < 1.5 and not track.IsPlaying == false then
                                -- Nicht stoppen wenn es Angriff Animation ist
                            end
                        end
                    end
                end

                -- Haupt Anti-Stun: WalkSpeed wiederherstellen wenn zu niedrig
                if hum then
                    if _G.SpeedOn and hum.WalkSpeed < (_G.CustomSpeed or 16) * 0.5 then
                        task.wait(0.3) -- kurz warten (nicht zu aggressiv)
                        if hum and hum.Parent then
                            hum.WalkSpeed = _G.SpeedOn and 28 or (_G.CustomSpeed or 16)
                        end
                    end

                    -- Jump Power wiederherstellen
                    if hum.JumpPower < 40 then
                        task.wait(0.2)
                        if hum and hum.Parent then hum.JumpPower = 50 end
                    end
                end
            end
        end
    end)
end

------------------------------------------------
-- CUSTOM EMOTES SYSTEM
-- Spielt Animationen auf dem eigenen Charakter ab
------------------------------------------------
local EMOTE_ANIMS = {
    ["Bow"]         = "rbxassetid://507770239",
    ["Cheer"]       = "rbxassetid://507770677",
    ["Dance"]       = "rbxassetid://507771019",
    ["Dance2"]      = "rbxassetid://507776043",
    ["Dance3"]      = "rbxassetid://507777268",
    ["Laugh"]       = "rbxassetid://507770818",
    ["Point"]       = "rbxassetid://507770453",
    ["Salute"]      = "rbxassetid://3360686446",
    ["Tilt"]        = "rbxassetid://3360692915",
    ["Atento"]      = "rbxassetid://3360686798",
}

local currentEmoteTrack = nil

local function playEmote(animId)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    -- Stop vorherige Emote
    if currentEmoteTrack then
        pcall(function() currentEmoteTrack:Stop() end)
        currentEmoteTrack = nil
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local track = animator:LoadAnimation(anim)
    track:Play()
    currentEmoteTrack = track
    playUI(1.3)

    -- Automatisch stoppen nach Animation
    track.Stopped:Connect(function()
        currentEmoteTrack = nil
        anim:Destroy()
    end)
end

local function stopEmote()
    if currentEmoteTrack then
        TweenService:Create(currentEmoteTrack, TweenInfo.new(0.3), {WeightCurrent=0}):Play()
        task.wait(0.3)
        pcall(function() currentEmoteTrack:Stop() end)
        currentEmoteTrack = nil
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
}

------------------------------------------------
-- SCREENUI
------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GodValleyV6"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------
-- PARTIKEL
------------------------------------------------
local function spawnParticle(parent)
    local p = Instance.new("Frame", parent)
    local size = math.random(2,5)
    p.Size = UDim2.new(0,size,0,size)
    p.Position = UDim2.new(math.random(0,100)/100, 0, 1.05, 0)
    p.BackgroundColor3 = math.random(1,2)==1 and C.accent or C.accent2
    p.BackgroundTransparency = 0.3
    p.BorderSizePixel = 0
    p.ZIndex = 2
    Instance.new("UICorner",p).CornerRadius = UDim.new(1,0)
    TweenService:Create(p, TweenInfo.new(math.random(5,10), Enum.EasingStyle.Linear), {
        Position = UDim2.new(math.random(0,100)/100, 0, -0.1, 0),
        BackgroundTransparency = 1,
    }):Play()
    game:GetService("Debris"):AddItem(p, 11)
end

------------------------------------------------
-- OPEN BUTTON
------------------------------------------------
local OpenOuter = Instance.new("Frame", ScreenGui)
OpenOuter.Size = UDim2.new(0,54,0,54)
OpenOuter.Position = UDim2.new(0,10,0.5,-27)
OpenOuter.BackgroundColor3 = C.bg
OpenOuter.BorderSizePixel = 0
OpenOuter.ZIndex = 10
OpenOuter.Visible = false
Instance.new("UICorner", OpenOuter).CornerRadius = UDim.new(1,0)

local OBStroke = Instance.new("UIStroke", OpenOuter)
OBStroke.Thickness = 2.5
OBStroke.Color = C.accent

local OBImg = Instance.new("ImageLabel", OpenOuter)
OBImg.Size = UDim2.new(1,-6,1,-6)
OBImg.Position = UDim2.new(0,3,0,3)
OBImg.BackgroundTransparency = 1
OBImg.Image = IMG.luffy
OBImg.ScaleType = Enum.ScaleType.Fit
OBImg.ZIndex = 11
Instance.new("UICorner", OBImg).CornerRadius = UDim.new(1,0)

local OBClick = Instance.new("TextButton", OpenOuter)
OBClick.Size = UDim2.new(1,0,1,0)
OBClick.BackgroundTransparency = 1
OBClick.Text = ""
OBClick.ZIndex = 12

task.spawn(function()
    local t = 0
    while true do
        t = t + 0.03
        OBStroke.Color = C.accent:Lerp(C.accent2, (math.sin(t)+1)/2)
        task.wait(0.04)
    end
end)

-- Open Button Drag
local obDragging, obDragStart, obStartPos, obMoved
OBClick.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        obDragging=true obDragStart=i.Position obStartPos=OpenOuter.Position obMoved=false
    end
end)
UIS.InputChanged:Connect(function(i)
    if obDragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-obDragStart
        if math.abs(d.X)>4 or math.abs(d.Y)>4 then obMoved=true end
        OpenOuter.Position=UDim2.new(obStartPos.X.Scale,obStartPos.X.Offset+d.X,obStartPos.Y.Scale,obStartPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        obDragging=false
    end
end)

------------------------------------------------
-- MAIN FRAME
------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,GUI_W,0,GUI_H)
MainFrame.Position = UDim2.new(0.5,-GUI_W/2,0.5,-GUI_H/2)
MainFrame.BackgroundColor3 = C.bg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Visible = false
MainFrame.ZIndex = 20
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,14)

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

local isOpen = false

local function openHub()
    isOpen=true
    MainFrame.Size=UDim2.new(0,0,0,0)
    MainFrame.Position=UDim2.new(0.5,0,0.5,0)
    MainFrame.Visible=true
    playUI(1.3)
    TweenService:Create(MainFrame, TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {
        Size=UDim2.new(0,GUI_W,0,GUI_H),
        Position=UDim2.new(0.5,-GUI_W/2,0.5,-GUI_H/2),
    }):Play()
end

local function closeHub()
    isOpen=false
    playUI(0.85)
    TweenService:Create(MainFrame, TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In), {
        Size=UDim2.new(0,0,0,0),
        Position=UDim2.new(0.5,0,0.5,0),
    }):Play()
    task.wait(0.33)
    if not isOpen then MainFrame.Visible=false end
end

OBClick.MouseButton1Click:Connect(function()
    if not obMoved then
        if isOpen then closeHub() else openHub() end
    end
end)

------------------------------------------------
-- BUILD MAIN UI
------------------------------------------------
local function buildMainUI(keyType)

    local Header=Instance.new("Frame",MainFrame)
    Header.Size=UDim2.new(1,0,0,60) Header.BackgroundColor3=C.panel
    Header.BorderSizePixel=0 Header.ZIndex=21
    Instance.new("UICorner",Header).CornerRadius=UDim.new(0,14)
    local HGrad=Instance.new("UIGradient",Header)
    HGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(22,8,6)),ColorSequenceKeypoint.new(1,Color3.fromRGB(8,8,20))})
    HGrad.Rotation=90

    local HJolly=Instance.new("ImageLabel",Header)
    HJolly.Size=UDim2.new(0,44,0,44) HJolly.Position=UDim2.new(0,9,0.5,-22)
    HJolly.BackgroundTransparency=1 HJolly.Image=IMG.jolly HJolly.ImageColor3=C.accent HJolly.ZIndex=22

    -- Custom Zeichen im Titel
    local HTitle=Instance.new("TextLabel",Header)
    HTitle.Size=UDim2.new(0,200,0,22) HTitle.Position=UDim2.new(0,59,0,10)
    HTitle.BackgroundTransparency=1
    HTitle.Text= SYM.anchor .. " GOD VALLEY HUB"
    HTitle.Font=Enum.Font.GothamBold HTitle.TextSize=isMobile and 13 or 15
    HTitle.TextXAlignment=Enum.TextXAlignment.Left HTitle.ZIndex=22
    Instance.new("UIGradient",HTitle).Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.accent),ColorSequenceKeypoint.new(1,C.accent2)
    })

    if keyType=="admin" then
        local badge=Instance.new("Frame",Header)
        badge.Size=UDim2.new(0,66,0,16) badge.Position=UDim2.new(0,59,0,36)
        badge.BackgroundColor3=Color3.fromRGB(40,20,5) badge.BorderSizePixel=0 badge.ZIndex=22
        Instance.new("UICorner",badge).CornerRadius=UDim.new(1,0)
        Instance.new("UIStroke",badge).Color=C.accent
        local bL=Instance.new("TextLabel",badge) bL.Size=UDim2.new(1,0,1,0)
        bL.BackgroundTransparency=1 bL.Text= SYM.crown .. " ADMIN"
        bL.TextColor3=C.accent bL.Font=Enum.Font.GothamBold bL.TextSize=9 bL.ZIndex=23
    else
        local HSub=Instance.new("TextLabel",Header)
        HSub.Size=UDim2.new(0,210,0,13) HSub.Position=UDim2.new(0,59,0,36)
        HSub.BackgroundTransparency=1 HSub.Text="TSB " .. SYM.wave .. " v6.0 " .. SYM.wave .. " One Piece"
        HSub.TextColor3=C.sub HSub.Font=Enum.Font.Gotham HSub.TextSize=FONT_S
        HSub.TextXAlignment=Enum.TextXAlignment.Left HSub.ZIndex=22
    end

    local MinBtn=Instance.new("TextButton",Header)
    MinBtn.Size=UDim2.new(0,24,0,24) MinBtn.Position=UDim2.new(1,-60,0.5,-12)
    MinBtn.Backgro