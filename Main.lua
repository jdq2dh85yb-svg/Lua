-- ══════════════════════════════════════════════════════════════
-- GOD VALLEY HUB v8.0 — The Strongest Battleground
-- One Piece Edition | Key System | Full Features
-- ══════════════════════════════════════════════════════════════

-- SERVICES
local Players       = game:GetService("Players")
local Lighting      = game:GetService("Lighting")
local Stats         = game:GetService("Stats")
local UIS           = game:GetService("UserInputService")
local RunService    = game:GetService("RunService")
local TweenService  = game:GetService("TweenService")
local SoundService  = game:GetService("SoundService")
local HttpService   = game:GetService("HttpService")
local StarterGui    = game:GetService("StarterGui")
local Workspace     = game:GetService("Workspace")
local PhysicsService= game:GetService("PhysicsService")
local Camera        = Workspace.CurrentCamera

local LocalPlayer   = Players.LocalPlayer
local Mouse         = LocalPlayer:GetMouse()

-- ══════════════════════════════════════════════════════════════
-- GLOBALE STATES
-- ══════════════════════════════════════════════════════════════
_G.UISound        = true
_G.KillOn         = false
_G.KillId         = 4612365796
_G.KillVol        = 0.7
_G.SpeedOn        = false
_G.SpeedVal       = 16
_G.AntiStun       = false
_G.AutoParry      = false
_G.AutoBlock      = false
_G.NoKnockback    = false
_G.InfiniteStamina= false
_G.ESP            = false
_G.ChestESP       = false
_G.BallTrail      = false
_G.CustomFOV      = false
_G.OrigFOV        = Camera.FieldOfView
_G.ShowFPS        = false
_G.ShowPing       = false
_G.ShowHP         = false
_G.Theme          = "gold"

-- ══════════════════════════════════════════════════════════════
-- CUSTOM ZEICHEN
-- ══════════════════════════════════════════════════════════════
local S = {
    anchor  = "⊕",  skull   = "◈",  sword   = "⟁",  wave    = "≋",
    star    = "✦",  diamond = "◆",  eye     = "◉",  cross   = "✕",
    arrow   = "➤",  crown   = "♛",  shield  = "⬡",  fire    = "▲",
    check   = "✔",  music   = "♪",  gem     = "⬟",  spin    = "⟳",
    target  = "⊛",  ban     = "⊘",  power   = "⌁",  lock    = "⊞",
    unlock  = "⊟",  bolt    = "⚡",  chart   = "▣",  world   = "⊜",
    heart   = "♥",  info    = "◌",  dot     = "◆",  tri     = "▸",
    bar     = "▬",  circle  = "●",  square  = "■",  plus    = "✚",
}

-- ══════════════════════════════════════════════════════════════
-- WEBSITE & KEYS
-- ══════════════════════════════════════════════════════════════
local KEY_WEBSITE  = "https://godvalleykey.tiiny.site/"
local SAVE_FILE    = "GodValleyKey.json"

local ADMIN_KEYS = {
    ["GODVALLEY-ADMIN-2024"] = true,
    ["GODVALLEY-ADMIN-DEV"]  = true,
}

-- ══════════════════════════════════════════════════════════════
-- KEY SAVE / LOAD SYSTEM
-- ══════════════════════════════════════════════════════════════
local function saveKey(key)
    pcall(function()
        local data = HttpService:JSONEncode({ key=key, savedAt=os.time() })
        writefile(SAVE_FILE, data)
    end)
end

local function loadSavedKey()
    local ok, res = pcall(function()
        if not isfile(SAVE_FILE) then return nil end
        local raw  = readfile(SAVE_FILE)
        local data = HttpService:JSONDecode(raw)
        if not data or not data.key or not data.savedAt then return nil end
        if os.time() - data.savedAt > 86400 then
            deletefile(SAVE_FILE) return nil
        end
        return data.key
    end)
    return ok and res or nil
end

local function clearSavedKey()
    pcall(function() if isfile(SAVE_FILE) then deletefile(SAVE_FILE) end end)
end

local function checkKey(raw)
    if not raw or type(raw)~="string" then return false end
    local k = raw:upper():gsub("%s+",""):gsub("-+","-")
    if ADMIN_KEYS[k] then return "admin" end
    if k:sub(1,5)=="FREE_" then
        local body = k:sub(6)
        if #body==40 and body:match("^[A-F0-9]+$") then return "user" end
    end
    return false
end

-- ══════════════════════════════════════════════════════════════
-- THEMES
-- ══════════════════════════════════════════════════════════════
local THEMES = {
    gold = {
        acc  = Color3.fromRGB(255,185,50),
        acc2 = Color3.fromRGB(255,75,45),
    },
    blue = {
        acc  = Color3.fromRGB(80,160,255),
        acc2 = Color3.fromRGB(50,100,220),
    },
    green = {
        acc  = Color3.fromRGB(80,220,130),
        acc2 = Color3.fromRGB(40,180,90),
    },
    purple = {
        acc  = Color3.fromRGB(180,80,255),
        acc2 = Color3.fromRGB(120,50,200),
    },
    red = {
        acc  = Color3.fromRGB(255,80,80),
        acc2 = Color3.fromRGB(200,40,40),
    },
    cyan = {
        acc  = Color3.fromRGB(80,220,220),
        acc2 = Color3.fromRGB(40,180,200),
    },
}

-- ══════════════════════════════════════════════════════════════
-- FARBEN (dynamisch — ändert sich mit Theme)
-- ══════════════════════════════════════════════════════════════
local C = {
    bg      = Color3.fromRGB(7,7,14),
    panel   = Color3.fromRGB(13,13,24),
    card    = Color3.fromRGB(19,19,34),
    cardH   = Color3.fromRGB(27,27,48),
    acc     = Color3.fromRGB(255,185,50),
    acc2    = Color3.fromRGB(255,75,45),
    green   = Color3.fromRGB(75,215,125),
    red     = Color3.fromRGB(255,75,75),
    orange  = Color3.fromRGB(255,160,50),
    yellow  = Color3.fromRGB(255,215,60),
    off     = Color3.fromRGB(42,42,62),
    text    = Color3.fromRGB(238,232,218),
    sub     = Color3.fromRGB(135,125,105),
    white   = Color3.new(1,1,1),
    black   = Color3.fromRGB(5,5,10),
}

local function applyTheme(name)
    local t = THEMES[name]
    if not t then return end
    _G.Theme = name
    C.acc  = t.acc
    C.acc2 = t.acc2
end

-- ══════════════════════════════════════════════════════════════
-- RESPONSIVE
-- ══════════════════════════════════════════════════════════════
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local isTablet = UIS.TouchEnabled and UIS.KeyboardEnabled
local GW  = isMobile and 300 or isTablet and 360 or 420
local GH  = isMobile and 480 or isTablet and 530 or 570
local FL  = isMobile and 11 or 13
local FS  = isMobile and 9  or 10
local CH  = isMobile and 40 or 46
local CHD = isMobile and 50 or 56

-- ══════════════════════════════════════════════════════════════
-- IMG ASSETS
-- ══════════════════════════════════════════════════════════════
local IMG = {
    luffy = "rbxassetid://7072085162",
    zoro  = "rbxassetid://7072086105",
    jolly = "rbxassetid://6031075938",
}

-- ══════════════════════════════════════════════════════════════
-- SOUND HELPERS
-- ══════════════════════════════════════════════════════════════
local function uiSnd(p)
    if not _G.UISound then return end
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://6042053626"
    s.Volume = 0.28
    s.PlaybackSpeed = p or 1
    s.Parent = SoundService
    s:Play()
    game:GetService("Debris"):AddItem(s,3)
end

local function playSnd(id, vol, p)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://"..tostring(id)
    s.Volume  = vol or 1
    s.PlaybackSpeed = p or 1
    s.Parent  = SoundService
    s:Play()
    game:GetService("Debris"):AddItem(s,6)
end

-- ══════════════════════════════════════════════════════════════
-- KILL SOUND SYSTEM
-- ══════════════════════════════════════════════════════════════
local killConnections = {}

local function setupKillDetection()
    for _, c in ipairs(killConnections) do pcall(function() c:Disconnect() end) end
    killConnections = {}

    local function hookPlayer(plr)
        if plr == LocalPlayer then return end
        local conn = plr.CharacterAdded:Connect(function(char)
            local h = char:WaitForChild("Humanoid",5)
            if h then
                h.Died:Connect(function()
                    if _G.KillOn then playSnd(_G.KillId, _G.KillVol, 1) end
                end)
            end
        end)
        table.insert(killConnections, conn)
        if plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h then
                h.Died:Connect(function()
                    if _G.KillOn then playSnd(_G.KillId, _G.KillVol, 1) end
                end)
            end
        end
    end

    local paConn = Players.PlayerAdded:Connect(hookPlayer)
    table.insert(killConnections, paConn)
    for _, plr in ipairs(Players:GetPlayers()) do hookPlayer(plr) end
end

setupKillDetection()

-- ══════════════════════════════════════════════════════════════
-- SPEED SYSTEM
-- ══════════════════════════════════════════════════════════════
local speedConn  = nil
local stateConn  = nil

local function getSpeedTarget()
    return _G.SpeedOn and math.max(28, _G.SpeedVal) or _G.SpeedVal
end

local function applySpeedNow()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    hum.WalkSpeed = getSpeedTarget()
end

local function setupSpeedLoop(active)
    if speedConn then speedConn:Disconnect() speedConn=nil end
    if stateConn then stateConn:Disconnect() stateConn=nil end
    if not active then return end

    speedConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local t = getSpeedTarget()
        if math.abs(hum.WalkSpeed - t) > 0.5 then
            hum.WalkSpeed = t
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.4)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local t = getSpeedTarget()
        if t ~= 16 then hum.WalkSpeed = t end

        stateConn = hum.StateChanged:Connect(function()
            task.wait(0.05)
            if hum and hum.Parent then
                local target = getSpeedTarget()
                if target ~= 16 then hum.WalkSpeed = target end
            end
        end)
    end
    if _G.SpeedOn or _G.SpeedVal ~= 16 then setupSpeedLoop(true) end
end)

-- ══════════════════════════════════════════════════════════════
-- JUMP POWER SYSTEM
-- ══════════════════════════════════════════════════════════════
local jumpConn = nil

