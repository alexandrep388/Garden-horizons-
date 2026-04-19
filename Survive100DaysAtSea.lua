-- ============================================================
--  GD Studio | Survive 100 Days at Sea
--  WindUI v1.6.63 | No Key System
-- ============================================================

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- ============================================================
--  SERVICES & LOCALS
-- ============================================================
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
--  AURA MODULE  (Render_Damage + DamageHighlight heartbeat)
--  Basé sur le code décompilé fourni
-- ============================================================
local AuraModule    = {}
local _GlobalAPI    = require(game.ReplicatedStorage.GlobalAPI)
local _Assets       = game.ReplicatedStorage.Assets

local _hlInterval   = 0.025
local _lastHLTime   = os.clock()
local _lastHBTime   = os.clock()
local _highlight    = nil
local _healthBar    = nil

function AuraModule.Render_Damage(model, healthObj)
    if _highlight then
        _highlight.Adornee = model
    end
    if not _healthBar then
        _healthBar        = _Assets.UI.HealthBar:Clone()
        _healthBar.Parent = PlayerGui
    end

    local now  = os.clock()
    _lastHBTime = now

    local showBar = true
    local hp, maxHp = 0, 10
    local humanoid = model:FindFirstChild("Humanoid")

    if humanoid then
        hp    = humanoid.Health
        maxHp = humanoid.MaxHealth
        if humanoid.HealthDisplayType == Enum.HumanoidHealthDisplayType.AlwaysOff then
            showBar = false
        end
    else
        local hVal = healthObj or model:FindFirstChild("Health")
        if hVal then
            hp    = hVal.Value
            maxHp = hVal:GetAttribute("Max") or 100
        end
    end

    if showBar then
        _healthBar.Adornee       = model
        _lastHLTime              = os.clock()
        _healthBar.Bar.Fill.Size = UDim2.new(hp / maxHp, 0, 1, 0)
        _GlobalAPI.Thread(3, function()
            if _healthBar.Adornee == model and _lastHBTime == now then
                _healthBar.Adornee = nil
            end
        end)
    end
end

-- Heartbeat : gère le clignotement du DamageHighlight
RunService.Heartbeat:Connect(function()
    if not _highlight or (not _highlight.Parent or _highlight.Parent ~= PlayerGui) then
        if _highlight then
            _highlight.Enabled  = false
            _highlight.Adornee  = nil
        end
        _highlight        = _Assets.UI.DamageHighlight:Clone()
        _highlight.Parent = PlayerGui
    end

    if _highlight.Adornee == nil or _hlInterval >= os.clock() - _lastHLTime then
        if _highlight.Adornee == nil and (_highlight.Enabled or _hlInterval > 0.025) then
            _highlight.Enabled = false
            _hlInterval        = 0.025
        end
    else
        _hlInterval = _hlInterval * 1.25
        _highlight.Enabled = true
        _highlight.FillTransparency = (_highlight.FillTransparency <= 0.5) and 0.65 or 0.5
        if _hlInterval > 0.3 then
            _highlight.Adornee  = nil
            _hlInterval         = 0.025
            _highlight.Enabled  = false
        end
    end
end)

-- ============================================================
--  AURA CONFIG (modifiable via Settings)
-- ============================================================
local AuraCfg = {
    Enabled  = false,
    Range    = 50,     -- studs
    Damage   = 25,     -- HP par tick
    Speed    = 1.0,    -- secondes entre chaque tick
}

-- ============================================================
--  FONCTIONS AURA
-- ============================================================

-- Retourne tous les modèles dans workspace avec Humanoid ou Health
local function GetEntities()
    local entities = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= LocalPlayer.Character then
            local hum   = obj:FindFirstChildOfClass("Humanoid")
            local hval  = obj:FindFirstChild("Health")
            local root  = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("RootPart") or obj.PrimaryPart
            if (hum or hval) and root then
                table.insert(entities, { model = obj, humanoid = hum, healthVal = hval, root = root })
            end
        end
    end
    return entities
end

