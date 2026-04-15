-- SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer

_G.UISound  = true
_G.KillOn   = false
_G.KillId   = 4612365796
_G.KillVol  = 0.7
_G.SpeedOn  = false
_G.SpeedVal = 16
_G.AntiStun = false

------------------------------------------------
-- CUSTOM ZEICHEN (Unicode, keine Emojis)
------------------------------------------------
local S = {
    anchor="⊕", skull="◈", sword="⟁", wave="≋",
    star="✦",   diamond="◆", eye="◉",  cross="✕",
    arrow="➤",  crown="♛", shield="⬡", fire="▲",
    check="✔",  music="♪",  gem="⬟",  spin="⟳",
    target="⊛", ban="⊘",   power="⌁", lock="⊞",
    unlock="⊟", bolt="⚡",  chart="▣", world="⊜",
}

------------------------------------------------
-- WEBSITE (hier deine URL eintragen)
-- Die HTML-Datei "godvalley-keys.html" auf einen
-- kostenlosen Hosting-Dienst hochladen z.B.:
-- https://pages.github.com  oder  https://netlify.com
------------------------------------------------
local KEY_WEBSITE = "godvalleyhub.tiiny.site"

------------------------------------------------
-- KEY VALIDIERUNG
-- Format FREE_: 32 Hex-Zeichen + 8 Hex (Signatur)
-- Wird von der Website generiert
-- Admin Keys: fest eingetragen
------------------------------------------------
local ADMIN_KEYS = {
    ["GODVALLEY-ADMIN-2024"] = true,
    ["GODVALLEY-ADMIN-DEV"]  = true,
}

local function checkKey(raw)
    if not raw or type(raw) ~= "string" then return false end
    local k = raw:upper():gsub("%s+","")
    if ADMIN_KEYS[k] then return "admin" end
    if k:sub(1,5) == "FREE_" then
        local body = k:sub(6)
        -- 40 Zeichen: 32 (rand) + 8 (sig)
        if #body == 40 and body:match("^[A-F0-9]+$") then
            return "user"
        end
    end
    return false
end

------------------------------------------------
-- RESPONSIVE
------------------------------------------------
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local isTablet = UIS.TouchEnabled and UIS.KeyboardEnabled
local GW = isMobile and 300 or isTablet and 360 or 410
local GH = isMobile and 470 or isTablet and 520 or 560
local FL = isMobile and 11 or 13
local FS = isMobile and 9  or 10
local CH = isMobile and 40 or 46
local CHD= isMobile and 50 or 56

------------------------------------------------
-- SOUND HELPERS
------------------------------------------------
local function uiSnd(p)
    if not _G.UISound then return end
    local s=Instance.new("Sound") s.SoundId="rbxassetid://6042053626"
    s.Volume=0.28 s.PlaybackSpeed=p or 1 s.Parent=SoundService
    s:Play() game:GetService("Debris"):AddItem(s,3)
end
local function playSnd(id,vol,p)
    local s=Instance.new("Sound") s.SoundId="rbxassetid://"..tostring(id)
    s.Volume=vol or 1 s.PlaybackSpeed=p or 1 s.Parent=SoundService
    s:Play() game:GetService("Debris"):AddItem(s,6)
end

------------------------------------------------
-- KILL SOUND SETUP
------------------------------------------------
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").Died:Connect(function()
            if _G.KillOn and plr~=LocalPlayer then playSnd(_G.KillId,_G.KillVol,1) end
        end)
    end)
end)
for _,plr in ipairs(Players:GetPlayers()) do
    if plr~=LocalPlayer and plr.Character then
        local h=plr.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Died:Connect(function() if _G.KillOn then playSnd(_G.KillId,_G.KillVol,1) end end) end
    end
end

------------------------------------------------
-- ANTI STUN
------------------------------------------------
local function startAntiStun(on)
    _G.AntiStun=on
    if not on then return end
    task.spawn(function()
        while _G.AntiStun do
            task.wait(0.08)
            local char=LocalPlayer.Character
            if char then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local target=_G.SpeedOn and 28 or _G.SpeedVal
                    if hum.WalkSpeed < target*0.6 then
                        task.wait(0.25)
                        if hum and hum.Parent then hum.WalkSpeed=target end
                    end
                    if hum.JumpPower < 35 then
                        task.wait(0.2)
                        if hum and hum.Parent then hum.JumpPower=50 end
                    end
                end
            end
        end
    end)
end

------------------------------------------------
-- EMOTES
------------------------------------------------
local EMOTES = {
    {sym="♛",name="Verbeugung", id="rbxassetid://507770239"},
    {sym="◆",name="Jubeln",     id="rbxassetid://507770677"},
    {sym="≋",name="Tanzen 1",   id="rbxassetid://507771019"},
    {sym="⊕",name="Tanzen 2",   id="rbxassetid://507776043"},
    {sym="✦",name="Tanzen 3",   id="rbxassetid://507777268"},
    {sym="⟳",name="Lachen",     id="rbxassetid://507770818"},
    {sym="➤",name="Zeigen",     id="rbxassetid://507770453"},
    {sym="⬡",name="Salutieren", id="rbxassetid://3360686446"},
    {sym="⊛",name="Kippen",     id="rbxassetid://3360692915"},
    {sym="◈",name="Atento",     id="rbxassetid://3360686798"},
}
local curEmote=nil
local function playEmote(id)
    local char=LocalPlayer.Character if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local anim=hum and hum:FindFirstChildOfClass("Animator")
    if not anim then return end
    if curEmote then pcall(function() curEmote:Stop() end) curEmote=nil end
    local a=Instance.new("Animation") a.AnimationId=id
    local t=anim:LoadAnimation(a) t:Play() curEmote=t uiSnd(1.3)
    t.Stopped:Connect(function() curEmote=nil a:Destroy() end)
end

------------------------------------------------
-- GRAFIK PRESETS
------------------------------------------------
local function clearFX()
    for _,c in ipairs(Lighting:GetChildren()) do
        if c:IsA("PostEffect") or c:IsA("Atmosphere") then c:Destroy() end
    end