local function setupJumpLoop(active, val)
    if jumpConn then jumpConn:Disconnect() jumpConn=nil end
    if not active then return end
    jumpConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 and math.abs(hum.JumpPower - val) > 0.5 then
            hum.JumpPower = val
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- ANTI STUN
-- ══════════════════════════════════════════════════════════════
local function startAntiStun(on)
    _G.AntiStun = on
    if not on then return end
    task.spawn(function()
        while _G.AntiStun do
            task.wait(0.08)
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    if hum.JumpPower < 35 then hum.JumpPower = 50 end
                end
            end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- INFINITE STAMINA
-- ══════════════════════════════════════════════════════════════
local staminaConn = nil

local function setupInfiniteStamina(on)
    if staminaConn then staminaConn:Disconnect() staminaConn=nil end
    if not on then return end
    staminaConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        -- TSB verwendet oft einen "Stamina" oder "Energy" Value
        local stamina = char:FindFirstChild("Stamina")
            or char:FindFirstChild("Energy")
            or char:FindFirstChild("Mana")
        if stamina and stamina:IsA("NumberValue") then
            if stamina.Value < stamina.MaxValue or stamina.Value < 100 then
                stamina.Value = stamina.MaxValue or 100
            end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- NO KNOCKBACK
-- ══════════════════════════════════════════════════════════════
local kbConn = nil

local function setupNoKnockback(on)
    if kbConn then kbConn:Disconnect() kbConn=nil end
    if not on then return end
    kbConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and root:IsA("BasePart") then
            -- Dämpft Velocity wenn zu hoch (Knockback)
            local vel = root.AssemblyLinearVelocity
            if vel.Magnitude > 60 then
                root.AssemblyLinearVelocity = vel.Unit * 60
            end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- ESP SYSTEM (Enemy wallhack outlines)
-- ══════════════════════════════════════════════════════════════
local espObjects = {}

local function clearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

local function createESP(char, plr)
    if not char or not char.Parent then return end
    local existing = espObjects[char]
    if existing then pcall(function() existing:Destroy() end) end

    local hl = Instance.new("Highlight")
    hl.Adornee     = char
    hl.FillColor   = C.acc
    hl.OutlineColor= C.acc2
    hl.FillTransparency    = 0.75
    hl.OutlineTransparency = 0
    hl.DepthMode   = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent      = char

    espObjects[char] = hl

    -- Billboard mit Name + HP
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if root and hum then
        local bb = Instance.new("BillboardGui")
        bb.Name          = "_ESP_BB"
        bb.Size          = UDim2.new(0,140,0,36)
        bb.StudsOffset   = Vector3.new(0,3.5,0)
        bb.AlwaysOnTop   = true
        bb.Parent        = root

        local nameLbl = Instance.new("TextLabel", bb)
        nameLbl.Size             = UDim2.new(1,0,0.55,0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text             = plr and plr.Name or char.Name
        nameLbl.TextColor3       = C.acc
        nameLbl.Font             = Enum.Font.GothamBold
        nameLbl.TextScaled       = true

        local hpLbl = Instance.new("TextLabel", bb)
        hpLbl.Size               = UDim2.new(1,0,0.45,0)
        hpLbl.Position           = UDim2.new(0,0,0.55,0)
        hpLbl.BackgroundTransparency = 1
        hpLbl.TextColor3         = C.green
        hpLbl.Font               = Enum.Font.Gotham
        hpLbl.TextScaled         = true

        -- HP live updaten
        local hpConn
        hpConn = RunService.Heartbeat:Connect(function()
            if not hum or not hum.Parent then
                hpConn:Disconnect() return
            end
            local pct = math.floor((hum.Health / math.max(hum.MaxHealth,1)) * 100)
            hpLbl.Text = S.heart.." "..pct.."%"
            hpLbl.TextColor3 = pct > 50 and C.green or pct > 25 and C.orange or C.red
        end)

        espObjects["_BB_"..tostring(char)] = bb
    end
end

local function refreshESP()
    clearESP()
    if not _G.ESP then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            createESP(plr.Character, plr)
        end
    end
end

local espAddConn = nil

local function setupESP(on)
    _G.ESP = on
    if espAddConn then espAddConn:Disconnect() espAddConn=nil end

    if on then
        refreshESP()
        espAddConn = Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                if _G.ESP then createESP(char, plr) end
            end)
        end)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                plr.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if _G.ESP then createESP(char, plr) end
                end)
            end
        end
    else
        clearESP()
    end
end

-- ══════════════════════════════════════════════════════════════
-- HIT PARTICLES (Visueller Effekt bei Treffern)
-- ══════════════════════════════════════════════════════════════
local function spawnHitParticle(position, color)
    local part = Instance.new("Part")
    part.Size     = Vector3.new(0.3,0.3,0.3)
    part.Position = position
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color    = color or C.acc
    part.Shape    = Enum.PartType.Ball
    part.Parent   = Workspace

    TweenService:Create(part, TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {
        Size = Vector3.new(2,2,2),
        Transparency = 1,
    }):Play()

    game:GetService("Debris"):AddItem(part, 0.5)
end

-- ══════════════════════════════════════════════════════════════
-- CROSSHAIR SYSTEM
-- ══════════════════════════════════════════════════════════════
local crosshairEnabled = false
local crosshairGui     = nil

local function buildCrosshair(style, size, color)
    if crosshairGui then crosshairGui:Destroy() crosshairGui=nil end
    if not crosshairEnabled then return end

    local sg = Instance.new("ScreenGui")
    sg.Name = "_GV_Crosshair"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local vp = Camera.ViewportSize
    local cx, cy = vp.X/2, vp.Y/2
    local col = color or C.white
    local sz  = size  or 8

    if style == "cross" then
        -- Horizontale Linie
        local h = Instance.new("Frame",sg)
        h.Size = UDim2.new(0,sz*2,0,2)
        h.Position = UDim2.new(0,cx-sz,0,cy-1)
        h.BackgroundColor3 = col h.BorderSizePixel=0 h.ZIndex=100
        -- Vertikale Linie
        local v = Instance.new("Frame",sg)
        v.Size = UDim2.new(0,2,0,sz*2)
        v.Position = UDim2.new(0,cx-1,0,cy-sz)
        v.BackgroundColor3 = col v.BorderSizePixel=0 v.ZIndex=100
    elseif style == "dot" then
        local d = Instance.new("Frame",sg)
        d.Size = UDim2.new(0,6,0,6)
        d.Position = UDim2.new(0,cx-3,0,cy-3)
        d.BackgroundColor3 = col d.BorderSizePixel=0 d.ZIndex=100
        Instance.new("UICorner",d).CornerRadius=UDim.new(1,0)
    elseif style == "circle" then
        local ring = Instance.new("Frame",sg)
        ring.Size = UDim2.new(0,sz*2,0,sz*2)
        ring.Position = UDim2.new(0,cx-sz,0,cy-sz)
        ring.BackgroundTransparency = 1
        ring.BorderSizePixel = 0
        ring.ZIndex = 100
        local stroke = Instance.new("UIStroke",ring)
        stroke.Color = col stroke.Thickness = 1.5
        Instance.new("UICorner",ring).CornerRadius=UDim.new(1,0)
    elseif style == "gap" then
        -- 4 Linien mit Gap
        local gap = sz/2
        local thickness = 2
        local positions = {
            {UDim2.new(0,cx+gap,0,cy-1),     UDim2.new(0,sz,0,thickness)},
            {UDim2.new(0,cx-gap-sz,0,cy-1),  UDim2.new(0,sz,0,thickness)},
            {UDim2.new(0,cx-1,0,cy+gap),     UDim2.new(0,thickness,0,sz)},
            {UDim2.new(0,cx-1,0,cy-gap-sz),  UDim2.new(0,thickness,0,sz)},
        }
        for _, pd in ipairs(positions) do
            local f = Instance.new("Frame",sg)
            f.Position = pd[1] f.Size = pd[2]
            f.BackgroundColor3 = col f.BorderSizePixel=0 f.ZIndex=100
        end
    end

    crosshairGui = sg
end

-- ══════════════════════════════════════════════════════════════
-- FOV CHANGER
-- ══════════════════════════════════════════════════════════════
local function setFOV(val)
    Camera.FieldOfView = val
end

local function resetFOV()
    Camera.FieldOfView = _G.OrigFOV
end

-- ══════════════════════════════════════════════════════════════
-- BALL TRAIL
-- ══════════════════════════════════════════════════════════════
local trailConn = nil
local activeTrail = nil

local function setupBallTrail(on)
    if trailConn then trailConn:Disconnect() trailConn=nil end
    if activeTrail then activeTrail:Destroy() activeTrail=nil end
    if not on then return end

    trailConn = RunService.Heartbeat:Connect(function()
        -- TSB Ball suchen
        local ball = Workspace:FindFirstChild("Ball",true)
            or Workspace:FindFirstChildWhichIsA("Part",true)
        if ball and ball:IsA("BasePart") and not ball:FindFirstChild("_GV_Trail") then
            local a0 = Instance.new("Attachment",ball)
            a0.Position = Vector3.new(0, 0.5, 0) a0.Name="_GV_A0"
            local a1 = Instance.new("Attachment",ball)
            a1.Position = Vector3.new(0,-0.5,0) a1.Name="_GV_A1"

            local trail = Instance.new("Trail",ball)
            trail.Name = "_GV_Trail"
            trail.Attachment0 = a0
            trail.Attachment1 = a1
            trail.Lifetime    = 0.4
            trail.MinLength   = 0
            trail.FaceCamera  = true
            trail.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, C.acc),
                ColorSequenceKeypoint.new(0.5, C.acc2),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
            })
            trail.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            })
            activeTrail = trail
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- HUD SYSTEM (HP, FPS, Ping Anzeige)
-- ══════════════════════════════════════════════════════════════
local hudGui    = nil
local fpsLabel  = nil
local pingLabel = nil
local hpLabel   = nil
local hpBar     = nil
local hudConn   = nil

local function buildHUD()
    if hudGui then hudGui:Destroy() hudGui=nil end

    hudGui = Instance.new("ScreenGui")
    hudGui.Name = "_GV_HUD"
    hudGui.ResetOnSpawn = false
    hudGui.IgnoreGuiInset = true
    hudGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    hudGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local function makeHUDFrame(x, y, w, h)
        local f = Instance.new("Frame", hudGui)
        f.Size = UDim2.new(0,w,0,h)
        f.Position = UDim2.new(0,x,0,y)
        f.BackgroundColor3 = C.panel
        f.BackgroundTransparency = 0.25
        f.BorderSizePixel = 0
        f.ZIndex = 90
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,7)
        local st = Instance.new("UIStroke",f) st.Color=C.acc st.Thickness=1 st.Transparency=0.6
        return f
    end

    local function makeHUDLabel(parent, text, color)
        local l = Instance.new("TextLabel", parent)
        l.Size = UDim2.new(1,0,1,0)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = color or C.text
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.ZIndex = 91
        return l
    end

    -- FPS Frame
    if _G.ShowFPS then
        local fpsF = makeHUDFrame(8, 8, 80, 22)
        fpsLabel = makeHUDLabel(fpsF, S.bolt.." 0 FPS", C.green)
    end

    -- Ping Frame
    if _G.ShowPing then
        local pingF = makeHUDFrame(96, 8, 80, 22)
        pingLabel = makeHUDLabel(pingF, S.dot.." 0ms", C.acc)
    end

    -- HP Bar
    if _G.ShowHP then
        local hpF = makeHUDFrame(8, 36, 170, 36)
        local hpTitle = Instance.new("TextLabel", hpF)
        hpTitle.Size = UDim2.new(1,0,0.45,0)
        hpTitle.BackgroundTransparency = 1
        hpTitle.Text = S.heart.." HP"
        hpTitle.TextColor3 = C.text
        hpTitle.Font = Enum.Font.GothamBold
        hpTitle.TextSize = 10
        hpTitle.ZIndex = 91

        local hpTrack = Instance.new("Frame", hpF)
        hpTrack.Size = UDim2.new(1,-12,0,7)
        hpTrack.Position = UDim2.new(0,6,1,-12)
        hpTrack.BackgroundColor3 = C.off
        hpTrack.BorderSizePixel = 0
        hpTrack.ZIndex = 91
        Instance.new("UICorner",hpTrack).CornerRadius=UDim.new(1,0)

        hpBar = Instance.new("Frame", hpTrack)
        hpBar.Size = UDim2.new(1,0,1,0)
        hpBar.BackgroundColor3 = C.green
        hpBar.BorderSizePixel = 0
        hpBar.ZIndex = 92
        Instance.new("UICorner",hpBar).CornerRadius=UDim.new(1,0)
    end

    -- HUD Update Loop
    if hudConn then hudConn:Disconnect() hudConn=nil end
    local lastFPS = tick()
    local frames  = 0

    hudConn = RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()

        if now - lastFPS >= 1 then
            if fpsLabel then
                local fps = frames
                fpsLabel.Text = S.bolt.." "..fps.." FPS"
                fpsLabel.TextColor3 = fps >= 55 and C.green or fps >= 30 and C.orange or C.red
            end
            if pingLabel then
                local ping = LocalPlayer:GetNetworkPing() * 1000
                pingLabel.Text = S.dot.." "..math.floor(ping).."ms"
                pingLabel.TextColor3 = ping < 80 and C.green or ping < 150 and C.orange or C.red
            end
            frames   = 0
            lastFPS  = now
        end

        if hpBar then
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                local pct = math.clamp(hum.Health / math.max(hum.MaxHealth,1), 0, 1)
                TweenService:Create(hpBar, TweenInfo.new(0.15), {
                    Size = UDim2.new(pct, 0, 1, 0),
                    BackgroundColor3 = pct > 0.5 and C.green or pct > 0.25 and C.orange or C.red,
                }):Play()
            end
        end
    end)
end

local function destroyHUD()
    if hudConn then hudConn:Disconnect() hudConn=nil end
    if hudGui  then hudGui:Destroy()  hudGui=nil  end
    fpsLabel = nil pingLabel = nil hpLabel = nil hpBar = nil
