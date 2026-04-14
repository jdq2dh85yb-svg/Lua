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
    anchor   = "⊕",   -- Anker-artig
    skull    = "◈",   -- Totenschädel-artig
    sword    = "⟁",   -- Schwert-artig
    wave     = "≋",   -- Wellen
    star     = "✦",   -- Stern
    diamond  = "◆",   -- Diamant
    bolt     = "⚡",  -- Blitz (kein Emoji, Unicode Symbol)
    eye      = "◉",   -- Auge
    cross    = "✕",   -- X
    arrow    = "➤",   -- Pfeil
    crown    = "♛",   -- Krone
    shield   = "⬡",   -- Schild
    lock     = "⊞",   -- Schloss-artig
    unlock   = "⊟",   -- Offen
    fire     = "▲",   -- Feuer-artig
    check    = "✔",   -- Check
    music    = "♪",   -- Musik
    gem      = "⬟",   -- Edelstein
    spin     = "⟳",   -- Rotation
    target   = "⊛",   -- Ziel
    forbidden= "⊘",   -- Verboten
    power    = "⌁",   -- Power
    chart    = "⊟",   -- Chart
    world    = "⊜",   -- Welt
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
    -- Füge hier deine generierten Keys ein
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
                            -- Prüfe ob es eine Stun Animation sein könnte (kurze Looplänge)
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
    MinBtn.BackgroundColor3=C.accent MinBtn.Text="–"
    MinBtn.TextColor3=Color3.fromRGB(10,8,4) MinBtn.Font=Enum.Font.GothamBold
    MinBtn.TextSize=14 MinBtn.ZIndex=23
    Instance.new("UICorner",MinBtn).CornerRadius=UDim.new(1,0)

    local CloseBtn=Instance.new("TextButton",Header)
    CloseBtn.Size=UDim2.new(0,24,0,24) CloseBtn.Position=UDim2.new(1,-30,0.5,-12)
    CloseBtn.BackgroundColor3=C.red CloseBtn.Text=SYM.cross
    CloseBtn.TextColor3=C.white CloseBtn.Font=Enum.Font.GothamBold
    CloseBtn.TextSize=11 CloseBtn.ZIndex=23
    Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(1,0)
    CloseBtn.MouseButton1Click:Connect(closeHub)

    local isMin=false
    MinBtn.MouseButton1Click:Connect(function()
        isMin=not isMin playUI(isMin and 0.9 or 1.2)
        TweenService:Create(MainFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{
            Size=isMin and UDim2.new(0,GUI_W,0,60) or UDim2.new(0,GUI_W,0,GUI_H)
        }):Play()
        MinBtn.Text=isMin and "+" or "–"
    end)

    local dragging,dragStart,startPos2
    Header.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true dragStart=i.Position startPos2=MainFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-dragStart
            MainFrame.Position=UDim2.new(startPos2.X.Scale,startPos2.X.Offset+d.X,startPos2.Y.Scale,startPos2.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)

    local HEADER_H=isMobile and 36 or 40
    local TOP_OFFSET=64+HEADER_H+6

    local TabBar=Instance.new("Frame",MainFrame)
    TabBar.Size=UDim2.new(1,-16,0,HEADER_H) TabBar.Position=UDim2.new(0,8,0,64)
    TabBar.BackgroundColor3=C.panel TabBar.BorderSizePixel=0 TabBar.ZIndex=21
    Instance.new("UICorner",TabBar).CornerRadius=UDim.new(0,10)

    local TabInner=Instance.new("Frame",TabBar)
    TabInner.Size=UDim2.new(1,-8,1,-8) TabInner.Position=UDim2.new(0,4,0,4)
    TabInner.BackgroundTransparency=1 TabInner.ZIndex=22
    local TabLayout=Instance.new("UIListLayout",TabInner)
    TabLayout.FillDirection=Enum.FillDirection.Horizontal
    TabLayout.Padding=UDim.new(0,3) TabLayout.VerticalAlignment=Enum.VerticalAlignment.Center

    local ContentHolder=Instance.new("Frame",MainFrame)
    ContentHolder.Size=UDim2.new(1,-16,1,-(TOP_OFFSET+8))
    ContentHolder.Position=UDim2.new(0,8,0,TOP_OFFSET)
    ContentHolder.BackgroundTransparency=1 ContentHolder.ClipsDescendants=true
    ContentHolder.BorderSizePixel=0 ContentHolder.ZIndex=21

    -- TABS mit custom Symbolen
    local TAB_LIST={
        {name="Perf",   icon=IMG.bolt,  label=SYM.bolt.." Perf"},
        {name="Visual", icon=IMG.eye,   label=SYM.eye.." Visual"},
        {name="Battle", icon=IMG.tool,  label=SYM.sword.." Battle"},
        {name="Emote",  icon=IMG.music, label=SYM.star.." Emote"},
        {name="Gfx",    icon=IMG.gem,   label=SYM.gem.." Gfx"},
    }

    local tabScrolls={} local tabs2={} local layoutOrders={}
    local currentTab2=nil
    local TAB_W=math.floor((GUI_W-24)/#TAB_LIST)-3

    for _,t in ipairs(TAB_LIST) do
        layoutOrders[t.name]=0
        local sf=Instance.new("ScrollingFrame",ContentHolder)
        sf.Name="SF_"..t.name sf.Size=UDim2.new(1,0,1,0)
        sf.BackgroundTransparency=1 sf.BorderSizePixel=0
        sf.ScrollBarThickness=isMobile and 3 or 4
        sf.ScrollBarImageColor3=C.accent sf.ScrollBarImageTransparency=0.3
        sf.CanvasSize=UDim2.new(0,0,0,0) sf.ScrollingEnabled=true
        sf.ScrollingDirection=Enum.ScrollingDirection.Y
        sf.ElasticBehavior=Enum.ElasticBehavior.WhenScrollable
        sf.Visible=false sf.ZIndex=22

        local ll=Instance.new("UIListLayout",sf)
        ll.Padding=UDim.new(0,5) ll.SortOrder=Enum.SortOrder.LayoutOrder
        ll.HorizontalAlignment=Enum.HorizontalAlignment.Center
        local lp=Instance.new("UIPadding",sf)
        lp.PaddingTop=UDim.new(0,5) lp.PaddingBottom=UDim.new(0,12)
        lp.PaddingLeft=UDim.new(0,2) lp.PaddingRight=UDim.new(0,6)
        ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            sf.CanvasSize=UDim2.new(0,0,0,ll.AbsoluteContentSize.Y+16)
        end)
        tabScrolls[t.name]=sf

        local btn=Instance.new("Frame",TabInner)
        btn.Size=UDim2.new(0,TAB_W,1,0) btn.BackgroundTransparency=1 btn.ZIndex=23
        local btnBg=Instance.new("Frame",btn)
        btnBg.Size=UDim2.new(1,0,1,0) btnBg.BackgroundColor3=C.accent2
        btnBg.BackgroundTransparency=1 btnBg.BorderSizePixel=0 btnBg.ZIndex=23
        Instance.new("UICorner",btnBg).CornerRadius=UDim.new(0,7)
        local btnLbl=Instance.new("TextLabel",btn)
        btnLbl.Size=UDim2.new(1,0,1,0)
        btnLbl.BackgroundTransparency=1 btnLbl.Text=t.label
        btnLbl.TextColor3=C.sub btnLbl.Font=Enum.Font.GothamBold
        btnLbl.TextSize=FONT_S btnLbl.ZIndex=24
        local btnClick=Instance.new("TextButton",btn)
        btnClick.Size=UDim2.new(1,0,1,0) btnClick.BackgroundTransparency=1
        btnClick.Text="" btnClick.ZIndex=25

        tabs2[t.name]={btnBg=btnBg,btnLbl=btnLbl}

        local cap=t.name
        local function doSwitch(name)
            if currentTab2==name then return end
            currentTab2=name playUI(1.5)
            for _,td in ipairs(TAB_LIST) do
                local sf2=tabScrolls[td.name]
                local active=(td.name==name)
                sf2.Visible=active
                if active then sf2.CanvasPosition=Vector2.new(0,0) end
                local td2=tabs2[td.name]
                TweenService:Create(td2.btnBg,TweenInfo.new(0.18),{
                    BackgroundColor3=active and C.accent2 or Color3.fromRGB(0,0,0),
                    BackgroundTransparency=active and 0 or 1
                }):Play()
                TweenService:Create(td2.btnLbl,TweenInfo.new(0.18),{TextColor3=active and C.accent or C.sub}):Play()
            end
        end
        btnClick.MouseButton1Click:Connect(function() doSwitch(cap) end)
        btnClick.MouseEnter:Connect(function()
            if currentTab2~=cap then TweenService:Create(btnBg,TweenInfo.new(0.14),{BackgroundTransparency=0.8}):Play() end
        end)
        btnClick.MouseLeave:Connect(function()
            if currentTab2~=cap then TweenService:Create(btnBg,TweenInfo.new(0.14),{BackgroundTransparency=1}):Play() end
        end)
    end

    currentTab2="Perf"
    tabScrolls["Perf"].Visible=true
    tabs2["Perf"].btnBg.BackgroundTransparency=0
    tabs2["Perf"].btnLbl.TextColor3=C.accent

    local function getScroll(n) return tabScrolls[n] end
    local function nextOrd(n) layoutOrders[n]=layoutOrders[n]+1 return layoutOrders[n] end

    -- Section mit custom Symbol
    local function addSection(tabName,symbol,text)
        local f=Instance.new("Frame",getScroll(tabName))
        f.Size=UDim2.new(1,-8,0,22) f.BackgroundColor3=Color3.fromRGB(20,10,5)
        f.BorderSizePixel=0 f.LayoutOrder=nextOrd(tabName) f.ZIndex=23
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local bar=Instance.new("Frame",f) bar.Size=UDim2.new(0,3,0,11) bar.Position=UDim2.new(0,7,0.5,-5)
        bar.BackgroundColor3=C.accent bar.BorderSizePixel=0 bar.ZIndex=24
        Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
        local lbl=Instance.new("TextLabel",f) lbl.Size=UDim2.new(1,-18,1,0) lbl.Position=UDim2.new(0,16,0,0)
        lbl.BackgroundTransparency=1 lbl.Text=symbol .. "  " .. text lbl.TextColor3=C.accent
        lbl.Font=Enum.Font.GothamBold lbl.TextSize=FONT_S lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.ZIndex=24
    end

    local function createToggle(tabName,symbol,title,desc,callback)
        local hasDesc=desc and desc~=""
        local h=hasDesc and CARD_HD or CARD_H
        local sf=getScroll(tabName)
        local card=Instance.new("Frame",sf)
        card.Size=UDim2.new(1,-8,0,h) card.BackgroundColor3=C.card
        card.BorderSizePixel=0 card.LayoutOrder=nextOrd(tabName) card.ZIndex=23
        Instance.new("UICorner",card).CornerRadius=UDim.new(0,9)
        local stroke=Instance.new("UIStroke",card) stroke.Color=C.accent stroke.Thickness=1 stroke.Transparency=1

        -- Symbol links
        local symLbl=Instance.new("TextLabel",card)
        symLbl.Size=UDim2.new(0,20,1,0) symLbl.Position=UDim2.new(0,8,0,0)
        symLbl.BackgroundTransparency=1 symLbl.Text=symbol
        symLbl.TextColor3=C.accent symLbl.Font=Enum.Font.GothamBold
        symLbl.TextSize=14 symLbl.ZIndex=24

        local lbl=Instance.new("TextLabel",card)
        lbl.Size=UDim2.new(0.68,0,0,16) lbl.Position=UDim2.new(0,32,0,hasDesc and 8 or 12)
        lbl.BackgroundTransparency=1 lbl.Text=title lbl.TextColor3=C.text
        lbl.Font=Enum.Font.GothamBold lbl.TextSize=FONT_L lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.ZIndex=24
        if hasDesc then
            local sub=Instance.new("TextLabel",card) sub.Size=UDim2.new(0.7,0,0,13) sub.Position=UDim2.new(0,32,0,28)
            sub.BackgroundTransparency=1 sub.Text=desc sub.TextColor3=C.sub
            sub.Font=Enum.Font.Gotham sub.TextSize=FONT_S sub.TextXAlignment=Enum.TextXAlignment.Left sub.ZIndex=24
        end
        local swBg=Instance.new("Frame",card) swBg.Size=UDim2.new(0,40,0,20) swBg.Position=UDim2.new(1,-48,0.5,-10)
        swBg.BackgroundColor3=C.off swBg.BorderSizePixel=0 swBg.ZIndex=24
        Instance.new("UICorner",swBg).CornerRadius=UDim.new(1,0)
        local knob=Instance.new("Frame",swBg) knob.Size=UDim2.new(0,14,0,14) knob.Position=UDim2.new(0,3,0.5,-7)
        knob.BackgroundColor3=C.white knob.BorderSizePixel=0 knob.ZIndex=25
        Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
        local state=false
        local clickBtn=Instance.new("TextButton",card) clickBtn.Size=UDim2.new(1,0,1,0)
        clickBtn.BackgroundTransparency=1 clickBtn.Text="" clickBtn.ZIndex=26
        clickBtn.MouseEnter:Connect(function()
            TweenService:Create(card,TweenInfo.new(0.14),{BackgroundColor3=C.cardHov}):Play()
            TweenService:Create(stroke,TweenInfo.new(0.14),{Transparency=0.55}):Play()
        end)
        clickBtn.MouseLeave:Connect(function()
            TweenService:Create(card,TweenInfo.new(0.14),{BackgroundColor3=C.card}):Play()
            TweenService:Create(stroke,TweenInfo.new(0.14),{Transparency=1}):Play()
        end)
        clickBtn.MouseButton1Click:Connect(function()
            state=not state playUI(state and 1.5 or 1.0)
            TweenService:Create(swBg,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundColor3=state and C.green or C.off}):Play()
            TweenService:Create(knob,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                Position=state and UDim2.new(0,23,0.5,-7) or UDim2.new(0,3,0.5,-7)
            }):Play()
            -- Symbol ändert Farbe bei ON
            TweenService:Create(symLbl,TweenInfo.new(0.2),{TextColor3=state and C.green or C.accent}):Play()
            callback(state)
        end)
    end

    local function createDropdown(tabName,title,options,callback)
        local sf=getScroll(tabName)
        local card=Instance.new("Frame",sf) card.Size=UDim2.new(1,-8,0,CARD_H) card.BackgroundColor3=C.card
        card.BorderSizePixel=0 card.ClipsDescendants=false card.LayoutOrder=nextOrd(tabName) card.ZIndex=30
        Instance.new("UICorner",card).CornerRadius=UDim.new(0,9)
        local lbl=Instance.new("TextLabel",card) lbl.Size=UDim2.new(0.48,0,1,0) lbl.Position=UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency=1 lbl.Text=title lbl.TextColor3=C.text
        lbl.Font=Enum.Font.GothamBold lbl.TextSize=FONT_L lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.ZIndex=31
        local dW=isMobile and 100 or 115
        local dBtn=Instance.new("TextButton",card) dBtn.Size=UDim2.new(0,dW,0,26) dBtn.Position=UDim2.new(1,-(dW+8),0.5,-13)
        dBtn.BackgroundColor3=C.accent dBtn.TextColor3=Color3.fromRGB(10,8,4)
        dBtn.Font=Enum.Font.GothamBold dBtn.TextSize=FONT_S dBtn.Text=options[1].." ▾"
        dBtn.ClipsDescendants=false dBtn.ZIndex=31
        Instance.new("UICorner",dBtn).CornerRadius=UDim.new(0,7)
        local dList=Instance.new("Frame",card) dList.Size=UDim2.new(0,dW,0,#options*26+6)
        dList.Position=UDim2.new(1,-(dW+8),1,3) dList.BackgroundColor3=C.panel
        dList.BorderSizePixel=0 dList.Visible=false dList.ZIndex=55
        Instance.new("UICorner",dList).CornerRadius=UDim.new(0,8)
        Instance.new("UIStroke",dList).Color=C.accent
        local dll=Instance.new("UIListLayout",dList) dll.Padding=UDim.new(0,2)
        local dlp=Instance.new("UIPadding",dList) dlp.PaddingTop=UDim.new(0,3) dlp.PaddingLeft=UDim.new(0,3) dlp.PaddingRight=UDim.new(0,3)
        for _,opt in ipairs(options) do
            local ob=Instance.new("TextButton",dList) ob.Size=UDim2.new(1,0,0,24) ob.BackgroundColor3=C.card
            ob.TextColor3=C.text ob.Font=Enum.Font.Gotham ob.TextSize=FONT_S ob.Text=opt ob.ZIndex=56
            Instance.new("UICorner",ob).CornerRadius=UDim.new(0,5)
            ob.MouseEnter:Connect(function() TweenService:Create(ob,TweenInfo.new(0.1),{BackgroundColor3=C.cardHov}):Play() end)
            ob.MouseLeave:Connect(function() TweenService:Create(ob,TweenInfo.new(0.1),{BackgroundColor3=C.card}):Play() end)
            ob.MouseButton1Click:Connect(function() dBtn.Text=opt.." ▾" dList.Visible=false playUI(1.3) callback(opt) end)
        end
        dBtn.MouseButton1Click:Connect(function() dList.Visible=not dList.Visible playUI(1.2) end)
    end

    local function createSlider(tabName,symbol,title,min,max,default,callback)
        local sf=getScroll(tabName)
        local card=Instance.new("Frame",sf) card.Size=UDim2.new(1,-8,0,isMobile and 50 or 54)
        card.BackgroundColor3=C.card card.BorderSizePixel=0 card.LayoutOrder=nextOrd(tabName) card.ZIndex=23
        Instance.new("UICorner",card).CornerRadius=UDim.new(0,9)
        local symL=Instance.new("TextLabel",card) symL.Size=UDim2.new(0,20,0,16) symL.Position=UDim2.new(0,8,0,7)
        symL.BackgroundTransparency=1 symL.Text=symbol symL.TextColor3=C.accent
        symL.Font=Enum.Font.GothamBold symL.TextSize=14 symL.ZIndex=24
        local lbl=Instance.new("TextLabel",card) lbl.Size=UDim2.new(0.66,0,0,16) lbl.Position=UDim2.new(0,30,0,7)
        lbl.BackgroundTransparency=1 lbl.Text=title lbl.TextColor3=C.text
        lbl.Font=Enum.Font.GothamBold lbl.TextSize=FONT_L lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.ZIndex=24
        local valLbl=Instance.new("TextLabel",card) valLbl.Size=UDim2.new(0,40,0,16) valLbl.Position=UDim2.new(1,-46,0,7)
        valLbl.BackgroundTransparency=1 valLbl.Text=tostring(default) valLbl.TextColor3=C.accent
        valLbl.Font=Enum.Font.GothamBold valLbl.TextSize=FONT_L valLbl.TextXAlignment=Enum.TextXAlignment.Right valLbl.ZIndex=24
        local track=Instance.new("Frame",card) track.Size=UDim2.new(1,-20,0,5) track.Position=UDim2.new(0,10,0,isMobile and 34 or 37)
        track.BackgroundColor3=C.off track.BorderSizePixel=0 track.ZIndex=24
        Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
        local fill=Instance.new("Frame",track) fill.Size=UDim2.new((default-min)/(max-min),0,1,0)
        fill.BackgroundColor3=C.accent fill.BorderSizePixel=0 fill.ZIndex=25
        Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
        local knob=Instance.new("Frame",track) knob.Size=UDim2.new(0,13,0,13)
        knob.Position=UDim2.new((default-min)/(max-min),-6,0.5,-6)
        knob.BackgroundColor3=C.white knob.BorderSizePixel=0 knob.ZIndex=26
        Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
        local draggingSlider=false
        local clickBtn=Instance.new("TextButton",card) clickBtn.Size=UDim2.new(1,0,1,0)
        clickBtn.BackgroundTransparency=1 clickBtn.Text="" clickBtn.ZIndex=27
        local function doSlider(inputX)
            local ratio=math.clamp((inputX-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
            local val=math.floor(min+(max-min)*ratio)
            fill.Size=UDim2.new(ratio,0,1,0) knob.Position=UDim2.new(ratio,-6,0.5,-6)
            valLbl.Text=tostring(val) callback(val)
        end
        clickBtn.MouseButton1Down:Connect(function(x) draggingSlider=true doSlider(x) end)
        UIS.InputChanged:Connect(function(i)
            if draggingSlider and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then doSlider(i.Position.X) end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then draggingSlider=false end
        end)
    end

    -- Emote Button
    local function createEmoteBtn(tabName,symbol,emoteName,animId)
        local sf=getScroll(tabName)
        local card=Instance.new("TextButton",sf)
        card.Size=UDim2.new(0.48,-4,0,CARD_H) card.BackgroundColor3=C.card
        card.BorderSizePixel=0 card.LayoutOrder=nextOrd(tabName) card.ZIndex=23
        card.Text="" card.AutoButtonColor=false
        Instance.new("UICorner",card).CornerRadius=UDim.new(0,9)
        local stroke=Instance.new("UIStroke",card) stroke.Color=C.accent stroke.Thickness=1 stroke.Transparency=1

        local sym=Instance.new("TextLabel",card) sym.Size=UDim2.new(1,0,0,22) sym.Position=UDim2.new(0,0,0,5)
        sym.BackgroundTransparency=1 sym.Text=symbol sym.TextColor3=C.accent
        sym.Font=Enum.Font.GothamBold sym.TextSize=18 sym.ZIndex=24

        local lbl=Instance.new("TextLabel",card) lbl.Size=UDim2.new(1,-4,0,14) lbl.Position=UDim2.new(0,2,1,-17)
        lbl.BackgroundTransparency=1 lbl.Text=emoteName lbl.TextColor3=C.sub
        lbl.Font=Enum.Font.Gotham lbl.TextSize=FONT_S lbl.ZIndex=24

        card.MouseEnter:Connect(function()
            TweenService:Create(card,TweenInfo.new(0.14),{BackgroundColor3=C.cardHov}):Play()
            TweenService:Create(stroke,TweenInfo.new(0.14),{Transparency=0.55}):Play()
        end)
        card.MouseLeave:Connect(function()
            TweenService:Create(card,TweenInfo.new(0.14),{BackgroundColor3=C.card}):Play()
            TweenService:Create(stroke,TweenInfo.new(0.14),{Transparency=1}):Play()
        end)
        card.MouseButton1Click:Connect(function()
            playEmote(animId)
            TweenService:Create(sym,TweenInfo.new(0.15),{TextColor3=C.green}):Play()
            task.wait(0.3)
            TweenService:Create(sym,TweenInfo.new(0.3),{TextColor3=C.accent}):Play()
        end)
    end

    -- Emote Grid Frame
    local function startEmoteGrid(tabName)
        local sf=getScroll(tabName)
        local grid=Instance.new("Frame",sf)
        grid.Size=UDim2.new(1,-8,0,0) grid.BackgroundTransparency=1
        grid.BorderSizePixel=0 grid.LayoutOrder=nextOrd(tabName) grid.ZIndex=23
        grid.AutomaticSize=Enum.AutomaticSize.Y
        local gl=Instance.new("UIGridLayout",grid)
        gl.CellSize=UDim2.new(0.48,-4,0,CARD_H) gl.CellPadding=UDim2.new(0,6,0,6)
        gl.HorizontalAlignment=Enum.HorizontalAlignment.Center
        return grid
    end

    ------------------------------------------------
    -- ◆ PERF TAB
    ------------------------------------------------
    addSection("Perf",SYM.bolt,"PERFORMANCE")
    createToggle("Perf",SYM.bolt,"FPS Boost","VFX & Schatten entfernen",function(on)
        Lighting.GlobalShadows=not on
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=not on end
            if v:IsA("BasePart") and on then v.Material=Enum.Material.Plastic v.Reflectance=0 v.CastShadow=false end
        end
    end)
    createToggle("Perf",SYM.fire,"Ultra Low Graphics","Level 1 max FPS",function(on)
        settings().Rendering.QualityLevel=on and Enum.QualityLevel.Level01 or Enum.QualityLevel.Level10
    end)
    createToggle("Perf",SYM.chart,"Auto RAM Boost","Grafik nach RAM anpassen",function(on)
        task.spawn(function()
            while on and task.wait(5) do
                local m=Stats:GetTotalMemoryUsageMb()
                settings().Rendering.QualityLevel=m>2000 and Enum.QualityLevel.Level01 or m>1200 and Enum.QualityLevel.Level05 or Enum.QualityLevel.Level10
            end
        end)
    end)
    createToggle("Perf",SYM.forbidden,"No Shadows","Alle Schatten aus",function(on)
        Lighting.GlobalShadows=not on
        for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.CastShadow=not on end end
    end)
    createToggle("Perf",SYM.forbidden,"No Particles","Partikel global aus",function(on)
        for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") then v.Enabled=not on end end
        if on then workspace.DescendantAdded:Connect(function(v) if v:IsA("ParticleEmitter") then v.Enabled=false end end) end
    end)
    createToggle("Perf",SYM.eye,"Anti AFK","Verhindert AFK Kick",function(on)
        if on then local VU=game:GetService("VirtualUser") LocalPlayer.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end) end
    end)
    addSection("Perf",SYM.eye,"FPS COUNTER")
    createToggle("Perf",SYM.eye,"FPS Anzeige","FPS Counter einblenden",function(on)
        local fl=ScreenGui:FindFirstChild("_FPS")
        if on then
            if not fl then
                fl=Instance.new("Frame",ScreenGui) fl.Name="_FPS"
                fl.Size=UDim2.new(0,90,0,24) fl.Position=UDim2.new(0,76,0,5)
                fl.BackgroundColor3=C.panel fl.BorderSizePixel=0 fl.ZIndex=100
                Instance.new("UICorner",fl).CornerRadius=UDim.new(0,7)
                local st=Instance.new("UIStroke",fl) st.Color=C.accent st.Thickness=1 st.Transparency=0.5
                local ft=Instance.new("TextLabel",fl) ft.Size=UDim2.new(1,0,1,0) ft.BackgroundTransparency=1
                ft.TextColor3=C.green ft.Font=Enum.Font.GothamBold ft.TextSize=11 ft.ZIndex=101
                task.spawn(function()
                    local last=tick() local fr=0
                    while fl and fl.Parent do
                        fr=fr+1
                        if tick()-last>=1 then ft.Text=SYM.bolt.." "..fr.." FPS" fr=0 last=tick() end
                        RunService.RenderStepped:Wait()
                    end
                end)
            end
        else if fl then fl:Destroy() end end
    end)

    ------------------------------------------------
    -- ◉ VISUAL TAB
    ------------------------------------------------
    addSection("Visual",SYM.eye,"VISUAL")
    createToggle("Visual",SYM.star,"Full Bright","Maximale Helligkeit",function(on)
        Lighting.Ambient=on and Color3.new(1,1,1) or Color3.fromRGB(70,70,70)
        Lighting.OutdoorAmbient=on and Color3.new(1,1,1) or Color3.fromRGB(100,100,100)
        Lighting.Brightness=on and 10 or 2
    end)
    createToggle("Visual",SYM.wave,"No Fog","Nebel entfernen",function(on)
        Lighting.FogEnd=on and 9e9 or 1000 Lighting.FogStart=on and 9e9 or 0
    end)
    createToggle("Visual",SYM.forbidden,"Remove VFX","Partikel, Beams aus",function(on)
        local function clear(o)
            for _,v in ipairs(o:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=not on end
                if v:IsA("PointLight") or v:IsA("SpotLight") then v.Enabled=not on end
            end
        end
        clear(workspace)
        if on then workspace.DescendantAdded:Connect(function(o) task.wait() clear(o) end) end
    end)
    createToggle("Visual",SYM.diamond,"Neon Enemies","Gegner leuchten neon",function(on)
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                for _,v in ipairs(p.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.Material=on and Enum.Material.Neon or Enum.Material.Plastic end
                end
            end
        end
    end)
    createToggle("Visual",SYM.target,"Enemy Highlight","Roter Rahmen um Gegner",function(on)
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
    createToggle("Visual",SYM.anchor,"Name Tags","Namen über Spielern",function(on)
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local root=p.Character:FindFirstChild("HumanoidRootPart")
                if on and root then
                    local bb=Instance.new("BillboardGui",root) bb.Name="_NT"
                    bb.Size=UDim2.new(0,130,0,24) bb.StudsOffset=Vector3.new(0,3,0) bb.AlwaysOnTop=true
                    local tl=Instance.new("TextLabel",bb) tl.Size=UDim2.new(1,0,1,0)
                    tl.BackgroundTransparency=1 tl.Text=SYM.sword.." "..p.Name
                    tl.TextColor3=C.accent tl.Font=Enum.Font.GothamBold tl.TextScaled=true
                elseif not on then
                    local tag=root and root:FindFirstChild("_NT") if tag then tag:Destroy() end
                end
            end
        end
    end)

    ------------------------------------------------
    -- ⟁ BATTLE TAB (NEU - ersetzt Misc)
    ------------------------------------------------
    addSection("Battle",SYM.sword,"KAMPF FEATURES")

    createToggle("Battle",SYM.shield,"Anti Stun","Verhindert Stun-Effekte in TSB",function(on)
        setupAntiStun(on)
    end)

    createToggle("Battle",SYM.bolt,"Speed Boost","WalkSpeed auf 28",function(on)
        _G.SpeedOn=on
        local char=LocalPlayer.Character
        if char then local hum=char:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed=on and 28 or 16 end end
    end)

    createSlider("Battle",SYM.arrow,"Custom Speed",16,60,16,function(val)
        _G.CustomSpeed=val
        local char=LocalPlayer.Character
        if char then
            local hum=char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed=val
                task.defer(function() if hum and hum.Parent then hum.WalkSpeed=val end end)
            end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then
            if _G.SpeedOn then hum.WalkSpeed=28
            elseif _G.CustomSpeed and _G.CustomSpeed~=16 then hum.WalkSpeed=_G.CustomSpeed end
        end
    end)

    createToggle("Battle",SYM.eye,"Max Camera Zoom","Kamera weit rauszoomen",function(on)
        LocalPlayer.CameraMaxZoomDistance=on and 200 or 30
    end)

    createToggle("Battle",SYM.world,"No Clip","Durch Wände gehen",function(on)
        RunService.Stepped:Connect(function()
            if on and LocalPlayer.Character then
                for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide=false end
                end
            end
        end)
    end)

    addSection("Battle",SYM.music,"KILL SOUNDS")
    createToggle("Battle",SYM.music,"Kill Sound (Default)","Click bei Kill",function(on) setupKillSound(on,4612365796) end)
    createToggle("Battle",SYM.star,"Goat Sound","Ziegensound bei Kill",function(on) setupKillSound(on,135017578) end)
    createToggle("Battle",SYM.wave,"Bruh Sound","Bruh bei Kill",function(on) setupKillSound(on,1444622487) end)
    createToggle("Battle",SYM.diamond,"MLG Airhorn","MLG bei Kill",function(on) setupKillSound(on,135946816) end)
    createToggle("Battle",SYM.anchor,"Vine Boom","Vine Boom bei Kill",function(on) setupKillSound(on,5153644985) end)
    createSlider("Battle",SYM.music,"Kill Lautstärke",1,10,7,function(val) _G.KillVolume=val*0.1 end)

    addSection("Battle",SYM.target,"EXTRA")
    createToggle("Battle",SYM.power,"Anti AFK","Verhindert AFK Kick",function(on)
        if on then local VU=game:GetService("VirtualUser") LocalPlayer.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end) end
    end)
    createToggle("Battle",SYM.shield,"Low HP Alarm","Alarm bei wenig Leben",function(on)
        task.spawn(function()
            while on and task.wait(1) do
                local c=LocalPlayer.Character
                if c then local h=c:FindFirstChildOfClass("Humanoid") if h and h.Health<30 and h.Health>0 then playSound(131961136,1,1) end end
            end
        end)
    end)
    createToggle("Battle",SYM.forbidden,"UI Sounds aus","Click-Sounds deaktivieren",function(on) _G.UISound=not on end)

    ------------------------------------------------
    -- ✦ EMOTE TAB (NEU)
    ------------------------------------------------
    addSection("Emote",SYM.star,"EMOTES SPIELEN")

    -- Stop Button
    local sf_emote=getScroll("Emote")
    local stopCard=Instance.new("TextButton",sf_emote)
    stopCard.Size=UDim2.new(1,-8,0,CARD_H) stopCard.BackgroundColor3=Color3.fromRGB(30,12,12)
    stopCard.BorderSizePixel=0 stopCard.LayoutOrder=nextOrd("Emote") stopCard.ZIndex=23
    stopCard.Text="" stopCard.AutoButtonColor=false
    Instance.new("UICorner",stopCard).CornerRadius=UDim.new(0,9)
    local stopStroke=Instance.new("UIStroke",stopCard) stopStroke.Color=C.red stopStroke.Thickness=1 stopStroke.Transparency=0.5
    local stopLbl=Instance.new("TextLabel",stopCard) stopLbl.Size=UDim2.new(1,0,1,0)
    stopLbl.BackgroundTransparency=1 stopLbl.Text=SYM.cross.."  EMOTE STOPPEN"
    stopLbl.TextColor3=C.red stopLbl.Font=Enum.Font.GothamBold stopLbl.TextSize=FONT_L stopLbl.ZIndex=24
    stopCard.MouseButton1Click:Connect(function()
        stopEmote() playUI(0.8)
    end)

    addSection("Emote",SYM.anchor,"STANDARD EMOTES")

    -- Emote Buttons in Grid
    local emoteGrid=Instance.new("Frame",sf_emote)
    emoteGrid.Size=UDim2.new(1,-8,0,0) emoteGrid.BackgroundTransparency=1
    emoteGrid.BorderSizePixel=0 emoteGrid.LayoutOrder=nextOrd("Emote") emoteGrid.ZIndex=22
    emoteGrid.AutomaticSize=Enum.AutomaticSize.Y
    local egl=Instance.new("UIGridLayout",emoteGrid)
    egl.CellSize=UDim2.new(0.48,-4,0,CARD_H+10) egl.CellPadding=UDim2.new(0,6,0,6)
    egl.HorizontalAlignment=Enum.HorizontalAlignment.Center

    local emoteList = {
        {sym="♛", name="Verbeugung",  id=EMOTE_ANIMS["Bow"]},
        {sym="◆", name="Jubeln",      id=EMOTE_ANIMS["Cheer"]},
        {sym="≋", name="Tanzen 1",    id=EMOTE_ANIMS["Dance"]},
        {sym="⊕", name="Tanzen 2",    id=EMOTE_ANIMS["Dance2"]},
        {sym="✦", name="Tanzen 3",    id=EMOTE_ANIMS["Dance3"]},
        {sym="⟳", name="Lachen",      id=EMOTE_ANIMS["Laugh"]},
        {sym="➤", name="Zeigen",      id=EMOTE_ANIMS["Point"]},
        {sym="◈", name="Salutieren",  id=EMOTE_ANIMS["Salute"]},
        {sym="⬡", name="Kippen",      id=EMOTE_ANIMS["Tilt"]},
        {sym="⊛", name="Stillstand",  id=EMOTE_ANIMS["Atento"]},
    }

    for _, em in ipairs(emoteList) do
        local btn=Instance.new("TextButton",emoteGrid)
        btn.Size=UDim2.new(1,0,1,0) btn.BackgroundColor3=C.card
        btn.BorderSizePixel=0 btn.Text="" btn.AutoButtonColor=false btn.ZIndex=23
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,9)
        local bStroke=Instance.new("UIStroke",btn) bStroke.Color=C.accent bStroke.Thickness=1 bStroke.Transparency=1
        local bSym=Instance.new("TextLabel",btn) bSym.Size=UDim2.new(1,0,0,26) bSym.Position=UDim2.new(0,0,0,4)
        bSym.BackgroundTransparency=1 bSym.Text=em.sym bSym.TextColor3=C.accent
        bSym.Font=Enum.Font.GothamBold bSym.TextSize=20 bSym.ZIndex=24
        local bLbl=Instance.new("TextLabel",btn) bLbl.Size=UDim2.new(1,-4,0,13) bLbl.Position=UDim2.new(0,2,1,-16)
        bLbl.BackgroundTransparency=1 bLbl.Text=em.name bLbl.TextColor3=C.sub
        bLbl.Font=Enum.Font.Gotham bLbl.TextSize=FONT_S bLbl.ZIndex=24
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.14),{BackgroundColor3=C.cardHov}):Play()
            TweenService:Create(bStroke,TweenInfo.new(0.14),{Transparency=0.55}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.14),{BackgroundColor3=C.card}):Play()
            TweenService:Create(bStroke,TweenInfo.new(0.14),{Transparency=1}):Play()
        end)
        btn.MouseButton1Click:Connect(function()
            playEmote(em.id)
            TweenService:Create(bSym,TweenInfo.new(0.1),{TextColor3=C.green}):Play()
            task.wait(0.4)
            TweenService:Create(bSym,TweenInfo.new(0.3),{TextColor3=C.accent}):Play()
            -- Bounce Animation
            TweenService:Create(btn,TweenInfo.new(0.1,Enum.EasingStyle.Back),{Size=UDim2.new(0.95,0,0.9,0)}):Play()
            task.wait(0.1)
            TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0)}):Play()
        end)
    end

    ------------------------------------------------
    -- ◆ GFX TAB
    ------------------------------------------------
    addSection("Gfx",SYM.gem,"PRESET")
    createDropdown("Gfx",SYM.gem.." Grafik Preset",{"POTATO","LOW","MEDIUM","HIGH","ULTRA","CINEMATIC","ANIME"},function(sel)
        if GrafixPresets[sel] then GrafixPresets[sel]() end
    end)
    addSection("Gfx",SYM.star,"EFFEKTE")
    createToggle("Gfx",SYM.star,"Bloom","Glow-Effekt",function(on)
        local b=Lighting:FindFirstChildOfClass("BloomEffect")
        if on then if not b then b=Instance.new("BloomEffect",Lighting) end b.Intensity=0.8 b.Size=40 b.Threshold=0.9
        elseif b then b:Destroy() end
    end)
    createSlider("Gfx",SYM.star,"Bloom Stärke",1,20,4,function(val)
        local b=Lighting:FindFirstChildOfClass("BloomEffect") if b then b.Intensity=val*0.15 end
    end)
    createToggle("Gfx",SYM.bolt,"Sun Rays","Sonnenstrahlen",function(on)
        local sr=Lighting:FindFirstChildOfClass("SunRaysEffect")
        if on then if not sr then sr=Instance.new("SunRaysEffect",Lighting) end sr.Intensity=0.15 sr.Spread=0.6
        elseif sr then sr:Destroy() end
    end)
    createToggle("Gfx",SYM.diamond,"Color Grading","Farb-Korrektur",function(on)
        local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if on then if not cc then cc=Instance.new("ColorCorrectionEffect",Lighting) end cc.Saturation=0.35 cc.Contrast=0.2 cc.Brightness=0.05
        elseif cc then cc:Destroy() end
    end)
    createSlider("Gfx",SYM.wave,"Saturation",0,10,3,function(val)
        local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect") if cc then cc.Saturation=val*0.1 end
    end)
    createToggle("Gfx",SYM.world,"Atmosphere","Atmosphären-Effekt",function(on)
        local a=Lighting:FindFirstChildOfClass("Atmosphere")
        if on then if not a then a=Instance.new("Atmosphere",Lighting) end a.Density=0.3 a.Haze=0.5 a.Glare=0.5 a.Color=Color3.fromRGB(199,210,255)
        elseif a then a:Destroy() end
    end)
    createToggle("Gfx",SYM.eye,"Depth of Field","Tiefenschärfe",function(on)
        local d=Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
        if on then if not d then d=Instance.new("DepthOfFieldEffect",Lighting) end d.FarIntensity=0.3 d.NearIntensity=0.1 d.FocusDistance=40 d.InFocusRadius=20
        elseif d then d:Destroy() end
    end)
    createSlider("Gfx",SYM.star,"Helligkeit",1,10,2,function(val) Lighting.Brightness=val*0.5 end)
    createSlider("Gfx",SYM.chart,"Quality Level",1,21,10,function(val) settings().Rendering.QualityLevel=val end)
