local LawXW = {}
LawXW.__index = LawXW

local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService= game:GetService("UserInputService")
local CoreGui         = game:GetService("CoreGui")
local LocalPlayer     = Players.LocalPlayer

local C = {
    Bg          = Color3.fromRGB(8,   8,   8),
    Panel       = Color3.fromRGB(13,  13,  13),
    Surface     = Color3.fromRGB(20,  20,  20),
    SurfHov     = Color3.fromRGB(26,  26,  26),
    Border      = Color3.fromRGB(38,  38,  38),
    Accent      = Color3.fromRGB(255,255,255),
    AccentDim   = Color3.fromRGB(155,155,155),
    TextMain    = Color3.fromRGB(232,232,232),
    TextSub     = Color3.fromRGB(100,100,100),
    TogOn       = Color3.fromRGB(205,205,205),
    TogOff      = Color3.fromRGB(38,  38,  38),
    SlFill      = Color3.fromRGB(185,185,185),
    SlBg        = Color3.fromRGB(28,  28,  28),
    DropBg      = Color3.fromRGB(14,  14,  14),
    DropHov     = Color3.fromRGB(24,  24,  24),
    NotifBg     = Color3.fromRGB(13,  13,  13),
    Font        = Enum.Font.GothamBold,
    FontReg     = Enum.Font.Gotham,
    WinW        = 500,
    WinH        = 370,
    SideW       = 108,
    TabH        = 36,
    ItemH       = 40,
    Spd         = 0.16,
    Key         = Enum.KeyCode.RightShift,
}

local Cfg = {}

local function tw(o, p, t, s, d)
    TweenService:Create(o, TweenInfo.new(t or C.Spd, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out), p):Play()