end
local GFX={
    POTATO=function()
        clearFX() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 Lighting.GlobalShadows=false
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material=Enum.Material.Plastic v.Reflectance=0 v.CastShadow=false end
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false end
        end
    end,
    LOW=function() clearFX() settings().Rendering.QualityLevel=Enum.QualityLevel.Level03 Lighting.GlobalShadows=false end,
    MEDIUM=function()
        clearFX() settings().Rendering.QualityLevel=Enum.QualityLevel.Level07 Lighting.GlobalShadows=true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=0.3 b.Size=20 b.Threshold=0.98
    end,
    HIGH=function()
        clearFX() settings().Rendering.QualityLevel=Enum.QualityLevel.Level14 Lighting.GlobalShadows=true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=0.6 b.Size=36 b.Threshold=0.93
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.2 cc.Contrast=0.1
        local sr=Instance.new("SunRaysEffect",Lighting) sr.Intensity=0.08 sr.Spread=0.4
    end,
    ULTRA=function()
        clearFX() settings().Rendering.QualityLevel=Enum.QualityLevel.Level21 Lighting.GlobalShadows=true Lighting.Brightness=2.5
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=1.2 b.Size=56 b.Threshold=0.85
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.4 cc.Contrast=0.2 cc.Brightness=0.05
        local sr=Instance.new("SunRaysEffect",Lighting) sr.Intensity=0.15 sr.Spread=0.6
        local a=Instance.new("Atmosphere",Lighting) a.Density=0.35 a.Haze=0.4 a.Glare=0.6 a.Color=Color3.fromRGB(199,210,255)
    end,
    CINEMATIC=function()
        clearFX() settings().Rendering.QualityLevel=Enum.QualityLevel.Level21 Lighting.GlobalShadows=true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=2 b.Size=80 b.Threshold=0.75
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.6 cc.Contrast=0.3 cc.TintColor=Color3.fromRGB(210,220,255)
        local sr=Instance.new("SunRaysEffect",Lighting) sr.Intensity=0.25 sr.Spread=0.8
    end,
    ANIME=function()
        clearFX() settings().Rendering.QualityLevel=Enum.QualityLevel.Level14 Lighting.GlobalShadows=true
        local b=Instance.new("BloomEffect",Lighting) b.Intensity=3 b.Size=100 b.Threshold=0.6
        local cc=Instance.new("ColorCorrectionEffect",Lighting) cc.Saturation=0.8 cc.Contrast=0.25 cc.TintColor=Color3.fromRGB(255,210,230)
    end,
}

------------------------------------------------
-- FARBEN & BILDER
------------------------------------------------
local C={
    bg=Color3.fromRGB(7,7,14),      panel=Color3.fromRGB(13,13,24),
    card=Color3.fromRGB(19,19,34),  cardH=Color3.fromRGB(27,27,48),
    acc=Color3.fromRGB(255,185,50), acc2=Color3.fromRGB(255,75,45),
    green=Color3.fromRGB(75,215,125), red=Color3.fromRGB(255,75,75),
    off=Color3.fromRGB(42,42,62),   text=Color3.fromRGB(238,232,218),
    sub=Color3.fromRGB(135,125,105), white=Color3.new(1,1,1),
    black=Color3.fromRGB(5,5,10),
}
local IMG={
    luffy="rbxassetid://7072085162", zoro="rbxassetid://7072086105",
    jolly="rbxassetid://6031075938",
}

------------------------------------------------
-- SCREEN GUI
------------------------------------------------
local GUI=Instance.new("ScreenGui")
GUI.Name="GodValleyV6" GUI.ResetOnSpawn=false
GUI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
GUI.IgnoreGuiInset=true
GUI.Parent=LocalPlayer:WaitForChild("PlayerGui")

local function spawnPart(parent)
    local p=Instance.new("Frame",parent)
    local sz=math.random(2,5)
    p.Size=UDim2.new(0,sz,0,sz)
    p.Position=UDim2.new(math.random(0,100)/100,0,1.05,0)
    p.BackgroundColor3=math.random(1,2)==1 and C.acc or C.acc2
    p.BackgroundTransparency=0.3 p.BorderSizePixel=0 p.ZIndex=2
    Instance.new("UICorner",p).CornerRadius=UDim.new(1,0)
    TweenService:Create(p,TweenInfo.new(math.random(5,10),Enum.EasingStyle.Linear),{
        Position=UDim2.new(math.random(0,100)/100,0,-0.1,0),BackgroundTransparency=1
    }):Play()
    game:GetService("Debris"):AddItem(p,11)
end

------------------------------------------------
-- OPEN BUTTON (Drag + Click)
------------------------------------------------
local OB=Instance.new("Frame",GUI)
OB.Size=UDim2.new(0,54,0,54) OB.Position=UDim2.new(0,10,0.5,-27)
OB.BackgroundColor3=C.bg OB.BorderSizePixel=0 OB.ZIndex=10 OB.Visible=false
Instance.new("UICorner",OB).CornerRadius=UDim.new(1,0)

local OBS=Instance.new("UIStroke",OB) OBS.Thickness=2.5 OBS.Color=C.acc

local OBImg=Instance.new("ImageLabel",OB)
OBImg.Size=UDim2.new(1,-6,1,-6) OBImg.Position=UDim2.new(0,3,0,3)
OBImg.BackgroundTransparency=1 OBImg.Image=IMG.luffy
OBImg.ScaleType=Enum.ScaleType.Fit OBImg.ZIndex=11
Instance.new("UICorner",OBImg).CornerRadius=UDim.new(1,0)

local OBC=Instance.new("TextButton",OB)
OBC.Size=UDim2.new(1,0,1,0) OBC.BackgroundTransparency=1 OBC.Text="" OBC.ZIndex=12

-- Ring Farb-Animation
task.spawn(function()
    local t=0 while true do t=t+0.03
        OBS.Color=C.acc:Lerp(C.acc2,(math.sin(t)+1)/2) task.wait(0.04)
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

------------------------------------------------
-- MAIN FRAME
------------------------------------------------
local MF=Instance.new("Frame",GUI)
MF.Size=UDim2.new(0,GW,0,GH) MF.Position=UDim2.new(0.5,-GW/2,0.5,-GH/2)
MF.BackgroundColor3=C.bg MF.BorderSizePixel=0 MF.ClipsDescendants=false MF.Visible=false MF.ZIndex=20
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,14)

local MFS=Instance.new("UIStroke",MF) MFS.Thickness=1.5 MFS.Color=C.acc MFS.Transparency=0.25
task.spawn(function() local t=0 while true do t=t+0.025 MFS.Color=C.acc:Lerp(C.acc2,(math.sin(t)+1)/2) task.wait(0.04) end end)

local isOpen=false
local function openMenu()
    isOpen=true MF.Size=UDim2.new(0,0,0,0) MF.Position=UDim2.new(0.5,0,0.5,0) MF.Visible=true uiSnd(1.3)
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