end

------------------------------------------------
-- KEY SCREEN
------------------------------------------------
local KeyScreen=Instance.new("Frame",ScreenGui)
KeyScreen.Size=UDim2.new(1,0,1,0) KeyScreen.BackgroundColor3=C.black
KeyScreen.ZIndex=50 KeyScreen.BorderSizePixel=0 KeyScreen.Visible=true

task.spawn(function()
    while KeyScreen.Visible do spawnParticle(KeyScreen) task.wait(0.25) end
end)

local KSGrad=Instance.new("UIGradient",KeyScreen)
KSGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(10,5,20)),ColorSequenceKeypoint.new(1,Color3.fromRGB(5,5,12))})
KSGrad.Rotation=135

local KSLuffy=Instance.new("ImageLabel",KeyScreen)
KSLuffy.Size=UDim2.new(0,isMobile and 80 or 110,0,isMobile and 80 or 110)
KSLuffy.Position=UDim2.new(0.1,0,0.5,-80) KSLuffy.BackgroundTransparency=1 KSLuffy.Image=IMG.luffy KSLuffy.ZIndex=51

local KSZoro=Instance.new("ImageLabel",KeyScreen)
KSZoro.Size=UDim2.new(0,isMobile and 80 or 110,0,isMobile and 80 or 110)
KSZoro.Position=UDim2.new(0.9,isMobile and -80 or -110,0.5,-80) KSZoro.BackgroundTransparency=1 KSZoro.Image=IMG.zoro KSZoro.ZIndex=51

