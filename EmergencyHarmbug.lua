-- ╔══════════════════════════════════════════════════════════╗
-- ║          GD Studio  ·  Emergency Harmbug                ║
-- ║          github.com/alexandrep388                       ║
-- ╚══════════════════════════════════════════════════════════╝

-- ─────────────────────────────────────────────────────────
--  SERVICES
-- ─────────────────────────────────────────────────────────
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UserInput    = game:GetService("UserInputService")

local LP           = Players.LocalPlayer
local Camera       = workspace.CurrentCamera

-- ─────────────────────────────────────────────────────────
--  ORION
-- ─────────────────────────────────────────────────────────
local OrionLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/jensonhirst/Orion/main/source", true
))()

-- ─────────────────────────────────────────────────────────
--  SON  (137402801272072)
-- ─────────────────────────────────────────────────────────
local SFX     = Instance.new("Sound")
SFX.SoundId   = "rbxassetid://137402801272072"
SFX.Volume    = 0.65
SFX.Parent    = LP:WaitForChild("PlayerGui")
local function sfx() SFX.TimePosition = 0 SFX:Play() end

-- ─────────────────────────────────────────────────────────
--  NOTIFY
-- ─────────────────────────────────────────────────────────
local function Notify(title, content)
    sfx()
    OrionLib:MakeNotification({
        Name    = title,
        Content = content,
        Image   = "rbxassetid://4483345875",
        Time    = 3,
    })
end

