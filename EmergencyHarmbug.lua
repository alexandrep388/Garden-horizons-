-- ╔══════════════════════════════════════════════════╗
-- ║        GD Studio | Emergency Harmbug             ║
-- ║        github.com/alexandrep388                  ║
-- ╚══════════════════════════════════════════════════╝

-- ──────────────────────────────────────────────────
--  SERVICES
-- ──────────────────────────────────────────────────
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local Teams        = game:GetService("Teams")

local LocalPlayer  = Players.LocalPlayer
local Camera       = workspace.CurrentCamera

-- ──────────────────────────────────────────────────
--  WINDUI
-- ──────────────────────────────────────────────────
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua", true
))()

-- ──────────────────────────────────────────────────
--  SOUND  (ID : 137402801272072)
-- ──────────────────────────────────────────────────
local SFX = Instance.new("Sound")
SFX.SoundId = "rbxassetid://137402801272072"
SFX.Volume  = 0.65
SFX.Parent  = LocalPlayer:WaitForChild("PlayerGui")

local function playSound()
    SFX.TimePosition = 0
    SFX:Play()
end

-- ──────────────────────────────────────────────────
--  LANGUES
-- ──────────────────────────────────────────────────
local LANGS = {
    ["EN 🇬🇧"] = {
        tabMain = "Main",          tabESP = "ESP",       tabAimbot = "Aimbot",
        secSettings = "Settings",  langLabel = "Language",
        langDesc = "Select your display language",
        secMovement = "Movement",
        infStamina = "Infinite Stamina", infStaminaDesc = "Stamina never runs out",
        antiFall = "Anti Fall",          antiFallDesc  = "Float gently to the ground, no damage",
        secTeams = "Team ESP",
        espPolice = "Police",  espPrisoner = "Prisoner",  espFire = "Fire Department",
        espHARS   = "HARS",    espTruck    = "Truck Company",
        secAimbot = "Aimbot Settings",
        aimbotToggle = "Aimbot",        aimbotToggleDesc = "Lock onto nearest enemy head",
        aimbotFOV    = "FOV Radius",    aimbotFOVDesc    = "On-screen detection radius",
        aimbotSmooth = "Smoothness",    aimbotSmoothDesc = "Lower = faster lock",
        aimbotColor  = "FOV Color",
        on = "Enabled", off = "Disabled",
    },
    ["FR 🇫🇷"] = {
        tabMain = "Principal",     tabESP = "ESP",       tabAimbot = "Aimbot",
        secSettings = "Paramètres", langLabel = "Langue",
        langDesc = "Choisissez votre langue d'affichage",
        secMovement = "Mouvement",
        infStamina = "Stamina Infinie", infStaminaDesc = "La stamina ne s'épuise jamais",
        antiFall = "Anti Chute",        antiFallDesc   = "Flotte doucement, aucun dégât",
        secTeams = "ESP par Équipe",
        espPolice = "Police",  espPrisoner = "Prisonnier",  espFire = "Pompiers",
        espHARS   = "HARS",    espTruck    = "Camionnage",
        secAimbot = "Paramètres Aimbot",
        aimbotToggle = "Aimbot",        aimbotToggleDesc = "Verrouille la tête de l'ennemi",
        aimbotFOV    = "Rayon FOV",     aimbotFOVDesc    = "Rayon de détection à l'écran",
        aimbotSmooth = "Fluidité",      aimbotSmoothDesc = "Plus bas = plus rapide",
        aimbotColor  = "Couleur FOV",
        on = "Activé", off = "Désactivé",
    },
    ["ES 🇪🇸"] = {
        tabMain = "Principal",     tabESP = "ESP",       tabAimbot = "Aimbot",
        secSettings = "Ajustes",   langLabel = "Idioma",
        langDesc = "Selecciona tu idioma de pantalla",
        secMovement = "Movimiento",
        infStamina = "Stamina Infinita", infStaminaDesc = "La stamina nunca se agota",
        antiFall = "Anti Caída",         antiFallDesc   = "Flota suavemente, sin daño",
        secTeams = "ESP por Equipo",
        espPolice = "Policía",  espPrisoner = "Prisionero",  espFire = "Bomberos",
        espHARS   = "HARS",     espTruck    = "Camioneros",
        secAimbot = "Config. Aimbot",
        aimbotToggle = "Aimbot",        aimbotToggleDesc = "Apunta a la cabeza del enemigo",
        aimbotFOV    = "Radio FOV",     aimbotFOVDesc    = "Radio de detección en pantalla",
        aimbotSmooth = "Suavidad",      aimbotSmoothDesc = "Más bajo = más rápido",
        aimbotColor  = "Color FOV",
        on = "Activado", off = "Desactivado",
    },
    ["PT 🇧🇷"] = {
        tabMain = "Principal",     tabESP = "ESP",       tabAimbot = "Aimbot",
        secSettings = "Config.",   langLabel = "Idioma",
        langDesc = "Selecione seu idioma de exibição",
        secMovement = "Movimento",
        infStamina = "Stamina Infinita", infStaminaDesc = "Stamina nunca acaba",
        antiFall = "Anti Queda",         antiFallDesc   = "Flutua suavemente, sem dano",
        secTeams = "ESP por Equipe",
        espPolice = "Polícia",  espPrisoner = "Prisioneiro",  espFire = "Bombeiros",
        espHARS   = "HARS",     espTruck    = "Caminhoneiros",
        secAimbot = "Config. Aimbot",
        aimbotToggle = "Aimbot",        aimbotToggleDesc = "Mira automaticamente na cabeça",
        aimbotFOV    = "Raio FOV",      aimbotFOVDesc    = "Raio de detecção na tela",
        aimbotSmooth = "Suavidade",     aimbotSmoothDesc = "Mais baixo = mais rápido",
        aimbotColor  = "Cor FOV",
        on = "Ativado", off = "Desativado",
    },
    ["DE 🇩🇪"] = {
        tabMain = "Haupt",         tabESP = "ESP",       tabAimbot = "Aimbot",
        secSettings = "Einstellungen", langLabel = "Sprache",
        langDesc = "Wähle deine Anzeigesprache",
        secMovement = "Bewegung",
        infStamina = "Unendl. Stamina", infStaminaDesc = "Stamina wird niemals aufgebraucht",
        antiFall = "Anti-Fall",          antiFallDesc   = "Schwebt sanft, kein Schaden",
        secTeams = "Team-ESP",
        espPolice = "Polizei",  espPrisoner = "Gefangener",  espFire = "Feuerwehr",
        espHARS   = "HARS",     espTruck    = "LKW-Firma",
        secAimbot = "Aimbot-Einstellungen",
        aimbotToggle = "Aimbot",        aimbotToggleDesc = "Zielt automatisch auf den Kopf",
        aimbotFOV    = "FOV-Radius",    aimbotFOVDesc    = "Erkennungsradius auf dem Bildschirm",
        aimbotSmooth = "Glättung",      aimbotSmoothDesc = "Niedriger = schneller",
        aimbotColor  = "FOV-Farbe",
        on = "Aktiviert", off = "Deaktiviert",
    },
}
local LANG_KEYS = {"EN 🇬🇧","FR 🇫🇷","ES 🇪🇸","PT 🇧🇷","DE 🇩🇪"}
local LANG_CODES = {["EN 🇬🇧"]="EN",["FR 🇫🇷"]="FR",["ES 🇪🇸"]="ES",["PT 🇧🇷"]="PT",["DE 🇩🇪"]="DE"}