task.spawn(function()
    local t=0
    while KeyScreen.Visible do
        t=t+0.02
        local o=math.sin(t)*12
        KSLuffy.Position=UDim2.new(0.1,0,0.5,-80+o)
        KSZoro.Position=UDim2.new(0.9,isMobile and -80 or -110,0.5,-80-o)
        task.wait(0.03)
    end
end)

-- Custom Zeichen im Key Screen Titel
local KSTitle=Instance.new("TextLabel",KeyScreen)
KSTitle.Size=UDim2.new(0.8,0,0,40) KSTitle.Position=UDim2.new(0.1,0,0,isMobile and 55 or 70)
KSTitle.BackgroundTransparency=1 KSTitle.Text= SYM.anchor .. "  GOD VALLEY HUB  " .. SYM.anchor
KSTitle.Font=Enum.Font.GothamBold KSTitle.TextSize=isMobile and 20 or 26 KSTitle.ZIndex=52
Instance.new("UIGradient",KSTitle).Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.accent),ColorSequenceKeypoint.new(1,C.accent2)})

local KSSub=Instance.new("TextLabel",KeyScreen)
KSSub.Size=UDim2.new(0.8,0,0,18) KSSub.Position=UDim2.new(0.1,0,0,isMobile and 100 or 118)
KSSub.BackgroundTransparency=1
KSSub.Text= SYM.wave .. " The Strongest Battleground " .. SYM.wave .. " One Piece Edition"
KSSub.TextColor3=C.sub KSSub.Font=Enum.Font.Gotham KSSub.TextSize=isMobile and 10 or 12 KSSub.ZIndex=52

