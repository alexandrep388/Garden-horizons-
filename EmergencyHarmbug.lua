-- ╔══════════════════════════════════════════════════════════╗
-- ║          GD Studio  ·  Emergency Harmbug                ║
-- ║          github.com/alexandrep388                       ║
-- ╚══════════════════════════════════════════════════════════╝

-- ═══════════════════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════════════════
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local RS         = game:GetService("ReplicatedStorage")
local TweenSvc   = game:GetService("TweenService")

local LP     = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ═══════════════════════════════════════════════
--  REMOTES
-- ═══════════════════════════════════════════════
local REM = RS:FindFirstChild("6Dg")
local function getR(id) return REM and REM:FindFirstChild(id) end

local REM_ENTER  = "274b3bb0-ebe4-45f2-8664-22db4ef7a7b7"
local REM_RELOAD = "b7cc119c-139f-485b-9952-2a226e88e13d"
local REM_FIRE   = "55248063-b18f-4f0d-802c-39a0e9843ce0"
local REM_EQUIP  = "4766e04c-1184-445b-9efa-4d04c1bae5a0"

-- ═══════════════════════════════════════════════
--  ORION
-- ═══════════════════════════════════════════════
local OrionLib
for _,url in ipairs({
    "https://raw.githubusercontent.com/alexandrep388/Garden-horizons-/refs/heads/main/OrionLib.lua",
    "https://raw.githubusercontent.com/shlexware/Orion/main/source",
    "https://raw.githubusercontent.com/jensonhirst/Orion/main/source",
}) do
    local ok,res = pcall(function() return loadstring(game:HttpGet(url,true))() end)
    if ok and type(res)=="table" and res.MakeWindow then OrionLib=res break end
end
assert(OrionLib,"[GD Studio] Orion failed to load!")

-- ═══════════════════════════════════════════════
--  SON
-- ═══════════════════════════════════════════════
local SFX = Instance.new("Sound")
SFX.SoundId = "rbxassetid://137402801272072"
SFX.Volume  = 0.65
SFX.Parent  = LP:WaitForChild("PlayerGui")
local function sfx() SFX.TimePosition=0 SFX:Play() end

local function Notify(title, content)
    sfx()
    OrionLib:MakeNotification({Name=title, Content=content, Image="rbxassetid://4483345875", Time=4})
end