------------------------------------------------
-- BUILD MAIN UI (nach Key)
------------------------------------------------
local function buildUI(keyType)

    -- HEADER
    local Hdr=Instance.new("Frame",MF)
    Hdr.Size=UDim2.new(1,0,0,60) Hdr.BackgroundColor3=C.panel Hdr.BorderSizePixel=0 Hdr.ZIndex=21
    Instance.new("UICorner",Hdr).CornerRadius=UDim.new(0,14)
    do
        local g=Instance.new("UIGradient",Hdr)
        g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(22,8,6)),ColorSequenceKeypoint.new(1,Color3.fromRGB(8,8,20))}) g.Rotation=90
        local j=Instance.new("ImageLabel",Hdr) j.Size=UDim2.new(0,44,0,44) j.Position=UDim2.new(0,9,0.5,-22) j.BackgroundTransparency=1 j.Image=IMG.jolly j.ImageColor3=C.acc j.ZIndex=22
        local ht=Instance.new("TextLabel",Hdr) ht.Size=UDim2.new(0,200,0,22) ht.Position=UDim2.new(0,59,0,10) ht.BackgroundTransparency=1 ht.Text=S.anchor.." GOD VALLEY HUB" ht.Font=Enum.Font.GothamBold ht.TextSize=isMobile and 13 or 15 ht.TextXAlignment=Enum.TextXAlignment.Left ht.ZIndex=22
        Instance.new("UIGradient",ht).Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.acc),ColorSequenceKeypoint.new(1,C.acc2)})
        if keyType=="admin" then
            local b=Instance.new("Frame",Hdr) b.Size=UDim2.new(0,64,0,16) b.Position=UDim2.new(0,59,0,36) b.BackgroundColor3=Color3.fromRGB(40,20,5) b.BorderSizePixel=0 b.ZIndex=22
            Instance.new("UICorner",b).CornerRadius=UDim.new(1,0) Instance.new("UIStroke",b).Color=C.acc
            local bl=Instance.new("TextLabel",b) bl.Size=UDim2.new(1,0,1,0) bl.BackgroundTransparency=1 bl.Text=S.crown.." ADMIN" bl.TextColor3=C.acc bl.Font=Enum.Font.GothamBold bl.TextSize=9 bl.ZIndex=23
        else
            local hs=Instance.new("TextLabel",Hdr) hs.Size=UDim2.new(0,210,0,13) hs.Position=UDim2.new(0,59,0,36) hs.BackgroundTransparency=1 hs.Text="TSB "..S.wave.." v6.0 "..S.wave.." One Piece" hs.TextColor3=C.sub hs.Font=Enum.Font.Gotham hs.TextSize=FS hs.TextXAlignment=Enum.TextXAlignment.Left hs.ZIndex=22
        end
        -- Minimize
        local mb=Instance.new("TextButton",Hdr) mb.Size=UDim2.new(0,24,0,24) mb.Position=UDim2.new(1,-60,0.5,-12) mb.BackgroundColor3=C.acc mb.Text="–" mb.TextColor3=Color3.fromRGB(10,8,4) mb.Font=Enum.Font.GothamBold mb.TextSize=14 mb.ZIndex=23
        Instance.new("UICorner",mb).CornerRadius=UDim.new(1,0)
        -- Close
        local cb=Instance.new("TextButton",Hdr) cb.Size=UDim2.new(0,24,0,24) cb.Position=UDim2.new(1,-30,0.5,-12) cb.BackgroundColor3=C.red cb.Text=S.cross cb.TextColor3=C.white cb.Font=Enum.Font.GothamBold cb.TextSize=11 cb.ZIndex=23
        Instance.new("UICorner",cb).CornerRadius=UDim.new(1,0) cb.MouseButton1Click:Connect(closeMenu)
        local isMin=false
        mb.MouseButton1Click:Connect(function()
            isMin=not isMin uiSnd(isMin and 0.9 or 1.2)
            TweenService:Create(MF,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{Size=isMin and UDim2.new(0,GW,0,60) or UDim2.new(0,GW,0,GH)}):Play()
            mb.Text=isMin and "+" or "–"
        end)
        -- Drag
        local dg,ds,dp
        Hdr.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=true ds=i.Position dp=MF.Position end
        end)
        UIS.InputChanged:Connect(function(i)
            if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local d=i.Position-ds MF.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end end)
    end

    -- TAB BAR
    local TH=isMobile and 36 or 40
    local TO=64+TH+6
    local TB=Instance.new("Frame",MF) TB.Size=UDim2.new(1,-16,0,TH) TB.Position=UDim2.new(0,8,0,64) TB.BackgroundColor3=C.panel TB.BorderSizePixel=0 TB.ZIndex=21
    Instance.new("UICorner",TB).CornerRadius=UDim.new(0,10)
    local TI=Instance.new("Frame",TB) TI.Size=UDim2.new(1,-8,1,-8) TI.Position=UDim2.new(0,4,0,4) TI.BackgroundTransparency=1 TI.ZIndex=22
    local TLL=Instance.new("UIListLayout",TI) TLL.FillDirection=Enum.FillDirection.Horizontal TLL.Padding=UDim.new(0,3) TLL.VerticalAlignment=Enum.VerticalAlignment.Center
    local CH2=Instance.new("Frame",MF) CH2.Size=UDim2.new(1,-16,1,-(TO+8)) CH2.Position=UDim2.new(0,8,0,TO) CH2.BackgroundTransparency=1 CH2.ClipsDescendants=true CH2.BorderSizePixel=0 CH2.ZIndex=21

    local TABS={
        {n="Perf",  l=S.bolt.."Perf"},
        {n="Visual",l=S.eye.."Visual"},
        {n="Battle",l=S.sword.."Battle"},
        {n="Emote", l=S.star.."Emote"},
        {n="Gfx",   l=S.gem.."Gfx"},
    }
    local SFS={} local TBS={} local LOS={} local cur=nil
    local TW=math.floor((GW-24)/#TABS)-3

    for _,t in ipairs(TABS) do
        LOS[t.n]=0
        local sf=Instance.new("ScrollingFrame",CH2)
        sf.Name="SF_"..t.n sf.Size=UDim2.new(1,0,1,0) sf.BackgroundTransparency=1 sf.BorderSizePixel=0
        sf.ScrollBarThickness=isMobile and 3 or 4 sf.ScrollBarImageColor3=C.acc sf.ScrollBarImageTransparency=0.3
        sf.CanvasSize=UDim2.new(0,0,0,0) sf.ScrollingEnabled=true sf.ScrollingDirection=Enum.ScrollingDirection.Y
        sf.ElasticBehavior=Enum.ElasticBehavior.WhenScrollable sf.Visible=false sf.ZIndex=22
        local ll=Instance.new("UIListLayout",sf) ll.Padding=UDim.new(0,5) ll.SortOrder=Enum.SortOrder.LayoutOrder ll.HorizontalAlignment=Enum.HorizontalAlignment.Center
        local lp=Instance.new("UIPadding",sf) lp.PaddingTop=UDim.new(0,5) lp.PaddingBottom=UDim.new(0,12) lp.PaddingLeft=UDim.new(0,2) lp.PaddingRight=UDim.new(0,6)
        ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() sf.CanvasSize=UDim2.new(0,0,0,ll.AbsoluteContentSize.Y+16) end)
        SFS[t.n]=sf

        local btn=Instance.new("Frame",TI) btn.Size=UDim2.new(0,TW,1,0) btn.BackgroundTransparency=1 btn.ZIndex=23
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
    cur="Perf" SFS["Perf"].Visible=true TBS["Perf"].bb.BackgroundTransparency=0 TBS["Perf"].bl.TextColor3=C.acc

    local function gs(n) return SFS[n] end
    local function no(n) LOS[n]=LOS[n]+1 return LOS[n] end

    -- SECTION HEADER
    local function sec(tn,sym,txt)
        local f=Instance.new("Frame",gs(tn)) f.Size=UDim2.new(1,-8,0,22) f.BackgroundColor3=Color3.fromRGB(20,10,5) f.BorderSizePixel=0 f.LayoutOrder=no(tn) f.ZIndex=23
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local bar=Instance.new("Frame",f) bar.Size=UDim2.new(0,3,0,11) bar.Position=UDim2.new(0,7,0.5,-5) bar.BackgroundColor3=C.acc bar.BorderSizePixel=0 bar.ZIndex=24
        Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
        local l=Instance.new("TextLabel",f) l.Size=UDim2.new(1,-18,1,0) l.Position=UDim2.new(0,16,0,0) l.BackgroundTransparency=1 l.Text=sym.."  "..txt l.TextColor3=C.acc l.Font=Enum.Font.GothamBold l.TextSize=FS l.TextXAlignment=Enum.TextXAlignment.Left l.ZIndex=24
    end

    -- TOGGLE
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
    end

    -- DROPDOWN
    local function drp(tn,title,opts,cb)
        local sf=gs(tn)
        local c=Instance.new("Frame",sf) c.Size=UDim2.new(1,-8,0,CH) c.BackgroundColor3=C.card c.BorderSizePixel=0 c.ClipsDescendants=false c.LayoutOrder=no(tn) c.ZIndex=30
        Instance.new("UICorner",c).CornerRadius=UDim.new(0,9)
        local l=Instance.new("TextLabel",c) l.Size=UDim2.new(0.48,0,1,0) l.Position=UDim2.new(0,10,0,0) l.BackgroundTransparency=1 l.Text=title l.TextColor3=C.text l.Font=Enum.Font.GothamBold l.TextSize=FL l.TextXAlignment=Enum.TextXAlignment.Left l.ZIndex=31
        local dW=isMobile and 98 or 112
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

    -- SLIDER
    local function sld(tn,sym,title,mn,mx,def,cb)
        local sf=gs(tn)
        local c=Instance.new("Frame",sf) c.Size=UDim2.new(1,-8,0,isMobile and 50 or 54) c.BackgroundColor3=C.card c.BorderSizePixel=0 c.LayoutOrder=no(tn) c.ZIndex=23
        Instance.new("UICorner",c).CornerRadius=UDim.new(0,9)
        local sl2=Instance.new("TextLabel",c) sl2.Size=UDim2.new(0,20,0,16) sl2.Position=UDim2.new(0,8,0,7) sl2.BackgroundTransparency=1 sl2.Text=sym sl2.TextColor3=C.acc sl2.Font=Enum.Font.GothamBold sl2.TextSize=14 sl2.ZIndex=24
        local tl=Instance.new("TextLabel",c) tl.Size=UDim2.new(0.66,0,0,16) tl.Position=UDim2.new(0,30,0,7) tl.BackgroundTransparency=1 tl.Text=title tl.TextColor3=C.text tl.Font=Enum.Font.GothamBold tl.TextSize=FL tl.TextXAlignment=Enum.TextXAlignment.Left tl.ZIndex=24
        local vl=Instance.new("TextLabel",c) vl.Size=UDim2.new(0,40,0,16) vl.Position=UDim2.new(1,-46,0,7) vl.BackgroundTransparency=1 vl.Text=tostring(def) vl.TextColor3=C.acc vl.Font=Enum.Font.GothamBold vl.TextSize=FL vl.TextXAlignment=Enum.TextXAlignment.Right vl.ZIndex=24
        local tr=Instance.new("Frame",c) tr.Size=UDim2.new(1,-20,0,5) tr.Position=UDim2.new(0,10,0,isMobile and 34 or 37) tr.BackgroundColor3=C.off tr.BorderSizePixel=0 tr.ZIndex=24
        Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
        local fi=Instance.new("Frame",tr) fi.Size=UDim2.new((def-mn)/(mx-mn),0,1,0) fi.BackgroundColor3=C.acc fi.BorderSizePixel=0 fi.ZIndex=25
        Instance.new("UICorner",fi).CornerRadius=UDim.new(1,0)
        local kn=Instance.new("Frame",tr) kn.Size=UDim2.new(0,13,0,13) kn.Position=UDim2.new((def-mn)/(mx-mn),-6,0.5,-6) kn.BackgroundColor3=C.white kn.BorderSizePixel=0 kn.ZIndex=26
        Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)
        local dgs=false
        local btn=Instance.new("TextButton",c) btn.Size=UDim2.new(1,0,1,0) btn.BackgroundTransparency=1 btn.Text="" btn.ZIndex=27
        local function ds(x)
            local r=math.clamp((x-tr.AbsolutePosition.X)/math.max(tr.AbsoluteSize.X,1),0,1)
            local v=math.floor(mn+(mx-mn)*r) fi.Size=UDim2.new(r,0,1,0) kn.Position=UDim2.new(r,-6,0.5,-6) vl.Text=tostring(v) cb(v)
        end
        btn.MouseButton1Down:Connect(function(x) dgs=true ds(x) end)
        UIS.InputChanged:Connect(function(i) if dgs and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then ds(i.Position.X) end end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dgs=false end end)
    end

    ---- PERF ----
    sec("Perf",S.bolt,"PERFORMANCE")
    tog("Perf",S.bolt,"FPS Boost","VFX & Schatten entfernen",function(on)
        Lighting.GlobalShadows=not on
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=not on end
            if v:IsA("BasePart") and on then v.Material=Enum.Material.Plastic v.Reflectance=0 v.CastShadow=false end
        end
    end)
    tog("Perf",S.fire,"Ultra Low","Level 1 max FPS",function(on) settings().Rendering.QualityLevel=on and Enum.QualityLevel.Level01 or Enum.QualityLevel.Level10 end)
    tog("Perf",S.chart,"Auto RAM","Grafik nach RAM",function(on) task.spawn(function() while on and task.wait(5) do local m=Stats:GetTotalMemoryUsageMb() settings().Rendering.QualityLevel=m>2000 and Enum.QualityLevel.Level01 or m>1200 and Enum.QualityLevel.Level05 or Enum.QualityLevel.Level10 end end) end)
    tog("Perf",S.ban,"No Shadows","Schatten aus",function(on) Lighting.GlobalShadows=not on for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.CastShadow=not on end end end)
    tog("Perf",S.ban,"No Particles","Partikel aus",function(on) for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") then v.Enabled=not on end end if on then workspace.DescendantAdded:Connect(function(v) if v:IsA("ParticleEmitter") then v.Enabled=false end end) end end)
    tog("Perf",S.eye,"Anti AFK","Verhindert Kick",function(on) if on then local VU=game:GetService("VirtualUser") LocalPlayer.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end) end end)
    sec("Perf",S.eye,"FPS COUNTER")
    tog("Perf",S.eye,"FPS Anzeige","Counter einblenden",function(on)
        local fl=GUI:FindFirstChild("_FPS")
        if on then
            if not fl then
                fl=Instance.new("Frame",GUI) fl.Name="_FPS" fl.Size=UDim2.new(0,92,0,24) fl.Position=UDim2.new(0,76,0,5) fl.BackgroundColor3=C.panel fl.BorderSizePixel=0 fl.ZIndex=100
                Instance.new("UICorner",fl).CornerRadius=UDim.new(0,7)
                local st=Instance.new("UIStroke",fl) st.Color=C.acc st.Thickness=1 st.Transparency=0.5
                local ft=Instance.new("TextLabel",fl) ft.Size=UDim2.new(1,0,1,0) ft.BackgroundTransparency=1 ft.TextColor3=C.green ft.Font=Enum.Font.GothamBold ft.TextSize=11 ft.ZIndex=101
                task.spawn(function() local last=tick() local fr=0 while fl and fl.Parent do fr=fr+1 if tick()-last>=1 then ft.Text=S.bolt.." "..fr.." FPS" fr=0 last=tick() end RunService.RenderStepped:Wait() end end)
            end
        else if fl then fl:Destroy() end end
    end)

    ---- VISUAL ----
    sec("Visual",S.eye,"VISUAL")
    tog("Visual",S.star,"Full Bright","Max Helligkeit",function(on) Lighting.Ambient=on and Color3.new(1,1,1) or Color3.fromRGB(70,70,70) Lighting.OutdoorAmbient=on and Color3.new(1,1,1) or Color3.fromRGB(100,100,100) Lighting.Brightness=on and 10 or 2 end)
    tog("Visual",S.wave,"No Fog","Nebel entfernen",function(on) Lighting.FogEnd=on and 9e9 or 1000 Lighting.FogStart=on and 9e9 or 0 end)
    tog("Visual",S.ban,"Remove VFX","Partikel, Beams aus",function(on)
        local function cl(o) for _,v in ipairs(o:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=not on end if v:IsA("PointLight") or v:IsA("SpotLight") then v.Enabled=not on end end end
        cl(workspace) if on then workspace.DescendantAdded:Connect(function(o) task.wait() cl(o) end) end
    end)
    tog("Visual",S.diamond,"Neon Enemies","Gegner leuchten",function(on) for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then for _,v in ipairs(p.Character:GetDescendants()) do if v:IsA("BasePart") then v.Material=on and Enum.Material.Neon or Enum.Material.Plastic end end end end end)
    tog("Visual",S.target,"Enemy Highlight","Rahmen um Gegner",function(on) for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local sel=p.Character:FindFirstChild("_EB") if on and not sel then local b=Instance.new("SelectionBox",p.Character) b.Name="_EB" b.Adornee=p.Character b.Color3=C.red b.LineThickness=0.04 b.SurfaceTransparency=0.85 b.SurfaceColor3=C.red elseif not on and sel then sel:Destroy() end end end end)
    tog("Visual",S.anchor,"Name Tags","Namen über Spielern",function(on) for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local r=p.Character:FindFirstChild("HumanoidRootPart") if on and r then local bb=Instance.new("BillboardGui",r) bb.Name="_NT" bb.Size=UDim2.new(0,130,0,24) bb.StudsOffset=Vector3.new(0,3,0) bb.AlwaysOnTop=true local tl=Instance.new("TextLabel",bb) tl.Size=UDim2.new(1,0,1,0) tl.BackgroundTransparency=1 tl.Text=S.sword.." "..p.Name tl.TextColor3=C.acc tl.Font=Enum.Font.GothamBold tl.TextScaled=true elseif not on then local t=r and r:FindFirstChild("_NT") if t then t:Destroy() end end end end end)

    ---- BATTLE ----
    sec("Battle",S.sword,"KAMPF FEATURES")
    tog("Battle",S.shield,"Anti Stun","Verhindert Stun-Effekte",function(on) startAntiStun(on) end)
    tog("Battle",S.bolt,"Speed Boost","WalkSpeed auf 28",function(on)
        _G.SpeedOn=on
        local char=LocalPlayer.Character
        if char then local h=char:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=on and 28 or _G.SpeedVal end end
    end)
    sld("Battle",S.arrow,"Custom Speed",16,60,16,function(val)
        _G.SpeedVal=val
        local char=LocalPlayer.Character
        if char then local h=char:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=val task.defer(function() if h and h.Parent then h.WalkSpeed=val end end) end end
    end)
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        local h=char:FindFirstChildOfClass("Humanoid")
        if h then if _G.SpeedOn then h.WalkSpeed=28 elseif _G.SpeedVal~=16 then h.WalkSpeed=_G.SpeedVal end end
    end)
    tog("Battle",S.eye,"Max Zoom","Kamera rauszoomen",function(on) LocalPlayer.CameraMaxZoomDistance=on and 200 or 30 end)
    tog("Battle",S.world,"No Clip","Durch Wände gehen",function(on) RunService.Stepped:Connect(function() if on and LocalPlayer.Character then for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end end) end)
    sec("Battle",S.music,"KILL SOUNDS")
    tog("Battle",S.music,"Kill Sound","Click bei Kill",function(on) _G.KillOn=on _G.KillId=4612365796 end)
    tog("Battle",S.star,"Goat Sound","Ziege bei Kill",function(on) _G.KillOn=on _G.KillId=135017578 end)
    tog("Battle",S.wave,"Bruh Sound","Bruh bei Kill",function(on) _G.KillOn=on _G.KillId=1444622487 end)
    tog("Battle",S.diamond,"MLG Airhorn","MLG bei Kill",function(on) _G.KillOn=on _G.KillId=135946816 end)
    tog("Battle",S.anchor,"Vine Boom","Vine bei Kill",function(on) _G.KillOn=on _G.KillId=5153644985 end)
    sld("Battle",S.music,"Kill Lautstärke",1,10,7,function(v) _G.KillVol=v*0.1 end)
    sec("Battle",S.target,"EXTRA")
    tog("Battle",S.shield,"Low HP Alarm","Alarm bei wenig HP",function(on) task.spawn(function() while on and task.wait(1) do local c=LocalPlayer.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h and h.Health<30 and h.Health>0 then playSnd(131961136,1,1) end end end end) end)
    tog("Battle",S.ban,"UI Sounds aus","Click-Sounds aus",function(on) _G.UISound=not on end)

    ---- EMOTE ----
    sec("Emote",S.star,"EMOTES")
    do
        local sf=gs("Emote")
        local sc=Instance.new("TextButton",sf) sc.Size=UDim2.new(1,-8,0,CH) sc.BackgroundColor3=Color3.fromRGB(28,10,10) sc.BorderSizePixel=0 sc.LayoutOrder=no("Emote") sc.Text="" sc.AutoButtonColor=false sc.ZIndex=23
        Instance.new("UICorner",sc).CornerRadius=UDim.new(0,9)
        local ssk=Instance.new("UIStroke",sc) ssk.Color=C.red ssk.Thickness=1 ssk.Transparency=0.5
        local sl3=Instance.new("TextLabel",sc) sl3.Size=UDim2.new(1,0,1,0) sl3.BackgroundTransparency=1 sl3.Text=S.cross.."  EMOTE STOPPEN" sl3.TextColor3=C.red sl3.Font=Enum.Font.GothamBold sl3.TextSize=FL sl3.ZIndex=24
        sc.MouseButton1Click:Connect(function() if curEmote then pcall(function() curEmote:Stop() end) curEmote=nil end uiSnd(0.8) end)
        sec("Emote",S.anchor,"EMOTE AUSWÄHLEN")
        local eg=Instance.new("Frame",sf) eg.Size=UDim2.new(1,-8,0,0) eg.BackgroundTransparency=1 eg.BorderSizePixel=0 eg.LayoutOrder=no("Emote") eg.ZIndex=22 eg.AutomaticSize=Enum.AutomaticSize.Y
        local egl=Instance.new("UIGridLayout",eg) egl.CellSize=UDim2.new(0.48,-4,0,CH+10) egl.CellPadding=UDim2.new(0,6,0,6) egl.HorizontalAlignment=Enum.HorizontalAlignment.Center
        for _,em in ipairs(EMOTES) do
            local b=Instance.new("TextButton",eg) b.Size=UDim2.new(1,0,1,0) b.BackgroundColor3=C.card b.BorderSizePixel=0 b.Text="" b.AutoButtonColor=false b.ZIndex=23
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,9)
            local bsk=Instance.new("UIStroke",b) bsk.Color=C.acc bsk.Thickness=1 bsk.Transparency=1
            local bsm=Instance.new("TextLabel",b) bsm.Size=UDim2.new(1,0,0,26) bsm.Position=UDim2.new(0,0,0,4) bsm.BackgroundTransparency=1 bsm.Text=em.sym bsm.TextColor3=C.acc bsm.Font=Enum.Font.GothamBold bsm.TextSize=20 bsm.ZIndex=24
            local bnm=Instance.new("TextLabel",b) bnm.Size=UDim2.new(1,-4,0,13) bnm.Position=UDim2.new(0,2,1,-16) bnm.BackgroundTransparency=1 bnm.Text=em.name bnm.TextColor3=C.sub bnm.Font=Enum.Font.Gotham bnm.TextSize=FS bnm.ZIndex=24
            b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.14),{BackgroundColor3=C.cardH}):Play() TweenService:Create(bsk,TweenInfo.new(0.14),{Transparency=0.55}):Play() end)
            b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.14),{BackgroundColor3=C.card}):Play() TweenService:Create(bsk,TweenInfo.new(0.14),{Transparency=1}):Play() end)
            local eid=em.id
            b.MouseButton1Click:Connect(function()
                playEmote(eid)
                TweenService:Create(bsm,TweenInfo.new(0.1),{TextColor3=C.green}):Play()
                TweenService:Create(b,TweenInfo.new(0.1,Enum.EasingStyle.Back),{Size=UDim2.new(0.95,0,0.92,0)}):Play()
                task.wait(0.12)
                TweenService:Create(b,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0)}):Play()
                task.wait(0.35) TweenService:Create(bsm,TweenInfo.new(0.3),{TextColor3=C.acc}):Play()
            end)
        end
    end

    ---- GFX ----
    sec("Gfx",S.gem,"PRESET")
    drp("Gfx",S.gem.." Preset",{"POTATO","LOW","MEDIUM","HIGH","ULTRA","CINEMATIC","ANIME"},function(s) if GFX[s] then GFX[s]() end end)
    sec("Gfx",S.star,"EFFEKTE")
    tog("Gfx",S.star,"Bloom","Glow-Effekt",function(on) local b=Lighting:FindFirstChildOfClass("BloomEffect") if on then if not b then b=Instance.new("BloomEffect",Lighting) end b.Intensity=0.8 b.Size=40 b.Threshold=0.9 elseif b then b:Destroy() end end)
    sld("Gfx",S.star,"Bloom Stärke",1,20,4,function(v) local b=Lighting:FindFirstChildOfClass("BloomEffect") if b then b.Intensity=v*0.15 end end)
    tog("Gfx",S.bolt,"Sun Rays","Sonnenstrahlen",function(on) local sr=Lighting:FindFirstChildOfClass("SunRaysEffect") if on then if not sr then sr=Instance.new("SunRaysEffect",Lighting) end sr.Intensity=0.15 sr.Spread=0.6 elseif sr then sr:Destroy() end end)
    tog("Gfx",S.diamond,"Color Grading","Farb-Korrektur",function(on) local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect") if on then if not cc then cc=Instance.new("ColorCorrectionEffect",Lighting) end cc.Saturation=0.35 cc.Contrast=0.2 cc.Brightness=0.05 elseif cc then cc:Destroy() end end)
    sld("Gfx",S.wave,"Saturation",0,10,3,function(v) local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect") if cc then cc.Saturation=v*0.1 end end)
    tog("Gfx",S.eye,"Depth of Field","Tiefenschärfe",function(on) local d=Lighting:FindFirstChildOfClass("DepthOfFieldEffect") if on then if not d then d=Instance.new("DepthOfFieldEffect",Lighting) end d.FarIntensity=0.3 d.NearIntensity=0.1 d.FocusDistance=40 d.InFocusRadius=20 elseif d then d:Destroy() end end)
    sld("Gfx",S.star,"Helligkeit",1,10,2,function(v) Lighting.Brightness=v*0.5 end)
    sld("Gfx",S.chart,"Quality Level",1,21,10,function(v) settings().Rendering.QualityLevel=v end)
end

------------------------------------------------
-- KEY SCREEN
------------------------------------------------
local KS=Instance.new("Frame",GUI)
KS.Size=UDim2.new(1,0,1,0) KS.BackgroundColor3=C.black KS.ZIndex=50 KS.BorderSizePixel=0 KS.Visible=true

task.spawn(function() while KS.Visible do spawnPart(KS) task.wait(0.25) end end)

local KG=Instance.new("UIGradient",KS)
KG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(10,5,20)),ColorSequenceKeypoint.new(1,Color3.fromRGB(5,5,12))}) KG.Rotation=135