local KW=isMobile and 280 or 360
local KH=isMobile and 220 or 248
local KeyBox=Instance.new("Frame",KeyScreen)
KeyBox.Size=UDim2.new(0,KW,0,KH) KeyBox.Position=UDim2.new(0.5,-KW/2,0.5,-KH/2+20)
KeyBox.BackgroundColor3=C.panel KeyBox.BorderSizePixel=0 KeyBox.ZIndex=52
Instance.new("UICorner",KeyBox).CornerRadius=UDim.new(0,16)

local KBStroke=Instance.new("UIStroke",KeyBox) KBStroke.Thickness=1.5 KBStroke.Color=C.accent KBStroke.Transparency=0.3
task.spawn(function()
    local t=0
    while KeyScreen.Visible do
        t=t+0.025 KBStroke.Color=C.accent:Lerp(C.accent2,(math.sin(t)+1)/2) task.wait(0.04)
    end
end)

local LockBg=Instance.new("Frame",KeyBox) LockBg.Size=UDim2.new(0,44,0,44) LockBg.Position=UDim2.new(0.5,-22,0,-22)
LockBg.BackgroundColor3=C.panel LockBg.BorderSizePixel=0 LockBg.ZIndex=54
Instance.new("UICorner",LockBg).CornerRadius=UDim.new(1,0)
local LBStroke=Instance.new("UIStroke",LockBg) LBStroke.Color=C.accent LBStroke.Thickness=1.5
local LockLbl=Instance.new("TextLabel",LockBg) LockLbl.Size=UDim2.new(1,0,1,0)
LockLbl.BackgroundTransparency=1 LockLbl.Text=SYM.lock LockLbl.TextScaled=true LockLbl.ZIndex=55