end

-- ══════════════════════════════════════════════════════════════
-- AUTO PARRY SYSTEM
-- ══════════════════════════════════════════════════════════════
local parryConn = nil

local function setupAutoParry(on)
    _G.AutoParry = on
    if parryConn then parryConn:Disconnect() parryConn=nil end
    if not on then return end

    -- TSB Parry: meist 'Q' Taste
    parryConn = RunService.Heartbeat:Connect(function()
        if not _G.AutoParry then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        -- Schaue ob ein Angriff in der Nähe ist
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local eRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    local dist = (root.Position - eRoot.Position).Magnitude
                    if dist < 12 then
                        -- Parry Input simulieren
                        pcall(function()
                            local vInput = game:GetService("VirtualInputManager")
                            -- Nur als Hinweis — echter AutoParry ist spiel-spezifisch
                        end)
                    end
                end
            end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- GRAFIK PRESETS
-- ══════════════════════════════════════════════════════════════
local function clearFX()
    for _,c in ipairs(Lighting:GetChildren()) do
        if c:IsA("PostEffect") or c:IsA("Atmosphere") then c:Destroy() end
    end
end

local GFX = {
    POTATO = function()
        clearFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
                v.CastShadow  = false
            end
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = false
            end
        end
    end,
    LOW = function()
        clearFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level03
        Lighting.GlobalShadows = false
    end,
    MEDIUM = function()
        clearFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level07
        Lighting.GlobalShadows = true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=0.3 b.Size=20 b.Threshold=0.98
    end,
    HIGH = function()
        clearFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level14
        Lighting.GlobalShadows = true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=0.6 b.Size=36 b.Threshold=0.93
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.2 cc.Contrast=0.1
        local sr=Instance.new("SunRaysEffect",Lighting) sr.Intensity=0.08 sr.Spread=0.4
    end,
    ULTRA = function()
        clearFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
        Lighting.GlobalShadows = true
        Lighting.Brightness    = 2.5
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=1.2 b.Size=56 b.Threshold=0.85
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.4 cc.Contrast=0.2 cc.Brightness=0.05
        local sr=Instance.new("SunRaysEffect",Lighting) sr.Intensity=0.15 sr.Spread=0.6
        local a=Instance.new("Atmosphere",Lighting) a.Density=0.35 a.Haze=0.4 a.Glare=0.6 a.Color=Color3.fromRGB(199,210,255)
        local d=Instance.new("DepthOfFieldEffect",Lighting) d.FarIntensity=0.05 d.NearIntensity=0 d.FocusDistance=50 d.InFocusRadius=30
    end,
    CINEMATIC = function()
        clearFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
        Lighting.GlobalShadows = true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=2 b.Size=80 b.Threshold=0.75
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.6 cc.Contrast=0.3 cc.TintColor=Color3.fromRGB(210,220,255)
        local sr=Instance.new("SunRaysEffect",Lighting) sr.Intensity=0.25 sr.Spread=0.8
        local a=Instance.new("Atmosphere",Lighting) a.Density=0.5 a.Haze=0.8 a.Glare=1 a.Color=Color3.fromRGB(180,200,255)
    end,
    ANIME = function()
        clearFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level14
        Lighting.GlobalShadows = true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=3 b.Size=100 b.Threshold=0.6
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.8 cc.Contrast=0.25 cc.TintColor=Color3.fromRGB(255,210,230)
    end,
    NIGHTMARE = function()
        clearFX()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level14
        Lighting.GlobalShadows = true
        Lighting.Brightness    = 0.3
        Lighting.FogEnd        = 120
        Lighting.FogStart      = 30
        Lighting.FogColor      = Color3.fromRGB(10,0,20)
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=2 b.Size=60 b.Threshold=0.7
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.2 cc.Contrast=0.4 cc.TintColor=Color3.fromRGB(200,150,255)
    end,
}

-- ══════════════════════════════════════════════════════════════
-- EMOTES
-- ══════════════════════════════════════════════════════════════
local EMOTES = {
    {sym="♛", name="Verbeugung", cmd="wave",   id="rbxassetid://507770239"},
    {sym="◆", name="Jubeln",     cmd="cheer",  id="rbxassetid://507770677"},
    {sym="≋", name="Tanzen 1",   cmd="dance",  id="rbxassetid://507771019"},
    {sym="⊕", name="Tanzen 2",   cmd="dance2", id="rbxassetid://507776043"},
    {sym="✦", name="Tanzen 3",   cmd="dance3", id="rbxassetid://507777268"},
    {sym="⟳", name="Lachen",     cmd="laugh",  id="rbxassetid://507770818"},
    {sym="➤", name="Zeigen",     cmd="point",  id="rbxassetid://507770453"},
    {sym="⬡", name="Salutieren", cmd="salute", id="rbxassetid://3360686446"},
    {sym="⊛", name="Kippen",     cmd="tilt",   id="rbxassetid://3360692915"},
    {sym="◈", name="Atento",     cmd="atento", id="rbxassetid://3360686798"},
}

local curEmoteTrack = nil

local function playEmote(id, cmd)
    local char     = LocalPlayer.Character
    if not char then return end
    local hum      = char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    if curEmoteTrack then
        pcall(function() curEmoteTrack:Stop(0.2) end)
        curEmoteTrack = nil
    end

    task.spawn(function()
        local ok = pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = id
            local track = animator:LoadAnimation(anim)
            track.Priority = Enum.AnimationPriority.Action4
            track:Play()
            curEmoteTrack = track
            uiSnd(1.3)
            track.Stopped:Connect(function()
                if curEmoteTrack == track then curEmoteTrack=nil end
                anim:Destroy()
            end)
        end)
        if not ok then
            pcall(function()
                local VU = game:GetService("VirtualUser")
                VU:TypeMessage("/"..cmd)
            end)
        end
    end)
end

local function stopEmote()
    if curEmoteTrack then
        pcall(function() curEmoteTrack:Stop(0.3) end)
        curEmoteTrack = nil
    end
end

-- ══════════════════════════════════════════════════════════════
-- SCREEN GUI
-- ══════════════════════════════════════════════════════════════
local GUI = Instance.new("ScreenGui")
GUI.Name           = "GodValleyV8"
GUI.ResetOnSpawn   = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.IgnoreGuiInset = true
GUI.Parent         = LocalPlayer:WaitForChild("PlayerGui")

local function spawnPart(parent)
    local p   = Instance.new("Frame", parent)
    local sz  = math.random(2,5)
    p.Size    = UDim2.new(0,sz,0,sz)
    p.Position= UDim2.new(math.random(0,100)/100,0,1.05,0)
    p.BackgroundColor3 = math.random(1,2)==1 and C.acc or C.acc2
    p.BackgroundTransparency = 0.3
    p.BorderSizePixel = 0
    p.ZIndex = 2
    Instance.new("UICorner",p).CornerRadius = UDim.new(1,0)
    TweenService:Create(p, TweenInfo.new(math.random(5,10),Enum.EasingStyle.Linear),{
        Position=UDim2.new(math.random(0,100)/100,0,-0.1,0),
        BackgroundTransparency=1,
    }):Play()
    game:GetService("Debris"):AddItem(p,11)
end

-- ══════════════════════════════════════════════════════════════
-- OPEN BUTTON
-- ══════════════════════════════════════════════════════════════
local OB = Instance.new("Frame", GUI)
OB.Size             = UDim2.new(0,54,0,54)
OB.Position         = UDim2.new(0,10,0.5,-27)
OB.BackgroundColor3 = C.bg
OB.BorderSizePixel  = 0
OB.ZIndex           = 10
OB.Visible          = false
Instance.new("UICorner",OB).CornerRadius = UDim.new(1,0)

local OBS = Instance.new("UIStroke",OB) OBS.Thickness=2.5 OBS.Color=C.acc

local OBImg = Instance.new("ImageLabel",OB)
OBImg.Size               = UDim2.new(1,-6,1,-6)
OBImg.Position           = UDim2.new(0,3,0,3)
OBImg.BackgroundTransparency = 1
OBImg.Image              = IMG.luffy
OBImg.ScaleType          = Enum.ScaleType.Fit
OBImg.ZIndex             = 11
Instance.new("UICorner",OBImg).CornerRadius = UDim.new(1,0)

local OBC = Instance.new("TextButton",OB)
OBC.Size             = UDim2.new(1,0,1,0)
OBC.BackgroundTransparency = 1
OBC.Text             = ""
OBC.ZIndex           = 12

-- Ring-Animation
task.spawn(function()
    local t=0 while true do t=t+0.03
        OBS.Color=C.acc:Lerp(C.acc2,(math.sin(t)+1)/2)
        task.wait(0.04)
    end
end)

-- Drag
local obDrag,obStart,obPos,obMoved
OBC.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        obDrag=true obStart=i.Position obPos=OB.Position obMoved=false
    end
end)
UIS.InputChanged:Connect(function(i)
    if obDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-obStart
        if math.abs(d.X)>4 or math.abs(d.Y)>4 then obMoved=true end
        OB.Position=UDim2.new(obPos.X.Scale,obPos.X.Offset+d.X,obPos.Y.Scale,obPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        obDrag=false
    end
end)

-- ══════════════════════════════════════════════════════════════
-- MAIN FRAME
-- ══════════════════════════════════════════════════════════════
local MF = Instance.new("Frame",GUI)
MF.Size             = UDim2.new(0,GW,0,GH)
MF.Position         = UDim2.new(0.5,-GW/2,0.5,-GH/2)
MF.BackgroundColor3 = C.bg
MF.BorderSizePixel  = 0
MF.ClipsDescendants = false
MF.Visible          = false
MF.ZIndex           = 20
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,14)

local MFS = Instance.new("UIStroke",MF) MFS.Thickness=1.5 MFS.Color=C.acc MFS.Transparency=0.25
task.spawn(function() local t=0 while true do t=t+0.025 MFS.Color=C.acc:Lerp(C.acc2,(math.sin(t)+1)/2) task.wait(0.04) end end)

local BGGrad = Instance.new("UIGradient",MF)
BGGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(8,7,16)),ColorSequenceKeypoint.new(1,Color3.fromRGB(12,8,20))})
BGGrad.Rotation=135

local isOpen=false

local function openMenu()
    isOpen=true
    MF.Size=UDim2.new(0,0,0,0) MF.Position=UDim2.new(0.5,0,0.5,0) MF.Visible=true
    uiSnd(1.3)
    TweenService:Create(MF,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,GW,0,GH),Position=UDim2.new(0.5,-GW/2,0.5,-GH/2)
    }):Play()
end

