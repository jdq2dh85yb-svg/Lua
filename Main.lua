-- SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer

_G.UISound = true
_G.KillSoundOn = false
_G.KillSoundId = 4612365796

------------------------------------------------
-- SOUND
------------------------------------------------
local function playSound(id, vol, pitch)
    if not _G.UISound then return end
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
                playSound(_G.KillSoundId, 1, 1)
            end
        end)
    end)
end)
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                if _G.KillSoundOn then playSound(_G.KillSoundId, 1, 1) end
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
        local d=Instance.new("DepthOfFieldEffect",Lighting) d.FarIntensity=0.05 d.NearIntensity=0 d.FocusDistance=50 d.InFocusRadius=30
    end,
    ["CINEMATIC"] = function()
        clearPostFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
        Lighting.GlobalShadows = true
        Lighting.Brightness = 1.8
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=2 b.Size=80 b.Threshold=0.75
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.6 cc.Contrast=0.3 cc.TintColor=Color3.fromRGB(210,220,255)
        local sr=Instance.new("SunRaysEffect",Lighting) sr.Intensity=0.25 sr.Spread=0.8
        local a=Instance.new("Atmosphere",Lighting) a.Density=0.5 a.Haze=0.8 a.Glare=1 a.Color=Color3.fromRGB(180,200,255)
    end,
    ["ANIME"] = function()
        clearPostFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level14
        Lighting.GlobalShadows = true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=3 b.Size=100 b.Threshold=0.6
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.8 cc.Contrast=0.25 cc.TintColor=Color3.fromRGB(255,210,230)
    end,
}

------------------------------------------------
-- FARBEN
------------------------------------------------
local C = {
    bg      = Color3.fromRGB(6, 6, 14),
    panel   = Color3.fromRGB(14, 14, 26),
    card    = Color3.fromRGB(20, 20, 36),
    cardHov = Color3.fromRGB(28, 28, 50),
    accent  = Color3.fromRGB(255, 180, 50),   -- One Piece Gold
    accent2 = Color3.fromRGB(255, 80, 50),    -- One Piece Rot
    green   = Color3.fromRGB(80, 220, 130),
    red     = Color3.fromRGB(255, 80, 80),
    off     = Color3.fromRGB(45, 45, 65),
    text    = Color3.fromRGB(240, 235, 220),  -- warmes Weiß
    sub     = Color3.fromRGB(140, 130, 110),
}

-- One Piece Image IDs (Decal IDs die in Roblox funktionieren)
local IMAGES = {
    luffy    = "rbxassetid://7072085162",   -- Luffy
    zoro     = "rbxassetid://7072086105",   -- Zoro
    sanji    = "rbxassetid://7072086800",   -- Sanji
    nami     = "rbxassetid://7072085600",   -- Nami
    logo     = "rbxassetid://7072084500",   -- OP Logo
    jolly    = "rbxassetid://6031075938",   -- Jolly Roger (Totenschädel)
    sword    = "rbxassetid://6034769670",   -- Schwert Icon
    star     = "rbxassetid://6034281983",   -- Stern
    perf     = "rbxassetid://6034284934",   -- Bolt (Performance)
    visual   = "rbxassetid://6034768450",   -- Eye (Visual)
    misc     = "rbxassetid://6034769670",   -- Tool (Misc)
    sound    = "rbxassetid://6034686678",   -- Speaker (Sound)
    graphics = "rbxassetid://6034684949",   -- Diamond (Graphics)
}

------------------------------------------------
-- SCREENUI
------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GodValleyHubV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------
-- OPEN BUTTON (One Piece Stil)
------------------------------------------------
local OpenOuter = Instance.new("Frame", ScreenGui)
OpenOuter.Size = UDim2.new(0, 64, 0, 64)
OpenOuter.Position = UDim2.new(0, 12, 0.5, -32)
OpenOuter.BackgroundColor3 = C.bg
OpenOuter.BorderSizePixel = 0
OpenOuter.ZIndex = 10
Instance.new("UICorner", OpenOuter).CornerRadius = UDim.new(1, 0)

-- Gold Ring
local OBStroke = Instance.new("UIStroke", OpenOuter)
OBStroke.Thickness = 3
OBStroke.Color = C.accent
OBStroke.Transparency = 0

-- Luffy Bild
local OBImage = Instance.new("ImageLabel", OpenOuter)
OBImage.Size = UDim2.new(1, -6, 1, -6)
OBImage.Position = UDim2.new(0, 3, 0, 3)
OBImage.BackgroundTransparency = 1
OBImage.Image = IMAGES.luffy
OBImage.ScaleType = Enum.ScaleType.Fit
OBImage.ZIndex = 11
Instance.new("UICorner", OBImage).CornerRadius = UDim.new(1, 0)

local OBClick = Instance.new("TextButton", OpenOuter)
OBClick.Size = UDim2.new(1, 0, 1, 0)
OBClick.BackgroundTransparency = 1
OBClick.Text = ""
OBClick.ZIndex = 12