-- Floating Characters
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

local KTit=Instance.new("TextLabel",KS)
KTit.Size=UDim2.new(0.8,0,0,40) KTit.Position=UDim2.new(0.1,0,0,isMobile and 55 or 70)
KTit.BackgroundTransparency=1 KTit.Text=S.anchor.."  GOD VALLEY HUB  "..S.anchor
KTit.Font=Enum.Font.GothamBold KTit.TextSize=isMobile and 20 or 26 KTit.ZIndex=52
Instance.new("UIGradient",KTit).Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.acc),ColorSequenceKeypoint.new(1,C.acc2)})

local KSub=Instance.new("TextLabel",KS)
KSub.Size=UDim2.new(0.8,0,0,18) KSub.Position=UDim2.new(0.1,0,0,isMobile and 100 or 118)
KSub.BackgroundTransparency=1 KSub.Text=S.wave.." The Strongest Battleground "..S.wave.." One Piece Edition"
KSub.TextColor3=C.sub KSub.Font=Enum.Font.Gotham KSub.TextSize=isMobile and 10 or 12 KSub.ZIndex=52

-- KEY BOX
local KW=isMobile and 280 or 355
local KH=isMobile and 250 or 280
local KB=Instance.new("Frame",KS)
KB.Size=UDim2.new(0,KW,0,KH) KB.Position=UDim2.new(0.5,-KW/2,0.5,-KH/2+20)
KB.BackgroundColor3=C.panel KB.BorderSizePixel=0 KB.ZIndex=52
Instance.new("UICorner",KB).CornerRadius=UDim.new(0,16)