-- Applique les dégâts à une entité
local function DealDamage(entry)
    local hum   = entry.humanoid
    local hval  = entry.healthVal
    local model = entry.model

    -- Tentative 1 : Humanoid:TakeDamage (fonctionne si sans FE strict)
    if hum and hum.Health > 0 then
        pcall(function() hum:TakeDamage(AuraCfg.Damage) end)
    end

    -- Tentative 2 : Modifier la value Health directement
    if hval then
        pcall(function()
            hval.Value = math.max(0, hval.Value - AuraCfg.Damage)
        end)
    end

    -- Tentative 3 : RemoteEvent communs du jeu
    local dmgRE = game.ReplicatedStorage:FindFirstChild("DamageEntity")
                  or game.ReplicatedStorage:FindFirstChild("Damage")
                  or game.ReplicatedStorage:FindFirstChild("TakeDamage")
    if dmgRE and dmgRE:IsA("RemoteEvent") then
        pcall(function() dmgRE:FireServer(model, AuraCfg.Damage) end)
    end

    -- Rendu visuel
    AuraModule.Render_Damage(model, hval)
end

-- Boucle principale de l'Aura
local _auraThread = nil

local function StartAura()
    if _auraThread then return end
    _auraThread = task.spawn(function()
        while AuraCfg.Enabled do
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local origin   = hrp.Position
                local entities = GetEntities()

                for _, entry in ipairs(entities) do
                    local dist = (entry.root.Position - origin).Magnitude
                    if dist <= AuraCfg.Range then
                        DealDamage(entry)
                    end
                end
            end

            task.wait(AuraCfg.Speed)
        end
        _auraThread = nil
    end)
end

local function StopAura()
    AuraCfg.Enabled = false
    _auraThread     = nil
end

-- ============================================================
--  THÈME EMERALD (GD Studio)
-- ============================================================
WindUI:AddTheme({
    Name        = "GDEmerald",
    Accent      = Color3.fromRGB(4,  120, 87),
    Background  = Color3.fromRGB(1,  20,  17),
    Outline     = Color3.fromRGB(255,255,255),
    Text        = Color3.fromRGB(236,253,245),
    Placeholder = Color3.fromRGB(63, 191,143),
    Button      = Color3.fromRGB(5,  150,105),
    Icon        = Color3.fromRGB(16, 185,129),
})
WindUI:SetTheme("GDEmerald")

-- ============================================================
--  FENÊTRE PRINCIPALE
-- ============================================================
local Window = WindUI:CreateWindow({
    Title          = "Survive 100 Days at Sea",
    Icon           = "rbxassetid://10734950309",
    Author         = "GD Studio",
    Folder         = "Survive100dayinsea",
    Transparent    = true,
    Resizable      = false,
    HideSearchBar  = false,
    ScrollBarEnabled = true,
})

-- ============================================================
--  SECTIONS & TABS
-- ============================================================
local MainGroup   = Window:Section({ Title = "Principal",  Icon = "rbxassetid://10723342555", Opened = true  })
local TabInfo     = MainGroup:Tab({  Title = "INFO",        Icon = "rbxassetid://10723344430" })
local TabMain     = MainGroup:Tab({  Title = "MAIN",        Icon = "rbxassetid://10723342321" })

local BringGroup  = Window:Section({ Title = "Bring",      Icon = "rbxassetid://10734950153", Opened = false })
local TabOther    = BringGroup:Tab({ Title = "Other",       Icon = "rbxassetid://10723343606" })
local TabAura     = BringGroup:Tab({ Title = "Aura",        Icon = "rbxassetid://10734949168" })
local TabMiscs    = BringGroup:Tab({ Title = "Miscs",       Icon = "rbxassetid://10734897102" })
local TabFarm     = BringGroup:Tab({ Title = "Farm",        Icon = "rbxassetid://10723344331" })

local ThirdsGroup = Window:Section({ Title = "Thirds",     Icon = "rbxassetid://10734951102", Opened = false })
local TabAuto     = ThirdsGroup:Tab({ Title = "Auto",       Icon = "rbxassetid://10723341857" })
local TabTeleport = ThirdsGroup:Tab({ Title = "Teleport",   Icon = "rbxassetid://10734950020" })
local TabUpdate   = ThirdsGroup:Tab({ Title = "UPDATE!",    Icon = "rbxassetid://10734950680" })
local TabSetting  = ThirdsGroup:Tab({ Title = "Setting",    Icon = "rbxassetid://10734950309" })