-- Tooltip
local OBTip = Instance.new("TextLabel", OpenOuter)
OBTip.Size = UDim2.new(0, 80, 0, 18)
OBTip.Position = UDim2.new(1, 6, 0.5, -9)
OBTip.BackgroundColor3 = C.panel
OBTip.TextColor3 = C.accent
OBTip.Font = Enum.Font.GothamBold
OBTip.TextSize = 10
OBTip.Text = "GOD VALLEY"
OBTip.ZIndex = 13
Instance.new("UICorner", OBTip).CornerRadius = UDim.new(0, 4)

-- Pulse
task.spawn(function()
    while true do
        TweenService:Create(OBStroke, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency=0.7}):Play()
        task.wait(1.0)
        TweenService:Create(OBStroke, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency=0}):Play()
        task.wait(1.0)
    end
end)

-- Rotate Ring Farbe
task.spawn(function()
    local colors = {C.accent, C.accent2, C.accent}
    local t = 0
    while true do
        t = t + 0.02
        local ratio = (math.sin(t) + 1) / 2
        OBStroke.Color = C.accent:Lerp(C.accent2, ratio)
        task.wait(0.04)
    end
end)

------------------------------------------------
-- MAIN FRAME
------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 430, 0, 590)
MainFrame.Position = UDim2.new(0.5, -215, 0.5, -295)
MainFrame.BackgroundColor3 = C.bg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Visible = false
MainFrame.ZIndex = 20
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- Animierter Rahmen
local MFStroke = Instance.new("UIStroke", MainFrame)
MFStroke.Thickness = 2
MFStroke.Color = C.accent
MFStroke.Transparency = 0.2

task.spawn(function()
    local t = 0
    while true do
        t = t + 0.025
        local r = (math.sin(t) + 1) / 2
        MFStroke.Color = C.accent:Lerp(C.accent2, r)
        task.wait(0.04)
    end
end)

-- BG Gradient
local BGGrad = Instance.new("UIGradient", MainFrame)
BGGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 7, 16)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 8, 20)),
})
BGGrad.Rotation = 135

------------------------------------------------
-- OPEN/CLOSE
------------------------------------------------
local isOpen = false

local function openHub()
    isOpen = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Visible = true
    playSound(6042053626, 0.5, 1.2)
    TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 430, 0, 590),
        Position = UDim2.new(0.5, -215, 0.5, -295),
    }):Play()
end

local function closeHub()
    isOpen = false
    playSound(6042053626, 0.5, 0.85)
    TweenService:Create(MainFrame, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }):Play()
    task.wait(0.35)
    if not isOpen then MainFrame.Visible = false end
end

OBClick.MouseButton1Click:Connect(function()
    if isOpen then closeHub() else openHub() end
end)

------------------------------------------------
-- HEADER (One Piece Banner Stil)
------------------------------------------------
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 80)
Header.BackgroundColor3 = C.panel
Header.BorderSizePixel = 0
Header.ZIndex = 21
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

-- Gradient rot-gold
local HGrad = Instance.new("UIGradient", Header)
HGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 8, 8)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 6)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 20)),
})
HGrad.Rotation = 90

-- Jolly Roger Links
local HJolly = Instance.new("ImageLabel", Header)
HJolly.Size = UDim2.new(0, 60, 0, 60)
HJolly.Position = UDim2.new(0, 10, 0.5, -30)
HJolly.BackgroundTransparency = 1
HJolly.Image = IMAGES.jolly
HJolly.ImageColor3 = C.accent
HJolly.ScaleType = Enum.ScaleType.Fit
HJolly.ZIndex = 22

-- Titel
local HTitleMain = Instance.new("TextLabel", Header)
HTitleMain.Size = UDim2.new(0, 220, 0, 28)
HTitleMain.Position = UDim2.new(0, 78, 0, 13)
HTitleMain.BackgroundTransparency = 1
HTitleMain.Text = "GOD VALLEY HUB"
HTitleMain.TextColor3 = C.accent
HTitleMain.Font = Enum.Font.GothamBold
HTitleMain.TextSize = 18
HTitleMain.TextXAlignment = Enum.TextXAlignment.Left
HTitleMain.ZIndex = 22

local HTitleGrad = Instance.new("UIGradient", HTitleMain)
HTitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.accent),
    ColorSequenceKeypoint.new(1, C.accent2),
})

-- Untertitel
local HSub = Instance.new("TextLabel", Header)
HSub.Size = UDim2.new(0, 260, 0, 16)
HSub.Position = UDim2.new(0, 78, 0, 44)
HSub.BackgroundTransparency = 1
HSub.Text = "The Strongest Battleground  |  v4.0"
HSub.TextColor3 = C.sub
HSub.Font = Enum.Font.Gotham
HSub.TextSize = 11
HSub.TextXAlignment = Enum.TextXAlignment.Left
HSub.ZIndex = 22

-- Status Badge
local StatusBadge = Instance.new("Frame", Header)
StatusBadge.Size = UDim2.new(0, 72, 0, 20)
StatusBadge.Position = UDim2.new(0, 78, 0, 62)
StatusBadge.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
StatusBadge.BorderSizePixel = 0
StatusBadge.ZIndex = 22
Instance.new("UICorner", StatusBadge).CornerRadius = UDim.new(1, 0)