local function closeMenu()
    isOpen=false uiSnd(0.85)
    TweenService:Create(MF,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
        Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.wait(0.33) if not isOpen then MF.Visible=false end
end

OBC.MouseButton1Click:Connect(function()
    if not obMoved then if isOpen then closeMenu() else openMenu() end end
end)

-- Keybind RightShift
UIS.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode==Enum.KeyCode.RightShift then
        if isOpen then closeMenu() else openMenu() end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- UI BUILDER
-- ══════════════════════════════════════════════════════════════
local function buildUI(keyType)

    -- ── HEADER ──
    local Hdr = Instance.new("Frame",MF)
    Hdr.Size=UDim2.new(1,0,0,62) Hdr.BackgroundColor3=C.panel Hdr.BorderSizePixel=0 Hdr.ZIndex=21
    Instance.new("UICorner",Hdr).CornerRadius=UDim.new(0,14)

    do
        local hg=Instance.new("UIGradient",Hdr)
        hg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(22,8,6)),ColorSequenceKeypoint.new(1,Color3.fromRGB(8,8,20))}) hg.Rotation=90

        -- Jolly Roger Icon
        local j=Instance.new("ImageLabel",Hdr)
        j.Size=UDim2.new(0,46,0,46) j.Position=UDim2.new(0,9,0.5,-23)
        j.BackgroundTransparency=1 j.Image=IMG.jolly j.ImageColor3=C.acc j.ZIndex=22

        -- Titel mit Gradient
        local ht=Instance.new("TextLabel",Hdr)
        ht.Size=UDim2.new(0,195,0,22) ht.Position=UDim2.new(0,60,0,10)
        ht.BackgroundTransparency=1 ht.Text=S.anchor.." GOD VALLEY HUB"
        ht.Font=Enum.Font.GothamBold ht.TextSize=isMobile and 13 or 15
        ht.TextXAlignment=Enum.TextXAlignment.Left ht.ZIndex=22
        Instance.new("UIGradient",ht).Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,C.acc),ColorSequenceKeypoint.new(1,C.acc2)
        })

        -- Sub-Zeile
        if keyType=="admin" then
            local b=Instance.new("Frame",Hdr) b.Size=UDim2.new(0,64,0,16) b.Position=UDim2.new(0,60,0,36) b.BackgroundColor3=Color3.fromRGB(40,20,5) b.BorderSizePixel=0 b.ZIndex=22
            Instance.new("UICorner",b).CornerRadius=UDim.new(1,0) Instance.new("UIStroke",b).Color=C.acc
            local bl=Instance.new("TextLabel",b) bl.Size=UDim2.new(1,0,1,0) bl.BackgroundTransparency=1 bl.Text=S.crown.." ADMIN" bl.TextColor3=C.acc bl.Font=Enum.Font.GothamBold bl.TextSize=9 bl.ZIndex=23
        else
            local hs=Instance.new("TextLabel",Hdr) hs.Size=UDim2.new(0,210,0,13) hs.Position=UDim2.new(0,60,0,37) hs.BackgroundTransparency=1 hs.Text="TSB "..S.wave.." v8.0 "..S.wave.." One Piece" hs.TextColor3=C.sub hs.Font=Enum.Font.Gotham hs.TextSize=FS hs.TextXAlignment=Enum.TextXAlignment.Left hs.ZIndex=22
        end

        -- Online-Dot
        local dot=Instance.new("Frame",Hdr) dot.Size=UDim2.new(0,7,0,7) dot.Position=UDim2.new(1,-92,0,10) dot.BackgroundColor3=C.green dot.BorderSizePixel=0 dot.ZIndex=23
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        task.spawn(function() while true do TweenService:Create(dot,TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0.6}):Play() task.wait(0.8) TweenService:Create(dot,TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0}):Play() task.wait(0.8) end end)

        -- Logout Button
        local logB=Instance.new("TextButton",Hdr) logB.Size=UDim2.new(0,44,0,16) logB.Position=UDim2.new(1,-125,0.5,-8) logB.BackgroundColor3=Color3.fromRGB(28,10,10) logB.Text=S.ban.." Key" logB.TextColor3=C.sub logB.Font=Enum.Font.Gotham logB.TextSize=9 logB.ZIndex=23
        Instance.new("UICorner",logB).CornerRadius=UDim.new(0,5)
        logB.MouseButton1Click:Connect(function() clearSavedKey() GUI:Destroy() destroyHUD() end)

        -- Minimize (–/+)
        local mb=Instance.new("TextButton",Hdr) mb.Size=UDim2.new(0,24,0,24) mb.Position=UDim2.new(1,-58,0.5,-12) mb.BackgroundColor3=C.acc mb.Text="–" mb.TextColor3=Color3.fromRGB(10,8,4) mb.Font=Enum.Font.GothamBold mb.TextSize=14 mb.ZIndex=23
        Instance.new("UICorner",mb).CornerRadius=UDim.new(1,0)

        -- Close (X)
        local cb=Instance.new("TextButton",Hdr) cb.Size=UDim2.new(0,24,0,24) cb.Position=UDim2.new(1,-28,0.5,-12) cb.BackgroundColor3=C.red cb.Text=S.cross cb.TextColor3=C.white cb.Font=Enum.Font.GothamBold cb.TextSize=11 cb.ZIndex=23
        Instance.new("UICorner",cb).CornerRadius=UDim.new(1,0) cb.MouseButton1Click:Connect(closeMenu)

        local isMin=false
        mb.MouseButton1Click:Connect(function()
            isMin=not isMin uiSnd(isMin and 0.9 or 1.2)
            TweenService:Create(MF,TweenInfo.new(0.28,Enum.EasingStyle.Quad),{Size=isMin and UDim2.new(0,GW,0,62) or UDim2.new(0,GW,0,GH)}):Play()
            mb.Text=isMin and "+" or "–"
        end)

        -- Hover Effects für Buttons
        for _, btn in ipairs({mb,cb,logB}) do
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn,TweenInfo.new(0.12),{Size=UDim2.new(btn.Size.X.Scale,btn.Size.X.Offset+2,btn.Size.Y.Scale,btn.Size.Y.Offset+2)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn,TweenInfo.new(0.12),{Size=UDim2.new(btn.Size.X.Scale,btn.Size.X.Offset-2,btn.Size.Y.Scale,btn.Size.Y.Offset-2)}):Play()
            end)
        end

        -- Drag Header
        local dg,ds,dp
        Hdr.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dg=true ds=i.Position dp=MF.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local d=i.Position-ds MF.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end
        end)
    end

    -- ── TABS ──
    local TH  = isMobile and 36 or 40
    local TO  = 66 + TH + 6

    local TabBar = Instance.new("Frame",MF)
    TabBar.Size=UDim2.new(1,-16,0,TH) TabBar.Position=UDim2.new(0,8,0,66) TabBar.BackgroundColor3=C.panel TabBar.BorderSizePixel=0 TabBar.ZIndex=21
    Instance.new("UICorner",TabBar).CornerRadius=UDim.new(0,10)

    local TabInner = Instance.new("Frame",TabBar)
    TabInner.Size=UDim2.new(1,-8,1,-8) TabInner.Position=UDim2.new(0,4,0,4) TabInner.BackgroundTransparency=1 TabInner.ZIndex=22
    local TLL=Instance.new("UIListLayout",TabInner)
    TLL.FillDirection=Enum.FillDirection.Horizontal TLL.Padding=UDim.new(0,3) TLL.VerticalAlignment=Enum.VerticalAlignment.Center

    local ContentArea = Instance.new("Frame",MF)
    ContentArea.Size=UDim2.new(1,-16,1,-(TO+8)) ContentArea.Position=UDim2.new(0,8,0,TO)
    ContentArea.BackgroundTransparency=1 ContentArea.ClipsDescendants=true ContentArea.BorderSizePixel=0 ContentArea.ZIndex=21

    local TABS = {
        {n="Main",    l=S.bolt.."Main"},
        {n="Combat",  l=S.sword.."Combat"},
        {n="Visual",  l=S.eye.."Visual"},
        {n="Player",  l=S.arrow.."Player"},
        {n="Emote",   l=S.star.."Emote"},
        {n="Gfx",     l=S.gem.."Gfx"},
        {n="Settings",l=S.dot.."Settings"},
    }

    local SFS={} local TBS={} local LOS={} local cur=nil
    local TW = math.floor((GW-24)/#TABS)-3

    for _,t in ipairs(TABS) do
        LOS[t.n]=0
        local sf=Instance.new("ScrollingFrame",ContentArea)
        sf.Name="SF_"..t.n sf.Size=UDim2.new(1,0,1,0) sf.BackgroundTransparency=1 sf.BorderSizePixel=0
        sf.ScrollBarThickness=isMobile and 3 or 4 sf.ScrollBarImageColor3=C.acc sf.ScrollBarImageTransparency=0.3
        sf.CanvasSize=UDim2.new(0,0,0,0) sf.ScrollingEnabled=true sf.ScrollingDirection=Enum.ScrollingDirection.Y
        sf.ElasticBehavior=Enum.ElasticBehavior.WhenScrollable sf.Visible=false sf.ZIndex=22

        local ll=Instance.new("UIListLayout",sf)
        ll.Padding=UDim.new(0,5) ll.SortOrder=Enum.SortOrder.LayoutOrder ll.HorizontalAlignment=Enum.HorizontalAlignment.Center
        local lp=Instance.new("UIPadding",sf) lp.PaddingTop=UDim.new(0,5) lp.PaddingBottom=UDim.new(0,12) lp.PaddingLeft=UDim.new(0,2) lp.PaddingRight=UDim.new(0,6)
        ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            sf.CanvasSize=UDim2.new(0,0,0,ll.AbsoluteContentSize.Y+16)
        end)
        SFS[t.n]=sf

        local btn=Instance.new("Frame",TabInner) btn.Size=UDim2.new(0,TW,1,0) btn.BackgroundTransparency=1 btn.ZIndex=23
        local bb=Instance.new("Frame",btn) bb.Size=UDim2.new(1,0,1,0) bb.BackgroundColor3=C.acc2 bb.BackgroundTransparency=1 bb.BorderSizePixel=0 bb.ZIndex=23
        Instance.new("UICorner",bb).CornerRadius=UDim.new(0,7)
        local bl=Instance.new("TextLabel",btn) bl.Size=UDim2.new(1,0,1,0) bl.BackgroundTransparency=1 bl.Text=t.l bl.TextColor3=C.sub bl.Font=Enum.Font.GothamBold bl.TextSize=FS bl.ZIndex=24
        local bc=Instance.new("TextButton",btn) bc.Size=UDim2.new(1,0,1,0) bc.BackgroundTransparency=1 bc.Text="" bc.ZIndex=25
        TBS[t.n]={bb=bb,bl=bl}

        local cap=t.n
        local function sw(name)
            if cur==name then return end cur=name uiSnd(1.5)
            for _,td in ipairs(TABS) do
                local a=(td.n==name) SFS[td.n].Visible=a
                if a then SFS[td.n].CanvasPosition=Vector2.new(0,0) end
                TweenService:Create(TBS[td.n].bb,TweenInfo.new(0.18),{BackgroundColor3=a and C.acc2 or Color3.fromRGB(0,0,0),BackgroundTransparency=a and 0 or 1}):Play()
                TweenService:Create(TBS[td.n].bl,TweenInfo.new(0.18),{TextColor3=a and C.acc or C.sub}):Play()
            end
        end
        bc.MouseButton1Click:Connect(function() sw(cap) end)
        bc.MouseEnter:Connect(function() if cur~=cap then TweenService:Create(bb,TweenInfo.new(0.14),{BackgroundTransparency=0.8}):Play() end end)
        bc.MouseLeave:Connect(function() if cur~=cap then TweenService:Create(bb,TweenInfo.new(0.14),{BackgroundTransparency=1}):Play() end end)
    end

    cur="Main" SFS["Main"].Visible=true TBS["Main"].bb.BackgroundTransparency=0 TBS["Main"].bl.TextColor3=C.acc

    -- ── HELPER FUNCTIONS ──
    local function gs(n) return SFS[n] end
    local function no(n) LOS[n]=LOS[n]+1 return LOS[n] end

    local function sec(tn,sym,txt)
        local f=Instance.new("Frame",gs(tn)) f.Size=UDim2.new(1,-8,0,22) f.BackgroundColor3=Color3.fromRGB(18,9,4) f.BorderSizePixel=0 f.LayoutOrder=no(tn) f.ZIndex=23
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local bar=Instance.new("Frame",f) bar.Size=UDim2.new(0,3,0,11) bar.Position=UDim2.new(0,7,0.5,-5) bar.BackgroundColor3=C.acc bar.BorderSizePixel=0 bar.ZIndex=24
        Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
        local l=Instance.new("TextLabel",f) l.Size=UDim2.new(1,-18,1,0) l.Position=UDim2.new(0,16,0,0) l.BackgroundTransparency=1 l.Text=sym.."  "..txt l.TextColor3=C.acc l.Font=Enum.Font.GothamBold l.TextSize=FS l.TextXAlignment=Enum.TextXAlignment.Left l.ZIndex=24
    end

    local function tog(tn,sym,title,desc,cb)
        local hD=desc and desc~=""
        local sf=gs(tn)
        local c=Instance.new("Frame",sf) c.Size=UDim2.new(1,-8,0,hD and CHD or CH) c.BackgroundColor3=C.card c.BorderSizePixel=0 c.LayoutOrder=no(tn) c.ZIndex=23
        Instance.new("UICorner",c).CornerRadius=UDim.new(0,9)
        local sk=Instance.new("UIStroke",c) sk.Color=C.acc sk.Thickness=1 sk.Transparency=1
        local sl=Instance.new("TextLabel",c) sl.Size=UDim2.new(0,20,1,0) sl.Position=UDim2.new(0,8,0,0) sl.BackgroundTransparency=1 sl.Text=sym sl.TextColor3=C.acc sl.Font=Enum.Font.GothamBold sl.TextSize=14 sl.ZIndex=24
        local tl=Instance.new("TextLabel",c) tl.Size=UDim2.new(0.68,0,0,16) tl.Position=UDim2.new(0,30,0,hD and 8 or 12) tl.BackgroundTransparency=1 tl.Text=title tl.TextColor3=C.text tl.Font=Enum.Font.GothamBold tl.TextSize=FL tl.TextXAlignment=Enum.TextXAlignment.Left tl.ZIndex=24
        if hD then
            local dl=Instance.new("TextLabel",c) dl.Size=UDim2.new(0.7,0,0,13) dl.Position=UDim2.new(0,30,0,28) dl.BackgroundTransparency=1 dl.Text=desc dl.TextColor3=C.sub dl.Font=Enum.Font.Gotham dl.TextSize=FS dl.TextXAlignment=Enum.TextXAlignment.Left dl.ZIndex=24
        end
        local sb=Instance.new("Frame",c) sb.Size=UDim2.new(0,40,0,20) sb.Position=UDim2.new(1,-48,0.5,-10) sb.BackgroundColor3=C.off sb.BorderSizePixel=0 sb.ZIndex=24
        Instance.new("UICorner",sb).CornerRadius=UDim.new(1,0)
        local kn=Instance.new("Frame",sb) kn.Size=UDim2.new(0,14,0,14) kn.Position=UDim2.new(0,3,0.5,-7) kn.BackgroundColor3=C.white kn.BorderSizePixel=0 kn.ZIndex=25
        Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)
        local st=false
        local btn=Instance.new("TextButton",c) btn.Size=UDim2.new(1,0,1,0) btn.BackgroundTransparency=1 btn.Text="" btn.ZIndex=26
        btn.MouseEnter:Connect(function() TweenService:Create(c,TweenInfo.new(0.14),{BackgroundColor3=C.cardH}):Play() TweenService:Create(sk,TweenInfo.new(0.14),{Transparency=0.55}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(c,TweenInfo.new(0.14),{BackgroundColor3=C.card}):Play() TweenService:Create(sk,TweenInfo.new(0.14),{Transparency=1}):Play() end)
        btn.MouseButton1Click:Connect(function()
            st=not st uiSnd(st and 1.5 or 1.0)
            TweenService:Create(sb,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundColor3=st and C.green or C.off}):Play()
            TweenService:Create(kn,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=st and UDim2.new(0,23,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
            TweenService:Create(sl,TweenInfo.new(0.2),{TextColor3=st and C.green or C.acc}):Play()
            cb(st)
        end)
        return {frame=c, getState=function() return st end}
    end

    local function drp(tn,title,opts,cb)
        local sf=gs(tn)
        local c=Instance.new("Frame",sf) c.Size=UDim2.new(1,-8,0,CH) c.BackgroundColor3=C.card c.BorderSizePixel=0 c.ClipsDescendants=false c.LayoutOrder=no(tn) c.ZIndex=30
        Instance.new("UICorner",c).CornerRadius=UDim.new(0,9)
        local l=Instance.new("TextLabel",c) l.Size=UDim2.new(0.48,0,1,0) l.Position=UDim2.new(0,10,0,0) l.BackgroundTransparency=1 l.Text=title l.TextColor3=C.text l.Font=Enum.Font.GothamBold l.TextSize=FL l.TextXAlignment=Enum.TextXAlignment.Left l.ZIndex=31
        local dW=isMobile and 95 or 110
        local db=Instance.new("TextButton",c) db.Size=UDim2.new(0,dW,0,26) db.Position=UDim2.new(1,-(dW+8),0.5,-13) db.BackgroundColor3=C.acc db.TextColor3=Color3.fromRGB(10,8,4) db.Font=Enum.Font.GothamBold db.TextSize=FS db.Text=opts[1].." ▾" db.ClipsDescendants=false db.ZIndex=31
        Instance.new("UICorner",db).CornerRadius=UDim.new(0,7)
        local dl=Instance.new("Frame",c) dl.Size=UDim2.new(0,dW,0,#opts*25+6) dl.Position=UDim2.new(1,-(dW+8),1,3) dl.BackgroundColor3=C.panel dl.BorderSizePixel=0 dl.Visible=false dl.ZIndex=55
        Instance.new("UICorner",dl).CornerRadius=UDim.new(0,8) Instance.new("UIStroke",dl).Color=C.acc
        Instance.new("UIListLayout",dl).Padding=UDim.new(0,2)
        local dlp=Instance.new("UIPadding",dl) dlp.PaddingTop=UDim.new(0,3) dlp.PaddingLeft=UDim.new(0,3) dlp.PaddingRight=UDim.new(0,3)
        for _,o in ipairs(opts) do
            local ob=Instance.new("TextButton",dl) ob.Size=UDim2.new(1,0,0,23) ob.BackgroundColor3=C.card ob.TextColor3=C.text ob.Font=Enum.Font.Gotham ob.TextSize=FS ob.Text=o ob.ZIndex=56
            Instance.new("UICorner",ob).CornerRadius=UDim.new(0,5)
            ob.MouseEnter:Connect(function() TweenService:Create(ob,TweenInfo.new(0.1),{BackgroundColor3=C.cardH}):Play() end)
            ob.MouseLeave:Connect(function() TweenService:Create(ob,TweenInfo.new(0.1),{BackgroundColor3=C.card}):Play() end)
            ob.MouseButton1Click:Connect(function() db.Text=o.." ▾" dl.Visible=false uiSnd(1.3) cb(o) end)
        end
        db.MouseButton1Click:Connect(function() dl.Visible=not dl.Visible uiSnd(1.2) end)
    end

    local function sld(tn,sym,title,mn,mx,def,cb)
        local sf=gs(tn)
        local c=Instance.new("Frame",sf) c.Size=UDim2.new(1,-8,0,isMobile and 50 or 54) c.BackgroundColor3=C.card c.BorderSizePixel=0 c.LayoutOrder=no(tn) c.ZIndex=23
        Instance.new("UICorner",c).CornerRadius=UDim.new(0,9)
        local sl2=Instance.new("TextLabel",c) sl2.Size=UDim2.new(0,18,0,15) sl2.Position=UDim2.new(0,8,0,7) sl2.BackgroundTransparency=1 sl2.Text=sym sl2.TextColor3=C.acc sl2.Font=Enum.Font.GothamBold sl2.TextSize=13 sl2.ZIndex=24
        local tl=Instance.new("TextLabel",c) tl.Size=UDim2.new(0.64,0,0,15) tl.Position=UDim2.new(0,28,0,7) tl.BackgroundTransparency=1 tl.Text=title tl.TextColor3=C.text tl.Font=Enum.Font.GothamBold tl.TextSize=FL tl.TextXAlignment=Enum.TextXAlignment.Left tl.ZIndex=24
        local vl=Instance.new("TextLabel",c) vl.Size=UDim2.new(0,40,0,15) vl.Position=UDim2.new(1,-46,0,7) vl.BackgroundTransparency=1 vl.Text=tostring(def) vl.TextColor3=C.acc vl.Font=Enum.Font.GothamBold vl.TextSize=FL vl.TextXAlignment=Enum.TextXAlignment.Right vl.ZIndex=24
        local tr=Instance.new("Frame",c) tr.Size=UDim2.new(1,-18,0,5) tr.Position=UDim2.new(0,9,0,isMobile and 34 or 37) tr.BackgroundColor3=C.off tr.BorderSizePixel=0 tr.ZIndex=24
        Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
        local fi=Instance.new("Frame",tr) fi.Size=UDim2.new((def-mn)/(mx-mn),0,1,0) fi.BackgroundColor3=C.acc fi.BorderSizePixel=0 fi.ZIndex=25
        Instance.new("UICorner",fi).CornerRadius=UDim.new(1,0)
        local kn=Instance.new("Frame",tr) kn.Size=UDim2.new(0,13,0,13) kn.Position=UDim2.new((def-mn)/(mx-mn),-6,0.5,-6) kn.BackgroundColor3=C.white kn.BorderSizePixel=0 kn.ZIndex=26
        Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)
        local dgs=false
        local btn=Instance.new("TextButton",c) btn.Size=UDim2.new(1,0,1,0) btn.BackgroundTransparency=1 btn.Text="" btn.ZIndex=27
        local function ds(x)
            local r=math.clamp((x-tr.AbsolutePosition.X)/math.max(tr.AbsoluteSize.X,1),0,1)
            local v=math.floor(mn+(mx-mn)*r)
            fi.Size=UDim2.new(r,0,1,0) kn.Position=UDim2.new(r,-6,0.5,-6) vl.Text=tostring(v) cb(v)
        end
        btn.MouseButton1Down:Connect(function(x) dgs=true ds(x) end)
        UIS.InputChanged:Connect(function(i) if dgs and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then ds(i.Position.X) end end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dgs=false end end)
    end

    -- Info Card (nicht klickbar, zeigt Text)
    local function infoCard(tn, sym, text, color)
        local sf=gs(tn)
        local c=Instance.new("Frame",sf) c.Size=UDim2.new(1,-8,0,CH) c.BackgroundColor3=C.card c.BorderSizePixel=0 c.LayoutOrder=no(tn) c.ZIndex=23
        Instance.new("UICorner",c).CornerRadius=UDim.new(0,9)
        local l=Instance.new("TextLabel",c) l.Size=UDim2.new(1,-16,1,0) l.Position=UDim2.new(0,8,0,0) l.BackgroundTransparency=1 l.Text=sym.."  "..text l.TextColor3=color or C.sub l.Font=Enum.Font.Gotham l.TextSize=FS l.TextXAlignment=Enum.TextXAlignment.Left l.TextWrapped=true l.ZIndex=24
        return l
    end

    -- Button Card (einzelner Action Button)
    local function btnCard(tn, sym, title, color, cb)
        local sf=gs(tn)
        local c=Instance.new("TextButton",sf)
        c.Size=UDim2.new(1,-8,0,CH) c.BackgroundColor3=color or C.card c.BorderSizePixel=0 c.LayoutOrder=no(tn) c.Text="" c.AutoButtonColor=false c.ZIndex=23
        Instance.new("UICorner",c).CornerRadius=UDim.new(0,9)
        local sk=Instance.new("UIStroke",c) sk.Color=color or C.acc sk.Thickness=1 sk.Transparency=0.5
        local l=Instance.new("TextLabel",c) l.Size=UDim2.new(1,0,1,0) l.BackgroundTransparency=1 l.Text=sym.."  "..title l.TextColor3=color and C.white or C.text l.Font=Enum.Font.GothamBold l.TextSize=FL l.ZIndex=24
        c.MouseEnter:Connect(function() TweenService:Create(c,TweenInfo.new(0.14),{BackgroundColor3=(color or C.card):Lerp(C.white,0.1)}):Play() end)
        c.MouseLeave:Connect(function() TweenService:Create(c,TweenInfo.new(0.14),{BackgroundColor3=color or C.card}):Play() end)
        c.MouseButton1Click:Connect(function() uiSnd(1.3) cb() end)
        return c
    end

    -- ══════════════════════════════════════════════
    -- MAIN TAB
    -- ══════════════════════════════════════════════
    sec("Main",S.bolt,"PERFORMANCE")

    tog("Main",S.bolt,"FPS Boost","VFX & Schatten entfernen",function(on)
        Lighting.GlobalShadows=not on
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=not on end
            if v:IsA("BasePart") and on then v.Material=Enum.Material.Plastic v.Reflectance=0 v.CastShadow=false end
        end
    end)

    tog("Main",S.fire,"Ultra Low","Level 1 max FPS",function(on)
        settings().Rendering.QualityLevel=on and Enum.QualityLevel.Level01 or Enum.QualityLevel.Level10
    end)

    tog("Main",S.chart,"Auto RAM Boost","Grafik nach RAM anpassen",function(on)
        task.spawn(function()
            while on and task.wait(5) do
                local m=Stats:GetTotalMemoryUsageMb()
                settings().Rendering.QualityLevel=m>2000 and Enum.QualityLevel.Level01 or m>1200 and Enum.QualityLevel.Level05 or Enum.QualityLevel.Level10
            end
        end)
    end)

    tog("Main",S.ban,"No Shadows","Schatten aus",function(on)
        Lighting.GlobalShadows=not on
        for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.CastShadow=not on end end
    end)

    tog("Main",S.ban,"No Particles","Partikel aus",function(on)
        for _,v in ipairs(Workspace:GetDescendants()) do if v:IsA("ParticleEmitter") then v.Enabled=not on end end
        if on then Workspace.DescendantAdded:Connect(function(v) if v:IsA("ParticleEmitter") then v.Enabled=false end end) end
    end)

    sec("Main",S.chart,"ANZEIGE")

    tog("Main",S.bolt,"FPS Counter","FPS einblenden",function(on)
        _G.ShowFPS=on destroyHUD() buildHUD()
    end)

    tog("Main",S.dot,"Ping Anzeige","Ping einblenden",function(on)
        _G.ShowPing=on destroyHUD() buildHUD()
    end)

    tog("Main",S.heart,"HP Anzeige","HP Bar einblenden",function(on)
        _G.ShowHP=on destroyHUD() buildHUD()
    end)

    sec("Main",S.eye,"UTILITIES")

    tog("Main",S.eye,"Anti AFK","Verhindert Kick",function(on)
        if on then
            local VU=game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)
        end
    end)

    tog("Main",S.lock,"Chat Deactivate","Chat unsichtbar machen",function(on)
        pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, not on) end)
    end)

    tog("Main",S.world,"Leaderboard aus","Leaderboard verstecken",function(on)
        pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, not on) end)
    end)

    -- ══════════════════════════════════════════════
    -- COMBAT TAB
    -- ══════════════════════════════════════════════
    sec("Combat",S.sword,"KAMPF FEATURES")

    tog("Combat",S.shield,"Anti Stun","Stun-Effekte verhindern",function(on) startAntiStun(on) end)

    tog("Combat",S.ban,"No Knockback","Knockback reduzieren",function(on)
        _G.NoKnockback=on setupNoKnockback(on)
    end)

    tog("Combat",S.bolt,"Infinite Stamina","Stamina immer voll",function(on)
        _G.InfiniteStamina=on setupInfiniteStamina(on)
    end)

    tog("Combat",S.target,"Auto Parry","Automatisch Parieren",function(on)
        setupAutoParry(on)
    end)

    sec("Combat",S.eye,"ESP & VISION")

    tog("Combat",S.eye,"Player ESP","Gegner durch Wände sehen",function(on)
        setupESP(on)
    end)

    tog("Combat",S.diamond,"Neon Enemies","Gegner leuchten neon",function(on)
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                for _,v in ipairs(p.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.Material=on and Enum.Material.Neon or Enum.Material.Plastic end
                end
            end
        end
    end)

    tog("Combat",S.target,"Enemy Highlight","Roter Rahmen um Gegner",function(on)
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local sel=p.Character:FindFirstChild("_EB")
                if on and not sel then
                    local b=Instance.new("SelectionBox",p.Character) b.Name="_EB"
                    b.Adornee=p.Character b.Color3=C.red b.LineThickness=0.04
                    b.SurfaceTransparency=0.85 b.SurfaceColor3=C.red
                elseif not on and sel then sel:Destroy() end
            end
        end
    end)

    tog("Combat",S.anchor,"Name Tags","Namen über Spielern",function(on)
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local r=p.Character:FindFirstChild("HumanoidRootPart")
                if on and r then
                    local bb=Instance.new("BillboardGui",r) bb.Name="_NT"
                    bb.Size=UDim2.new(0,130,0,24) bb.StudsOffset=Vector3.new(0,3.5,0) bb.AlwaysOnTop=true
                    local tl=Instance.new("TextLabel",bb) tl.Size=UDim2.new(1,0,1,0)
                    tl.BackgroundTransparency=1 tl.Text=S.sword.." "..p.Name
                    tl.TextColor3=C.acc tl.Font=Enum.Font.GothamBold tl.TextScaled=true
                elseif not on then
                    local t=r and r:FindFirstChild("_NT") if t then t:Destroy() end
                end
            end
        end
    end)

    sec("Combat",S.music,"KILL SOUNDS")

    tog("Combat",S.music,"Kill Sound (Default)","Sound bei Kill",function(on) _G.KillOn=on _G.KillId=4612365796 end)
    tog("Combat",S.star,"Goat Sound","Ziege bei Kill",function(on) _G.KillOn=on _G.KillId=135017578 end)
    tog("Combat",S.wave,"Bruh Sound","Bruh bei Kill",function(on) _G.KillOn=on _G.KillId=1444622487 end)
    tog("Combat",S.diamond,"MLG Airhorn","MLG bei Kill",function(on) _G.KillOn=on _G.KillId=135946816 end)
    tog("Combat",S.anchor,"Vine Boom","Vine bei Kill",function(on) _G.KillOn=on _G.KillId=5153644985 end)

    sld("Combat",S.music,"Kill Lautstärke",1,10,7,function(v) _G.KillVol=v*0.1 end)

    sec("Combat",S.shield,"ALARM")

    tog("Combat",S.heart,"Low HP Alarm","Alarm bei wenig HP",function(on)
        task.spawn(function()
            while on and task.wait(1) do
                local c=LocalPlayer.Character
                if c then local h=c:FindFirstChildOfClass("Humanoid") if h and h.Health<30 and h.Health>0 then playSnd(131961136,1,1) end end
            end
        end)
    end)

    -- ══════════════════════════════════════════════
    -- VISUAL TAB
    -- ══════════════════════════════════════════════
    sec("Visual",S.eye,"LIGHTING")

    tog("Visual",S.star,"Full Bright","Max Helligkeit",function(on)
        Lighting.Ambient=on and Color3.new(1,1,1) or Color3.fromRGB(70,70,70)
        Lighting.OutdoorAmbient=on and Color3.new(1,1,1) or Color3.fromRGB(100,100,100)
        Lighting.Brightness=on and 10 or 2
    end)

    tog("Visual",S.wave,"No Fog","Nebel entfernen",function(on)
        Lighting.FogEnd=on and 9e9 or 1000 Lighting.FogStart=on and 9e9 or 0
    end)

    tog("Visual",S.ban,"Remove VFX","Partikel, Beams aus",function(on)
        local function cl(o)
            for _,v in ipairs(o:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=not on end
                if v:IsA("PointLight") or v:IsA("SpotLight") then v.Enabled=not on end
            end
        end
        cl(Workspace)
        if on then Workspace.DescendantAdded:Connect(function(o) task.wait() cl(o) end) end
    end)

    sld("Visual",S.star,"Ambient Helligkeit",0,10,5,function(v)
        local b=v/10 Lighting.Ambient=Color3.new(b,b,b)
    end)

    sld("Visual",S.bolt,"Brightness",1,10,2,function(v) Lighting.Brightness=v*0.5 end)

    sec("Visual",S.eye,"CROSSHAIR")

    drp("Visual","Crosshair Style",{"Deaktiviert","Cross","Dot","Circle","Gap"},function(sel)
        if sel=="Deaktiviert" then
            crosshairEnabled=false buildCrosshair()
        else
            crosshairEnabled=true
            local map={Cross="cross",Dot="dot",Circle="circle",Gap="gap"}
            buildCrosshair(map[sel] or "cross")
        end
    end)

    sld("Visual",S.dot,"Crosshair Größe",4,24,8,function(v)
        if crosshairEnabled then
            buildCrosshair(nil,v,nil) -- rebuild mit neuer Größe
        end
    end)

    sec("Visual",S.gem,"FARBE")

    tog("Visual",S.spin,"Rainbow World","Welt ändert Farbe",function(on)
        task.spawn(function()
            local h=0 while on do h=(h+1)%360
                Lighting.Ambient=Color3.fromHSV(h/360,0.35,0.9) task.wait(0.05)
            end
            if not on then Lighting.Ambient=Color3.fromRGB(70,70,70) end
        end)
    end)

    tog("Visual",S.gem,"Ball Trail","Trail am Ball",function(on)
        _G.BallTrail=on setupBallTrail(on)
    end)

    -- ══════════════════════════════════════════════
    -- PLAYER TAB
    -- ══════════════════════════════════════════════
    sec("Player",S.arrow,"MOVEMENT")

    tog("Player",S.bolt,"Speed Boost","WalkSpeed auf 28",function(on)
        _G.SpeedOn=on _G.SpeedVal=on and 28 or 16
        applySpeedNow() setupSpeedLoop(on)
    end)

    sld("Player",S.arrow,"Custom Speed",16,100,16,function(val)
        _G.SpeedVal=val _G.SpeedOn=(val>16)
        applySpeedNow() setupSpeedLoop(_G.SpeedOn)
    end)

    tog("Player",S.fire,"High Jump","JumpPower erhöhen",function(on)
        setupJumpLoop(on, on and 100 or 50)
        local char=LocalPlayer.Character
        if char then local h=char:FindFirstChildOfClass("Humanoid") if h then h.JumpPower=on and 100 or 50 end end
    end)

    sld("Player",S.fire,"Jump Power",50,300,50,function(val)
        setupJumpLoop(true,val)
        local char=LocalPlayer.Character
        if char then local h=char:FindFirstChildOfClass("Humanoid") if h then h.JumpPower=val end end
    end)

    tog("Player",S.world,"No Clip","Durch Wände gehen",function(on)
        RunService.Stepped:Connect(function()
            if on and LocalPlayer.Character then
                for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide=false end
                end
            end
        end)
    end)

    sec("Player",S.eye,"KAMERA")

    tog("Player",S.eye,"Max Zoom","Kamera weit rauszoomen",function(on)
        LocalPlayer.CameraMaxZoomDistance=on and 200 or 30
    end)

    sld("Player",S.eye,"FOV",50,130,70,function(val)
        setFOV(val)
    end)

    tog("Player",S.eye,"FOV Reset","FOV zurücksetzen",function(on)
        if on then resetFOV() end
    end)

    sec("Player",S.chart,"CHARACTER")

    tog("Player",S.gem,"Invisible Char","Charakter unsichtbar",function(on)
        local char=LocalPlayer.Character
        if not char then return end
        for _,v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.LocalTransparencyModifier=on and 1 or 0 end
        end
    end)

    tog("Player",S.anchor,"Floating","Charakter schwebt",function(on)
        local char=LocalPlayer.Character
        if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart")
        if root then
            local bg=root:FindFirstChild("_FloatBG")
            if on and not bg then
                bg=Instance.new("BodyGyro",root) bg.Name="_FloatBG" bg.MaxTorque=Vector3.new(4e5,4e5,4e5) bg.CFrame=root.CFrame
                local bv=Instance.new("BodyVelocity",root) bv.Name="_FloatBV" bv.MaxForce=Vector3.new(0,4e5,0) bv.Velocity=Vector3.new(0,0,0)
            elseif not on then
                if root:FindFirstChild("_FloatBG") then root:FindFirstChild("_FloatBG"):Destroy() end
                if root:FindFirstChild("_FloatBV") then root:FindFirstChild("_FloatBV"):Destroy() end
            end
        end
    end)

    -- ══════════════════════════════════════════════
    -- EMOTE TAB
    -- ══════════════════════════════════════════════
    sec("Emote",S.star,"EMOTES")

    do
        local sf=gs("Emote")
        local sc=Instance.new("TextButton",sf)
        sc.Size=UDim2.new(1,-8,0,CH) sc.BackgroundColor3=Color3.fromRGB(28,10,10)
        sc.BorderSizePixel=0 sc.LayoutOrder=no("Emote") sc.Text="" sc.AutoButtonColor=false sc.ZIndex=23
        Instance.new("UICorner",sc).CornerRadius=UDim.new(0,9)
        local ssk=Instance.new("UIStroke",sc) ssk.Color=C.red ssk.Thickness=1 ssk.Transparency=0.5
        local sl3=Instance.new("TextLabel",sc) sl3.Size=UDim2.new(1,0,1,0) sl3.BackgroundTransparency=1
        sl3.Text=S.cross.."  EMOTE STOPPEN" sl3.TextColor3=C.red sl3.Font=Enum.Font.GothamBold sl3.TextSize=FL sl3.ZIndex=24
        sc.MouseButton1Click:Connect(function() stopEmote() uiSnd(0.8) end)

        sec("Emote",S.anchor,"AUSWÄHLEN")

        local eg=Instance.new("Frame",sf)
        eg.Size=UDim2.new(1,-8,0,0) eg.BackgroundTransparency=1
        eg.BorderSizePixel=0 eg.LayoutOrder=no("Emote") eg.ZIndex=22 eg.AutomaticSize=Enum.AutomaticSize.Y
        local egl=Instance.new("UIGridLayout",eg)
        egl.CellSize=UDim2.new(0.48,-4,0,CH+10) egl.CellPadding=UDim2.new(0,6,0,6) egl.HorizontalAlignment=Enum.HorizontalAlignment.Center

        for _,em in ipairs(EMOTES) do
            local b=Instance.new("TextButton",eg)
            b.Size=UDim2.new(1,0,1,0) b.BackgroundColor3=C.card b.BorderSizePixel=0 b.Text="" b.AutoButtonColor=false b.ZIndex=23
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,9)
            local bsk=Instance.new("UIStroke",b) bsk.Color=C.acc bsk.Thickness=1 bsk.Transparency=1
            local bsm=Instance.new("TextLabel",b) bsm.Size=UDim2.new(1,0,0,26) bsm.Position=UDim2.new(0,0,0,4) bsm.BackgroundTransparency=1 bsm.Text=em.sym bsm.TextColor3=C.acc bsm.Font=Enum.Font.GothamBold bsm.TextSize=20 bsm.ZIndex=24
            local bnm=Instance.new("TextLabel",b) bnm.Size=UDim2.new(1,-4,0,13) bnm.Position=UDim2.new(0,2,1,-16) bnm.BackgroundTransparency=1 bnm.Text=em.name bnm.TextColor3=C.sub bnm.Font=Enum.Font.Gotham bnm.TextSize=FS bnm.ZIndex=24

            b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.14),{BackgroundColor3=C.cardH}):Play() TweenService:Create(bsk,TweenInfo.new(0.14),{Transparency=0.55}):Play() end)
            b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.14),{BackgroundColor3=C.card}):Play() TweenService:Create(bsk,TweenInfo.new(0.14),{Transparency=1}):Play() end)

            local eid, ecmd = em.id, em.cmd
            b.MouseButton1Click:Connect(function()
                playEmote(eid, ecmd)
                TweenService:Create(bsm,TweenInfo.new(0.1),{TextColor3=C.green}):Play()
                TweenService:Create(b,TweenInfo.new(0.1,Enum.EasingStyle.Back),{Size=UDim2.new(0.94,0,0.9,0)}):Play()
                task.wait(0.12)
                TweenService:Create(b,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0)}):Play()
                task.wait(0.4)
                TweenService:Create(bsm,TweenInfo.new(0.3),{TextColor3=C.acc}):Play()
            end)
        end
    end

    -- ══════════════════════════════════════════════
    -- GFX TAB
    -- ══════════════════════════════════════════════
    sec("Gfx",S.gem,"PRESET")

    drp("Gfx",S.gem.." Preset",{"POTATO","LOW","MEDIUM","HIGH","ULTRA","CINEMATIC","ANIME","NIGHTMARE"},function(s)
        if GFX[s] then GFX[s]() end
    end)

    sec("Gfx",S.star,"POST PROCESSING")

    tog("Gfx",S.star,"Bloom","Glow-Effekt",function(on)
        local b=Lighting:FindFirstChildOfClass("BloomEffect")
        if on then if not b then b=Instance.new("BloomEffect",Lighting) end b.Intensity=0.8 b.Size=40 b.Threshold=0.9
        elseif b then b:Destroy() end
    end)

    sld("Gfx",S.star,"Bloom Stärke",1,20,4,function(v)
        local b=Lighting:FindFirstChildOfClass("BloomEffect") if b then b.Intensity=v*0.15 end
    end)

    tog("Gfx",S.bolt,"Sun Rays","Sonnenstrahlen",function(on)
        local sr=Lighting:FindFirstChildOfClass("SunRaysEffect")
        if on then if not sr then sr=Instance.new("SunRaysEffect",Lighting) end sr.Intensity=0.15 sr.Spread=0.6
        elseif sr then sr:Destroy() end
    end)

    tog("Gfx",S.diamond,"Color Grading","Farb-Korrektur",function(on)
        local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if on then if not cc then cc=Instance.new("ColorCorrectionEffect",Lighting) end cc.Saturation=0.35 cc.Contrast=0.2 cc.Brightness=0.05
        elseif cc then cc:Destroy() end
    end)

    sld("Gfx",S.wave,"Saturation",0,10,3,function(v)
        local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect") if cc then cc.Saturation=v*0.1 end
    end)

    sld("Gfx",S.diamond,"Contrast",0,10,2,function(v)
        local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect") if cc then cc.Contrast=v*0.08 end
    end)

    tog("Gfx",S.eye,"Depth of Field","Tiefenschärfe",function(on)
        local d=Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
        if on then if not d then d=Instance.new("DepthOfFieldEffect",Lighting) end d.FarIntensity=0.3 d.NearIntensity=0.1 d.FocusDistance=40 d.InFocusRadius=20
        elseif d then d:Destroy() end
    end)

    tog("Gfx",S.world,"Atmosphere","Atmosphären-Effekt",function(on)
        local a=Lighting:FindFirstChildOfClass("Atmosphere")
        if on then if not a then a=Instance.new("Atmosphere",Lighting) end a.Density=0.3 a.Haze=0.5 a.Glare=0.5 a.Color=Color3.fromRGB(199,210,255)
        elseif a then a:Destroy() end
    end)

    sld("Gfx",S.star,"Helligkeit",1,10,2,function(v) Lighting.Brightness=v*0.5 end)

    sld("Gfx",S.chart,"Quality Level",1,21,10,function(v)
        settings().Rendering.QualityLevel=v
    end)

    -- ══════════════════════════════════════════════
    -- SETTINGS TAB
    -- ══════════════════════════════════════════════
    sec("Settings",S.dot,"UI EINSTELLUNGEN")

    tog("Settings",S.ban,"UI Sounds aus","Click-Sounds deaktivieren",function(on) _G.UISound=not on end)

    sec("Settings",S.gem,"THEME")

    drp("Settings","UI Theme",{"Gold","Blue","Green","Purple","Red","Cyan"},function(sel)
        local map={Gold="gold",Blue="blue",Green="green",Purple="purple",Red="red",Cyan="cyan"}
        local name=map[sel]
        if name then
            applyTheme(name)
            -- Stroke Farben updaten
            MFS.Color  = C.acc
            OBS.Color  = C.acc
        end
    end)

    sec("Settings",S.dot,"KEYBINDS")

    infoCard("Settings",S.arrow,"RightShift → UI öffnen / schließen", C.sub)

    sec("Settings",S.info,"SCRIPT INFO")

    infoCard("Settings",S.skull,"GOD VALLEY HUB v8.0",C.acc)
    infoCard("Settings",S.wave,"The Strongest Battleground",C.sub)
    infoCard("Settings",S.anchor,"One Piece Edition",C.sub)
    infoCard("Settings",S.check,"Key: 24h gespeichert",C.green)

    btnCard("Settings",S.ban,"Key löschen & Logout",C.red,function()
        clearSavedKey() GUI:Destroy() destroyHUD()
    end)

    -- Player Count Info
    do
        local pInfo = infoCard("Settings",S.eye,"Spieler: laden...",C.sub)
        task.spawn(function()
            while pInfo and pInfo.Parent do
                local count = #Players:GetPlayers()
                pInfo.Text = S.eye.."  Spieler im Server: "..count
                task.wait(5)
            end
        end)
    end