-- Config folder
local FOLDER = "GDStudio_EHarmbug"
pcall(function() if not isfolder(FOLDER) then makefolder(FOLDER) end end)

-- Load saved language
local savedKey = "EN 🇬🇧"
pcall(function()
    local code = readfile(FOLDER .. "/language.txt")
    for _, k in ipairs(LANG_KEYS) do
        if LANG_CODES[k] == code then savedKey = k break end
    end
end)

local L = LANGS[savedKey]

-- ──────────────────────────────────────────────────
--  STATE
-- ──────────────────────────────────────────────────
local State = {
    infStamina   = false,
    antiFall     = false,
    aimbot       = false,
    aimbotFOV    = 150,
    aimbotSmooth = 5,
    aimbotColor  = Color3.fromRGB(255, 60, 60),
    esp = {
        Police         = false,
        Prisoner       = false,
        FireDepartment = false,
        HARS           = false,
        TruckCompany   = false,
    },
}

-- Team → highlight color
local TEAM_COLOR = {
    Police         = Color3.fromRGB(30,  110, 255),
    Prisoner       = Color3.fromRGB(255, 140,   0),
    FireDepartment = Color3.fromRGB(220,  30,  30),
    HARS           = Color3.fromRGB(230, 230,  80),
    TruckCompany   = Color3.fromRGB(210, 210, 210),
}