local StatusDot = Instance.new("Frame", StatusBadge)
StatusDot.Size = UDim2.new(0, 7, 0, 7)
StatusDot.Position = UDim2.new(0, 5, 0.5, -3)
StatusDot.BackgroundColor3 = C.green
StatusDot.BorderSizePixel = 0
StatusDot.ZIndex = 23
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusTxt = Instance.new("TextLabel", StatusBadge)
StatusTxt.Size = UDim2.new(1, -16, 1, 0)
StatusTxt.Position = UDim2.new(0, 16, 0, 0)
StatusTxt.BackgroundTransparency = 1
StatusTxt.Text = "ACTIVE"
StatusTxt.TextColor3 = C.green
StatusTxt.Font = Enum.Font.GothamBold
StatusTxt.TextSize = 9
StatusTxt.ZIndex = 23

-- Zoro Bild rechts
local HZoro = Instance.new("ImageLabel", Header)
HZoro.Size = UDim2.new(0, 55, 0, 70)
HZoro.Position = UDim2.new(1, -115, 0, 5)
HZoro.BackgroundTransparency = 1
HZoro.Image = IMAGES.zoro
HZoro.ScaleType = Enum.ScaleType.Fit
HZoro.ZIndex = 22

-- Close
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 8)
CloseBtn.BackgroundColor3 = C.red
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.ZIndex = 23
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(closeHub)

-- Drag
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging=true dragStart=i.Position startPos=MainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging=false
    end
end)

------------------------------------------------
-- SIDEBAR TABS (Links, vertikal)
------------------------------------------------
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 58, 1, -90)
Sidebar.Position = UDim2.new(0, 8, 0, 84)
Sidebar.BackgroundColor3 = C.panel
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 21
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 4)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local SidePad = Instance.new("UIPadding", Sidebar)
SidePad.PaddingTop = UDim.new(0, 6)
SidePad.PaddingBottom = UDim.new(0, 6)

-- Content Bereich (rechts von Sidebar)
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -76, 1, -90)
ContentArea.Position = UDim2.new(0, 72, 0, 84)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 21

------------------------------------------------
-- SCROLL FRAME (KOMPLETT NEU AUFGEBAUT)
------------------------------------------------
local ScrollFrame = Instance.new("ScrollingFrame", ContentArea)
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.Position = UDim2.new(0, 0, 0, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = C.accent
ScrollFrame.ScrollBarImageTransparency = 0.4
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2000)  -- Start groß, wird angepasst
ScrollFrame.ScrollingEnabled = true
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
ScrollFrame.ZIndex = 22

local ListLayout = Instance.new("UIListLayout", ScrollFrame)
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ListPad = Instance.new("UIPadding", ScrollFrame)
ListPad.PaddingTop = UDim.new(0, 6)
ListPad.PaddingBottom = UDim.new(0, 14)
ListPad.PaddingLeft = UDim.new(0, 4)
ListPad.PaddingRight = UDim.new(0, 8)

local function updateCanvas()
    task.wait()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
end
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

------------------------------------------------
-- TABS SYSTEM (Sidebar Stil)
------------------------------------------------
local tabs = {}
local currentTab = nil
local layoutOrder = 0

-- Tab Daten mit Icons
local TAB_LIST = {
    {name="Perf",     icon=IMAGES.perf,     label="Perf"},
    {name="Visual",   icon=IMAGES.visual,   label="Visual"},
    {name="Misc",     icon=IMAGES.misc,     label="Misc"},
    {name="Sound",    icon=IMAGES.sound,    label="Sound"},
    {name="Graphics", icon=IMAGES.graphics, label="Gfx"},
}

local function switchTab(name)
    if currentTab == name then return end
    currentTab = name
    playSound(6042053626, 0.2, 1.6)

    -- Alle Elemente ein/ausblenden
    for tname, tdata in pairs(tabs) do
        local active = (tname == name)
        for _, elem in ipairs(tdata.elements) do
            elem.Visible = active
        end
        -- Tab Button Stil
        TweenService:Create(tdata.btnBg, TweenInfo.new(0.2), {
            BackgroundColor3 = active and C.accent2 or Color3.fromRGB(0,0,0),
            BackgroundTransparency = active and 0 or 1,
        }):Play()
        TweenService:Create(tdata.btnIcon, TweenInfo.new(0.2), {
            ImageColor3 = active and Color3.new(1,1,1) or C.sub,
        }):Play()
        TweenService:Create(tdata.btnLbl, TweenInfo.new(0.2), {
            TextColor3 = active and C.accent or C.sub,
        }):Play()
    end

    -- Scroll zurück nach oben
    ScrollFrame.CanvasPosition = Vector2.new(0, 0)
    updateCanvas()
end

