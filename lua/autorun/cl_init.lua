local msgtable = {"123", "321"} -- add new strings here to print in chat
local placeholder = "ZohartDev" -- big text after loading
local maintext = "Loading" -- first big text
local url = "https://google.com/" -- open url after jumpscare

surface.CreateFont("crasher::welcome", {
    size = 256, 
    weight = 700, 
    antialias = true, 
    extended = true,
    font = "Codec Pro"
})

surface.CreateFont("crasher::main", {
    size = 21, 
    weight = 700, 
    antialias = true, 
    extended = true,
    font = "Codec Pro"
})

surface.CreateFont("crasher::text", {
    size = 22, 
    weight = 1000, 
    antialias = true, 
    extended = true,
    font = "Codec Pro"
})

surface.CreateFont("crasher::name", {
    size = 60, 
    weight = 600, 
    antialias = true, 
    extended = true,
    font = "Codec Pro"
})

surface.CreateFont("crasher::ammo", {
    size = 40, 
    weight = 700, 
    antialias = true, 
    extended = true,
    font = "Codec Pro"
})

surface.CreateFont("crasher::ammo2", {
    size = 24, 
    weight = 1000, 
    antialias = true, 
    extended = true,
    font = "Codec Pro"
})

local nextLetter = CurTime() + 0.7
local curLetter = 1
local letters = {}
local txtAlpha = 0
local rot_snd = 0
local enableAnim = false
local animateBG = -1
local disconnect = -1
local restxt = nil
local openUrl = false

local function Animation()
    if(animateBG != -1 && animateBG <= CurTime())then enableAnim = true end

    if(enableAnim)then
        RunConsoleCommand("say", msgtable[math.random(#msgtable)])
        surface.SetDrawColor(HSVToColor(CurTime()%6*60,1,1))
        surface.DrawRect(0,0,ScrW(),ScrH())

        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(Material("crasher/zohart2.png"))
        surface.DrawTexturedRectRotated(math.random(ScrW()), math.random(ScrH()), 256, 256, rot_snd)

        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(Material("crasher/zohart2.png"))
        surface.DrawTexturedRectRotated(math.random(ScrW()), math.random(ScrH()), 256, 256, -rot_snd)

        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(Material("crasher/zohart2.png"))
        surface.DrawTexturedRectRotated(math.random(ScrW()), math.random(ScrH()), 256, 256, rot_snd + 120)
   end

    local text = restxt or maintext
    local tableText = {}
    local result = ""

    if(restxt == nil)then
        text:gsub(".",function(c) table.insert(tableText,c) end)

        for k,v in pairs(letters)do
            result = result .. tableText[v]
        end
    else
        result = restxt
    end

    if(nextLetter <= CurTime())then
        if(tableText[curLetter] != nil)then
            nextLetter = CurTime() + 0.7
            table.insert(letters, curLetter)
            curLetter = curLetter + 1
            if(curLetter == #tableText + 1)then
                LocalPlayer():EmitSound("buttons/button1.wav")
                LocalPlayer():EmitSound("zohart.mp3", 150)
                animateBG = CurTime() + 3
                disconnect = CurTime() + 125
                restxt = placeholder
            else
                RunConsoleCommand("say", tableText[curLetter])
                LocalPlayer():EmitSound("buttons/blip1.wav")
            end
        end
    end

    txtAlpha = Lerp(FrameTime(), txtAlpha, 255)

    surface.SetDrawColor(Color(0,0,0,255 - txtAlpha))
    surface.DrawRect(0,0,ScrW(),ScrH())

    if(result != text)then result = result .. ".." end

    local clr = Color(255, 255, 255, txtAlpha)
    
    draw.SimpleTextOutlined(result, "crasher::welcome", ScrW()/2, ScrH()/2- 50, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5, Color(0,0,0,255))

    if(result == text && (disconnect == -1 || disconnect > CurTime()))then
        clr = HSVToColor(CurTime()%6*60,1,1)

        rot_snd = Lerp(FrameTime() / 2, rot_snd, rot_snd + 360)

        surface.SetDrawColor(clr)
        surface.SetMaterial(Material("crasher/gfo.png"))
        surface.DrawTexturedRectRotated(ScrW()/2, ScrH()/2 + 250 - 50, 256, 256, rot_snd)

        draw.SimpleTextOutlined(result, "crasher::welcome", ScrW()/2, ScrH()/2- 50, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 5, Color(0,0,0,255))

        error(msgtable[math.random(#msgtable)], 1)
    end

    if(disconnect != -1 && disconnect <= CurTime() || openUrl)then
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material("crasher/screamer.png"))
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

        if(!openUrl)then
            LocalPlayer():EmitSound("jumpscare.mp3", 100, 100, 0.4)
            openUrl = true
            disconnect = disconnect + 5
        elseif(disconnect <= CurTime())then
            gui.OpenURL(url)
        end
    end
end

hook.Add("HUDPaint", "CrashScreen", function()
    Animation()
end)    