-- ─────────────────────────────────────────────────────────
--  LANGUES
-- ─────────────────────────────────────────────────────────
local LANGS = {
    EN = {
        tabMain="Main", tabESP="ESP", tabAim="Aimbot",
        secMove="Movement", secTeams="Team ESP", secVis="Visual Options", secAim="Aimbot",
        infSt="Infinite Stamina",   infStD="Stamina never runs out",
        aFall="Anti Fall",          aFallD="Float gently, no fall damage",
        langBtn="Language: ",
        espPolice="Police ESP",     espPrisoner="Prisoner ESP",
        espFire="Fire Dept ESP",    espHARS="HARS ESP",   espTruck="Truck Co. ESP",
        espHL="Highlight",          espHLD="Colored glow through walls",
        espTr="Tracers",            espTrD="Line from screen bottom to player",
        espNm="Player Names",       espNmD="Show names above heads",
        aOn="Aimbot",               aOnD="Lock onto enemy head",
        aFov="FOV Radius",          aFovD="Detection circle size",
        aSmth="Smoothness",         aSmthD="Lower = snappier lock",
        aPred="Prediction",         aPredD="Compensate for player movement",
        aCol="FOV Color",
        on="ON", off="OFF",
        notifOn=" → Enabled", notifOff=" → Disabled",
        loaded="Emergency Harmbug loaded ✓",
    },
    FR = {
        tabMain="Principal", tabESP="ESP", tabAim="Aimbot",
        secMove="Mouvement", secTeams="ESP Équipes", secVis="Options Visuelles", secAim="Aimbot",
        infSt="Stamina Infinie",    infStD="La stamina ne s'épuise jamais",
        aFall="Anti Chute",         aFallD="Flotte doucement, aucun dégât",
        langBtn="Langue: ",
        espPolice="ESP Police",     espPrisoner="ESP Prisonnier",
        espFire="ESP Pompiers",     espHARS="ESP HARS",   espTruck="ESP Camionnage",
        espHL="Surbrillance",       espHLD="Glow coloré à travers les murs",
        espTr="Traceurs",           espTrD="Ligne du bas de l'écran vers le joueur",
        espNm="Noms Joueurs",       espNmD="Affiche les noms au-dessus",
        aOn="Aimbot",               aOnD="Verrouille la tête de l'ennemi",
        aFov="Rayon FOV",           aFovD="Taille du cercle de détection",
        aSmth="Fluidité",           aSmthD="Plus bas = plus rapide",
        aPred="Prédiction",         aPredD="Compense le mouvement du joueur",
        aCol="Couleur FOV",
        on="ON", off="OFF",
        notifOn=" → Activé", notifOff=" → Désactivé",
        loaded="Emergency Harmbug chargé ✓",
    },
    ES = {
        tabMain="Principal", tabESP="ESP", tabAim="Aimbot",
        secMove="Movimiento", secTeams="ESP Equipos", secVis="Opciones Visuales", secAim="Aimbot",
        infSt="Stamina Infinita",   infStD="La stamina no se agota nunca",
        aFall="Anti Caída",         aFallD="Flota suavemente, sin daño",
        langBtn="Idioma: ",
        espPolice="ESP Policía",    espPrisoner="ESP Prisionero",
        espFire="ESP Bomberos",     espHARS="ESP HARS",   espTruck="ESP Camioneros",
        espHL="Resaltado",          espHLD="Brillo colorido a través de paredes",
        espTr="Trazadores",         espTrD="Línea desde el centro hasta el jugador",
        espNm="Nombres",            espNmD="Muestra nombres sobre las cabezas",
        aOn="Aimbot",               aOnD="Apunta a la cabeza del enemigo",
        aFov="Radio FOV",           aFovD="Tamaño del círculo de detección",
        aSmth="Suavidad",           aSmthD="Más bajo = más rápido",
        aPred="Predicción",         aPredD="Compensa el movimiento del jugador",
        aCol="Color FOV",
        on="ON", off="OFF",
        notifOn=" → Activado", notifOff=" → Desactivado",
        loaded="Emergency Harmbug cargado ✓",
    },
    PT = {
        tabMain="Principal", tabESP="ESP", tabAim="Aimbot",
        secMove="Movimento", secTeams="ESP Equipes", secVis="Opções Visuais", secAim="Aimbot",
        infSt="Stamina Infinita",   infStD="A stamina nunca acaba",
        aFall="Anti Queda",         aFallD="Flutua suavemente, sem dano",
        langBtn="Idioma: ",
        espPolice="ESP Polícia",    espPrisoner="ESP Prisioneiro",
        espFire="ESP Bombeiros",    espHARS="ESP HARS",   espTruck="ESP Caminhoneiros",
        espHL="Destaque",           espHLD="Brilho colorido através das paredes",
        espTr="Tracers",            espTrD="Linha da base da tela até o jogador",
        espNm="Nomes",              espNmD="Mostra nomes acima das cabeças",
        aOn="Aimbot",               aOnD="Mira na cabeça do inimigo",
        aFov="Raio FOV",            aFovD="Tamanho do círculo de detecção",
        aSmth="Suavidade",          aSmthD="Mais baixo = mais rápido",
        aPred="Predição",           aPredD="Compensa o movimento do jogador",
        aCol="Cor FOV",
        on="ON", off="OFF",
        notifOn=" → Ativado", notifOff=" → Desativado",
        loaded="Emergency Harmbug carregado ✓",
    },
    DE = {
        tabMain="Haupt", tabESP="ESP", tabAim="Aimbot",
        secMove="Bewegung", secTeams="Team-ESP", secVis="Visuelle Optionen", secAim="Aimbot",
        infSt="Unendl. Stamina",    infStD="Stamina wird niemals aufgebraucht",
        aFall="Anti-Fall",          aFallD="Gleitet sanft, kein Schaden",
        langBtn="Sprache: ",
        espPolice="ESP Polizei",    espPrisoner="ESP Gefangener",
        espFire="ESP Feuerwehr",    espHARS="ESP HARS",   espTruck="ESP LKW-Firma",
        espHL="Hervorhebung",       espHLD="Farbiges Leuchten durch Wände",
        espTr="Tracer",             espTrD="Linie vom Bildschirmrand zum Spieler",
        espNm="Spielernamen",       espNmD="Namen über Köpfen anzeigen",
        aOn="Aimbot",               aOnD="Zielt automatisch auf den Kopf",
        aFov="FOV-Radius",          aFovD="Größe des Erkennungskreises",
        aSmth="Glättung",           aSmthD="Niedriger = schneller",
        aPred="Vorhersage",         aPredD="Kompensiert die Spielerbewegung",
        aCol="FOV-Farbe",
        on="ON", off="OFF",
        notifOn=" → Aktiviert", notifOff=" → Deaktiviert",
        loaded="Emergency Harmbug geladen ✓",
    },
}
local LANG_ORDER = {"EN","FR","ES","PT","DE"}
local LANG_FLAG  = {EN="🇬🇧",FR="🇫🇷",ES="🇪🇸",PT="🇧🇷",DE="🇩🇪"}