for _, t in ipairs(TAB_LIST) do
    -- Container
    local btnContainer = Instance.new("Frame", Sidebar)
    btnContainer.Size = UDim2.new(1, -8, 0, 52)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ZIndex = 22

    local btnBg = Instance.new("Frame", btnContainer)
    btnBg.Size = UDim2.new(1, 0, 1, 0)
    btnBg.BackgroundColor3 = C.accent2
    btnBg.BackgroundTransparency = 1
    btnBg.BorderSizePixel = 0
    btnBg.ZIndex = 22
    Instance.new("UICorner", btnBg).CornerRadius = UDim.new(0, 8)

    local btnIcon = Instance.new("ImageLabel", btnContainer)
    btnIcon.Size = UDim2.new(0, 26, 0, 26)
    btnIcon.Position = UDim2.new(0.5, -13, 0, 4)
    btnIcon.BackgroundTransparency = 1
    btnIcon.Image = t.icon
    btnIcon.ImageColor3 = C.sub
    btnIcon.ScaleType = Enum.ScaleType.Fit
    btnIcon.ZIndex = 23

    local btnLbl = Instance.new("TextLabel", btnContainer)
    btnLbl.Size = UDim2.new(1, 0, 0, 14)
    btnLbl.Position = UDim2.new(0, 0, 1, -16)
    btnLbl.BackgroundTransparency = 1
    btnLbl.Text = t.label
    btnLbl.TextColor3 = C.sub
    btnLbl.Font = Enum.Font.GothamBold
    btnLbl.TextSize = 9
    btnLbl.ZIndex = 23

    local btnClick = Instance.new("TextButton", btnContainer)
    btnClick.Size = UDim2.new(1, 0, 1, 0)
    btnClick.BackgroundTransparency = 1
    btnClick.Text = ""
    btnClick.ZIndex = 24

    tabs[t.name] = {
        btnBg = btnBg,
        btnIcon = btnIcon,
        btnLbl = btnLbl,
        elements = {},
    }

    local captured = t.name
    btnClick.MouseButton1Click:Connect(function() switchTab(captured) end)

    btnClick.MouseEnter:Connect(function()
        if currentTab ~= captured then
            TweenService:Create(btnBg, TweenInfo.new(0.15), {BackgroundTransparency=0.85}):Play()
        end
    end)
    btnClick.MouseLeave:Connect(function()
        if currentTab ~= captured then
            TweenService:Create(btnBg, TweenInfo.new(0.15), {BackgroundTransparency=1}):Play()
        end
    end)
end

-- Erster Tab
switchTab("Perf")

------------------------------------------------
-- HELPER FUNKTIONEN
------------------------------------------------
local function addElement(tabName, elem)
    layoutOrder = layoutOrder + 1
    elem.LayoutOrder = layoutOrder
    elem.Visible = (tabName == currentTab)
    table.insert(tabs[tabName].elements, elem)
    updateCanvas()
end