local KBH=Instance.new("TextLabel",KeyBox)
KBH.Size=UDim2.new(1,-20,0,24) KBH.Position=UDim2.new(0,10,0,18)
KBH.BackgroundTransparency=1 KBH.Text=SYM.crown.."  KEY SYSTEM"
KBH.TextColor3=C.text KBH.Font=Enum.Font.GothamBold KBH.TextSize=isMobile and 13 or 15 KBH.ZIndex=53

local KBD=Instance.new("TextLabel",KeyBox)
KBD.Size=UDim2.new(1,-20,0,28) KBD.Position=UDim2.new(0,10,0,44)
KBD.BackgroundTransparency=1 KBD.Text="Gib deinen Key ein.\nAdmin Key oder einen Free Key von der Website."
KBD.TextColor3=C.sub KBD.Font=Enum.Font.Gotham KBD.TextSize=isMobile and 9 or 10 KBD.TextWrapped=true KBD.ZIndex=53

local GKBtn=Instance.new("TextButton",KeyBox)
GKBtn.Size=UDim2.new(1,-20,0,isMobile and 26 or 28) GKBtn.Position=UDim2.new(0,10,0,78)
GKBtn.BackgroundColor3=Color3.fromRGB(28,15,5) GKBtn.TextColor3=C.accent
GKBtn.Font=Enum.Font.GothamBold GKBtn.TextSize=isMobile and 9 or 10
GKBtn.Text=SYM.anchor.."  Klick " .. SYM.arrow .. " Key kopieren: GODVALLEY-FREE-001" GKBtn.ZIndex=53
Instance.new("UICorner",GKBtn).CornerRadius=UDim.new(0,7)
Instance.new("UIStroke",GKBtn).Color=C.accent