local KBS=Instance.new("UIStroke",KB) KBS.Thickness=1.5 KBS.Color=C.acc KBS.Transparency=0.3
task.spawn(function() local t=0 while KS.Visible do t=t+0.025 KBS.Color=C.acc:Lerp(C.acc2,(math.sin(t)+1)/2) task.wait(0.04) end end)

-- Lock Icon
local LB=Instance.new("Frame",KB) LB.Size=UDim2.new(0,44,0,44) LB.Position=UDim2.new(0.5,-22,0,-22) LB.BackgroundColor3=C.panel LB.BorderSizePixel=0 LB.ZIndex=54
Instance.new("UICorner",LB).CornerRadius=UDim.new(1,0)
local LBS=Instance.new("UIStroke",LB) LBS.Color=C.acc LBS.Thickness=1.5
local LL=Instance.new("TextLabel",LB) LL.Size=UDim2.new(1,0,1,0) LL.BackgroundTransparency=1 LL.Text=S.lock LL.TextScaled=true LL.ZIndex=55

-- Titel
local KBT=Instance.new("TextLabel",KB) KBT.Size=UDim2.new(1,-20,0,24) KBT.Position=UDim2.new(0,10,0,18) KBT.BackgroundTransparency=1 KBT.Text=S.crown.."  KEY SYSTEM" KBT.TextColor3=C.text KBT.Font=Enum.Font.GothamBold KBT.TextSize=isMobile and 13 or 15 KBT.ZIndex=53
local KBD=Instance.new("TextLabel",KB) KBD.Size=UDim2.new(1,-20,0,20) KBD.Position=UDim2.new(0,10,0,44) KBD.BackgroundTransparency=1 KBD.Text="Hol dir deinen Key auf der Website." KBD.TextColor3=C.sub KBD.Font=Enum.Font.Gotham KBD.TextSize=isMobile and 9 or 10 KBD.ZIndex=53