local function addSection(tabName, text)
    local lbl = Instance.new("Frame", ScrollFrame)
    lbl.Size = UDim2.new(1, -12, 0, 26)
    lbl.BackgroundColor3 = Color3.fromRGB(18, 10, 6)
    lbl.BorderSizePixel = 0
    lbl.ZIndex = 23
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6)

    local line = Instance.new("Frame", lbl)
    line.Size = UDim2.new(0, 3, 0, 14)
    line.Position = UDim2.new(0, 6, 0.5, -7)
    line.BackgroundColor3 = C.accent
    line.BorderSizePixel = 0
    line.ZIndex = 24
    Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)

    local txt = Instance.new("TextLabel", lbl)
    txt.Size = UDim2.new(1, -20, 1, 0)
    txt.Position = UDim2.new(0, 16, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = C.accent
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 10
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.ZIndex = 24

    addElement(tabName, lbl)
end

------------------------------------------------
-- TOGGLE ERSTELLEN
------------------------------------------------
local function createToggle(tabName, title, desc, callback)
    local h = (desc and desc ~= "") and 56 or 44

    local card = Instance.new("Frame", ScrollFrame)
    card.Size = UDim2.new(1, -12, 0, h)
    card.BackgroundColor3 = C.card
    card.BorderSizePixel = 0
    card.ZIndex = 23
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = C.accent
    stroke.Thickness = 1
    stroke.Transparency = 1

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.72, 0, 0, 17)
    lbl.Position = UDim2.new(0, 12, 0, (desc and desc ~= "") and 10 or 13)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = C.text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 24

    if desc and desc ~= "" then
        local sub = Instance.new("TextLabel", card)
        sub.Size = UDim2.new(0.72, 0, 0, 13)
        sub.Position = UDim2.new(0, 12, 0, 32)
        sub.BackgroundTransparency = 1
        sub.Text = desc
        sub.TextColor3 = C.sub
        sub.Font = Enum.Font.Gotham
        sub.TextSize = 10
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.ZIndex = 24
    end

    -- Switch BG
    local swBg = Instance.new("Frame", card)
    swBg.Size = UDim2.new(0, 42, 0, 22)
    swBg.Position = UDim2.new(1, -52, 0.5, -11)
    swBg.BackgroundColor3 = C.off
    swBg.BorderSizePixel = 0
    swBg.ZIndex = 24
    Instance.new("UICorner", swBg).CornerRadius = UDim.new(1, 0)

    -- Knob
    local knob = Instance.new("Frame", swBg)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 25
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = false

    local clickBtn = Instance.new("TextButton", card)
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 26

    clickBtn.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = C.cardHov}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.6}):Play()
    end)
    clickBtn.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = C.card}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 1}):Play()
    end)
    clickBtn.MouseButton1Click:Connect(function()
        state = not state
        playSound(6042053626, 0.3, state and 1.5 or 1.0)
        TweenService:Create(swBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = state and C.green or C.off
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = state and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()
        callback(state)
    end)

    addElement(tabName, card)
    return card
end

------------------------------------------------
-- DROPDOWN
------------------------------------------------
local function createDropdown(tabName, title, options, callback)
    local card = Instance.new("Frame", ScrollFrame)
    card.Size = UDim2.new(1, -12, 0, 44)
    card.BackgroundColor3 = C.card
    card.BorderSizePixel = 0
    card.ClipsDescendants = false
    card.ZIndex = 30
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = C.text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 31

    local dropBtn = Instance.new("TextButton", card)
    dropBtn.Size = UDim2.new(0, 120, 0, 28)
    dropBtn.Position = UDim2.new(1, -128, 0.5, -14)
    dropBtn.BackgroundColor3 = C.accent
    dropBtn.TextColor3 = Color3.fromRGB(10, 8, 4)
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.TextSize = 10
    dropBtn.Text = options[1] .. " ▾"
    dropBtn.ClipsDescendants = false
    dropBtn.ZIndex = 31
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 7)

    local dropList = Instance.new("Frame", card)
    dropList.Size = UDim2.new(0, 120, 0, #options * 30 + 6)
    dropList.Position = UDim2.new(1, -128, 1, 4)
    dropList.BackgroundColor3 = C.panel
    dropList.BorderSizePixel = 0
    dropList.Visible = false
    dropList.ZIndex = 60
    Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 8)

    local dlStroke = Instance.new("UIStroke", dropList)
    dlStroke.Color = C.accent
    dlStroke.Thickness = 1
    dlStroke.Transparency = 0.4

    local dlLayout = Instance.new("UIListLayout", dropList)
    dlLayout.Padding = UDim.new(0, 2)

    local dlPad = Instance.new("UIPadding", dropList)
    dlPad.PaddingTop = UDim.new(0, 3)
    dlPad.PaddingLeft = UDim.new(0, 3)
    dlPad.PaddingRight = UDim.new(0, 3)

    for _, opt in ipairs(options) do
        local ob = Instance.new("TextButton", dropList)
        ob.Size = UDim2.new(1, 0, 0, 28)
        ob.BackgroundColor3 = C.card
        ob.TextColor3 = C.text
        ob.Font = Enum.Font.Gotham
        ob.TextSize = 10
        ob.Text = opt
        ob.ZIndex = 61
        Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 6)

        ob.MouseEnter:Connect(function()
            TweenService:Create(ob, TweenInfo.new(0.12), {BackgroundColor3=C.cardHov}):Play()
        end)
        ob.MouseLeave:Connect(function()
            TweenService:Create(ob, TweenInfo.new(0.12), {BackgroundColor3=C.card}):Play()
        end)
        ob.MouseButton1Click:Connect(function()
            dropBtn.Text = opt .. " ▾"
            dropList.Visible = false
            playSound(6042053626, 0.3, 1.3)
            callback(opt)
        end)
    end

    dropBtn.MouseButton1Click:Connect(function()
        dropList.Visible = not dropList.Visible
        playSound(6042053626, 0.25, 1.2)
    end)

    addElement(tabName, card)
end

------------------------------------------------
-- SLIDER
------------------------------------------------
local function createSlider(tabName, title, min, max, default, callback)
    local card = Instance.new("Frame", ScrollFrame)
    card.Size = UDim2.new(1, -12, 0, 58)
    card.BackgroundColor3 = C.card
    card.BorderSizePixel = 0
    card.ZIndex = 23
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.72, 0, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = C.text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 24

    local valLbl = Instance.new("TextLabel", card)
    valLbl.Size = UDim2.new(0, 45, 0, 18)
    valLbl.Position = UDim2.new(1, -52, 0, 8)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = C.accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 12
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 24

    local track = Instance.new("Frame", card)
    track.Size = UDim2.new(1, -24, 0, 6)
    track.Position = UDim2.new(0, 12, 0, 38)
    track.BackgroundColor3 = C.off
    track.BorderSizePixel = 0
    track.ZIndex = 24
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = C.accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 25
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((default-min)/(max-min), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 26
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local draggingSlider = false

    local clickBtn = Instance.new("TextButton", card)
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 27

    local function updateSlider(inputX)
        local ratio = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max-min) * ratio)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        knob.Position = UDim2.new(ratio, -7, 0.5, -7)
        valLbl.Text = tostring(val)
        callback(val)
    end

    clickBtn.MouseButton1Down:Connect(function(x)
        draggingSlider = true
        updateSlider(x)
    end)
    UIS.InputChanged:Connect(function(i)
        if draggingSlider and i.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)

    addElement(tabName, card)