GKBtn.MouseButton1Click:Connect(function()
    playUI(1.3)
    pcall(function() setclipboard("GODVALLEY-FREE-001") end)
    local orig=GKBtn.Text
    GKBtn.Text=SYM.check.."  Kopiert! Jetzt unten einfügen"
    GKBtn.TextColor3=C.green
    task.wait(2)
    GKBtn.Text=orig GKBtn.TextColor3=C.accent
end)

local FKLbl=Instance.new("TextLabel",KeyBox)
FKLbl.Size=UDim2.new(1,-20,0,13) FKLbl.Position=UDim2.new(0,10,0,112)
FKLbl.BackgroundTransparency=1
FKLbl.Text= SYM.diamond.." Weitere: GODVALLEY-FREE-002  " .. SYM.wave .. "  ONEPIECE-TSB-OPEN"
FKLbl.TextColor3=C.sub FKLbl.Font=Enum.Font.Gotham FKLbl.TextSize=isMobile and 8 or 9 FKLbl.TextWrapped=true FKLbl.ZIndex=53

local InBg=Instance.new("Frame",KeyBox)
InBg.Size=UDim2.new(1,-20,0,isMobile and 32 or 36) InBg.Position=UDim2.new(0,10,0,130)
InBg.BackgroundColor3=C.card InBg.BorderSizePixel=0 InBg.ZIndex=53
Instance.new("UICorner",InBg).CornerRadius=UDim.new(0,9)
local InStroke=Instance.new("UIStroke",InBg) InStroke.Color=C.off InStroke.Thickness=1.5