end

-- ══════════════════════════════════════════════════════════════
-- UNLOCK HUB
-- ══════════════════════════════════════════════════════════════
local function unlockHub(kType, wasSaved)
    buildUI(kType)
    OB.Visible=true
    OB.Size=UDim2.new(0,0,0,0) OB.Position=UDim2.new(0,0,0.5,0)
    TweenService:Create(OB,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,54,0,54),Position=UDim2.new(0,10,0.5,-27)
    }):Play()

    local tw=isMobile and 240 or 270
    local toast=Instance.new("Frame",GUI)
    toast.Size=UDim2.new(0,tw,0,56) toast.Position=UDim2.new(0.5,-tw/2,1,10)
    toast.BackgroundColor3=C.panel toast.BorderSizePixel=0 toast.ZIndex=200
    Instance.new("UICorner",toast).CornerRadius=UDim.new(0,11)
    local tSt=Instance.new("UIStroke",toast) tSt.Color=C.green tSt.Thickness=1.3

    local tI=Instance.new("ImageLabel",toast) tI.Size=UDim2.new(0,40,0,48) tI.Position=UDim2.new(0,5,0.5,-24) tI.BackgroundTransparency=1 tI.Image=IMG.luffy tI.ZIndex=201

    local tT=Instance.new("TextLabel",toast) tT.Size=UDim2.new(1,-52,0,20) tT.Position=UDim2.new(0,50,0,7) tT.BackgroundTransparency=1 tT.Text=S.anchor.." GOD VALLEY HUB v8.0" tT.TextColor3=C.acc tT.Font=Enum.Font.GothamBold tT.TextSize=isMobile and 11 or 12 tT.TextXAlignment=Enum.TextXAlignment.Left tT.ZIndex=201

    local tS2=Instance.new("TextLabel",toast) tS2.Size=UDim2.new(1,-52,0,14) tS2.Position=UDim2.new(0,50,0,29) tS2.BackgroundTransparency=1
    tS2.Text = wasSaved and (S.check.." Willkommen zurück!") or (kType=="admin" and (S.crown.." Admin Zugang!") or (S.check.." Zugang gewährt!"))
    tS2.TextColor3=C.green tS2.Font=Enum.Font.Gotham tS2.TextSize=isMobile and 9 or 10 tS2.TextXAlignment=Enum.TextXAlignment.Left tS2.ZIndex=201

    TweenService:Create(toast,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Position=UDim2.new(0.5,-tw/2,1,-66)
    }):Play()
    playSnd(4590662766,0.5,1.1)

    task.delay(4,function()
        TweenService:Create(toast,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In),{
            Position=UDim2.new(0.5,-tw/2,1,10)
        }):Play()
        task.wait(0.4) pcall(function() toast:Destroy() end)
    end)