-- ═══════════════════════════════════════════════
--  LANGUES
-- ═══════════════════════════════════════════════
local LANGS = {
    EN={
        tabP="🏠 Principal", tabV="🚗 Vehicle", tabPol="👮 Police",
        tabO="👥 Other", tabM="⚙️ Misc",
        secMove="Movement", secTeams="Team ESP", secVis="Visual",
        secAim="Aimbot", secVeh="Car Mods", secGun="Gun Mod",
        secTP="Teleport", secRob="Robbery", secJob="Job",
        infSt="Infinite Stamina", aFall="Anti Fall", langBtn="Language: ",
        espPolice="Police ESP", espPrisoner="Prisoner ESP",
        espFire="Fire Dept ESP", espHARS="HARS ESP", espTruck="Truck Co. ESP",
        espHL="Highlight", espTr="Tracers", espNm="Names",
        aOn="Aimbot", silAim="Silent Aim", aTarget="Target",
        aFov="FOV Radius", aSmth="Smoothness", aPred="Prediction", aCol="FOV Color",
        notifOn="→ ON", notifOff="→ OFF",
        loaded="Emergency Harmbug loaded ✓",
        flyStart="🚗 Flying to destination...",
        flyDone="✓ Arrived!",
        nocar="❌ Car not found!",
    },
    FR={
        tabP="🏠 Principal", tabV="🚗 Véhicule", tabPol="👮 Police",
        tabO="👥 Autres", tabM="⚙️ Misc",
        secMove="Mouvement", secTeams="ESP Équipes", secVis="Visuel",
        secAim="Aimbot", secVeh="Voiture", secGun="Armes",
        secTP="Téléport", secRob="Braquage", secJob="Métier",
        infSt="Stamina Infinie", aFall="Anti Chute", langBtn="Langue: ",
        espPolice="ESP Police", espPrisoner="ESP Prisonnier",
        espFire="ESP Pompiers", espHARS="ESP HARS", espTruck="ESP Camionnage",
        espHL="Surbrillance", espTr="Traceurs", espNm="Noms",
        aOn="Aimbot", silAim="Silent Aim", aTarget="Cible",
        aFov="Rayon FOV", aSmth="Fluidité", aPred="Prédiction", aCol="Couleur FOV",
        notifOn="→ ON", notifOff="→ OFF",
        loaded="Emergency Harmbug chargé ✓",
        flyStart="🚗 En route...",
        flyDone="✓ Arrivé!",
        nocar="❌ Voiture introuvable!",
    },
    ES={
        tabP="🏠 Principal", tabV="🚗 Vehículo", tabPol="👮 Policía",
        tabO="👥 Otros", tabM="⚙️ Misc",
        secMove="Movimiento", secTeams="ESP Equipos", secVis="Visual",
        secAim="Aimbot", secVeh="Auto", secGun="Armas",
        secTP="Teleporte", secRob="Robo", secJob="Trabajo",
        infSt="Stamina Infinita", aFall="Anti Caída", langBtn="Idioma: ",
        espPolice="ESP Policía", espPrisoner="ESP Prisionero",
        espFire="ESP Bomberos", espHARS="ESP HARS", espTruck="ESP Camioneros",
        espHL="Resaltado", espTr="Trazadores", espNm="Nombres",
        aOn="Aimbot", silAim="Silent Aim", aTarget="Objetivo",
        aFov="Radio FOV", aSmth="Suavidad", aPred="Predicción", aCol="Color FOV",
        notifOn="→ ON", notifOff="→ OFF",
        loaded="Emergency Harmbug cargado ✓",
        flyStart="🚗 Volando...",
        flyDone="✓ Llegado!",
        nocar="❌ Auto no encontrado!",
    },
    PT={
        tabP="🏠 Principal", tabV="🚗 Veículo", tabPol="👮 Polícia",
        tabO="👥 Outros", tabM="⚙️ Misc",
        secMove="Movimento", secTeams="ESP Equipes", secVis="Visual",
        secAim="Aimbot", secVeh="Carro", secGun="Armas",
        secTP="Teleporte", secRob="Roubo", secJob="Trabalho",
        infSt="Stamina Infinita", aFall="Anti Queda", langBtn="Idioma: ",
        espPolice="ESP Polícia", espPrisoner="ESP Prisioneiro",
        espFire="ESP Bombeiros", espHARS="ESP HARS", espTruck="ESP Caminhoneiros",
        espHL="Destaque", espTr="Tracers", espNm="Nomes",
        aOn="Aimbot", silAim="Silent Aim", aTarget="Alvo",
        aFov="Raio FOV", aSmth="Suavidade", aPred="Predição", aCol="Cor FOV",
        notifOn="→ ON", notifOff="→ OFF",
        loaded="Emergency Harmbug carregado ✓",
        flyStart="🚗 Voando...",
        flyDone="✓ Chegou!",
        nocar="❌ Carro não encontrado!",
    },
    DE={
        tabP="🏠 Haupt", tabV="🚗 Fahrzeug", tabPol="👮 Polizei",
        tabO="👥 Andere", tabM="⚙️ Misc",
        secMove="Bewegung", secTeams="Team-ESP", secVis="Visuell",
        secAim="Aimbot", secVeh="Auto", secGun="Waffen",
        secTP="Teleport", secRob="Raub", secJob="Beruf",
        infSt="Unendl. Stamina", aFall="Anti-Fall", langBtn="Sprache: ",
        espPolice="ESP Polizei", espPrisoner="ESP Gefangener",
        espFire="ESP Feuerwehr", espHARS="ESP HARS", espTruck="ESP LKW-Firma",
        espHL="Hervorhebung", espTr="Tracer", espNm="Namen",
        aOn="Aimbot", silAim="Silent Aim", aTarget="Ziel",
        aFov="FOV-Radius", aSmth="Glättung", aPred="Vorhersage", aCol="FOV-Farbe",
        notifOn="→ ON", notifOff="→ OFF",
        loaded="Emergency Harmbug geladen ✓",
        flyStart="🚗 Fliegen...",
        flyDone="✓ Angekommen!",
        nocar="❌ Auto nicht gefunden!",
    },
}
local LANG_ORDER = {"EN","FR","ES","PT","DE"}
local LANG_FLAG  = {EN="🇬🇧",FR="🇫🇷",ES="🇪🇸",PT="🇧🇷",DE="🇩🇪"}