-- ═══ WEBSITE BUTTON ═══
-- Öffnet die Key-Website im Browser
local WBtn=Instance.new("TextButton",KB)
WBtn.Size=UDim2.new(1,-20,0,isMobile and 34 or 38) WBtn.Position=UDim2.new(0,10,0,70)
WBtn.BackgroundColor3=Color3.fromRGB(18,10,4) WBtn.TextColor3=C.acc
WBtn.Font=Enum.Font.GothamBold WBtn.TextSize=isMobile and 10 or 11
WBtn.Text=S.anchor.."  Website öffnen  "..S.arrow.."  Key holen" WBtn.ZIndex=53
Instance.new("UICorner",WBtn).CornerRadius=UDim.new(0,9)
local WBS=Instance.new("UIStroke",WBtn) WBS.Color=C.acc WBS.Thickness=1.2 WBS.Transparency=0.3

-- Pulsing Animation auf Website Button
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
    -- Kopiert URL in Zwischenablage (Roblox kann keine Browser öffnen)
    pcall(function() setclipboard(KEY_WEBSITE) end)
    local orig=WBtn.Text
    WBtn.Text=S.check.."  Link kopiert! Im Browser öffnen"
    WBtn.TextColor3=C.green
    task.wait(2.5)
    WBtn.Text=orig WBtn.TextColor3=C.acc