end
local function rnd(o, r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=o return c end
local function brd(o, col, th) local s=Instance.new("UIStroke") s.Color=col or C.Border s.Thickness=th or 1 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=o return s end
local function shd(parent)
    local s=Instance.new("ImageLabel") s.Name="_shd" s.AnchorPoint=Vector2.new(0.5,0.5)
    s.BackgroundTransparency=1 s.Position=UDim2.new(0.5,0,0.5,6) s.Size=UDim2.new(1,40,1,40)
    s.ZIndex=(parent.ZIndex or 1)-1 s.Image="rbxassetid://6014261993"
    s.ImageColor3=Color3.new(0,0,0) s.ImageTransparency=0.5 s.ScaleType=Enum.ScaleType.Slice
    s.SliceCenter=Rect.new(49,49,450,450) s.Parent=parent return s
end
local function frm(parent, bg, size, pos, zi)
    local f=Instance.new("Frame") f.BackgroundColor3=bg or C.Surface f.BorderSizePixel=0
    f.Size=size or UDim2.new(1,0,0,40) if pos then f.Position=pos end if zi then f.ZIndex=zi end f.Parent=parent return f
end
local function scr(parent, size, zi)
    local sf=Instance.new("ScrollingFrame") sf.BackgroundTransparency=1 sf.BorderSizePixel=0
    sf.Size=size or UDim2.new(1,0,1,0) sf.ScrollBarThickness=2
    sf.ScrollBarImageColor3=Color3.fromRGB(50,50,50) sf.CanvasSize=UDim2.new(0,0,0,0)
    sf.AutomaticCanvasSize=Enum.AutomaticSize.Y sf.ScrollingDirection=Enum.ScrollingDirection.Y
    sf.ElasticBehavior=Enum.ElasticBehavior.Never if zi then sf.ZIndex=zi end sf.Parent=parent return sf
end
local function lst(parent, sp)
    local l=Instance.new("UIListLayout") l.FillDirection=Enum.FillDirection.Vertical
    l.SortOrder=Enum.SortOrder.LayoutOrder l.Padding=UDim.new(0,sp or 4) l.Parent=parent return l
end
local function pdg(parent, t, b, l, r)
    local p=Instance.new("UIPadding") p.PaddingTop=UDim.new(0,t or 0) p.PaddingBottom=UDim.new(0,b or 0)
    p.PaddingLeft=UDim.new(0,l or 0) p.PaddingRight=UDim.new(0,r or 0) p.Parent=parent return p
end
local function txl(parent, text, size, color, font, xalign, zi, pos, sz)
    local l=Instance.new("TextLabel") l.BackgroundTransparency=1 l.Text=text or ""
    l.TextSize=size or 13 l.TextColor3=color or C.TextMain l.Font=font or C.FontReg
    l.TextXAlignment=xalign or Enum.TextXAlignment.Left l.AutomaticSize=Enum.AutomaticSize.XY
    if zi then l.ZIndex=zi end if pos then l.Position=pos end if sz then l.Size=sz l.AutomaticSize=Enum.AutomaticSize.None end
    l.Parent=parent return l
end

-- Notif system
local NH = nil
local function ensureNH()
    if NH and NH.Parent then return end
    local sg=Instance.new("ScreenGui") sg.Name="LXW_N" sg.ResetOnSpawn=false
    sg.DisplayOrder=9999 sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    pcall(function() sg.Parent=CoreGui end) if not sg.Parent then sg.Parent=LocalPlayer.PlayerGui end
    NH=frm(sg,Color3.new(0,0,0),UDim2.new(0,280,1,-32),UDim2.new(1,-296,0,16),1)
    NH.BackgroundTransparency=1
    local ll=Instance.new("UIListLayout") ll.FillDirection=Enum.FillDirection.Vertical
    ll.SortOrder=Enum.SortOrder.LayoutOrder ll.Padding=UDim.new(0,8) ll.Parent=NH
end

function LawXW:Notify(title, body, dur)
    ensureNH() dur=dur or 4
    local nf=frm(NH,C.NotifBg,UDim2.new(1,0,0,60),nil,2) nf.BackgroundTransparency=1
    rnd(nf,8) brd(nf,C.Border)
    local ab=frm(nf,C.Accent,UDim2.new(0,2,0.65,0),UDim2.new(0,0,0.175,0),3) rnd(ab,2)
    local tl=Instance.new("TextLabel") tl.BackgroundTransparency=1 tl.Position=UDim2.new(0,12,0,10)
    tl.Size=UDim2.new(1,-18,0,16) tl.Text=title or "" tl.TextColor3=C.TextMain tl.TextSize=13
    tl.Font=C.Font tl.TextXAlignment=Enum.TextXAlignment.Left tl.ZIndex=3
    tl.TextTransparency=1 tl.TextTruncate=Enum.TextTruncate.AtEnd tl.Parent=nf
    local bl=Instance.new("TextLabel") bl.BackgroundTransparency=1 bl.Position=UDim2.new(0,12,0,29)
    bl.Size=UDim2.new(1,-18,0,22) bl.Text=body or "" bl.TextColor3=C.TextSub bl.TextSize=11
    bl.Font=C.FontReg bl.TextXAlignment=Enum.TextXAlignment.Left bl.ZIndex=3 bl.TextWrapped=true
    bl.TextTransparency=1 bl.TextTruncate=Enum.TextTruncate.AtEnd bl.Parent=nf
    tw(nf,{BackgroundTransparency=0},0.2) tw(tl,{TextTransparency=0},0.2) tw(bl,{TextTransparency=0},0.2)
    task.delay(dur,function()
        tw(nf,{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0)},0.25)
        tw(tl,{TextTransparency=1},0.18) tw(bl,{TextTransparency=1},0.18)
        task.delay(0.3,function() nf:Destroy() end)
    end)
end

function LawXW:SaveConfig(name, data)
    Cfg[name]=data
    pcall(function()
        if not isfolder("LawXW") then makefolder("LawXW") end
        writefile("LawXW/"..name..".json", game:GetService("HttpService"):JSONEncode(data))
    end)
end
function LawXW:LoadConfig(name)
    if Cfg[name] then return Cfg[name] end
    local ok,r=pcall(function() return game:GetService("HttpService"):JSONDecode(readfile("LawXW/"..name..".json")) end)
    return ok and r or nil
end