-- ============================================================
--  TAB : INFO
-- ============================================================
local InfoSect = TabInfo:Section({ Title = "GD Studio" })
InfoSect:Paragraph({
    Title   = "Survive 100 Days at Sea",
    Desc    = "Script by GD Studio\nVersion : 1.0.0\nDiscord : discord.gg/gdstudio",
    Icon    = "rbxassetid://10734950309",
})

-- ============================================================
--  TAB : MAIN
-- ============================================================
local MainSect = TabMain:Section({ Title = "Main" })
MainSect:Button({ Title = "Inf Jump",    Icon = "rbxassetid://10723342321",
    Callback = function()
        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpHeight = 999 end
    end
})
MainSect:Toggle({ Title = "Fullbright", Icon = "rbxassetid://10723342555", Value = false,
    Callback = function(v)
        game.Lighting.Brightness        = v and 2 or 1
        game.Lighting.ClockTime         = v and 14 or game.Lighting.ClockTime
        game.Lighting.FogEnd            = v and 100000 or 1000
        game.Lighting.GlobalShadows     = not v
        game.Lighting.OutdoorAmbient    = v and Color3.fromRGB(128,128,128) or Color3.fromRGB(70,70,70)
    end
})

-- ============================================================
--  TAB : OTHER (BRING)
-- ============================================================
local BringSetSect = TabOther:Section({ Title = "Setting" })
BringSetSect:Dropdown({ Title = "Vitesse de bring", Values = {"Lent","Moyen","Rapide"}, Value = "Moyen",
    Callback = function() end
})

local DebrisSect = TabOther:Section({ Title = "Bring" })
DebrisSect:Toggle({ Title = "TP Debris", Value = false, Callback = function() end })
local ArmorSect = TabOther:Section({ Title = "Armure" })
ArmorSect:Toggle({ Title = "TP Armure", Value = false, Callback = function() end })

-- ============================================================
--  TAB : MISCS
-- ============================================================
local MachineSect = TabMiscs:Section({ Title = "Machine" })
MachineSect:Toggle({ Title = "Auto active machine", Value = false, Callback = function() end })

-- ============================================================
--  TAB : AURA  ★ FONCTIONNEL ★
-- ============================================================

-- Section : Config locale dans l'onglet Aura
local AuraLocalCfgSect = TabAura:Section({ Title = "⚙ Configuration" })

local auraRangeSlider = AuraLocalCfgSect:Slider({
    Title = "Portée (studs)",
    Desc  = "Distance maximale pour toucher les entités",
    Step  = 1,
    Value = { Min = 5, Max = 150, Default = 50 },
    Callback = function(v)
        AuraCfg.Range = v
    end
})

local auraDmgSlider = AuraLocalCfgSect:Slider({
    Title = "Dégâts par tick",
    Desc  = "HP retirés à chaque tick",
    Step  = 1,
    Value = { Min = 1, Max = 100, Default = 25 },
    Callback = function(v)
        AuraCfg.Damage = v
    end
})

local auraSpeedSlider = AuraLocalCfgSect:Slider({
    Title = "Vitesse (intervalle sec.)",
    Desc  = "Délai entre chaque attaque (0.1 = très rapide)",
    Step  = 0.1,
    Value = { Min = 0.1, Max = 5.0, Default = 1.0 },
    Callback = function(v)
        AuraCfg.Speed = v
    end
})

-- Section : Activation
local AuraToggleSect = TabAura:Section({ Title = "★ Aura" })

AuraToggleSect:Toggle({
    Title = "Activer l'Aura",
    Desc  = "Inflige des dégâts à toutes les entités proches",
    Icon  = "rbxassetid://10734949168",
    Value = false,
    Callback = function(v)
        AuraCfg.Enabled = v
        if v then
            StartAura()
            task.spawn(function()
                task.wait(0.1)
                WindUI:Notify({
                    Title    = "Aura Activée",
                    Content  = "Portée : " .. AuraCfg.Range .. " studs | Dégâts : " .. AuraCfg.Damage,
                    Duration = 3,
                    Icon     = "rbxassetid://10734949168",
                    CanClose = true,
                })
            end)
        else
            StopAura()
            task.spawn(function()
                task.wait(0.1)
                WindUI:Notify({
                    Title    = "Aura Désactivée",
                    Content  = "L'aura a été stoppée.",
                    Duration = 2,
                    Icon     = "rbxassetid://10723344430",
                    CanClose = true,
                })
            end)
        end
    end,
})