local KeyInput=Instance.new("TextBox",InBg)
KeyInput.Size=UDim2.new(1,-16,1,0) KeyInput.Position=UDim2.new(0,8,0,0)
KeyInput.BackgroundTransparency=1 KeyInput.PlaceholderText=SYM.lock.." Key hier eingeben..."
KeyInput.PlaceholderColor3=C.sub KeyInput.Text=""
KeyInput.TextColor3=C.text KeyInput.Font=Enum.Font.Gotham
KeyInput.TextSize=isMobile and 10 or 12 KeyInput.ClearTextOnFocus=false KeyInput.ZIndex=54

KeyInput.Focused:Connect(function() TweenService:Create(InStroke,TweenInfo.new(0.2),{Color=C.accent}):Play() end)
KeyInput.FocusLost:Connect(function() TweenService:Create(InStroke,TweenInfo.new(0.2),{Color=C.off}):Play() end)

local StatusLbl=Instance.new("TextLabel",KeyBox)
StatusLbl.Size=UDim2.new(1,-20,0,13) StatusLbl.Position=UDim2.new(0,10,0,168)
StatusLbl.BackgroundTransparency=1 StatusLbl.Text=""
StatusLbl.TextColor3=C.red StatusLbl.Font=Enum.Font.Gotham StatusLbl.TextSize=FONT_S StatusLbl.ZIndex=53