-- ─── Sauvegarde langue ────────────────────────────────────
local FOLDER = "GDStudio_EHarmbug"
pcall(function() if not isfolder(FOLDER) then makefolder(FOLDER) end end)

local currentLang = "EN"
pcall(function()
    local s = readfile(FOLDER.."/language.txt")
    if LANGS[s] then currentLang = s end
end)
local L = LANGS[currentLang]

local function cycleLang()
    local idx = 1
    for i,c in ipairs(LANG_ORDER) do if c==currentLang then idx=i break end end
    currentLang = LANG_ORDER[(idx%#LANG_ORDER)+1]
    L = LANGS[currentLang]
    pcall(function() writefile(FOLDER.."/language.txt", currentLang) end)
    sfx()
    Notify("🌐 Language", LANG_FLAG[currentLang].." "..currentLang.." — reload for full translation")
end

-- ─────────────────────────────────────────────────────────
--  STATE
-- ─────────────────────────────────────────────────────────
local S = {
    infStamina = false,
    antiFall   = false,
    espHL      = true,
    espTr      = false,
    espNm      = false,
    esp = {
        Police=false, Prisoner=false, FireDepartment=false,
        HARS=false, TruckCompany=false,
    },
    aimbot  = false,
    aFov    = 150,
    aSmooth = 5,
    aPred   = 0,
    aColor  = Color3.fromRGB(255, 60, 60),
}

local TEAM_COL = {
    Police         = Color3.fromRGB(30,  110, 255),
    Prisoner       = Color3.fromRGB(255, 140,   0),
    FireDepartment = Color3.fromRGB(220,  30,  30),
    HARS           = Color3.fromRGB(230, 230,  80),
    TruckCompany   = Color3.fromRGB(215, 215, 215),
}

-- ─────────────────────────────────────────────────────────
--  FENÊTRE ORION
-- ─────────────────────────────────────────────────────────
local Window = OrionLib:MakeWindow({
    Name          = "GD Studio  ·  Emergency Harmbug",
    HidePremium   = true,
    SaveConfig    = false,
    IntroEnabled  = true,
    IntroText     = "GD Studio",
    IntroIcon     = "rbxassetid://4483345875",
})

-- ══════════════════════════════════════════════════════════
--  TAB : MAIN
-- ══════════════════════════════════════════════════════════
local MainTab = Window:MakeTab({Name = L.tabMain, Icon = "rbxassetid://4483345875", PremiumOnly = false})

-- Bouton cycle langue
MainTab:AddSection({Name = "🌐 Language"})
MainTab:AddButton({
    Name     = L.langBtn .. LANG_FLAG[currentLang] .. " " .. currentLang,
    Callback = cycleLang,
})

MainTab:AddSection({Name = L.secMove})

MainTab:AddToggle({
    Name     = L.infSt,
    Default  = false,
    Callback = function(v)
        S.infStamina = v
        sfx()
        Notify(L.infSt, v and L.notifOn or L.notifOff)
    end,
})

MainTab:AddToggle({
    Name     = L.aFall,
    Default  = false,
    Callback = function(v)
        S.antiFall = v
        sfx()
        Notify(L.aFall, v and L.notifOn or L.notifOff)
    end,
})

-- ══════════════════════════════════════════════════════════
--  TAB : ESP
-- ══════════════════════════════════════════════════════════
local ESPTab = Window:MakeTab({Name = L.tabESP, Icon = "rbxassetid://4483345875", PremiumOnly = false})

ESPTab:AddSection({Name = L.secTeams})

local espDefs = {
    {key="Police",         label=L.espPolice},
    {key="Prisoner",       label=L.espPrisoner},
    {key="FireDepartment", label=L.espFire},
    {key="HARS",           label=L.espHARS},
    {key="TruckCompany",   label=L.espTruck},
}
for _,e in ipairs(espDefs) do
    ESPTab:AddToggle({
        Name     = e.label,
        Default  = false,
        Callback = function(v) S.esp[e.key]=v sfx() end,
    })
end

ESPTab:AddSection({Name = L.secVis})

ESPTab:AddToggle({Name=L.espHL,  Default=true,  Callback=function(v) S.espHL=v sfx() end})
ESPTab:AddToggle({Name=L.espTr,  Default=false, Callback=function(v) S.espTr=v sfx() end})
ESPTab:AddToggle({Name=L.espNm,  Default=false, Callback=function(v) S.espNm=v sfx() end})

-- ══════════════════════════════════════════════════════════
--  TAB : AIMBOT
-- ══════════════════════════════════════════════════════════
local AimTab = Window:MakeTab({Name = L.tabAim, Icon = "rbxassetid://4483345875", PremiumOnly = false})

AimTab:AddSection({Name = L.secAim})

AimTab:AddToggle({
    Name     = L.aOn,
    Default  = false,
    Callback = function(v)
        S.aimbot = v sfx()
        Notify(L.aOn, v and L.notifOn or L.notifOff)
    end,
})

AimTab:AddSlider({
    Name     = L.aFov,
    Min      = 30,
    Max      = 700,
    Default  = 150,
    Color    = Color3.fromRGB(255, 60, 60),
    Increment= 5,
    Callback = function(v) S.aFov=v end,
})

AimTab:AddSlider({
    Name     = L.aSmth,
    Min      = 1,
    Max      = 30,
    Default  = 5,
    Color    = Color3.fromRGB(52, 211, 153),
    Increment= 1,
    Callback = function(v) S.aSmooth=v end,
})

AimTab:AddSlider({
    Name     = L.aPred,
    Min      = 0,
    Max      = 30,
    Default  = 0,
    Color    = Color3.fromRGB(255, 200, 50),
    Increment= 1,
    Callback = function(v) S.aPred=v end,
})

AimTab:AddColorpicker({
    Name     = L.aCol,
    Default  = Color3.fromRGB(255, 60, 60),
    Callback = function(v) S.aColor=v end,
})

-- ─────────────────────────────────────────────────────────
--  INIT ORION
-- ─────────────────────────────────────────────────────────
OrionLib:Init()

task.spawn(function()
    task.wait(1)
    Notify("GD Studio", L.loaded)
end)

-- ══════════════════════════════════════════════════════════
--  LOGIQUE : INFINITE STAMINA
--  Méthode fiable sur mobile : hook via le module require
--  + fallback rawset Heartbeat direct sur l'objet stamina
-- ══════════════════════════════════════════════════════════
task.spawn(function()
    task.wait(5)

    local RS   = game:GetService("ReplicatedStorage")
    local stObj = nil

    -- Cherche le module CharacterStaminaController
    local function tryRequire(inst)
        local ok, res = pcall(require, inst)
        if not ok then return nil end
        if type(res) ~= "table" then return nil end
        local cls = res.CharacterStaminaController
        if not cls then return nil end
        return cls
    end

    local stCls = nil
    for _, d in ipairs(RS:GetDescendants()) do
        if d:IsA("ModuleScript") then
            local cls = tryRequire(d)
            if cls then stCls = cls break end
        end
    end

    if stCls then
        -- Hook au niveau de la classe (affecte toutes les instances)
        local origSet = stCls.setStamina
        local origUse = stCls.useStamina

        if type(origSet) == "function" then
            stCls.setStamina = function(self, val)
                if S.infStamina then return origSet(self, 1) end
                return origSet(self, val)
            end
        end
        if type(origUse) == "function" then
            stCls.useStamina = function(self, amount)
                if S.infStamina then return true end
                return origUse(self, amount)
            end
        end

        -- Cherche aussi l'instance live pour rawset
        pcall(function()
            for _, v in ipairs(getgc(true)) do
                if type(v)=="table"
                and rawget(v,"stamina")~=nil
                and getmetatable(v)==stCls then
                    stObj = v break
                end
            end
        end)
    end

    -- Heartbeat : force stamina = 1 via rawset si instance trouvée
    RunService.Heartbeat:Connect(function()
        if not S.infStamina then return end
        if stObj then
            pcall(function() rawset(stObj, "stamina", 1) end)
        end
        -- Fallback attribut humanoid
        local char = LP.Character
        if not char then return end
        pcall(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            for _, a in ipairs({"Stamina","stamina","STAMINA","staminaValue"}) do
                if hum:GetAttribute(a) ~= nil then
                    hum:SetAttribute(a, 1)
                end
            end
            -- Parfois stocké dans un ValueBase
            local sv = hum:FindFirstChild("Stamina") or hum:FindFirstChild("stamina")
            if sv and sv:IsA("NumberValue") then sv.Value = 1 end
        end)
    end)
end)

-- ══════════════════════════════════════════════════════════
--  LOGIQUE : ANTI FALL
--  Utilise LinearVelocity (nouveau) avec fallback BodyVelocity
-- ══════════════════════════════════════════════════════════
local fallAttachment = nil
local fallLinear     = nil
local fallBV         = nil

local function cleanFall()
    pcall(function() if fallLinear    then fallLinear:Destroy()    end end)
    pcall(function() if fallBV        then fallBV:Destroy()        end end)
    pcall(function() if fallAttachment then fallAttachment:Destroy() end end)
    fallLinear = nil fallBV = nil fallAttachment = nil
end

LP.CharacterRemoving:Connect(cleanFall)

RunService.Heartbeat:Connect(function()
    if not S.antiFall then cleanFall() return end

    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Vérifie si on est en chute (state OU vélocité Y très négative)
    local vel      = hrp.AssemblyLinearVelocity
    local state    = hum:GetState()
    local isFalling = vel.Y < -22
        or state == Enum.HumanoidStateType.Freefall
        or state == Enum.HumanoidStateType.FallingDown

    if isFalling and vel.Y < -22 then
        -- Essaye LinearVelocity d'abord (Roblox moderne)
        local ok = pcall(function()
            if not fallAttachment or not fallAttachment.Parent then
                fallAttachment = Instance.new("Attachment")
                fallAttachment.Parent = hrp
            end
            if not fallLinear or not fallLinear.Parent then
                fallLinear = Instance.new("LinearVelocity")
                fallLinear.Attachment0   = fallAttachment
                fallLinear.MaxForce      = 1e6
                fallLinear.RelativeTo    = Enum.ActuatorRelativeTo.World
                fallLinear.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
                fallLinear.LineDirection = Vector3.new(0,1,0)
                fallLinear.Parent        = hrp
            end
            -- Freine la chute doucement, cible -8 studs/s
            local target = math.max(vel.Y * 0.80, -8)
            fallLinear.LineVelocity = target
        end)

        -- Fallback BodyVelocity si LinearVelocity échoue
        if not ok then
            pcall(function()
                if not fallBV or not fallBV.Parent then
                    fallBV = Instance.new("BodyVelocity")
                    fallBV.MaxForce = Vector3.new(0, math.huge, 0)
                    fallBV.P        = 1e5
                    fallBV.Parent   = hrp
                end
                fallBV.Velocity = Vector3.new(0, math.max(vel.Y*0.80, -8), 0)
            end)
        end
    else
        cleanFall()
    end
end)

-- ══════════════════════════════════════════════════════════
--  LOGIQUE : ESP  —  Highlight + Tracer + Nom
-- ══════════════════════════════════════════════════════════
local espData = {}

local function newLine()
    local l = Drawing.new("Line")
    l.Visible     = false
    l.Thickness   = 1.2
    l.Transparency= 1
    return l
end
local function newText()
    local t = Drawing.new("Text")
    t.Visible    = false
    t.Size       = 14
    t.Center     = true
    t.Outline    = true
    t.OutlineColor=Color3.fromRGB(0,0,0)
    t.Font       = Drawing.Fonts.UI
    t.Transparency=1
    return t
end

local function getED(pl)
    if not espData[pl] then
        espData[pl] = {hl=nil, tr=newLine(), nm=newText()}
    end
    return espData[pl]
end

local function removeED(pl)
    local d = espData[pl]
    if not d then return end
    pcall(function() if d.hl and d.hl.Parent then d.hl:Destroy() end end)
    pcall(function() d.tr:Remove() end)
    pcall(function() d.nm:Remove() end)
    espData[pl] = nil
end

Players.PlayerRemoving:Connect(removeED)

-- Nettoie quand le perso meurt / respawn
Players.PlayerAdded:Connect(function(pl)
    pl.CharacterRemoving:Connect(function()
        local d = espData[pl]
        if d and d.hl and d.hl.Parent then
            pcall(function() d.hl:Destroy() end)
            d.hl = nil
        end
    end)
end)

RunService.Heartbeat:Connect(function()
    local vp  = Camera.ViewportSize
    local bot = Vector2.new(vp.X/2, vp.Y)

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP then continue end

        local char = pl.Character
        local team = pl.Team
        -- Vérifie le nom de l'équipe de façon sécurisée
        local tname = nil
        pcall(function() tname = team and team.Name end)

        local col    = tname and TEAM_COL[tname]
        local active = col ~= nil and S.esp[tname] == true and char ~= nil

        if not active then
            removeED(pl)
            continue
        end

        local d    = getED(pl)
        local hrp  = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")

        -- ── Highlight ──
        if S.espHL then
            if not d.hl or not d.hl.Parent then
                local h = Instance.new("Highlight")
                h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
                h.FillTransparency    = 0.48
                h.OutlineTransparency = 0
                h.Parent              = char
                d.hl = h
            end
            d.hl.FillColor    = col
            d.hl.OutlineColor = col
        else
            if d.hl and d.hl.Parent then d.hl:Destroy() d.hl=nil end
        end

        -- ── Tracer + Nom ──
        if hrp then
            local sp, vis = Camera:WorldToViewportPoint(hrp.Position)

            if S.espTr then
                d.tr.Visible = vis
                d.tr.From    = bot
                d.tr.To      = Vector2.new(sp.X, sp.Y)
                d.tr.Color   = col
            else
                d.tr.Visible = false
            end

            if S.espNm and head then
                local hp, hv = Camera:WorldToViewportPoint(
                    head.Position + Vector3.new(0, 1.5, 0)
                )
                d.nm.Visible   = hv
                d.nm.Text      = pl.Name
                d.nm.Position  = Vector2.new(hp.X, hp.Y)
                d.nm.Color     = col
            else
                d.nm.Visible = false
            end
        else
            d.tr.Visible = false
            d.nm.Visible = false
        end
    end
end)

-- ══════════════════════════════════════════════════════════
--  LOGIQUE : AIMBOT  —  FOV Drawing + prédiction + lock tête
-- ══════════════════════════════════════════════════════════
local fovC = Drawing.new("Circle")
fovC.NumSides    = 64
fovC.Thickness   = 1.5
fovC.Filled      = false
fovC.Visible     = false

local function getTarget()
    local vp     = Camera.ViewportSize
    local center = Vector2.new(vp.X/2, vp.Y/2)
    local best, bd = nil, S.aFov

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LP then continue end
        local char = pl.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not head or not hum or hum.Health <= 0 then continue end

        local sp, os = Camera:WorldToViewportPoint(head.Position)
        if not os then continue end

        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if d < bd then bd=d best={head=head, char=char} end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    local vp = Camera.ViewportSize
    fovC.Visible   = S.aimbot
    fovC.Radius    = S.aFov
    fovC.Color     = S.aColor
    fovC.Position  = Vector2.new(vp.X/2, vp.Y/2)

    if not S.aimbot then return end

    local t = getTarget()
    if not t then return end

    -- Prédiction de mouvement
    local pos = t.head.Position
    if S.aPred > 0 then
        local hrp = t.char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel  = hrp.AssemblyLinearVelocity
            local dist = (Camera.CFrame.Position - pos).Magnitude
            pos = pos + vel * (dist / 1000) * S.aPred
        end
    end

    local alpha  = math.clamp(1 / math.max(S.aSmooth, 1), 0.01, 1)
    local target = CFrame.new(Camera.CFrame.Position, pos)
    pcall(function()
        Camera.CFrame = Camera.CFrame:Lerp(target, alpha)
    end)
end)