-- ──────────────────────────────────────────────────
--  THEME
-- ──────────────────────────────────────────────────
WindUI:AddTheme({
    Name       = "GDEmerald",
    Accent     = Color3.fromRGB(52,  211, 153),
    Background = Color3.fromRGB(13,   17,  23),
    Outline    = Color3.fromRGB(32,   44,  54),
    Text       = Color3.fromRGB(225, 240, 232),
    Placeholder= Color3.fromRGB(90,  120, 110),
    Button     = Color3.fromRGB(22,   32,  42),
    Icon       = Color3.fromRGB(52,  211, 153),
})
WindUI:SetTheme("GDEmerald")

-- ──────────────────────────────────────────────────
--  WINDOW
-- ──────────────────────────────────────────────────
local Window = WindUI:CreateWindow({
    Title       = "GD Studio",
    Icon        = "shield-check",
    Author      = "GD Studio",
    Folder      = FOLDER,
    Size        = UDim2.fromOffset(610, 460),
    Transparent = true,
    Resizable   = false,
})

Window:Tag({ Title = "Emergency Harmbug", Color = Color3.fromRGB(52, 211, 153), Radius = 20 })
Window:Tag({ Title = "🌐 " .. LANG_CODES[savedKey], Color = Color3.fromRGB(80, 160, 255), Radius = 20 })

-- ──────────────────────────────────────────────────
--  NOTIFY HELPER
-- ──────────────────────────────────────────────────
local function Notify(content, icon)
    playSound()
    task.spawn(function()
        WindUI:Notify({
            Title    = "GD Studio",
            Content  = content,
            Icon     = icon or "bell",
            Duration = 3,
            CanClose = true,
        })
    end)
end

-- ══════════════════════════════════════════════════
--  TAB : MAIN
-- ══════════════════════════════════════════════════
local MainTab = Window:Tab({ Title = L.tabMain, Icon = "layout-dashboard" })

-- ── Section : Settings ──────────────────────────
MainTab:Section({ Title = L.secSettings, Icon = "settings" })

MainTab:Dropdown({
    Title     = L.langLabel,
    Desc      = L.langDesc,
    Icon      = "globe",
    Values    = LANG_KEYS,
    Value     = savedKey,
    Multi     = false,
    AllowNone = false,
    Callback  = function(val)
        playSound()
        local code = LANG_CODES[val] or "EN"
        pcall(function() writefile(FOLDER .. "/language.txt", code) end)
        Notify("Language → " .. val .. "  (reload to apply)", "globe")
    end
})

-- ── Section : Movement ──────────────────────────
MainTab:Section({ Title = L.secMovement, Icon = "zap" })

MainTab:Toggle({
    Title    = L.infStamina,
    Desc     = L.infStaminaDesc,
    Icon     = "battery-charging",
    Type     = "Checkbox",
    Value    = false,
    Callback = function(v)
        State.infStamina = v
        playSound()
        Notify(L.infStamina .. " — " .. (v and L.on or L.off), "battery-charging")
    end
})