local FOLDER = "GDStudio_EHarmbug"
pcall(function() if not isfolder(FOLDER) then makefolder(FOLDER) end end)
local currentLang = "EN"
pcall(function() local s=readfile(FOLDER.."/language.txt") if LANGS[s] then currentLang=s end end)
local L = LANGS[currentLang]

local function cycleLang()
    local idx=1
    for i,c in ipairs(LANG_ORDER) do if c==currentLang then idx=i break end end
    currentLang = LANG_ORDER[(idx%#LANG_ORDER)+1]
    L = LANGS[currentLang]
    pcall(function() writefile(FOLDER.."/language.txt",currentLang) end)
    Notify("🌐 Language", LANG_FLAG[currentLang].." "..currentLang.." — reload to apply")
end

-- ═══════════════════════════════════════════════
--  LOCATIONS TP
-- ═══════════════════════════════════════════════
local ROBBERY_LOCS = {
    ["🏦 Bank"]         = Vector3.new(-1196, 5, 3232),
    ["💎 Jeweler"]      = Vector3.new(-425,  5, 3522),
    ["🎭 Club"]         = Vector3.new(-1851, 5, 3199),
    ["⛽ Gas-N-Go"]     = Vector3.new(-1547, 5, 3807),
    ["⛽ Ares Fuel"]    = Vector3.new(-861,  6, 1506),
    ["🔧 Tool Shop"]    = Vector3.new(-747,  6, 672),
    ["⛽ Osso Fuel"]    = Vector3.new(-27,   6, -770),
    ["🌾 Farm Shop"]    = Vector3.new(-914,  5, -1169),
}
local ROBBERY_LIST = {
    "🏦 Bank","💎 Jeweler","🎭 Club","⛽ Gas-N-Go",
    "⛽ Ares Fuel","🔧 Tool Shop","⛽ Osso Fuel","🌾 Farm Shop"
}

-- ⚠️ Coordonnées jobs à remplir quand tu les auras
local JOB_LOCS = {
    ["👮 Police"]       = Vector3.new(0, 5, 0),   -- TODO
    ["🚒 Fire Dept"]    = Vector3.new(0, 5, 0),   -- TODO
    ["🚌 Bus"]          = Vector3.new(0, 5, 0),   -- TODO
    ["🚑 HARS"]         = Vector3.new(0, 5, 0),   -- TODO
    ["🏛️ Prison"]       = Vector3.new(0, 5, 0),   -- TODO
    ["🚛 Truck Co."]    = Vector3.new(0, 5, 0),   -- TODO
}
local JOB_LIST = {"👮 Police","🚒 Fire Dept","🚌 Bus","🚑 HARS","🏛️ Prison","🚛 Truck Co."}

-- ═══════════════════════════════════════════════
--  STATE
-- ═══════════════════════════════════════════════
local S = {
    infStamina=false, antiFall=false,
    espHL=true, espTr=false, espNm=false,
    esp={Police=false,Prisoner=false,FireDepartment=false,HARS=false,TruckCompany=false},
    aimbot=false, silentAim=false, aTarget="Head",
    aFov=150, aSmooth=5, aPred=0, aColor=Color3.fromRGB(255,60,60),
    speedBoost=false, speedValue=150, noFlat=false, infFuel=false,
    rapidFire=false, rapidDelay=0.05, autoReload=false, autoEquip=false, noRecoil=false,
    -- TP
    robberyTarget = "🏦 Bank",
    jobTarget     = "👮 Police",
}

local TEAM_COL = {
    Police         = Color3.fromRGB(30,  110, 255),
    Prisoner       = Color3.fromRGB(255, 140,   0),
    FireDepartment = Color3.fromRGB(220,  30,  30),
    HARS           = Color3.fromRGB(230, 230,  80),
    TruckCompany   = Color3.fromRGB(215, 215, 215),
}

-- ═══════════════════════════════════════════════
--  FLY-TP SYSTEM
--  1. TP joueur à la voiture
--  2. Remote enter
--  3. Fly (TP progressif à haute altitude) vers dest
--  4. TP direct à la destination finale
-- ═══════════════════════════════════════════════
local isFlyingTP = false

local function flyToDestination(destPos)
    if isFlyingTP then return end
    isFlyingTP = true

    local char = LP.Character
    if not char then isFlyingTP=false return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then isFlyingTP=false return end

    -- Étape 1 : TP à la voiture
    local car = workspace.Vehicles and workspace.Vehicles:FindFirstChild(LP.Name)
    if not car then
        Notify("TP", L.nocar)
        isFlyingTP=false return
    end
    local seat = car:FindFirstChild("DriveSeat")
    if not seat then isFlyingTP=false return end

    Notify("🚗 TP", L.flyStart)

    -- TP au siège (étapes)
    local origin = hrp.CFrame
    local seatCF = seat.CFrame + Vector3.new(0, 3, 0)
    for i=1,4 do
        pcall(function() hrp.CFrame = origin:Lerp(seatCF, i/4) end)
        task.wait(0.04)
    end
    task.wait(0.1)

    -- Étape 2 : Remote enter
    pcall(function() getR(REM_ENTER):FireServer(seat,"ewr",false) end)
    task.wait(0.3)

    -- Étape 3 : Fly vers haute altitude au-dessus de la destination
    local flyHeight = 200
    local highDest  = Vector3.new(destPos.X, destPos.Y + flyHeight, destPos.Z)

    -- On TP par étapes en arc (montée puis déplacement horizontal)
    local startPos = hrp.Position
    local midHigh  = Vector3.new(
        (startPos.X + highDest.X) / 2,
        math.max(startPos.Y, highDest.Y) + 50,
        (startPos.Z + highDest.Z) / 2
    )

    local flySteps = 15
    -- Phase montée + déplacement
    for i=1,flySteps do
        local alpha = i/flySteps
        local pos
        if alpha < 0.5 then
            -- Montée vers le point haut
            pos = startPos:Lerp(midHigh, alpha*2)
        else
            -- Descente vers la destination haute
            pos = midHigh:Lerp(highDest, (alpha-0.5)*2)
        end
        pcall(function() hrp.CFrame = CFrame.new(pos) end)
        task.wait(0.05)
    end

    task.wait(0.15)

    -- Étape 4 : TP direct à la destination finale
    pcall(function() hrp.CFrame = CFrame.new(destPos) end)

    Notify("✅ TP", L.flyDone)
    isFlyingTP = false
end

-- ═══════════════════════════════════════════════
--  FENÊTRE ORION
-- ═══════════════════════════════════════════════
local Window = OrionLib:MakeWindow({
    Name         = "GD Studio  ·  Emergency Harmbug",
    HidePremium  = true,
    SaveConfig   = false,
    IntroEnabled = true,
    IntroText    = "GD Studio",
    IntroIcon    = "rbxassetid://4483345875",
})

-- ══════════════════════════════════════════════════════════
--  TAB 1 : PRINCIPAL  🏠
-- ══════════════════════════════════════════════════════════
local TabP = Window:MakeTab({Name=L.tabP, Icon="rbxassetid://4483345875", PremiumOnly=false})

TabP:AddSection({Name="🌐  Language"})
TabP:AddButton({
    Name     = L.langBtn..LANG_FLAG[currentLang].." "..currentLang,
    Callback = cycleLang,
})

TabP:AddSection({Name="⚡  "..L.secMove})
TabP:AddToggle({
    Name="🔋 "..L.infSt, Default=false,
    Callback=function(v) S.infStamina=v sfx() Notify("Stamina",v and L.notifOn or L.notifOff) end,
})
TabP:AddToggle({
    Name="🪂 "..L.aFall, Default=false,
    Callback=function(v) S.antiFall=v sfx() Notify("Anti Fall",v and L.notifOn or L.notifOff) end,
})

-- ══════════════════════════════════════════════════════════
--  TAB 2 : VÉHICULE  🚗
-- ══════════════════════════════════════════════════════════
local TabV = Window:MakeTab({Name=L.tabV, Icon="rbxassetid://4483345875", PremiumOnly=false})

-- ── Section Téléport ──
TabV:AddSection({Name="📍  "..L.secTP})

TabV:AddButton({
    Name="🏪 TP → Dealer",
    Callback=function()
        local dealer = workspace.Dealers and workspace.Dealers:FindFirstChild("Dealer")
        if not dealer then Notify("TP","❌ Dealer not found!") return end
        local pos = dealer.PrimaryPart and dealer.PrimaryPart.Position
            or (dealer:FindFirstChildOfClass("BasePart") and dealer:FindFirstChildOfClass("BasePart").Position)
        if not pos then Notify("TP","❌ Dealer position error!") return end
        task.spawn(function() flyToDestination(pos + Vector3.new(0,3,0)) end)
    end,
})

TabV:AddSection({Name="🔫  "..L.secRob})
TabV:AddDropdown({
    Name     = "📍 Location",
    Default  = ROBBERY_LIST[1],
    Options  = ROBBERY_LIST,
    Callback = function(v) S.robberyTarget=v sfx() end,
})
TabV:AddButton({
    Name="🚗 Fly to Robbery",
    Callback=function()
        local pos = ROBBERY_LOCS[S.robberyTarget]
        if not pos then return end
        task.spawn(function() flyToDestination(pos) end)
    end,
})

TabV:AddSection({Name="💼  "..L.secJob})
TabV:AddDropdown({
    Name     = "📍 Job",
    Default  = JOB_LIST[1],
    Options  = JOB_LIST,
    Callback = function(v) S.jobTarget=v sfx() end,
})
TabV:AddButton({
    Name="🚗 Fly to Job",
    Callback=function()
        local pos = JOB_LOCS[S.jobTarget]
        if not pos then return end
        task.spawn(function() flyToDestination(pos) end)
    end,
})

-- ── Section Car Mods ──
TabV:AddSection({Name="🔧  "..L.secVeh})
TabV:AddToggle({
    Name="⚡ Speed Boost", Default=false,
    Callback=function(v) S.speedBoost=v sfx() Notify("Speed",v and L.notifOn or L.notifOff) end,
})
TabV:AddSlider({
    Name="🏎️ Max Speed", Min=50, Max=500, Default=150,
    Color=Color3.fromRGB(255,165,0), Increment=10,
    Callback=function(v) S.speedValue=v end,
})
TabV:AddToggle({
    Name="🔩 No Flat Tires", Default=false,
    Callback=function(v) S.noFlat=v sfx() end,
})
TabV:AddToggle({
    Name="⛽ Infinite Fuel", Default=false,
    Callback=function(v) S.infFuel=v sfx() end,
})

-- ══════════════════════════════════════════════════════════
--  TAB 3 : POLICE  👮
-- ══════════════════════════════════════════════════════════
local TabPol = Window:MakeTab({Name=L.tabPol, Icon="rbxassetid://4483345875", PremiumOnly=false})

TabPol:AddSection({Name="🔵  Police ESP"})
TabPol:AddToggle({
    Name="👮 "..L.espPolice, Default=false,
    Callback=function(v) S.esp.Police=v sfx() end,
})

TabPol:AddSection({Name="🎨  "..L.secVis})
TabPol:AddToggle({Name="✨ "..L.espHL, Default=true,  Callback=function(v) S.espHL=v sfx() end})
TabPol:AddToggle({Name="📏 "..L.espTr, Default=false, Callback=function(v) S.espTr=v sfx() end})
TabPol:AddToggle({Name="🏷️ "..L.espNm, Default=false, Callback=function(v) S.espNm=v sfx() end})

-- ══════════════════════════════════════════════════════════
--  TAB 4 : OTHER  👥
-- ══════════════════════════════════════════════════════════
local TabO = Window:MakeTab({Name=L.tabO, Icon="rbxassetid://4483345875", PremiumOnly=false})

TabO:AddSection({Name="🎯  "..L.secTeams})
TabO:AddToggle({Name="🔶 "..L.espPrisoner, Default=false, Callback=function(v) S.esp.Prisoner=v       sfx() end})
TabO:AddToggle({Name="🔴 "..L.espFire,     Default=false, Callback=function(v) S.esp.FireDepartment=v sfx() end})
TabO:AddToggle({Name="🟡 "..L.espHARS,     Default=false, Callback=function(v) S.esp.HARS=v           sfx() end})
TabO:AddToggle({Name="⚪ "..L.espTruck,    Default=false, Callback=function(v) S.esp.TruckCompany=v   sfx() end})

-- ══════════════════════════════════════════════════════════
--  TAB 5 : MISC  ⚙️
-- ══════════════════════════════════════════════════════════
local TabM = Window:MakeTab({Name=L.tabM, Icon="rbxassetid://4483345875", PremiumOnly=false})

-- ── Aimbot ──
TabM:AddSection({Name="🎯  "..L.secAim})
TabM:AddToggle({
    Name="🔒 "..L.aOn, Default=false,
    Callback=function(v) S.aimbot=v sfx() Notify("Aimbot",v and L.notifOn or L.notifOff) end,
})
TabM:AddToggle({
    Name="🤫 "..L.silAim, Default=false,
    Callback=function(v) S.silentAim=v sfx() Notify("Silent Aim",v and L.notifOn or L.notifOff) end,
})
TabM:AddDropdown({
    Name="🎯 "..L.aTarget, Default="Head",
    Options={"Head","Torso","HumanoidRootPart"},
    Callback=function(v) S.aTarget=v sfx() end,
})
TabM:AddSlider({Name="⭕ "..L.aFov,  Min=30, Max=700,Default=150, Color=Color3.fromRGB(255,60,60),  Increment=5, Callback=function(v) S.aFov=v end})
TabM:AddSlider({Name="🌊 "..L.aSmth, Min=1,  Max=30, Default=5,   Color=Color3.fromRGB(52,211,153), Increment=1, Callback=function(v) S.aSmooth=v end})
TabM:AddSlider({Name="⚡ "..L.aPred, Min=0,  Max=30, Default=0,   Color=Color3.fromRGB(255,200,50), Increment=1, Callback=function(v) S.aPred=v end})
TabM:AddColorpicker({Name="🎨 "..L.aCol, Default=Color3.fromRGB(255,60,60), Callback=function(v) S.aColor=v end})

-- ── Gun Mod ──
TabM:AddSection({Name="🔫  "..L.secGun})
TabM:AddToggle({
    Name="🔫 Auto Equip Glock 17", Default=false,
    Callback=function(v)
        S.autoEquip=v sfx()
        if v then pcall(function() getR(REM_EQUIP):FireServer("Glock 17") end) end
    end,
})
TabM:AddToggle({
    Name="🔄 Auto Reload", Default=false,
    Callback=function(v) S.autoReload=v sfx() Notify("Auto Reload",v and L.notifOn or L.notifOff) end,
})
TabM:AddToggle({
    Name="🔥 Rapid Fire", Default=false,
    Callback=function(v) S.rapidFire=v sfx() Notify("Rapid Fire",v and L.notifOn or L.notifOff) end,
})
TabM:AddSlider({
    Name="💨 Fire Rate", Min=1, Max=20, Default=5,
    Color=Color3.fromRGB(255,80,80), Increment=1,
    Callback=function(v) S.rapidDelay=v/100 end,
})
TabM:AddToggle({
    Name="🎯 No Recoil", Default=false,
    Callback=function(v) S.noRecoil=v sfx() Notify("No Recoil",v and L.notifOn or L.notifOff) end,
})

-- ═══════════════════════════════════════════════
--  INIT
-- ═══════════════════════════════════════════════
OrionLib:Init()
task.spawn(function() task.wait(1) Notify("GD Studio 🛡️", L.loaded) end)

-- ═══════════════════════════════════════════════
--  LOGIQUE : INFINITE STAMINA
-- ═══════════════════════════════════════════════
task.spawn(function()
    task.wait(5)
    local instances = {}
    pcall(function()
        for _,v in ipairs(getgc(true)) do
            if type(v)=="table" then
                local s=rawget(v,"stamina")
                local h=rawget(v,"hasStaminaBoost")
                if type(s)=="number" and type(h)=="boolean" then
                    table.insert(instances,v)
                    local mt=getmetatable(v) or v
                    for k,fn in pairs(mt) do
                        if k=="useStamina" and type(fn)=="function" then
                            local o=fn mt[k]=function(self,a) if S.infStamina then return true end return o(self,a) end
                        end
                        if k=="setStamina" and type(fn)=="function" then
                            local o=fn mt[k]=function(self,v2) if S.infStamina then return o(self,1) end return o(self,v2) end
                        end
                    end
                end
            end
        end
    end)
    RunService.Heartbeat:Connect(function()
        if not S.infStamina then return end
        for _,inst in ipairs(instances) do pcall(function() rawset(inst,"stamina",1) end) end
        local char=LP.Character if not char then return end
        pcall(function()
            local hum=char:FindFirstChildOfClass("Humanoid") if not hum then return end
            for _,a in ipairs({"Stamina","stamina","STAMINA"}) do
                if hum:GetAttribute(a)~=nil then hum:SetAttribute(a,1) end
            end
            local sv=hum:FindFirstChild("Stamina") or hum:FindFirstChild("stamina")
            if sv and sv:IsA("NumberValue") then sv.Value=1 end
        end)
    end)
end)

-- ═══════════════════════════════════════════════
--  LOGIQUE : ANTI FALL
-- ═══════════════════════════════════════════════
local fallBV=nil
local function cleanFall()
    pcall(function() if fallBV and fallBV.Parent then fallBV:Destroy() end end)
    fallBV=nil
end
LP.CharacterRemoving:Connect(cleanFall)

RunService.Heartbeat:Connect(function()
    if not S.antiFall then cleanFall() return end
    local char=LP.Character if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local vel=hrp.AssemblyLinearVelocity
    local st=hum:GetState()
    if (vel.Y<-22 or st==Enum.HumanoidStateType.Freefall or st==Enum.HumanoidStateType.FallingDown) and vel.Y<-22 then
        if not fallBV or not fallBV.Parent then
            fallBV=Instance.new("BodyVelocity")
            fallBV.MaxForce=Vector3.new(0,math.huge,0) fallBV.P=1e5 fallBV.Parent=hrp
        end
        fallBV.Velocity=Vector3.new(0,math.max(vel.Y*0.82,-8),0)
    else cleanFall() end
end)

-- ═══════════════════════════════════════════════
--  LOGIQUE : VÉHICULE
-- ═══════════════════════════════════════════════
RunService.Heartbeat:Connect(function()
    local car=workspace.Vehicles and workspace.Vehicles:FindFirstChild(LP.Name)
    if not car then return end
    if S.speedBoost then
        local seat=car:FindFirstChild("DriveSeat")
        if seat then pcall(function() seat.MaxSpeed=S.speedValue end) end
    end
    if S.noFlat  then pcall(function() car:SetAttribute("flatTires",false) end) end
    if S.infFuel then
        local mx=car:GetAttribute("maxFuel") or 100
        pcall(function() car:SetAttribute("currentFuel",mx) end)
    end
end)

-- ═══════════════════════════════════════════════
--  LOGIQUE : GUN MOD
-- ═══════════════════════════════════════════════
LP.CharacterAdded:Connect(function()
    task.wait(2)
    if S.autoEquip then pcall(function() getR(REM_EQUIP):FireServer("Glock 17") end) end
end)

task.spawn(function()
    while task.wait(0.25) do
        if S.autoReload then
            pcall(function()
                local char=LP.Character if not char then return end
                local gun=char:FindFirstChild("Glock 17") if not gun then return end
                getR(REM_RELOAD):FireServer(gun)
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(S.rapidDelay or 0.05)
        if S.rapidFire then
            pcall(function()
                local char=LP.Character if not char then return end
                getR(REM_FIRE):FireServer(1,Camera.CFrame.LookVector,false,2668800)
            end)
        end
    end
end)

local isShooting=false
local _lastCamCF=nil
local savedCF=nil

UIS.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1
    or inp.UserInputType==Enum.UserInputType.Touch then isShooting=true end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1
    or inp.UserInputType==Enum.UserInputType.Touch then
        isShooting=false
        if savedCF then pcall(function() Camera.CFrame=savedCF end) savedCF=nil end
    end
end)

RunService.RenderStepped:Connect(function()
    if S.noRecoil then
        if isShooting then
            if not _lastCamCF then _lastCamCF=Camera.CFrame end
            pcall(function()
                Camera.CFrame=CFrame.new(Camera.CFrame.Position,
                    Camera.CFrame.Position+_lastCamCF.LookVector)
            end)
        else _lastCamCF=Camera.CFrame end
    else _lastCamCF=nil end
end)

-- ═══════════════════════════════════════════════
--  LOGIQUE : ESP
-- ═══════════════════════════════════════════════
local espData={}

local function newLine()
    local l=Drawing.new("Line") l.Visible=false l.Thickness=1.5 l.Transparency=1 return l
end
local function newText()
    local t=Drawing.new("Text") t.Visible=false t.Size=14 t.Center=true
    t.Outline=true t.OutlineColor=Color3.fromRGB(0,0,0) t.Font=Drawing.Fonts.UI t.Transparency=1 return t
end
local function getED(pl)
    if not espData[pl] then espData[pl]={hl=nil,tr=newLine(),nm=newText()} end
    return espData[pl]
end
local function removeED(pl)
    local d=espData[pl] if not d then return end
    pcall(function() if d.hl and d.hl.Parent then d.hl:Destroy() end end)
    pcall(function() d.tr:Remove() end) pcall(function() d.nm:Remove() end)
    espData[pl]=nil
end

Players.PlayerRemoving:Connect(removeED)
for _,pl in ipairs(Players:GetPlayers()) do
    pl.CharacterAdded:Connect(function() local d=espData[pl] if d then d.hl=nil end end)
end
Players.PlayerAdded:Connect(function(pl)
    pl.CharacterAdded:Connect(function() local d=espData[pl] if d then d.hl=nil end end)
end)

RunService.Heartbeat:Connect(function()
    local vp=Camera.ViewportSize
    local bot=Vector2.new(vp.X/2,vp.Y)
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LP then continue end
        local char=pl.Character
        local tname=nil pcall(function() tname=pl.Team and pl.Team.Name end)
        local col=tname and TEAM_COL[tname]
        local active=col~=nil and S.esp[tname]==true and char~=nil
        if not active then removeED(pl) continue end
        local d=getED(pl)
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local head=char:FindFirstChild("Head")
        -- Highlight
        if S.espHL then
            if not d.hl or not d.hl.Parent or d.hl.Parent~=char then
                pcall(function() if d.hl then d.hl:Destroy() end end)
                local h=Instance.new("Highlight")
                h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                h.FillTransparency=0.40 h.OutlineTransparency=0
                h.Parent=char d.hl=h
            end
            d.hl.FillColor=col d.hl.OutlineColor=col
        else if d.hl and d.hl.Parent then d.hl:Destroy() d.hl=nil end end
        -- Tracer + Nom
        if hrp then
            local sp,vis=Camera:WorldToViewportPoint(hrp.Position)
            if S.espTr then d.tr.Visible=vis d.tr.From=bot d.tr.To=Vector2.new(sp.X,sp.Y) d.tr.Color=col
            else d.tr.Visible=false end
            if S.espNm and head then
                local hp,hv=Camera:WorldToViewportPoint(head.Position+Vector3.new(0,1.5,0))
                d.nm.Visible=hv d.nm.Text=pl.Name d.nm.Position=Vector2.new(hp.X,hp.Y) d.nm.Color=col
            else d.nm.Visible=false end
        else d.tr.Visible=false d.nm.Visible=false end
    end
end)

-- ═══════════════════════════════════════════════
--  LOGIQUE : AIMBOT
-- ═══════════════════════════════════════════════
local fovC=Drawing.new("Circle")
fovC.NumSides=64 fovC.Thickness=1.5 fovC.Filled=false fovC.Visible=false

local function getTargetPart(char)
    if S.aTarget=="Head" then return char:FindFirstChild("Head")
    elseif S.aTarget=="Torso" then return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    else return char:FindFirstChild("HumanoidRootPart") end
end

local function getTarget()
    local vp=Camera.ViewportSize
    local center=Vector2.new(vp.X/2,vp.Y/2)
    local best,bd=nil,S.aFov
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl==LP then continue end
        local char=pl.Character if not char then continue end
        local part=getTargetPart(char)
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not part or not hum or hum.Health<=0 then continue end
        local sp,os=Camera:WorldToViewportPoint(part.Position)
        if not os then continue end
        local d=(Vector2.new(sp.X,sp.Y)-center).Magnitude
        if d<bd then bd=d best={part=part,char=char} end
    end
    return best
end

local function calcPos(t)
    local pos=t.part.Position
    if S.aPred>0 then
        local hrp=t.char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel=hrp.AssemblyLinearVelocity
            local dist=(Camera.CFrame.Position-pos).Magnitude
            pos=pos+vel*(dist/1000)*S.aPred
        end
    end
    return pos
end

RunService.RenderStepped:Connect(function()
    local vp=Camera.ViewportSize
    fovC.Visible=S.aimbot or S.silentAim
    fovC.Radius=S.aFov fovC.Color=S.aColor
    fovC.Position=Vector2.new(vp.X/2,vp.Y/2)
    if not S.aimbot and not S.silentAim then return end
    local t=getTarget() if not t then return end
    local pos=calcPos(t)
    local alpha=math.clamp(1/math.max(S.aSmooth,1),0.01,1)
    local goal=CFrame.new(Camera.CFrame.Position,pos)
    if S.silentAim and isShooting then
        if not savedCF then savedCF=Camera.CFrame end
        pcall(function() Camera.CFrame=goal end)
    elseif S.aimbot then
        pcall(function() Camera.CFrame=Camera.CFrame:Lerp(goal,alpha) end)
    end
end)