end)

-- Schritt-Anzeige
local StepsLbl=Instance.new("TextLabel",KB)
StepsLbl.Size=UDim2.new(1,-20,0,36) StepsLbl.Position=UDim2.new(0,10,0,114)
StepsLbl.BackgroundTransparency=1
StepsLbl.Text=S.diamond.." 1. Website öffnen\n"..S.arrow.." 2. Aufgaben abschließen\n"..S.check.." 3. Key kopieren & hier eingeben"
StepsLbl.TextColor3=C.sub StepsLbl.Font=Enum.Font.Gotham StepsLbl.TextSize=isMobile and 8 or 9
StepsLbl.TextWrapped=true StepsLbl.TextXAlignment=Enum.TextXAlignment.Left StepsLbl.ZIndex=53

-- Input Feld
local InBg=Instance.new("Frame",KB)
InBg.Size=UDim2.new(1,-20,0,isMobile and 32 or 36) InBg.Position=UDim2.new(0,10,0,156)
InBg.BackgroundColor3=C.card InBg.BorderSizePixel=0 InBg.ZIndex=53
Instance.new("UICorner",InBg).CornerRadius=UDim.new(0,9)
local InSt=Instance.new("UIStroke",InBg) InSt.Color=C.off InSt.Thickness=1.5