end

------------------------------------------------
-- ⚡ PERFORMANCE TAB
------------------------------------------------
addSection("Perf", "PERFORMANCE")

createToggle("Perf", "FPS Boost", "VFX & Schatten entfernen", function(on)
    Lighting.GlobalShadows = not on
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled = not on end
        if v:IsA("BasePart") and on then v.Material=Enum.Material.Plastic v.Reflectance=0 v.CastShadow=false end
    end
end)

createToggle("Perf", "Ultra Low Graphics", "Level 1 - Maximum FPS", function(on)
    settings().Rendering.QualityLevel = on and Enum.QualityLevel.Level01 or Enum.QualityLevel.Level10
end)

createToggle("Perf", "Auto RAM Boost", "Grafik nach RAM anpassen", function(on)
    task.spawn(function()
        while on and task.wait(5) do
            local m = Stats:GetTotalMemoryUsageMb()
            settings().Rendering.QualityLevel = m>2000 and Enum.QualityLevel.Level01 or m>1200 and Enum.QualityLevel.Level05 or Enum.QualityLevel.Level10
        end
    end)
end)

createToggle("Perf", "No Shadows", "Alle Schatten deaktivieren", function(on)
    Lighting.GlobalShadows = not on
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.CastShadow = not on end
    end
end)

createToggle("Perf", "No Particles", "Partikel global aus", function(on)
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") then v.Enabled = not on end
    end
    if on then
        workspace.DescendantAdded:Connect(function(v)
            if v:IsA("ParticleEmitter") then v.Enabled = false end
        end)
    end
end)

createToggle("Perf", "Anti AFK", "Verhindert AFK Kick", function(on)
    if on then
        local VU = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)
    end
end)

addSection("Perf", "FPS ANZEIGE")

createToggle("Perf", "FPS Counter", "Zeigt FPS oben links an", function(on)
    local fl = ScreenGui:FindFirstChild("_FPS")
    if on then
        if not fl then
            fl = Instance.new("Frame", ScreenGui)
            fl.Name = "_FPS"
            fl.Size = UDim2.new(0, 90, 0, 28)
            fl.Position = UDim2.new(0, 86, 0, 6)
            fl.BackgroundColor3 = C.panel
            fl.BorderSizePixel = 0
            fl.ZIndex = 100
            Instance.new("UICorner", fl).CornerRadius = UDim.new(0, 7)
            local flStroke = Instance.new("UIStroke", fl)
            flStroke.Color = C.accent
            flStroke.Thickness = 1
            flStroke.Transparency = 0.5
            local flt = Instance.new("TextLabel", fl)
            flt.Size = UDim2.new(1,0,1,0)
            flt.BackgroundTransparency = 1
            flt.TextColor3 = C.green
            flt.Font = Enum.Font.GothamBold
            flt.TextSize = 12
            flt.ZIndex = 101
            task.spawn(function()
                local last = tick() local fr = 0
                while fl and fl.Parent do
                    fr = fr + 1
                    local now = tick()
                    if now-last >= 1 then
                        flt.Text = fr .. " FPS"
                        fr = 0 last = now
                    end
                    RunService.RenderStepped:Wait()
                end
            end)
        end
    else
        if fl then fl:Destroy() end
    end
end)

------------------------------------------------
-- VISUAL TAB
------------------------------------------------
addSection("Visual", "VISUAL SETTINGS")

createToggle("Visual", "Full Bright", "Maximale Helligkeit", function(on)
    Lighting.Ambient = on and Color3.new(1,1,1) or Color3.fromRGB(70,70,70)
    Lighting.OutdoorAmbient = on and Color3.new(1,1,1) or Color3.fromRGB(100,100,100)
    Lighting.Brightness = on and 10 or 2
end)

createToggle("Visual", "No Fog", "Nebel komplett entfernen", function(on)
    Lighting.FogEnd = on and 9e9 or 1000
    Lighting.FogStart = on and 9e9 or 0
end)