local EnterBtn=Instance.new("TextButton",KeyBox)
EnterBtn.Size=UDim2.new(1,-20,0,isMobile and 30 or 34) EnterBtn.Position=UDim2.new(0,10,0,184)
EnterBtn.BackgroundColor3=C.accent2 EnterBtn.TextColor3=C.white
EnterBtn.Font=Enum.Font.GothamBold EnterBtn.TextSize=isMobile and 11 or 13
EnterBtn.Text=SYM.arrow.."  BESTÄTIGEN" EnterBtn.ZIndex=53
Instance.new("UICorner",EnterBtn).CornerRadius=UDim.new(0,9)

task.spawn(function()
    while KeyScreen.Visible do
        TweenService:Create(EnterBtn,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(200,55,30)}):Play()
        task.wait(0.9)
        TweenService:Create(EnterBtn,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=C.accent2}):Play()
        task.wait(0.9)
    end
end)

------------------------------------------------
-- KEY VALIDIERUNG
------------------------------------------------
local function tryKey(keyText)
    local cleaned=keyText:upper():gsub("%s+",""):gsub("-+","-")
    local keyData=KEYS[cleaned]

    if keyData then
        playSound(4590662766,0.8,1.2)
        EnterBtn.Text=SYM.check.."  KEY AKZEPTIERT!"
        EnterBtn.BackgroundColor3=C.green
        StatusLbl.TextColor3=C.green
        StatusLbl.Text=SYM.star.." Willkommen! Zugang gewährt."
        LockLbl.Text=SYM.unlock
        TweenService:Create(LBStroke,TweenInfo.new(0.3),{Color=C.green}):Play()

        -- Unlock Animation: Schloss springt hoch
        TweenService:Create(LockBg,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Size=UDim2.new(0,52,0,52),
            Position=UDim2.new(0.5,-26,0,-28)
        }):Play()

        task.wait(1.0)

        local flash=Instance.new("Frame",ScreenGui)
        flash.Size=UDim2.new(1,0,1,0) flash.BackgroundColor3=Color3.new(1,1,1)
        flash.BackgroundTransparency=0.4 flash.ZIndex=200 flash.BorderSizePixel=0
        TweenService:Create(flash,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
        game:GetService("Debris"):AddItem(flash,1)

        TweenService:Create(KeyScreen,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
            Position=UDim2.new(0,0,-1,0)
        }):Play()
        task.wait(0.55)
        KeyScreen.Visible=false
        KeyScreen.Position=UDim2.new(0,0,0,0)

        buildMainUI(keyData.type)

        OpenOuter.Visible=true
        OpenOuter.Size=UDim2.new(0,0,0,0)
        OpenOuter.Position=UDim2.new(0,0,0.5,0)
        TweenService:Create(OpenOuter,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Size=UDim2.new(0,54,0,54),
            Position=UDim2.new(0,10,0.5,-27),
        }):Play()

        local tw2=isMobile and 240 or 265
        local toast=Instance.new("Frame",ScreenGui)
        toast.Size=UDim2.new(0,tw2,0,54) toast.Position=UDim2.new(0.5,-tw2/2,1,10)
        toast.BackgroundColor3=C.panel toast.BorderSizePixel=0 toast.ZIndex=200
        Instance.new("UICorner",toast).CornerRadius=UDim.new(0,11)
        local tS=Instance.new("UIStroke",toast) tS.Color=C.green tS.Thickness=1.3
        local tImg=Instance.new("ImageLabel",toast) tImg.Size=UDim2.new(0,40,0,46) tImg.Position=UDim2.new(0,5,0.5,-23)
        tImg.BackgroundTransparency=1 tImg.Image=IMG.luffy tImg.ZIndex=201
        local tT=Instance.new("TextLabel",toast) tT.Size=UDim2.new(1,-52,0,18) tT.Position=UDim2.new(0,50,0,7)
        tT.BackgroundTransparency=1 tT.Text=SYM.anchor.." GOD VALLEY HUB v6.0"
        tT.TextColor3=C.accent tT.Font=Enum.Font.GothamBold tT.TextSize=isMobile and 11 or 12 tT.TextXAlignment=Enum.TextXAlignment.Left tT.ZIndex=201
        local tS2=Instance.new("TextLabel",toast) tS2.Size=UDim2.new(1,-52,0,13) tS2.Position=UDim2.new(0,50,0,27)
        tS2.BackgroundTransparency=1
        tS2.Text=keyData.type=="admin" and (SYM.crown.." Admin Zugang!") or (SYM.check.." Zugang gewährt!")
        tS2.TextColor3=C.green tS2.Font=Enum.Font.Gotham tS2.TextSize=isMobile and 9 or 10 tS2.TextXAlignment=Enum.TextXAlignment.Left tS2.ZIndex=201
        TweenService:Create(toast,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,-tw2/2,1,-64)}):Play()
        task.delay(4,function()
            TweenService:Create(toast,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Position=UDim2.new(0.5,-tw2/2,1,10)}):Play()
            task.wait(0.4) pcall(function() toast:Destroy() end)
        end)

    else
        playUI(0.5)
        EnterBtn.Text=SYM.forbidden.."  UNGÜLTIGER KEY"
        EnterBtn.BackgroundColor3=C.red
        StatusLbl.TextColor3=C.red
        StatusLbl.Text=SYM.cross.." Key nicht gefunden!"
        local origPos=InBg.Position
        task.spawn(function()
            for i=1,5 do
                TweenService:Create(InBg,TweenInfo.new(0.05),{Position=UDim2.new(origPos.X.Scale,origPos.X.Offset+(i%2==0 and 7 or -7),origPos.Y.Scale,origPos.Y.Offset)}):Play()
                task.wait(0.06)
            end
            TweenService:Create(InBg,TweenInfo.new(0.1),{Position=origPos}):Play()
        end)
        TweenService:Create(InStroke,TweenInfo.new(0.15),{Color=C.red}):Play()
        task.wait(2)
        EnterBtn.Text=SYM.arrow.."  BESTÄTIGEN"
        TweenService:Create(InStroke,TweenInfo.new(0.2),{Color=C.off}):Play()
        StatusLbl.Text=""
    end
end

EnterBtn.MouseButton1Click:Connect(function() tryKey(KeyInput.Text) end)
KeyInput.FocusLost:Connect(function(enter) if enter then tryKey(KeyInput.Text) end end)

KeyBox.Position=UDim2.new(0.5,-KW/2,0.6,-KH/2)
KeyScreen.BackgroundTransparency=1
task.wait(0.2)
TweenService:Create(KeyScreen,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()
TweenService:Create(KeyBox,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Position=UDim2.new(0.5,-KW/2,0.5,-KH/2+20)
}):Play()