MainTab:Toggle({
    Title    = L.antiFall,
    Desc     = L.antiFallDesc,
    Icon     = "feather",
    Type     = "Checkbox",
    Value    = false,
    Callback = function(v)
        State.antiFall = v
        playSound()
        Notify(L.antiFall .. " — " .. (v and L.on or L.off), "feather")
    end
})

-- ══════════════════════════════════════════════════
--  TAB : ESP
-- ══════════════════════════════════════════════════
local ESPTab = Window:Tab({ Title = L.tabESP, Icon = "eye" })

ESPTab:Section({ Title = L.secTeams, Icon = "users" })

local espEntries = {
    { key = "Police",         label = L.espPolice,   icon = "shield"      },
    { key = "Prisoner",       label = L.espPrisoner, icon = "lock"        },
    { key = "FireDepartment", label = L.espFire,     icon = "flame"       },
    { key = "HARS",           label = L.espHARS,     icon = "heart-pulse" },
    { key = "TruckCompany",   label = L.espTruck,    icon = "truck"       },
}

for _, e in ipairs(espEntries) do
    ESPTab:Toggle({
        Title    = e.label,
        Icon     = e.icon,
        Type     = "Checkbox",
        Value    = false,
        Callback = function(v)
            State.esp[e.key] = v
            playSound()
        end
    })
end

-- ══════════════════════════════════════════════════
--  TAB : AIMBOT
-- ══════════════════════════════════════════════════
local AimbotTab = Window:Tab({ Title = L.tabAimbot, Icon = "crosshair" })

AimbotTab:Section({ Title = L.secAimbot, Icon = "target" })

AimbotTab:Toggle({
    Title    = L.aimbotToggle,
    Desc     = L.aimbotToggleDesc,
    Icon     = "target",
    Type     = "Checkbox",
    Value    = false,
    Callback = function(v)
        State.aimbot = v
        playSound()
        Notify(L.aimbotToggle .. " — " .. (v and L.on or L.off), "crosshair")
    end
})

AimbotTab:Slider({
    Title    = L.aimbotFOV,
    Desc     = L.aimbotFOVDesc,
    Icon     = "circle",
    Value    = { Min = 50, Max = 600, Default = 150 },
    Step     = 5,
    Callback = function(v) State.aimbotFOV = v end
})

AimbotTab:Slider({
    Title    = L.aimbotSmooth,
    Desc     = L.aimbotSmoothDesc,
    Icon     = "sliders-horizontal",
    Value    = { Min = 1, Max = 25, Default = 5 },
    Step     = 1,
    Callback = function(v) State.aimbotSmooth = v end
})

AimbotTab:Colorpicker({
    Title    = L.aimbotColor,
    Icon     = "palette",
    Value    = Color3.fromRGB(255, 60, 60),
    Callback = function(v) State.aimbotColor = v end
})

-- ══════════════════════════════════════════════════
--  INIT  (doit être APRÈS tous les tabs)
-- ══════════════════════════════════════════════════
Window:Init()

task.spawn(function()
    task.wait(0.8)
    Notify("Emergency Harmbug chargé ✓", "check-circle")
end)

-- ══════════════════════════════════════════════════
--  LOGIQUE : INFINITE STAMINA
-- ══════════════════════════════════════════════════
task.spawn(function()
    task.wait(3)
    local RS = game:GetService("ReplicatedStorage")

    -- Méthode 1 : hook direct sur le module CharacterStaminaController
    local hooked = false
    pcall(function()
        for _, desc in ipairs(RS:GetDescendants()) do
            if desc:IsA("ModuleScript") and (
                string.lower(desc.Name):find("stamina") or
                string.lower(desc.Name):find("character")
            ) then
                local ok, mod = pcall(require, desc)
                if ok and type(mod) == "table" and mod.CharacterStaminaController then
                    local cls = mod.CharacterStaminaController

                    local origSet = cls.setStamina
                    cls.setStamina = function(self, value)
                        if State.infStamina then return origSet(self, 1) end
                        return origSet(self, value)
                    end

                    local origUse = cls.useStamina
                    cls.useStamina = function(self, amount)
                        if State.infStamina then return true end
                        return origUse(self, amount)
                    end

                    hooked = true
                    break
                end
            end
        end
    end)

    -- Méthode 2 (fallback) : attribute Heartbeat
    if not hooked then
        RunService.Heartbeat:Connect(function()
            if not State.infStamina then return end
            local char = LocalPlayer.Character
            if not char then return end
            pcall(function()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                for _, attr in ipairs({"Stamina","stamina","STAMINA"}) do
                    if hum:GetAttribute(attr) ~= nil then
                        hum:SetAttribute(attr, 1)
                    end
                end
            end)
        end)
    end
end)