function LawXW:CreateWindow(opts)
    opts = opts or {}
    local title   = opts.Title    or "Law-XW"
    local sub     = opts.Subtitle or ""
    local togKey  = opts.ToggleKey or C.Key

    local sg=Instance.new("ScreenGui") sg.Name="LXW_"..title sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling sg.DisplayOrder=100 sg.IgnoreGuiInset=true
    pcall(function() sg.Parent=CoreGui end) if not sg.Parent then sg.Parent=LocalPlayer.PlayerGui end

    -- Loading Screen
    local Load=frm(sg,Color3.fromRGB(5,5,5),UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),200)
    local lc=frm(Load,Color3.new(0,0,0),UDim2.new(0,220,0,80),nil,201)
    lc.BackgroundTransparency=1 lc.AnchorPoint=Vector2.new(0.5,0.5) lc.Position=UDim2.new(0.5,0,0.5,0)
    local lTitle=Instance.new("TextLabel") lTitle.BackgroundTransparency=1 lTitle.Size=UDim2.new(1,0,0,28)
    lTitle.Text="LAW-XW" lTitle.TextColor3=Color3.new(1,1,1) lTitle.TextSize=24 lTitle.Font=C.Font
    lTitle.TextXAlignment=Enum.TextXAlignment.Center lTitle.TextTransparency=1 lTitle.ZIndex=202 lTitle.Parent=lc
    local lSub=Instance.new("TextLabel") lSub.BackgroundTransparency=1 lSub.Size=UDim2.new(1,0,0,14)
    lSub.Position=UDim2.new(0,0,0,33) lSub.Text="Loading Law-XW..." lSub.TextColor3=C.TextSub
    lSub.TextSize=10 lSub.Font=C.FontReg lSub.TextXAlignment=Enum.TextXAlignment.Center
    lSub.TextTransparency=1 lSub.ZIndex=202 lSub.Parent=lc
    local lBarBg=frm(lc,Color3.fromRGB(22,22,22),UDim2.new(1,0,0,3),UDim2.new(0,0,0,58),202)
    lBarBg.BackgroundTransparency=1 rnd(lBarBg,2)
    local lBar=frm(lBarBg,Color3.fromRGB(200,200,200),UDim2.new(0,0,1,0),nil,203) rnd(lBar,2)
    task.spawn(function()
        task.wait(0.1) tw(lTitle,{TextTransparency=0},0.45) tw(lSub,{TextTransparency=0},0.45) tw(lBarBg,{BackgroundTransparency=0},0.45)
        task.wait(0.5) tw(lBar,{Size=UDim2.new(0.6,0,1,0)},0.55,Enum.EasingStyle.Quart)
        task.wait(0.65) tw(lBar,{Size=UDim2.new(1,0,1,0)},0.35,Enum.EasingStyle.Quart)
        task.wait(0.45) tw(Load,{BackgroundTransparency=1},0.38) tw(lTitle,{TextTransparency=1},0.22) tw(lSub,{TextTransparency=1},0.22)
        task.wait(0.42) Load:Destroy()
    end)

    -- Window
    local Win=frm(sg,C.Bg,UDim2.new(0,C.WinW,0,C.WinH),nil,10)
    Win.AnchorPoint=Vector2.new(0.5,0.5) Win.Position=UDim2.new(0.5,0,0.5,0)
    Win.ClipsDescendants=false Win.BackgroundTransparency=1
    rnd(Win,10) brd(Win,C.Border) shd(Win)
    local WinClip=frm(Win,C.Bg,UDim2.new(1,0,1,0),nil,10) WinClip.ClipsDescendants=true rnd(WinClip,10)

    task.delay(1.65,function() tw(Win,{BackgroundTransparency=0},0.3) tw(WinClip,{BackgroundTransparency=0},0.3) end)

    -- Drag
    local drg,dStart,dStartPos=false,nil,nil
    UserInputService.InputChanged:Connect(function(i)
        if not drg then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
            local d=i.Position-dStart
            Win.Position=UDim2.new(dStartPos.X.Scale,dStartPos.X.Offset+d.X,dStartPos.Y.Scale,dStartPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drg=false end
    end)

    -- Title bar
    local TBar=frm(WinClip,C.Panel,UDim2.new(1,0,0,44),nil,11)
    local TDiv=frm(WinClip,C.Border,UDim2.new(1,0,0,1),UDim2.new(0,0,0,44),11)
    TBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drg=true dStart=i.Position dStartPos=Win.Position
        end
    end)
    local ico=Instance.new("TextLabel") ico.BackgroundTransparency=1 ico.Position=UDim2.new(0,14,0,0)
    ico.Size=UDim2.new(0,22,1,0) ico.Text="◈" ico.TextColor3=C.Accent ico.TextSize=15 ico.Font=C.Font
    ico.TextXAlignment=Enum.TextXAlignment.Center ico.ZIndex=12 ico.Parent=TBar
    local tLbl=Instance.new("TextLabel") tLbl.BackgroundTransparency=1 tLbl.Position=UDim2.new(0,40,0,0)
    tLbl.Size=UDim2.new(0.6,0,1,0) tLbl.Text=title tLbl.TextColor3=C.TextMain tLbl.TextSize=14
    tLbl.Font=C.Font tLbl.TextXAlignment=Enum.TextXAlignment.Left tLbl.ZIndex=12 tLbl.Parent=TBar
    if sub~="" then
        local st=Instance.new("TextLabel") st.BackgroundTransparency=1 st.Position=UDim2.new(0,40,0,25)
        st.Size=UDim2.new(0.5,0,0,14) st.Text=sub st.TextColor3=C.TextSub st.TextSize=10
        st.Font=C.FontReg st.TextXAlignment=Enum.TextXAlignment.Left st.ZIndex=12 st.Parent=TBar
    end

    -- Body: sidebar left, content right
    local Body=frm(WinClip,C.Bg,UDim2.new(1,0,1,-45),UDim2.new(0,0,0,45),10)

    local Side=frm(Body,C.Panel,UDim2.new(0,C.SideW,1,0),nil,11)
    local SideDiv=frm(Body,C.Border,UDim2.new(0,1,1,0),UDim2.new(0,C.SideW,0,0),11)

    local SideScr=scr(Side,UDim2.new(1,0,1,0),12)
    local SideList=frm(SideScr,Color3.new(0,0,0),UDim2.new(1,0,0,0),nil,12)
    SideList.BackgroundTransparency=1 SideList.AutomaticSize=Enum.AutomaticSize.Y
    lst(SideList,2) pdg(SideList,6,6,6,6)

    local Content=frm(Body,C.Bg,UDim2.new(1,-C.SideW,1,0),UDim2.new(0,C.SideW,0,0),10)
    Content.ClipsDescendants=true

    -- Mobile toggle
    local Mob=Instance.new("TextButton") Mob.Name="LXW_Mob" Mob.BackgroundColor3=C.Panel
    Mob.Size=UDim2.new(0,46,0,46) Mob.Position=UDim2.new(0,14,1,-62) Mob.Text="◈"
    Mob.TextColor3=C.TextMain Mob.TextSize=18 Mob.Font=C.Font Mob.AutoButtonColor=false
    Mob.ZIndex=60 Mob.Parent=sg rnd(Mob,10) brd(Mob,C.Border) shd(Mob)

    local vis=true
    local function togWin()
        vis=not vis
        if vis then Win.Visible=true tw(Win,{BackgroundTransparency=0},0.2) tw(WinClip,{BackgroundTransparency=0},0.2)
        else tw(Win,{BackgroundTransparency=1},0.18) tw(WinClip,{BackgroundTransparency=1},0.18)
            task.delay(0.22,function() if not vis then Win.Visible=false end end) end
    end
    Mob.MouseButton1Click:Connect(togWin) Mob.TouchTap:Connect(togWin)
    UserInputService.InputBegan:Connect(function(i,gp) if gp then return end if i.KeyCode==togKey then togWin() end end)

    local tabs={}
    local Win2={}

    function Win2:AddTab(name)
        -- Sidebar tab button
        local tabBtn=Instance.new("TextButton") tabBtn.BackgroundColor3=C.Panel tabBtn.BackgroundTransparency=0
        tabBtn.Size=UDim2.new(1,0,0,C.TabH) tabBtn.Text="" tabBtn.AutoButtonColor=false
        tabBtn.BorderSizePixel=0 tabBtn.ZIndex=13 tabBtn.Parent=SideList rnd(tabBtn,6)

        local tBar=frm(tabBtn,C.Accent,UDim2.new(0,2,0.55,0),UDim2.new(0,0,0.225,0),14) tBar.Visible=false rnd(tBar,2)
        local tLb=Instance.new("TextLabel") tLb.BackgroundTransparency=1 tLb.Position=UDim2.new(0,12,0,0)
        tLb.Size=UDim2.new(1,-12,1,0) tLb.Text=name tLb.TextColor3=C.TextSub tLb.TextSize=12
        tLb.Font=C.FontReg tLb.TextXAlignment=Enum.TextXAlignment.Left tLb.ZIndex=14 tLb.Parent=tabBtn

        -- Content page
        local page=frm(Content,C.Bg,UDim2.new(1,0,1,0),nil,10) page.Visible=false page.ClipsDescendants=true
        local pScr=scr(page,UDim2.new(1,0,1,0),11)
        local pItems=frm(pScr,Color3.new(0,0,0),UDim2.new(1,0,0,0),nil,12)
        pItems.BackgroundTransparency=1 pItems.AutomaticSize=Enum.AutomaticSize.Y
        lst(pItems,5) pdg(pItems,10,10,10,10)

        local function activate()
            for _,t in ipairs(tabs) do
                t.btn.BackgroundColor3=C.Panel t.lbl.TextColor3=C.TextSub t.lbl.Font=C.FontReg
                t.bar.Visible=false t.page.Visible=false
            end
            tabBtn.BackgroundColor3=Color3.fromRGB(20,20,20) tLb.TextColor3=C.TextMain tLb.Font=C.Font
            tBar.Visible=true page.Visible=true
        end
        tabBtn.MouseButton1Click:Connect(activate) tabBtn.TouchTap:Connect(activate)
        tabBtn.MouseEnter:Connect(function() if tBar.Visible then return end tabBtn.BackgroundColor3=Color3.fromRGB(17,17,17) end)
        tabBtn.MouseLeave:Connect(function() if tBar.Visible then return end tabBtn.BackgroundColor3=C.Panel end)

        local entry={btn=tabBtn,lbl=tLb,bar=tBar,page=page,items=pItems}
        table.insert(tabs,entry)
        if #tabs==1 then activate() end

        local Tab={}
        local function gp(ov) return ov or pItems end

        function Tab:AddSection(sName)
            local sf=frm(gp(),Color3.new(0,0,0),UDim2.new(1,0,0,0),nil,12) sf.BackgroundTransparency=1 sf.AutomaticSize=Enum.AutomaticSize.Y
            local sl=Instance.new("TextLabel") sl.BackgroundTransparency=1 sl.Size=UDim2.new(1,0,0,14) sl.Text=string.upper(sName)
            sl.TextColor3=C.TextSub sl.TextSize=9 sl.Font=C.Font sl.TextXAlignment=Enum.TextXAlignment.Left sl.LetterSpacingOffset=2 sl.ZIndex=13 sl.Parent=sf
            frm(sf,C.Border,UDim2.new(1,0,0,1),UDim2.new(0,0,0,14),13)
            local si=frm(sf,Color3.new(0,0,0),UDim2.new(1,0,0,0),UDim2.new(0,0,0,20),12) si.BackgroundTransparency=1 si.AutomaticSize=Enum.AutomaticSize.Y
            lst(si,4)
            local sfll=Instance.new("UIListLayout") sfll.FillDirection=Enum.FillDirection.Vertical sfll.SortOrder=Enum.SortOrder.LayoutOrder sfll.Padding=UDim.new(0,0) sfll.Parent=sf
            local Sec={}
            function Sec:AddButton(t,cb)   return Tab:AddButton(t,cb,si) end
            function Sec:AddToggle(t,d,cb,id) return Tab:AddToggle(t,d,cb,id,si) end
            function Sec:AddSlider(t,mn,mx,df,cb,id) return Tab:AddSlider(t,mn,mx,df,cb,id,si) end
            function Sec:AddDropdown(t,opts,df,cb,id) return Tab:AddDropdown(t,opts,df,cb,id,si) end
            function Sec:AddLabel(t) return Tab:AddLabel(t,si) end
            return Sec
        end

        function Tab:AddButton(text,callback,over)
            local p=gp(over)
            local btn=Instance.new("TextButton") btn.BackgroundColor3=C.Surface btn.Size=UDim2.new(1,0,0,C.ItemH)
            btn.Text="" btn.AutoButtonColor=false btn.BorderSizePixel=0 btn.ZIndex=13 btn.Parent=p rnd(btn,7) brd(btn,C.Border)
            local bl=Instance.new("TextLabel") bl.BackgroundTransparency=1 bl.Position=UDim2.new(0,14,0,0)
            bl.Size=UDim2.new(1,-34,1,0) bl.Text=text or "Button" bl.TextColor3=C.TextMain bl.TextSize=13
            bl.Font=C.FontReg bl.TextXAlignment=Enum.TextXAlignment.Left bl.ZIndex=14 bl.Parent=btn
            local arr=Instance.new("TextLabel") arr.BackgroundTransparency=1 arr.Position=UDim2.new(1,-28,0,0)
            arr.Size=UDim2.new(0,22,1,0) arr.Text="›" arr.TextColor3=C.TextSub arr.TextSize=18 arr.Font=C.Font
            arr.TextXAlignment=Enum.TextXAlignment.Center arr.ZIndex=14 arr.Parent=btn
            local function press()
                tw(btn,{BackgroundColor3=C.SurfHov},0.07) task.delay(0.14,function() tw(btn,{BackgroundColor3=C.Surface},0.12) end)
                if callback then callback() end
            end
            btn.MouseButton1Click:Connect(press) btn.TouchTap:Connect(press)
            btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=C.SurfHov}) end)
            btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.Surface}) end)
            return btn
        end

        function Tab:AddToggle(text,default,callback,id,over)
            local p=gp(over)
            local state=default or false
            if id and Cfg[id]~=nil then state=Cfg[id] end
            local row=frm(p,C.Surface,UDim2.new(1,0,0,C.ItemH),nil,13) rnd(row,7) brd(row,C.Border)
            local rl=Instance.new("TextLabel") rl.BackgroundTransparency=1 rl.Position=UDim2.new(0,14,0,0)
            rl.Size=UDim2.new(1,-58,1,0) rl.Text=text or "Toggle" rl.TextColor3=C.TextMain rl.TextSize=13
            rl.Font=C.FontReg rl.TextXAlignment=Enum.TextXAlignment.Left rl.ZIndex=14 rl.Parent=row
            local pill=frm(row,state and C.TogOn or C.TogOff,UDim2.new(0,36,0,20),UDim2.new(1,-48,0.5,-10),14) rnd(pill,10)
            local dot=frm(pill,C.Bg,UDim2.new(0,14,0,14),state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),15) rnd(dot,7)
            local tog={Value=state}
            local function setV(v,silent)
                tog.Value=v tw(pill,{BackgroundColor3=v and C.TogOn or C.TogOff},0.18)
                tw(dot,{Position=v and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)},0.18)
                if not silent and callback then callback(v) end if id then Cfg[id]=v end
            end
            setV(state,true)
            row.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then setV(not tog.Value) end end)
            row.MouseEnter:Connect(function() tw(row,{BackgroundColor3=C.SurfHov}) end)
            row.MouseLeave:Connect(function() tw(row,{BackgroundColor3=C.Surface}) end)
            tog.Set=function(v) setV(v,true) end
            return tog
        end

        function Tab:AddSlider(text,mn,mx,df,callback,id,over)
            local p=gp(over) mn=mn or 0 mx=mx or 100 df=df or mn
            local curV=df if id and Cfg[id]~=nil then curV=Cfg[id] end
            local row=frm(p,C.Surface,UDim2.new(1,0,0,52),nil,13) rnd(row,7) brd(row,C.Border)
            local rl=Instance.new("TextLabel") rl.BackgroundTransparency=1 rl.Position=UDim2.new(0,14,0,7)
            rl.Size=UDim2.new(0.65,0,0,16) rl.Text=text or "Slider" rl.TextColor3=C.TextMain rl.TextSize=13
            rl.Font=C.FontReg rl.TextXAlignment=Enum.TextXAlignment.Left rl.ZIndex=14 rl.Parent=row
            local vl=Instance.new("TextLabel") vl.BackgroundTransparency=1 vl.Position=UDim2.new(1,-48,0,7)
            vl.Size=UDim2.new(0,42,0,16) vl.Text=tostring(curV) vl.TextColor3=C.AccentDim vl.TextSize=12
            vl.Font=C.Font vl.TextXAlignment=Enum.TextXAlignment.Right vl.ZIndex=14 vl.Parent=row
            local tBg=frm(row,C.SlBg,UDim2.new(1,-28,0,6),UDim2.new(0,14,0,36),14) rnd(tBg,3)
            local pct0=(curV-mn)/(mx-mn)
            local fill=frm(tBg,C.SlFill,UDim2.new(pct0,0,1,0),nil,15) rnd(fill,3)
            local handle=frm(tBg,C.Accent,UDim2.new(0,14,0,14),UDim2.new(pct0,-7,0.5,-7),16) rnd(handle,7)
            local sld={Value=curV} local sliding=false
            local function setV(v,silent)
                v=math.clamp(math.round(v),mn,mx) sld.Value=v
                local pp=(v-mn)/(mx-mn)
                tw(fill,{Size=UDim2.new(pp,0,1,0)},0.06,Enum.EasingStyle.Linear)
                tw(handle,{Position=UDim2.new(pp,-7,0.5,-7)},0.06,Enum.EasingStyle.Linear)
                vl.Text=tostring(v) if not silent and callback then callback(v) end if id then Cfg[id]=v end
            end
            local function fromX(x)
                local a=tBg.AbsolutePosition.X local s=tBg.AbsoluteSize.X
                local r=math.clamp(x-a,0,s) setV(mn+(mx-mn)*(r/s))
            end
            tBg.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true fromX(i.Position.X) end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then fromX(i.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end
            end)
            setV(curV,true) sld.Set=function(v) setV(v,true) end
            return sld
        end

        function Tab:AddDropdown(text,options,default,callback,id,over)
            local p=gp(over) options=options or {}
            local sel=default or options[1] or ""
            if id and Cfg[id]~=nil then sel=Cfg[id] end

            -- Container that does NOT clip, so list can overflow
            local wrap=Instance.new("Frame") wrap.BackgroundTransparency=1
            wrap.Size=UDim2.new(1,0,0,C.ItemH) wrap.ZIndex=30 wrap.ClipsDescendants=false wrap.Parent=p

            local row=frm(wrap,C.Surface,UDim2.new(1,0,0,C.ItemH),nil,30)
            rnd(row,7) brd(row,C.Border) row.ClipsDescendants=false

            local rl=Instance.new("TextLabel") rl.BackgroundTransparency=1 rl.Position=UDim2.new(0,14,0,0)
            rl.Size=UDim2.new(0.5,0,1,0) rl.Text=text or "Dropdown" rl.TextColor3=C.TextMain rl.TextSize=13
            rl.Font=C.FontReg rl.TextXAlignment=Enum.TextXAlignment.Left rl.ZIndex=31 rl.Parent=row

            local selL=Instance.new("TextLabel") selL.BackgroundTransparency=1 selL.Position=UDim2.new(0.5,0,0,0)
            selL.Size=UDim2.new(0.38,0,1,0) selL.Text=sel selL.TextColor3=C.AccentDim selL.TextSize=12
            selL.Font=C.FontReg selL.TextXAlignment=Enum.TextXAlignment.Right selL.TextTruncate=Enum.TextTruncate.AtEnd
            selL.ZIndex=31 selL.Parent=row

            local arrL=Instance.new("TextLabel") arrL.BackgroundTransparency=1 arrL.Position=UDim2.new(1,-26,0,0)
            arrL.Size=UDim2.new(0,22,1,0) arrL.Text="▾" arrL.TextColor3=C.TextSub arrL.TextSize=13 arrL.Font=C.Font
            arrL.TextXAlignment=Enum.TextXAlignment.Center arrL.ZIndex=31 arrL.Parent=row

            -- Dropdown list anchored below row, uses ScreenGui coords trick to avoid clipping
            local optH=32 local maxV=5 local listH=math.min(#options,maxV)*optH

            local dropF=frm(row,C.DropBg,UDim2.new(1,0,0,0),UDim2.new(0,0,1,5),55)
            dropF.ClipsDescendants=true dropF.Visible=false rnd(dropF,7) brd(dropF,C.Border) shd(dropF)

            local dScr=scr(dropF,UDim2.new(1,0,1,0),56) lst(dScr,0)

            local isOpen=false
            local drop={Value=sel}

            local function close()
                isOpen=false tw(dropF,{Size=UDim2.new(1,0,0,0)},0.16)
                task.delay(0.18,function() if not isOpen then dropF.Visible=false end end)
            end
            local function open()
                isOpen=true dropF.Visible=true
                tw(dropF,{Size=UDim2.new(1,0,0,listH)},0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
            end

            local function setValue(val,silent)
                drop.Value=val sel=val selL.Text=val
                for _,ch in ipairs(dScr:GetChildren()) do
                    if ch:IsA("TextButton") then
                        for _,c in ipairs(ch:GetChildren()) do
                            if c:IsA("TextLabel") then
                                if c.Name=="optLbl" then c.TextColor3=C.TextSub c.Font=C.FontReg end
                                if c.Name=="ckLbl" then c.Visible=false end
                            end
                        end
                        if ch:GetAttribute("opt")==val then
                            for _,c in ipairs(ch:GetChildren()) do
                                if c.Name=="optLbl" then c.TextColor3=C.TextMain c.Font=C.Font end
                                if c.Name=="ckLbl" then c.Visible=true end
                            end
                        end
                    end
                end
                if not silent and callback then callback(val) end if id then Cfg[id]=val end
                close()
            end

            for _,opt in ipairs(options) do
                local ob=Instance.new("TextButton") ob.BackgroundColor3=C.DropBg ob.Size=UDim2.new(1,0,0,optH)
                ob.Text="" ob.AutoButtonColor=false ob.BorderSizePixel=0 ob.ZIndex=57 ob.Parent=dScr
                ob:SetAttribute("opt",opt)
                local ol=Instance.new("TextLabel") ol.Name="optLbl" ol.BackgroundTransparency=1
                ol.Position=UDim2.new(0,12,0,0) ol.Size=UDim2.new(1,-36,1,0) ol.Text=opt
                ol.TextColor3=(opt==sel) and C.TextMain or C.TextSub ol.TextSize=12
                ol.Font=(opt==sel) and C.Font or C.FontReg ol.TextXAlignment=Enum.TextXAlignment.Left ol.ZIndex=58 ol.Parent=ob
                local ck=Instance.new("TextLabel") ck.Name="ckLbl" ck.BackgroundTransparency=1
                ck.Position=UDim2.new(1,-28,0,0) ck.Size=UDim2.new(0,22,1,0) ck.Text="✓" ck.TextColor3=C.Accent
                ck.TextSize=11 ck.Font=C.Font ck.TextXAlignment=Enum.TextXAlignment.Center ck.ZIndex=58
                ck.Visible=(opt==sel) ck.Parent=ob
                ob.MouseEnter:Connect(function() tw(ob,{BackgroundColor3=C.DropHov}) end)
                ob.MouseLeave:Connect(function() tw(ob,{BackgroundColor3=C.DropBg}) end)
                ob.MouseButton1Click:Connect(function() setValue(opt) end)
                ob.TouchTap:Connect(function() setValue(opt) end)
            end

            -- Click row to toggle (using InputBegan to capture both mouse and touch)
            local function toggleDrop()
                if isOpen then close() else open() end
            end
            row.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    toggleDrop()
                end
            end)
            row.MouseEnter:Connect(function() tw(row,{BackgroundColor3=C.SurfHov}) end)
            row.MouseLeave:Connect(function() tw(row,{BackgroundColor3=C.Surface}) end)

            drop.Set=function(v) setValue(v,true) end
            return drop
        end

        function Tab:AddLabel(text,over)
            local p=gp(over)
            local lf=frm(p,C.Surface,UDim2.new(1,0,0,30),nil,13) rnd(lf,7)
            local ll2=Instance.new("TextLabel") ll2.BackgroundTransparency=1 ll2.Position=UDim2.new(0,14,0,0)
            ll2.Size=UDim2.new(1,-14,1,0) ll2.Text=text or "" ll2.TextColor3=C.TextSub ll2.TextSize=12
            ll2.Font=C.FontReg ll2.TextXAlignment=Enum.TextXAlignment.Left ll2.ZIndex=14 ll2.Parent=lf
            return lf
        end

        return Tab
    end

    return Win2
end

return LawXW