createToggle("Visual", "Remove All VFX", "Partikel, Beams, Lichter aus", function(on)
    local function clear(obj)
        for _,v in ipairs(obj:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=not on end
            if v:IsA("PointLight") or v:IsA("SpotLight") then v.Enabled=not on end
        end
    end
    clear(workspace)
    if on then workspace.DescendantAdded:Connect(function(o) task.wait() clear(o) end) end
end)

createToggle("Visual", "Neon Enemies", "Gegner leuchten auf", function(on)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            for _,v in ipairs(p.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.Material=on and Enum.Material.Neon or Enum.Material.Plastic end
            end
        end
    end
end)

createToggle("Visual", "Enemy Highlight", "Roter Rahmen um Gegner", function(on)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local sel = p.Character:FindFirstChild("_EBox")
            if on and not sel then
                local b=Instance.new("SelectionBox",p.Character)
                b.Name="_EBox" b.Adornee=p.Character
                b.Color3=C.red b.LineThickness=0.04
                b.SurfaceTransparency=0.85 b.SurfaceColor3=C.red
            elseif not on and sel then sel:Destroy() end
        end
    end
end)

createToggle("Visual", "Name Tags", "Namen über Spielern", function(on)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character then
            local root=p.Character:FindFirstChild("HumanoidRootPart")
            if on and root then
                local bb=Instance.new("BillboardGui",root)
                bb.Name="_NameTag" bb.Size=UDim2.new(0,140,0,28)
                bb.StudsOffset=Vector3.new(0,3.2,0) bb.AlwaysOnTop=true
                local tl=Instance.new("TextLabel",bb)
                tl.Size=UDim2.new(1,0,1,0) tl.BackgroundTransparency=1
                tl.Text="⚔ "..p.Name tl.TextColor3=C.accent
                tl.Font=Enum.Font.GothamBold tl.TextScaled=true
            elseif not on then
                local t=root and root:FindFirstChild("_NameTag")
                if t then t:Destroy() end
            end
        end
    end
end)

createToggle("Visual", "Rainbow World", "Welt ändert kontinuierlich Farbe", function(on)
    task.spawn(function()
        local h=0
        while on do
            h=(h+1)%360
            Lighting.Ambient=Color3.fromHSV(h/360,0.4,0.9)
            task.wait(0.05)
        end
        if not on then Lighting.Ambient=Color3.fromRGB(70,70,70) end
    end)
end)

------------------------------------------------
-- MISC TAB
------------------------------------------------
addSection("Misc", "MISC SETTINGS")

createToggle("Misc", "Speed Boost", "WalkSpeed auf 28", function(on)
    local c=LocalPlayer.Character
    if c then local h=c:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=on and 28 or 16 end end
end)

createSlider("Misc", "Custom Speed", 16, 60, 16, function(val)
    local c=LocalPlayer.Character
    if c then local h=c:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=val end end
end)

createToggle("Misc", "Max Camera Zoom", "Kamera weiter rauszoomen", function(on)
    LocalPlayer.CameraMaxZoomDistance = on and 200 or 30
end)

createToggle("Misc", "Low HP Alarm", "Sound-Alarm bei wenig Leben", function(on)
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

createToggle("Misc", "No Clip", "Durch Wände gehen", function(on)
    RunService.Stepped:Connect(function()
        if on and LocalPlayer.Character then
            for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide=false end
            end
        end
    end)
end)

createToggle("Misc", "Auto Rejoin", "Reconnect bei Kick", function(on)
    if on then
        game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(state)
            if state == Enum.TeleportState.Failed then
                game:GetService("TeleportService"):Teleport(game.PlaceId)
            end
        end)
    end
end)

------------------------------------------------
-- SOUND TAB
------------------------------------------------
addSection("Sound", "KILL SOUNDS")

createToggle("Sound", "Kill Sound (Default)", "Click Sound bei Kill", function(on)
    setupKillSound(on, 4612365796)
end)

createToggle("Sound", "Goat Sound", "Ziegensound bei Kill", function(on)
    setupKillSound(on, 135017578)
end)

createToggle("Sound", "Bruh Sound", "Bruh-Sound bei Kill", function(on)
    setupKillSound(on, 1444622487)
end)

createToggle("Sound", "MLG Airhorn", "MLG Airhorn bei Kill", function(on)
    setupKillSound(on, 135946816)
end)

createToggle("Sound", "Explosion Sound", "Explosion bei Kill", function(on)
    setupKillSound(on, 4612415714)
end)

createToggle("Sound", "Vine Boom", "Vine Boom bei Kill", function(on)
    setupKillSound(on, 5153644985)
end)

addSection("Sound", "UI SOUNDS")

createToggle("Sound", "UI Sounds deaktivieren", "Kein Click-Sound beim Toggle", function(on)
    _G.UISound = not on
end)

createSlider("Sound", "Kill Sound Volume", 1, 10, 7, function(val)
    -- Volume wird beim naechsten Kill angewendet
    _G.KillVolume = val * 0.1
end)

------------------------------------------------
-- GRAPHICS TAB
------------------------------------------------
addSection("Graphics", "GRAFIK PRESET")

createDropdown("Graphics", "Preset wählen", {
    "POTATO", "LOW", "MEDIUM", "HIGH", "ULTRA", "CINEMATIC", "ANIME"
}, function(sel)
    if GrafixPresets[sel] then GrafixPresets[sel]() end
end)

addSection("Graphics", "EINZELNE EFFEKTE")

createToggle("Graphics", "Bloom", "Glow-Effekt aktivieren", function(on)
    local b=Lighting:FindFirstChildOfClass("BloomEffect")
    if on then
        if not b then b=Instance.new("BloomEffect",Lighting) end
        b.Intensity=0.8 b.Size=40 b.Threshold=0.9
    elseif b then b:Destroy() end
end)

createSlider("Graphics", "Bloom Intensity", 1, 20, 4, function(val)
    local b=Lighting:FindFirstChildOfClass("BloomEffect")
    if b then b.Intensity=val*0.15 end
end)

createToggle("Graphics", "Sun Rays", "Sonnenstrahlen-Effekt", function(on)
    local sr=Lighting:FindFirstChildOfClass("SunRaysEffect")
    if on then
        if not sr then sr=Instance.new("SunRaysEffect",Lighting) end
        sr.Intensity=0.15 sr.Spread=0.6
    elseif sr then sr:Destroy() end
end)

createToggle("Graphics", "Color Grading", "Farb-Korrektur", function(on)
    local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if on then
        if not cc then cc=Instance.new("ColorCorrectionEffect",Lighting) end
        cc.Saturation=0.35 cc.Contrast=0.2 cc.Brightness=0.05
    elseif cc then cc:Destroy() end
end)

createSlider("Graphics", "Saturation", 0, 10, 3, function(val)
    local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if cc then cc.Saturation=val*0.1 end
end)

createSlider("Graphics", "Contrast", 0, 10, 2, function(val)
    local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if cc then cc.Contrast=val*0.08 end
end)

createToggle("Graphics", "Atmosphere", "Atmosphäre & Haze", function(on)
    local a=Lighting:FindFirstChildOfClass("Atmosphere")
    if on then
        if not a then a=Instance.new("Atmosphere",Lighting) end
        a.Density=0.3 a.Haze=0.5 a.Glare=0.5
        a.Color=Color3.fromRGB(199,210,255)
    elseif a then a:Destroy() end
end)

createToggle("Graphics", "Depth of Field", "Tiefenschärfe (DOF)", function(on)
    local d=Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
    if on then
        if not d then d=Instance.new("DepthOfFieldEffect",Lighting) end
        d.FarIntensity=0.3 d.NearIntensity=0.1
        d.FocusDistance=40 d.InFocusRadius=20
    elseif d then d:Destroy() end
end)

createToggle("Graphics", "Brightness Boost", "Helligkeit erhöhen", function(on)
    Lighting.Brightness = on and 4 or 2
end)

createSlider("Graphics", "Brightness Level", 1, 10, 2, function(val)
    Lighting.Brightness = val * 0.5
end)

createSlider("Graphics", "Quality Level", 1, 21, 10, function(val)
    settings().Rendering.QualityLevel = val
end)

------------------------------------------------
-- SANJI DEKO UNTEN (One Piece Stil)
------------------------------------------------
local Footer = Instance.new("Frame", MainFrame)
Footer.Size = UDim2.new(1, 0, 0, 0)  -- unsichtbar, nur für Deko
Footer.Position = UDim2.new(0, 0, 1, -1)
Footer.BackgroundTransparency = 1
Footer.ZIndex = 21

------------------------------------------------
-- TOAST NOTIFICATION
------------------------------------------------
local toast = Instance.new("Frame", ScreenGui)
toast.Size = UDim2.new(0, 280, 0, 60)
toast.Position = UDim2.new(0.5, -140, 1, 10)
toast.BackgroundColor3 = C.panel
toast.BorderSizePixel = 0
toast.ZIndex = 200
Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 12)

local toastGrad = Instance.new("UIGradient", toast)
toastGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 10, 4)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 20)),
})
toastGrad.Rotation = 90