-- Bouton : tuer immédiatement tout dans la portée (one-shot)
AuraToggleSect:Button({
    Title = "One-Shot Aura",
    Desc  = "Inflige 9999 dégâts une seule fois dans la portée",
    Icon  = "rbxassetid://10734950153",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local savedDmg    = AuraCfg.Damage
        AuraCfg.Damage    = 9999
        local origin      = hrp.Position
        local entities    = GetEntities()
        for _, entry in ipairs(entities) do
            if (entry.root.Position - origin).Magnitude <= AuraCfg.Range then
                DealDamage(entry)
            end
        end
        AuraCfg.Damage = savedDmg

        task.spawn(function()
            task.wait(0.1)
            WindUI:Notify({
                Title    = "One-Shot",
                Content  = "Toutes les entités dans " .. AuraCfg.Range .. " studs ont été frappées !",
                Duration = 3,
                Icon     = "rbxassetid://10734950153",
                CanClose = true,
            })
        end)
    end,
})

-- ============================================================
--  TAB : TELEPORT
-- ============================================================
local PeopleSect = TabTeleport:Section({ Title = "Joueurs" })
local selectedPlayer = nil
PeopleSect:Dropdown({
    Title  = "Joueur",
    Values = (function()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        return names
    end)(),
    Callback = function(v) selectedPlayer = v end,
})
PeopleSect:Button({ Title = "TP vers joueur", Callback = function()
    if selectedPlayer then
        local target = Players:FindFirstChild(selectedPlayer)
        if target and target.Character then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(3,0,0)
            end
        end
    end
end })

-- ============================================================
--  TAB : AUTO
-- ============================================================
TabAuto:Section({ Title = "Auto" }):Paragraph({
    Title = "Coming Soon",
    Desc  = "Fonctions auto à venir.",
})

-- ============================================================
--  TAB : UPDATE
-- ============================================================
TabUpdate:Section({ Title = "Update Log" }):Paragraph({
    Title = "v1.0.0",
    Desc  = "• Aura fonctionnelle (range, damage, speed)\n• One-Shot Aura\n• Fullbright / Inf Jump\n• Settings globaux\n• Rendu dégâts (HealthBar + DamageHighlight)",
})

-- ============================================================
--  TAB : SETTING
-- ============================================================
local SetSect = TabSetting:Section({ Title = "Interface" })
SetSect:Dropdown({
    Title  = "Thème",
    Values = {"GDEmerald", "Default"},
    Value  = "GDEmerald",
    Callback = function(v) WindUI:SetTheme(v) end,
})

-- ── Section Aura dans Settings (miroir de la config Aura) ──
local AuraSettingSect = TabSetting:Section({ Title = "⚙ Aura — Paramètres globaux" })

AuraSettingSect:Slider({
    Title = "Portée Aura (studs)",
    Desc  = "Synchronisé avec l'onglet Aura",
    Step  = 1,
    Value = { Min = 5, Max = 150, Default = 50 },
    Callback = function(v)
        AuraCfg.Range = v
        auraRangeSlider:Set(v)   -- met à jour le slider dans TabAura
    end,
})

AuraSettingSect:Slider({
    Title = "Dégâts Aura",
    Desc  = "Synchronisé avec l'onglet Aura",
    Step  = 1,
    Value = { Min = 1, Max = 100, Default = 25 },
    Callback = function(v)
        AuraCfg.Damage = v
        auraDmgSlider:Set(v)
    end,
})

AuraSettingSect:Slider({
    Title = "Vitesse Aura (sec.)",
    Desc  = "Synchronisé avec l'onglet Aura",
    Step  = 0.1,
    Value = { Min = 0.1, Max = 5.0, Default = 1.0 },
    Callback = function(v)
        AuraCfg.Speed = v
        auraSpeedSlider:Set(v)
    end,
})

AuraSettingSect:Toggle({
    Title    = "Aura activée",
    Desc     = "Raccourci pour activer/désactiver depuis Settings",
    Value    = false,
    Callback = function(v)
        AuraCfg.Enabled = v
        if v then StartAura() else StopAura() end
    end,
})

-- ============================================================
--  INIT
-- ============================================================
Window:Init()