end

-- ══════════════════════════════════════════════════════════════
-- KEY SCREEN
-- ══════════════════════════════════════════════════════════════
local KS = Instance.new("Frame",GUI)
KS.Size=UDim2.new(1,0,1,0) KS.BackgroundColor3=C.black KS.ZIndex=50 KS.BorderSizePixel=0

-- Gespeicherten Key prüfen
local savedKey = loadSavedKey()
if savedKey then
    local kType = checkKey(savedKey)
    if kType then
        KS.Visible=false
        task.wait(0.4)
        unlockHub(kType, true)
    else
        clearSavedKey()
        KS.Visible=true
    end
else
    KS.Visible=true
end

if KS.Visible then
    task.spawn(function() while KS.Visible do spawnPart(KS) task.wait(0.25) end end)

    local KG=Instance.new("UIGradient",KS)
    KG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(10,5,20)),ColorSequenceKeypoint.new(1,Color3.fromRGB(5,5,12))}) KG.Rotation=135

    local KL=Instance.new("ImageLabel",KS) KL.Size=UDim2.new(0,isMobile and 80 or 110,0,isMobile and 80 or 110) KL.Position=UDim2.new(0.1,0,0.5,-80) KL.BackgroundTransparency=1 KL.Image=IMG.luffy KL.ZIndex=51
    local KZ=Instance.new("ImageLabel",KS) KZ.Size=UDim2.new(0,isMobile and 80 or 110,0,isMobile and 80 or 110) KZ.Position=UDim2.new(0.9,isMobile and -80 or -110,0.5,-80) KZ.BackgroundTransparency=1 KZ.Image=IMG.zoro KZ.ZIndex=51

    task.spawn(function()
        local t=0 while KS.Visible do t=t+0.02
            local o=math.sin(t)*12
            KL.Position=UDim2.new(0.1,0,0.5,-80+o)
            KZ.Position=UDim2.new(0.9,isMobile and -80 or -110,0.5,-80-o)
            task.wait(0.03)
        end
    end)

    local KTit=Instance.new("TextLabel",KS) KTit.Size=UDim2.new(0.8,0,0,42) KTit.Position=UDim2.new(0.1,0,0,isMobile and 52 or 68) KTit.BackgroundTransparency=1 KTit.Text=S.anchor.."  GOD VALLEY HUB  "..S.anchor KTit.Font=Enum.Font.GothamBold KTit.TextSize=isMobile and 20 or 27 KTit.ZIndex=52
    Instance.new("UIGradient",KTit).Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.acc),ColorSequenceKeypoint.new(1,C.acc2)})

    -- Animierter Titel
    task.spawn(function()
        while KS.Visible do
            TweenService:Create(KTit,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(0.1,0,0,(isMobile and 52 or 68)+5)}):Play()
            task.wait(1.4)
            TweenService:Create(KTit,TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(0.1,0,0,isMobile and 52 or 68)}):Play()
            task.wait(1.4)
        end
    end)

    local KSub=Instance.new("TextLabel",KS) KSub.Size=UDim2.new(0.8,0,0,18) KSub.Position=UDim2.new(0.1,0,0,isMobile and 98 or 116) KSub.BackgroundTransparency=1 KSub.Text=S.wave.." The Strongest Battleground "..S.wave.." One Piece Edition" KSub.TextColor3=C.sub KSub.Font=Enum.Font.Gotham KSub.TextSize=isMobile and 10 or 12 KSub.ZIndex=52

    local KW=isMobile and 278 or 355
    local KH=isMobile and 258 or 290
    local KB=Instance.new("Frame",KS) KB.Size=UDim2.new(0,KW,0,KH) KB.Position=UDim2.new(0.5,-KW/2,0.5,-KH/2+20) KB.BackgroundColor3=C.panel KB.BorderSizePixel=0 KB.ZIndex=52
    Instance.new("UICorner",KB).CornerRadius=UDim.new(0,16)

    local KBS=Instance.new("UIStroke",KB) KBS.Thickness=1.5 KBS.Color=C.acc KBS.Transparency=0.3
    task.spawn(function() local t=0 while KS.Visible do t=t+0.025 KBS.Color=C.acc:Lerp(C.acc2,(math.sin(t)+1)/2) task.wait(0.04) end end)

    local LB=Instance.new("Frame",KB) LB.Size=UDim2.new(0,46,0,46) LB.Position=UDim2.new(0.5,-23,0,-23) LB.BackgroundColor3=C.panel LB.BorderSizePixel=0 LB.ZIndex=54
    Instance.new("UICorner",LB).CornerRadius=UDim.new(1,0)
    local LBS=Instance.new("UIStroke",LB) LBS.Color=C.acc LBS.Thickness=1.5
    local LL=Instance.new("TextLabel",LB) LL.Size=UDim2.new(1,0,1,0) LL.BackgroundTransparency=1 LL.Text=S.lock LL.TextScaled=true LL.ZIndex=55
    -- Schloss-Puls
    task.spawn(function() while KS.Visible do TweenService:Create(LB,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size=UDim2.new(0,50,0,50),Position=UDim2.new(0.5,-25,0,-25)}):Play() task.wait(1) TweenService:Create(LB,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size=UDim2.new(0,46,0,46),Position=UDim2.new(0.5,-23,0,-23)}):Play() task.wait(1) end end)

    local KBT=Instance.new("TextLabel",KB) KBT.Size=UDim2.new(1,-20,0,24) KBT.Position=UDim2.new(0,10,0,18) KBT.BackgroundTransparency=1 KBT.Text=S.crown.."  KEY SYSTEM" KBT.TextColor3=C.text KBT.Font=Enum.Font.GothamBold KBT.TextSize=isMobile and 13 or 15 KBT.ZIndex=53

    local KBD=Instance.new("TextLabel",KB) KBD.Size=UDim2.new(1,-20,0,20) KBD.Position=UDim2.new(0,10,0,44) KBD.BackgroundTransparency=1 KBD.Text="Hol dir deinen Key auf der Website." KBD.TextColor3=C.sub KBD.Font=Enum.Font.Gotham KBD.TextSize=isMobile and 9 or 10 KBD.ZIndex=53

    -- Website Button
    local WBtn=Instance.new("TextButton",KB)
    WBtn.Size=UDim2.new(1,-20,0,isMobile and 34 or 38) WBtn.Position=UDim2.new(0,10,0,70)
    WBtn.BackgroundColor3=Color3.fromRGB(18,10,4) WBtn.TextColor3=C.acc
    WBtn.Font=Enum.Font.GothamBold WBtn.TextSize=isMobile and 10 or 11
    WBtn.Text=S.anchor.."  Website öffnen  "..S.arrow.."  Key holen" WBtn.ZIndex=53
    Instance.new("UICorner",WBtn).CornerRadius=UDim.new(0,9)

    local WBS=Instance.new("UIStroke",WBtn) WBS.Color=C.acc WBS.Thickness=1.2 WBS.Transparency=0.3
    task.spawn(function()
        while KS.Visible do
            TweenService:Create(WBS,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=0.7}):Play()
            task.wait(1)
            TweenService:Create(WBS,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=0}):Play()
            task.wait(1)
        end
    end)

    WBtn.MouseButton1Click:Connect(function()
        uiSnd(1.3)
        pcall(function() setclipboard(KEY_WEBSITE) end)
        local orig=WBtn.Text
        WBtn.Text=S.check.."  Link kopiert! Im Browser öffnen"
        WBtn.TextColor3=C.green
        task.wait(2.5) WBtn.Text=orig WBtn.TextColor3=C.acc
    end)

    -- Schritte
    local StepsLbl=Instance.new("TextLabel",KB)
    StepsLbl.Size=UDim2.new(1,-20,0,36) StepsLbl.Position=UDim2.new(0,10,0,114)
    StepsLbl.BackgroundTransparency=1
    StepsLbl.Text=S.diamond.." 1. Website öffnen\n"..S.arrow.." 2. Aufgaben abschließen\n"..S.check.." 3. Key kopieren & hier eingeben"
    StepsLbl.TextColor3=C.sub StepsLbl.Font=Enum.Font.Gotham StepsLbl.TextSize=isMobile and 8 or 9
    StepsLbl.TextWrapped=true StepsLbl.TextXAlignment=Enum.TextXAlignment.Left StepsLbl.ZIndex=53

    -- Input
    local InBg=Instance.new("Frame",KB)
    InBg.Size=UDim2.new(1,-20,0,isMobile and 32 or 36) InBg.Position=UDim2.new(0,10,0,156)
    InBg.BackgroundColor3=C.card InBg.BorderSizePixel=0 InBg.ZIndex=53
    Instance.new("UICorner",InBg).CornerRadius=UDim.new(0,9)
    local InSt=Instance.new("UIStroke",InBg) InSt.Color=C.off InSt.Thickness=1.5

    local KIn=Instance.new("TextBox",InBg)
    KIn.Size=UDim2.new(1,-16,1,0) KIn.Position=UDim2.new(0,8,0,0)
    KIn.BackgroundTransparency=1 KIn.PlaceholderText=S.lock.." FREE_... oder ADMIN Key"
    KIn.PlaceholderColor3=C.sub KIn.Text="" KIn.TextColor3=C.text
    KIn.Font=Enum.Font.Gotham KIn.TextSize=isMobile and 9 or 11 KIn.ClearTextOnFocus=false KIn.ZIndex=54

    KIn.Focused:Connect(function() TweenService:Create(InSt,TweenInfo.new(0.2),{Color=C.acc}):Play() end)
    KIn.FocusLost:Connect(function() TweenService:Create(InSt,TweenInfo.new(0.2),{Color=C.off}):Play() end)

    local StLbl=Instance.new("TextLabel",KB)
    StLbl.Size=UDim2.new(1,-20,0,13) StLbl.Position=UDim2.new(0,10,0,196)
    StLbl.BackgroundTransparency=1 StLbl.Text=""
    StLbl.TextColor3=C.red StLbl.Font=Enum.Font.Gotham StLbl.TextSize=FS StLbl.ZIndex=53

    local EnBtn=Instance.new("TextButton",KB)
    EnBtn.Size=UDim2.new(1,-20,0,isMobile and 30 or 34) EnBtn.Position=UDim2.new(0,10,0,212)
    EnBtn.BackgroundColor3=C.acc2 EnBtn.TextColor3=C.white
    EnBtn.Font=Enum.Font.GothamBold EnBtn.TextSize=isMobile and 11 or 13
    EnBtn.Text=S.arrow.."  BESTÄTIGEN" EnBtn.ZIndex=53
    Instance.new("UICorner",EnBtn).CornerRadius=UDim.new(0,9)

    task.spawn(function()
        while KS.Visible do
            TweenService:Create(EnBtn,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=Color3.fromRGB(200,55,30)}):Play()
            task.wait(0.9)
            TweenService:Create(EnBtn,TweenInfo.new(0.9,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=C.acc2}):Play()
            task.wait(0.9)
        end
    end)

    -- ── KEY VALIDIERUNG ──
    local function tryKey(raw)
        local kType = checkKey(raw)
        if kType then
            playSnd(4590662766,0.8,1.2)
            EnBtn.Text=S.check.."  KEY AKZEPTIERT!"
            EnBtn.BackgroundColor3=C.green
            StLbl.TextColor3=C.green
            StLbl.Text=S.star.." Gespeichert für 24 Stunden!"
            LL.Text=S.unlock
            TweenService:Create(LBS,TweenInfo.new(0.3),{Color=C.green}):Play()
            TweenService:Create(LB,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                Size=UDim2.new(0,54,0,54),Position=UDim2.new(0.5,-27,0,-27)
            }):Play()

            saveKey(raw:upper():gsub("%s+",""))

            task.wait(1.0)

            -- Flash
            local fl=Instance.new("Frame",GUI) fl.Size=UDim2.new(1,0,1,0) fl.BackgroundColor3=Color3.new(1,1,1) fl.BackgroundTransparency=0.4 fl.ZIndex=200 fl.BorderSizePixel=0
            TweenService:Create(fl,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
            game:GetService("Debris"):AddItem(fl,1)

            TweenService:Create(KS,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
                Position=UDim2.new(0,0,-1,0)
            }):Play()
            task.wait(0.55)
            KS.Visible=false KS.Position=UDim2.new(0,0,0,0)
            unlockHub(kType, false)
        else
            uiSnd(0.5)
            EnBtn.Text=S.ban.."  UNGÜLTIGER KEY"
            EnBtn.BackgroundColor3=C.red
            StLbl.TextColor3=C.red
            StLbl.Text=S.cross.." Key ungültig! Website besuchen."

            -- Shake
            local op=InBg.Position
            task.spawn(function()
                for i=1,5 do
                    TweenService:Create(InBg,TweenInfo.new(0.05),{Position=UDim2.new(op.X.Scale,op.X.Offset+(i%2==0 and 7 or -7),op.Y.Scale,op.Y.Offset)}):Play()
                    task.wait(0.06)
                end
                TweenService:Create(InBg,TweenInfo.new(0.1),{Position=op}):Play()
            end)
            TweenService:Create(InSt,TweenInfo.new(0.15),{Color=C.red}):Play()

            task.wait(2.5)
            EnBtn.Text=S.arrow.."  BESTÄTIGEN"
            TweenService:Create(InSt,TweenInfo.new(0.2),{Color=C.off}):Play()
            StLbl.Text=""
        end
    end

    EnBtn.MouseButton1Click:Connect(function() tryKey(KIn.Text) end)
    KIn.FocusLost:Connect(function(e) if e then tryKey(KIn.Text) end end)

    -- Intro Animation
    KB.Position=UDim2.new(0.5,-KW/2,0.62,-KH/2)
    KS.BackgroundTransparency=1
    task.wait(0.15)
    TweenService:Create(KS,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()
    TweenService:Create(KB,TweenInfo.new(0.55,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Position=UDim2.new(0.5,-KW/2,0.5,-KH/2+20)
    }):Play()
end