local toastStroke = Instance.new("UIStroke", toast)
toastStroke.Color = C.accent
toastStroke.Thickness = 1.5
toastStroke.Transparency = 0.2

-- Luffy Icon in Toast
local toastImg = Instance.new("ImageLabel", toast)
toastImg.Size = UDim2.new(0, 44, 0, 50)
toastImg.Position = UDim2.new(0, 6, 0.5, -25)
toastImg.BackgroundTransparency = 1
toastImg.Image = IMAGES.luffy
toastImg.ScaleType = Enum.ScaleType.Fit
toastImg.ZIndex = 201

local toastTitle = Instance.new("TextLabel", toast)
toastTitle.Size = UDim2.new(1, -60, 0, 22)
toastTitle.Position = UDim2.new(0, 56, 0, 8)
toastTitle.BackgroundTransparency = 1
toastTitle.Text = "GOD VALLEY HUB v4.0"
toastTitle.TextColor3 = C.accent
toastTitle.Font = Enum.Font.GothamBold
toastTitle.TextSize = 13
toastTitle.TextXAlignment = Enum.TextXAlignment.Left
toastTitle.ZIndex = 201

local toastSub = Instance.new("TextLabel", toast)
toastSub.Size = UDim2.new(1, -60, 0, 16)
toastSub.Position = UDim2.new(0, 56, 0, 32)
toastSub.BackgroundTransparency = 1
toastSub.Text = "Loaded & Ready — One Piece Style"
toastSub.TextColor3 = C.green
toastSub.Font = Enum.Font.Gotham
toastSub.TextSize = 10
toastSub.TextXAlignment = Enum.TextXAlignment.Left
toastSub.ZIndex = 201

task.wait(0.7)
TweenService:Create(toast, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -140, 1, -70)
}):Play()
playSound(4590662766, 0.6, 1.1)

task.delay(4, function()
    TweenService:Create(toast, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -140, 1, 10)
    }):Play()
    task.wait(0.5)
    pcall(function() toast:Destroy() end)
end)

-- Final Canvas Update
task.wait(0.5)
updateCanvas()