-- ══════════════════════════════════════════════════
--  LOGIQUE : ANTI FALL
--  → Ralentit la chute pour atterrir sans dégâts
-- ══════════════════════════════════════════════════
RunService.Heartbeat:Connect(function()
    if not State.antiFall then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if hum:GetState() == Enum.HumanoidStateType.Freefall then
        local vel = hrp.AssemblyLinearVelocity
        if vel.Y < -20 then
            -- Lévitation douce : approche progressive de -8 studs/s (seuil sans dégâts)
            hrp.AssemblyLinearVelocity = Vector3.new(
                vel.X,
                vel.Y + ((-8 - vel.Y) * 0.14),
                vel.Z
            )
        end
    end
end)

-- ══════════════════════════════════════════════════
--  LOGIQUE : ESP
-- ══════════════════════════════════════════════════
local espHL = {}   -- [Player] = Highlight

local function removeESP(player)
    if espHL[player] then
        pcall(function() espHL[player]:Destroy() end)
        espHL[player] = nil
    end
end

Players.PlayerRemoving:Connect(removeESP)

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local char     = player.Character
        local team     = player.Team
        local teamName = team and team.Name
        local color    = TEAM_COLOR[teamName]
        local show     = color and State.esp[teamName] and char ~= nil

        if show then
            local h = espHL[player]
            if not h or not h.Parent then
                h = Instance.new("Highlight")
                h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
                h.FillTransparency    = 0.52
                h.OutlineTransparency = 0
                h.Parent              = char
                espHL[player]         = h
            end
            h.FillColor    = color
            h.OutlineColor = color
        else
            removeESP(player)
        end
    end
end)

-- ══════════════════════════════════════════════════
--  LOGIQUE : AIMBOT + CERCLE FOV
-- ══════════════════════════════════════════════════
local fovCircle          = Drawing.new("Circle")
fovCircle.Visible        = false
fovCircle.Radius         = 150
fovCircle.Color          = Color3.fromRGB(255, 60, 60)
fovCircle.Thickness      = 1.5
fovCircle.NumSides       = 64
fovCircle.Filled         = false

local function getClosestHead()
    local vp      = Camera.ViewportSize
    local center  = Vector2.new(vp.X / 2, vp.Y / 2)
    local bestDist= State.aimbotFOV
    local bestHead= nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        if not head then continue end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local sp, onScreen = Camera:WorldToViewportPoint(head.Position)
        if not onScreen then continue end

        local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if dist < bestDist then
            bestDist = dist
            bestHead = head
        end
    end
    return bestHead
end

RunService.RenderStepped:Connect(function()
    -- Cercle FOV
    local vp = Camera.ViewportSize
    fovCircle.Visible  = State.aimbot
    fovCircle.Radius   = State.aimbotFOV
    fovCircle.Color    = State.aimbotColor
    fovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)

    -- Verrouillage tête
    if not State.aimbot then return end
    local head = getClosestHead()
    if not head then return end

    local alpha    = math.clamp(1 / State.aimbotSmooth, 0.02, 1)
    local targetCF = CFrame.new(Camera.CFrame.Position, head.Position)
    Camera.CFrame  = Camera.CFrame:Lerp(targetCF, alpha)
end)