local KIn=Instance.new("TextBox",InBg)
KIn.Size=UDim2.new(1,-16,1,0) KIn.Position=UDim2.new(0,8,0,0)
KIn.BackgroundTransparency=1 KIn.PlaceholderText=S.lock.." FREE_... oder ADMIN Key eingeben"
KIn.PlaceholderColor3=C.sub KIn.Text="" KIn.TextColor3=C.text
KIn.Font=Enum.Font.Gotham KIn.TextSize=isMobile and 9 or 11 KIn.ClearTextOnFocus=false KIn.ZIndex=54

KIn.Focused:Connect(function() TweenService:Create(InSt,TweenInfo.new(0.2),{Color=C.acc}):Play() end)
KIn.FocusLost:Connect(function() TweenService:Create(InSt,TweenInfo.new(0.2),{Color=C.off}):Play() end)

local StLbl=Instance.new("TextLabel",KB) StLbl.Size=UDim2.new(1,-20,0,13) StLbl.Position=UDim2.new(0,10,0,194) StLbl.BackgroundTransparency=1 StLbl.Text="" StLbl.TextColor3=C.red StLbl.Font=Enum.Font.Gotham StLbl.TextSize=FS StLbl.ZIndex=53

local EnBtn=Instance.new("TextButton",KB)
EnBtn.Size=UDim2.new(1,-20,0,isMobile and 30 or 34) EnBtn.Position=UDim2.new(0,10,0,210)
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

------------------------------------------------
-- KEY VALIDIERUNG + UNLOCK
------------------------------------------------
local function tryKey(raw)
    local kType=checkKey(raw)
    if kType then
        playSnd(4590662766,0.8,1.2)
        EnBtn.Text=S.check.."  KEY AKZEPTIERT!"
        EnBtn.BackgroundColor3=C.green
        StLbl.TextColor3=C.green
        StLbl.Text=S.star.." Willkommen! Zugang gewährt."
        LL.Text=S.unlock
        TweenService:Create(LBS,TweenInfo.new(0.3),{Color=C.green}):Play()
        TweenService:Create(LB,TweenInfo.new(0.3,Enum.EasingStyle.Back),{
            Size=UDim2.new(0,52,0,52), Position=UDim2.new(0.5,-26,0,-28)
        }):Play()

        task.wait(1.0)

        -- Weißer Flash
        local fl=Instance.new("Frame",GUI) fl.Size=UDim2.new(1,0,1,0) fl.BackgroundColor3=Color3.new(1,1,1) fl.BackgroundTransparency=0.4 fl.ZIndex=200 fl.BorderSizePixel=0
        TweenService:Create(fl,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
        game:GetService("Debris"):AddItem(fl,1)

        -- Key Screen wegfahren
        TweenService:Create(KS,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{
            Position=UDim2.new(0,0,-1,0)
        }):Play()
        task.wait(0.55)
        KS.Visible=false KS.Position=UDim2.new(0,0,0,0)

        -- Haupt UI bauen
        buildUI(kType)

        -- Open Button einblenden
        OB.Visible=true OB.Size=UDim2.new(0,0,0,0) OB.Position=UDim2.new(0,0,0.5,0)
        TweenService:Create(OB,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Size=UDim2.new(0,54,0,54),Position=UDim2.new(0,10,0.5,-27)
        }):Play()

        -- Toast
        local tw=isMobile and 240 or 265
        local toast=Instance.new("Frame",GUI) toast.Size=UDim2.new(0,tw,0,54) toast.Position=UDim2.new(0.5,-tw/2,1,10) toast.BackgroundColor3=C.panel toast.BorderSizePixel=0 toast.ZIndex=200
        Instance.new("UICorner",toast).CornerRadius=UDim.new(0,11)
        Instance.new("UIStroke",toast).Color=C.green
        local tI=Instance.new("ImageLabel",toast) tI.Size=UDim2.new(0,40,0,46) tI.Position=UDim2.new(0,5,0.5,-23) tI.BackgroundTransparency=1 tI.Image=IMG.luffy tI.ZIndex=201
        local tT=Instance.new("TextLabel",toast) tT.Size=UDim2.new(1,-52,0,18) tT.Position=UDim2.new(0,50,0,7) tT.BackgroundTransparency=1 tT.Text=S.anchor.." GOD VALLEY HUB v6.0" tT.TextColor3=C.acc tT.Font=Enum.Font.GothamBold tT.TextSize=isMobile and 11 or 12 tT.TextXAlignment=Enum.TextXAlignment.Left tT.ZIndex=201
        local tS2=Instance.new("TextLabel",toast) tS2.Size=UDim2.new(1,-52,0,13) tS2.Position=UDim2.new(0,50,0,27) tS2.BackgroundTransparency=1 tS2.Text=kType=="admin" and (S.crown.." Admin Zugang aktiviert!") or (S.check.." Zugang gewährt!") tS2.TextColor3=C.green tS2.Font=Enum.Font.Gotham tS2.TextSize=isMobile and 9 or 10 tS2.TextXAlignment=Enum.TextXAlignment.Left tS2.ZIndex=201
        TweenService:Create(toast,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,-tw/2,1,-64)}):Play()
        task.delay(4,function()
            TweenService:Create(toast,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Position=UDim2.new(0.5,-tw/2,1,10)}):Play()
            task.wait(0.4) pcall(function() toast:Destroy() end)
        end)
    else
        uiSnd(0.5)
        EnBtn.Text=S.ban.."  UNGÜLTIGER KEY"
        EnBtn.BackgroundColor3=C.red
        StLbl.TextColor3=C.red
        StLbl.Text=S.cross.." Ungültig! Hole deinen Key auf der Website."
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
KB.Position=UDim2.new(0.5,-KW/2,0.6,-KH/2)
KS.BackgroundTransparency=1
task.wait(0.2)
TweenService:Create(KS,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()
TweenService:Create(KB,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Position=UDim2.new(0.5,-KW/2,0.5,-KH/2+20)
}):Play()