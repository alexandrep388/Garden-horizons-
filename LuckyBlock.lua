-- Être un Lucky Block - GD Studio
-- UI: Obsidian Library (docs.mspaint.cc/obsidian)
-- Version: v1.4.0

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Toggles = Library.Toggles
local Options = Library.Options
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local SafePos  = Vector3.new(735.69, 38.57, -2122.73)
local CatchPos = Vector3.new(-454, 46, -2164)

local Bases = {
    { name = "Base 1",  pos = Vector3.new(638,  59, -2090) },
    { name = "Base 2",  pos = Vector3.new(563,  57, -2150) },
    { name = "Base 3",  pos = Vector3.new(480,  55, -2085) },
    { name = "Base 4",  pos = Vector3.new(402,  59, -2152) },
    { name = "Base 5",  pos = Vector3.new(291,  55, -2093) },
    { name = "Base 6",  pos = Vector3.new(211,  59, -2161) },
    { name = "Base 7",  pos = Vector3.new(52,   54, -2165) },
    { name = "Base 8",  pos = Vector3.new(-57,  52, -2088) },
    { name = "Base 9",  pos = Vector3.new(-138, 52, -2160) },
    { name = "Base 10", pos = Vector3.new(-217, 54, -2082) },
    { name = "Base 11", pos = Vector3.new(-223, 56, -2072) },
    { name = "Base 12", pos = Vector3.new(-297, 51, -2164) },
    { name = "Base 13", pos = Vector3.new(-376, 49, -2085) },
    { name = "Base 14", pos = Vector3.new(-459, 50, -2163) },
    { name = "Base 15", pos = Vector3.new(-524, 49, -2122) },
}

local RFBase     = game:GetService("ReplicatedStorage").Packages._Index
    :FindFirstChild("sleitnick_knit@1.7.0").knit.Services
local RFBrainrot = RFBase.ContainerService.RF.UpgradeBrainrot
local RFSpeedUpg = RFBase.UpgradesService.RF.Upgrade
local RFCaught   = RFBase.RunningService.RF.Caught

-- HELPERS
local function tpTo(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- Force TP pendant X secondes en boucle sur Heartbeat
local function forceTpTo(pos, duration)
    duration = duration or 2
    local endTime = tick() + duration
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if tick() > endTime then conn:Disconnect() return end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
    task.wait(duration + 0.1)
end

-- LOADING
local Loading = Library:CreateLoading({ Title = "GD Studio", Icon = "zap", TotalSteps = 3 })
Loading:SetMessage("GD Studio")
Loading:SetDescription("Chargement...")
task.wait(0.8)
Loading:SetCurrentStep(1)
Loading:SetDescription("Connexion aux services...")
task.wait(0.8)
Loading:SetCurrentStep(2)
Loading:ShowSidebarPage(true)
Loading.Sidebar:AddLabel("Joueur : " .. player.Name)
Loading.Sidebar:AddLabel("Jeu : Être un Lucky Block")
Loading.Sidebar:AddLabel("Version : v1.4.0")
task.wait(0.8)
Loading:SetCurrentStep(3)
Loading:SetDescription("Prêt !")
task.wait(0.5)
Loading:Continue()

-- WINDOW
local Window = Library:CreateWindow({
    Title = "GD Studio",
    Footer = "Être un Lucky Block • v1.4.0",
    Icon = "zap",
    NotifySide = "Right",
    ShowCustomCursor = false,
    MobileButtonsSide = "Right",
    AutoShow = true,
})

-- =====================
-- TAB: Auto Farm
-- =====================
local FarmTab   = Window:AddTab("Auto Farm", "cpu")
local FarmLeft  = FarmTab:AddLeftGroupbox("Farm", "repeat")
local FarmRight = FarmTab:AddRightGroupbox("Bases", "map")

local baseNames = {}
for _, b in ipairs(Bases) do table.insert(baseNames, b.name) end

FarmLeft:AddToggle("IndexBases", {
    Text = "Auto Index Bases",
    Default = false,
    Tooltip = "Parcourt toutes les bases dans l'ordre",
})

FarmRight:AddDropdown("SelectedBase", {
    Text = "Base ciblée (si Index OFF)",
    Default = "Base 1",
    Values = baseNames,
})

FarmLeft:AddSlider("FarmDelay", {
    Text = "Délai entre cycles",
    Default = 3, Min = 1, Max = 20, Rounding = 0, Suffix = "s",
})

-- Slider pour ajuster le timing du TP SafePos après Caught
FarmLeft:AddSlider("CaughtDelay", {
    Text = "Délai après Caught",
    Default = 3, Min = 1, Max = 10, Rounding = 0, Suffix = "s",
    Tooltip = "Augmente si tu reviens encore au début",
})

local StatusLabel = FarmLeft:AddLabel("Status : En attente")
local CycleLabel  = FarmLeft:AddLabel("Cycles : 0")

FarmLeft:AddToggle("AutoFarm", {
    Text = "Auto Farm",
    Default = false,
    Tooltip = "Farm automatique en boucle",
})

local farmCycles = 0
local currentBaseIndex = 1

local function getTargetBase()
    if Toggles.IndexBases.Value then
        local base = Bases[currentBaseIndex]
        currentBaseIndex = currentBaseIndex % #Bases + 1
        return base.pos, base.name
    else
        local selected = Options.SelectedBase.Value
        for _, b in ipairs(Bases) do
            if b.name == selected then return b.pos, b.name end
        end
        return Bases[1].pos, "Base 1"
    end
end

Toggles.AutoFarm:OnChanged(function(state)
    if not state then
        StatusLabel:SetText("Status : Arrêté")
        Library:Notify({ Title = "Auto Farm", Content = "Arrêté — " .. farmCycles .. " cycles", Duration = 3 })
        return
    end

    Library:Notify({ Title = "Auto Farm", Content = "Démarrage !", Duration = 2 })

    task.spawn(function()
        while Toggles.AutoFarm.Value do

            -- ÉTAPE 1 : TP CatchPos
            StatusLabel:SetText("Status : TP zone catch...")
            tpTo(CatchPos)
            task.wait(1.5)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 2 : Caught (pas de StartRun — déjà en run)
            StatusLabel:SetText("Status : Caught...")
            pcall(function() RFCaught:InvokeServer() end)

            -- ÉTAPE 3 : Attendre que le serveur finisse son TP
            -- (le slider CaughtDelay permet d'ajuster si ça revient au début)
            StatusLabel:SetText("Status : Attente serveur (" .. Options.CaughtDelay.Value .. "s)...")
            task.wait(Options.CaughtDelay.Value)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 4 : Force TP SafePos pendant 3s
            StatusLabel:SetText("Status : Force TP SafePos...")
            forceTpTo(SafePos, 3)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 5 : TP Base
            local targetPos, targetName = getTargetBase()
            StatusLabel:SetText("Status : TP " .. targetName .. "...")
            forceTpTo(targetPos, 1)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 6 : Done
            farmCycles = farmCycles + 1
            StatusLabel:SetText("Status : ✅ Cycle " .. farmCycles)
            CycleLabel:SetText("Cycles : " .. farmCycles)
            Library:Notify({
                Title = "Auto Farm",
                Content = "Cycle " .. farmCycles .. " → " .. targetName,
                Duration = 2,
            })

            task.wait(Options.FarmDelay.Value)
        end
        StatusLabel:SetText("Status : Arrêté")
    end)
end)

-- =====================
-- TAB: Escape
-- =====================
local EscapeTab   = Window:AddTab("Escape", "zap")
local EscapeLeft  = EscapeTab:AddLeftGroupbox("Auto Escape", "map-pin")
local EscapeRight = EscapeTab:AddRightGroupbox("Info", "info")

EscapeLeft:AddToggle("AutoEscape", {
    Text = "Auto Escape",
    Default = false,
    Tooltip = "TP SafePos dès que tu bouges (mode Brainrot)",
})

EscapeLeft:AddButton("TeleportNow", {
    Text = "⚡ Teleport SafePos",
    Func = function()
        tpTo(SafePos)
        Library:Notify({ Title = "Escape", Content = "✅ TP effectué !", Duration = 2 })
    end,
})

EscapeRight:AddLabel("SafePos :")
EscapeRight:AddLabel("X: 735  Y: 38  Z: -2122")
EscapeRight:AddLabel("CatchPos :")
EscapeRight:AddLabel("X: -454  Y: 46  Z: -2164")

Toggles.AutoEscape:OnChanged(function(state)
    if not state then
        Library:Notify({ Title = "Auto Escape", Content = "Désactivé", Duration = 2 })
        return
    end
    Library:Notify({ Title = "Auto Escape", Content = "Activé !", Duration = 2 })
    task.spawn(function()
        local connection
        local function startWatcher()
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            local lastPos = root.Position
            connection = RunService.Heartbeat:Connect(function()
                if not Toggles.AutoEscape.Value then connection:Disconnect() return end
                local c = player.Character
                if not c then return end
                local r = c:FindFirstChild("HumanoidRootPart")
                if not r then return end
                if (r.Position - lastPos).Magnitude > 0.5 then
                    r.CFrame = CFrame.new(SafePos)
                    lastPos = SafePos
                    connection:Disconnect()
                    Library:Notify({ Title = "Auto Escape", Content = "✅ Escaped !", Duration = 1.5 })
                    task.wait(2)
                    if Toggles.AutoEscape.Value then startWatcher() end
                end
            end)
        end
        startWatcher()
    end)
end)

-- =====================
-- TAB: Speed
-- =====================
local SpeedTab   = Window:AddTab("Speed", "gauge")
local SpeedLeft  = SpeedTab:AddLeftGroupbox("Speed Hack", "gauge")
local SpeedRight = SpeedTab:AddRightGroupbox("Presets", "bookmark")

SpeedLeft:AddToggle("SpeedEnabled", { Text = "Speed Hack", Default = false })

SpeedLeft:AddSlider("SpeedValue", {
    Text = "Vitesse", Default = 147, Min = 16, Max = 9999, Rounding = 0, Suffix = " spd",
})

local function applySpeed(val)
    local s = player.leaderstats and player.leaderstats:FindFirstChild("Speed")
    if s then s.Value = val end
end

Toggles.SpeedEnabled:OnChanged(function(state)
    if state then
        applySpeed(Options.SpeedValue.Value)
        Library:Notify({ Title = "Speed", Content = "Activé : " .. Options.SpeedValue.Value, Duration = 2 })
    else
        applySpeed(147)
        Library:Notify({ Title = "Speed", Content = "Reset à 147", Duration = 2 })
    end
end)

Options.SpeedValue:OnChanged(function(val)
    if Toggles.SpeedEnabled.Value then applySpeed(val) end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if Toggles.SpeedEnabled.Value then applySpeed(Options.SpeedValue.Value) end
end)

SpeedRight:AddButton("P200",  { Text = "⚡ 200",  Func = function() Options.SpeedValue:SetValue(200)  end })
SpeedRight:AddButton("P500",  { Text = "🚀 500",  Func = function() Options.SpeedValue:SetValue(500)  end })
SpeedRight:AddButton("P1000", { Text = "💨 1000", Func = function() Options.SpeedValue:SetValue(1000) end })
SpeedRight:AddButton("PMAX",  { Text = "☄️ 9999", Func = function() Options.SpeedValue:SetValue(9999) end })

-- =====================
-- TAB: Upgrades
-- =====================
local UpgTab   = Window:AddTab("Upgrades", "trending-up")
local UpgLeft  = UpgTab:AddLeftGroupbox("Speed Upgrade", "zap-fast")
local UpgRight = UpgTab:AddRightGroupbox("Brainrot Upgrade", "brain")

UpgLeft:AddSlider("SpeedUpgDelay", { Text = "Délai", Default = 10, Min = 1, Max = 60, Rounding = 0, Suffix = "s" })
UpgLeft:AddToggle("AutoSpeedUpg", { Text = "Auto Upgrade Speed", Default = false })
UpgLeft:AddButton("SpeedUpgOnce", {
    Text = "⚡ Upgrade x1",
    Func = function()
        pcall(function() RFSpeedUpg:InvokeServer("MovementSpeed", 1) end)
        Library:Notify({ Title = "Speed Upgrade", Content = "Upgradé !", Duration = 1.5 })
    end,
})

Toggles.AutoSpeedUpg:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoSpeedUpg.Value do
            pcall(function() RFSpeedUpg:InvokeServer("MovementSpeed", 1) end)
            task.wait(Options.SpeedUpgDelay.Value)
        end
    end)
end)

UpgRight:AddSlider("BrainrotUpgDelay", { Text = "Délai", Default = 10, Min = 1, Max = 60, Rounding = 0, Suffix = "s" })
UpgRight:AddToggle("AutoBrainrotUpg", { Text = "Auto Upgrade Brainrot", Default = false })
UpgRight:AddButton("BrainrotUpgOnce", {
    Text = "🧠 Upgrade x1",
    Func = function()
        pcall(function() RFBrainrot:InvokeServer("7") end)
        Library:Notify({ Title = "Brainrot Upgrade", Content = "Upgradé !", Duration = 1.5 })
    end,
})

Toggles.AutoBrainrotUpg:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoBrainrotUpg.Value do
            pcall(function() RFBrainrot:InvokeServer("7") end)
            task.wait(Options.BrainrotUpgDelay.Value)
        end
    end)
end)

-- =====================
-- TAB: Settings
-- =====================
local SetTab   = Window:AddTab("Settings", "settings")
local ThemeBox = SetTab:AddLeftGroupbox("Thème", "palette")
local SaveBox  = SetTab:AddRightGroupbox("Config", "save")

ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToGroupbox(ThemeBox)

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("GDStudio-LuckyBlock")
SaveManager:BuildConfigSection(SaveBox)
SaveManager:LoadAutoloadConfig()

Library:Notify({
    Title = "GD Studio",
    Content = "Bienvenue " .. player.Name .. " ! v1.4.0",
    Duration = 3,
})
    :FindFirstChild("sleitnick_knit@1.7.0").knit.Services
local RFBrainrot = RFBase.ContainerService.RF.UpgradeBrainrot
local RFSpeedUpg = RFBase.UpgradesService.RF.Upgrade
local RFStartRun = RFBase.RunningService.RF.StartRun
local RFCaught   = RFBase.RunningService.RF.Caught

local function tpTo(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local function forceTpTo(pos, duration)
    duration = duration or 1.5
    local endTime = tick() + duration
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if tick() > endTime then conn:Disconnect() return end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
    task.wait(duration + 0.1)
end

-- LOADING
local Loading = Library:CreateLoading({ Title = "GD Studio", Icon = "zap", TotalSteps = 3 })
Loading:SetMessage("GD Studio")
Loading:SetDescription("Chargement...")
task.wait(0.8)
Loading:SetCurrentStep(1)
Loading:SetDescription("Connexion aux services...")
task.wait(0.8)
Loading:SetCurrentStep(2)
Loading:ShowSidebarPage(true)
Loading.Sidebar:AddLabel("Joueur : " .. player.Name)
Loading.Sidebar:AddLabel("Jeu : Être un Lucky Block")
Loading.Sidebar:AddLabel("Version : v1.3.0")
task.wait(0.8)
Loading:SetCurrentStep(3)
Loading:SetDescription("Prêt !")
task.wait(0.5)
Loading:Continue()

-- WINDOW
local Window = Library:CreateWindow({
    Title = "GD Studio",
    Footer = "Être un Lucky Block • v1.3.0",
    Icon = "zap",
    NotifySide = "Right",
    ShowCustomCursor = false,
    MobileButtonsSide = "Right",
    AutoShow = true,
})

-- TAB: Auto Farm
local FarmTab   = Window:AddTab("Auto Farm", "cpu")
local FarmLeft  = FarmTab:AddLeftGroupbox("Farm", "repeat")
local FarmRight = FarmTab:AddRightGroupbox("Bases", "map")

local baseNames = {}
for _, b in ipairs(Bases) do table.insert(baseNames, b.name) end

FarmLeft:AddToggle("IndexBases", {
    Text = "Auto Index Bases",
    Default = false,
    Tooltip = "Parcourt toutes les bases dans l'ordre",
})

FarmRight:AddDropdown("SelectedBase", {
    Text = "Base ciblée (si Index OFF)",
    Default = "Base 1",
    Values = baseNames,
})

FarmLeft:AddSlider("FarmDelay", {
    Text = "Délai entre cycles",
    Default = 3, Min = 1, Max = 20, Rounding = 0, Suffix = "s",
})

local StatusLabel = FarmLeft:AddLabel("Status : En attente")
local CycleLabel  = FarmLeft:AddLabel("Cycles : 0")

FarmLeft:AddToggle("AutoFarm", {
    Text = "Auto Farm",
    Default = false,
    Tooltip = "Farm automatique en boucle",
})

local farmCycles = 0
local currentBaseIndex = 1
local isRunning = false

local function getTargetBase()
    if Toggles.IndexBases.Value then
        local base = Bases[currentBaseIndex]
        currentBaseIndex = currentBaseIndex % #Bases + 1
        return base.pos, base.name
    else
        local selected = Options.SelectedBase.Value
        for _, b in ipairs(Bases) do
            if b.name == selected then return b.pos, b.name end
        end
        return Bases[1].pos, "Base 1"
    end
end

Toggles.AutoFarm:OnChanged(function(state)
    if not state then
        isRunning = false
        StatusLabel:SetText("Status : Arrêté")
        Library:Notify({ Title = "Auto Farm", Content = "Arrêté — " .. farmCycles .. " cycles", Duration = 3 })
        return
    end

    Library:Notify({ Title = "Auto Farm", Content = "Démarrage !", Duration = 2 })

    task.spawn(function()
        while Toggles.AutoFarm.Value do

            -- ÉTAPE 1 : StartRun seulement si pas déjà en run
            if not isRunning then
                StatusLabel:SetText("Status : StartRun...")
                pcall(function() RFStartRun:InvokeServer() end)
                isRunning = true
                task.wait(1)
            end
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 2 : TP CatchPos
            StatusLabel:SetText("Status : TP zone catch...")
            tpTo(CatchPos)
            task.wait(1.5)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 3 : Caught
            StatusLabel:SetText("Status : Caught...")
            pcall(function() RFCaught:InvokeServer() end)
            isRunning = false

            -- ÉTAPE 4 : Attendre le TP reset du serveur PUIS on écrase
            StatusLabel:SetText("Status : Attente serveur...")
            task.wait(2.5)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 5 : Force TP SafePos (écrase le reset serveur)
            StatusLabel:SetText("Status : Escape SafePos...")
            forceTpTo(SafePos, 2)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 6 : TP Base
            local targetPos, targetName = getTargetBase()
            StatusLabel:SetText("Status : TP " .. targetName .. "...")
            forceTpTo(targetPos, 1)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 7 : Done
            farmCycles = farmCycles + 1
            StatusLabel:SetText("Status : ✅ Cycle " .. farmCycles)
            CycleLabel:SetText("Cycles : " .. farmCycles)
            Library:Notify({
                Title = "Auto Farm",
                Content = "Cycle " .. farmCycles .. " → " .. targetName,
                Duration = 2,
            })

            task.wait(Options.FarmDelay.Value)
        end
        StatusLabel:SetText("Status : Arrêté")
    end)
end)

-- TAB: Escape
local EscapeTab   = Window:AddTab("Escape", "zap")
local EscapeLeft  = EscapeTab:AddLeftGroupbox("Auto Escape", "map-pin")
local EscapeRight = EscapeTab:AddRightGroupbox("Info", "info")

EscapeLeft:AddToggle("AutoEscape", {
    Text = "Auto Escape",
    Default = false,
    Tooltip = "TP SafePos dès que tu bouges (mode Brainrot)",
})

EscapeLeft:AddButton("TeleportNow", {
    Text = "⚡ Teleport SafePos",
    Func = function()
        tpTo(SafePos)
        Library:Notify({ Title = "Escape", Content = "✅ TP effectué !", Duration = 2 })
    end,
})

EscapeRight:AddLabel("SafePos :")
EscapeRight:AddLabel("X: 735  Y: 38  Z: -2122")
EscapeRight:AddLabel("CatchPos :")
EscapeRight:AddLabel("X: -454  Y: 46  Z: -2164")

Toggles.AutoEscape:OnChanged(function(state)
    if not state then
        Library:Notify({ Title = "Auto Escape", Content = "Désactivé", Duration = 2 })
        return
    end
    Library:Notify({ Title = "Auto Escape", Content = "Activé !", Duration = 2 })
    task.spawn(function()
        local connection
        local function startWatcher()
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            local lastPos = root.Position
            connection = RunService.Heartbeat:Connect(function()
                if not Toggles.AutoEscape.Value then connection:Disconnect() return end
                local c = player.Character
                if not c then return end
                local r = c:FindFirstChild("HumanoidRootPart")
                if not r then return end
                if (r.Position - lastPos).Magnitude > 0.5 then
                    r.CFrame = CFrame.new(SafePos)
                    lastPos = SafePos
                    connection:Disconnect()
                    Library:Notify({ Title = "Auto Escape", Content = "✅ Escaped !", Duration = 1.5 })
                    task.wait(2)
                    if Toggles.AutoEscape.Value then startWatcher() end
                end
            end)
        end
        startWatcher()
    end)
end)

-- TAB: Speed
local SpeedTab   = Window:AddTab("Speed", "gauge")
local SpeedLeft  = SpeedTab:AddLeftGroupbox("Speed Hack", "gauge")
local SpeedRight = SpeedTab:AddRightGroupbox("Presets", "bookmark")

SpeedLeft:AddToggle("SpeedEnabled", { Text = "Speed Hack", Default = false })

SpeedLeft:AddSlider("SpeedValue", {
    Text = "Vitesse", Default = 147, Min = 16, Max = 9999, Rounding = 0, Suffix = " spd",
})

local function applySpeed(val)
    local s = player.leaderstats and player.leaderstats:FindFirstChild("Speed")
    if s then s.Value = val end
end

Toggles.SpeedEnabled:OnChanged(function(state)
    if state then
        applySpeed(Options.SpeedValue.Value)
        Library:Notify({ Title = "Speed", Content = "Activé : " .. Options.SpeedValue.Value, Duration = 2 })
    else
        applySpeed(147)
        Library:Notify({ Title = "Speed", Content = "Reset à 147", Duration = 2 })
    end
end)

Options.SpeedValue:OnChanged(function(val)
    if Toggles.SpeedEnabled.Value then applySpeed(val) end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if Toggles.SpeedEnabled.Value then applySpeed(Options.SpeedValue.Value) end
end)

SpeedRight:AddButton("P200",  { Text = "⚡ 200",  Func = function() Options.SpeedValue:SetValue(200)  end })
SpeedRight:AddButton("P500",  { Text = "🚀 500",  Func = function() Options.SpeedValue:SetValue(500)  end })
SpeedRight:AddButton("P1000", { Text = "💨 1000", Func = function() Options.SpeedValue:SetValue(1000) end })
SpeedRight:AddButton("PMAX",  { Text = "☄️ 9999", Func = function() Options.SpeedValue:SetValue(9999) end })

-- TAB: Upgrades
local UpgTab   = Window:AddTab("Upgrades", "trending-up")
local UpgLeft  = UpgTab:AddLeftGroupbox("Speed Upgrade", "zap-fast")
local UpgRight = UpgTab:AddRightGroupbox("Brainrot Upgrade", "brain")

UpgLeft:AddSlider("SpeedUpgDelay", { Text = "Délai", Default = 10, Min = 1, Max = 60, Rounding = 0, Suffix = "s" })
UpgLeft:AddToggle("AutoSpeedUpg", { Text = "Auto Upgrade Speed", Default = false })
UpgLeft:AddButton("SpeedUpgOnce", {
    Text = "⚡ Upgrade x1",
    Func = function()
        pcall(function() RFSpeedUpg:InvokeServer("MovementSpeed", 1) end)
        Library:Notify({ Title = "Speed Upgrade", Content = "Upgradé !", Duration = 1.5 })
    end,
})

Toggles.AutoSpeedUpg:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoSpeedUpg.Value do
            pcall(function() RFSpeedUpg:InvokeServer("MovementSpeed", 1) end)
            task.wait(Options.SpeedUpgDelay.Value)
        end
    end)
end)

UpgRight:AddSlider("BrainrotUpgDelay", { Text = "Délai", Default = 10, Min = 1, Max = 60, Rounding = 0, Suffix = "s" })
UpgRight:AddToggle("AutoBrainrotUpg", { Text = "Auto Upgrade Brainrot", Default = false })
UpgRight:AddButton("BrainrotUpgOnce", {
    Text = "🧠 Upgrade x1",
    Func = function()
        pcall(function() RFBrainrot:InvokeServer("7") end)
        Library:Notify({ Title = "Brainrot Upgrade", Content = "Upgradé !", Duration = 1.5 })
    end,
})

Toggles.AutoBrainrotUpg:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoBrainrotUpg.Value do
            pcall(function() RFBrainrot:InvokeServer("7") end)
            task.wait(Options.BrainrotUpgDelay.Value)
        end
    end)
end)

-- TAB: Settings
local SetTab   = Window:AddTab("Settings", "settings")
local ThemeBox = SetTab:AddLeftGroupbox("Thème", "palette")
local SaveBox  = SetTab:AddRightGroupbox("Config", "save")

ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToGroupbox(ThemeBox)

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("GDStudio-LuckyBlock")
SaveManager:BuildConfigSection(SaveBox)
SaveManager:LoadAutoloadConfig()

Library:Notify({
    Title = "GD Studio",
    Content = "Bienvenue " .. player.Name .. " ! v1.3.0",
    Duration = 3,
})

-- RF References
local RFBase = game:GetService("ReplicatedStorage").Packages._Index
    :FindFirstChild("sleitnick_knit@1.7.0").knit.Services

local RFBrainrot    = RFBase.ContainerService.RF.UpgradeBrainrot
local RFSpeedUpg    = RFBase.UpgradesService.RF.Upgrade
local RFStartRun    = RFBase.RunningService.RF.StartRun
local RFCaught      = RFBase.RunningService.RF.Caught

-- =====================
-- HELPERS
-- =====================
local function tpTo(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- TP forcé qui s'assure que ça reste en place (anti server override)
local function forceTpTo(pos, duration)
    duration = duration or 1
    local endTime = tick() + duration
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
        if tick() > endTime then
            conn:Disconnect()
        end
    end)
end

-- =====================
-- LOADING SCREEN
-- =====================
local Loading = Library:CreateLoading({
    Title = "GD Studio",
    Icon = "zap",
    TotalSteps = 3
})

Loading:SetMessage("GD Studio")
Loading:SetDescription("Chargement du script...")
task.wait(0.8)

Loading:SetCurrentStep(1)
Loading:SetDescription("Connexion aux services...")
task.wait(0.8)

Loading:SetCurrentStep(2)
Loading:ShowSidebarPage(true)
Loading.Sidebar:AddLabel("Joueur : " .. player.Name)
Loading.Sidebar:AddLabel("Jeu : Être un Lucky Block")
Loading.Sidebar:AddLabel("Version : v1.2.0")
task.wait(0.8)

Loading:SetCurrentStep(3)
Loading:SetDescription("Prêt !")
task.wait(0.5)
Loading:Continue()

-- =====================
-- WINDOW
-- =====================
local Window = Library:CreateWindow({
    Title = "GD Studio",
    Footer = "Être un Lucky Block • v1.2.0",
    Icon = "zap",
    NotifySide = "Right",
    ShowCustomCursor = false,
    MobileButtonsSide = "Right",
    AutoShow = true,
})

-- =====================
-- TAB: Auto Farm
-- =====================
local FarmTab = Window:AddTab("Auto Farm", "cpu")
local FarmLeft  = FarmTab:AddLeftGroupbox("Farm", "repeat")
local FarmRight = FarmTab:AddRightGroupbox("Bases", "map")

local baseNames = {}
for _, b in ipairs(Bases) do
    table.insert(baseNames, b.name)
end

FarmLeft:AddToggle("IndexBases", {
    Text = "Auto Index Bases",
    Default = false,
    Tooltip = "Parcourt toutes les bases dans l'ordre",
})

FarmRight:AddDropdown("SelectedBase", {
    Text = "Base ciblée (si Index OFF)",
    Default = "Base 1",
    Values = baseNames,
})

FarmLeft:AddSlider("FarmDelay", {
    Text = "Délai entre cycles",
    Default = 5,
    Min = 2,
    Max = 20,
    Rounding = 0,
    Suffix = "s",
})

local StatusLabel = FarmLeft:AddLabel("Status : En attente")
local CycleLabel  = FarmLeft:AddLabel("Cycles : 0")

FarmLeft:AddToggle("AutoFarm", {
    Text = "Auto Farm",
    Default = false,
    Tooltip = "Farm automatique en boucle",
})

-- Logique
local farmCycles = 0
local currentBaseIndex = 1

local function getTargetBase()
    if Toggles.IndexBases.Value then
        local base = Bases[currentBaseIndex]
        currentBaseIndex = currentBaseIndex % #Bases + 1
        return base.pos, base.name
    else
        local selected = Options.SelectedBase.Value
        for _, b in ipairs(Bases) do
            if b.name == selected then
                return b.pos, b.name
            end
        end
        return Bases[1].pos, "Base 1"
    end
end

Toggles.AutoFarm:OnChanged(function(state)
    if not state then
        StatusLabel:SetText("Status : Arrêté")
        Library:Notify({ Title = "Auto Farm", Content = "Arrêté — " .. farmCycles .. " cycles", Duration = 3 })
        return
    end

    Library:Notify({ Title = "Auto Farm", Content = "Démarrage !", Duration = 2 })

    task.spawn(function()
        while Toggles.AutoFarm.Value do

            -- ÉTAPE 1 : TP vers zone catch
            StatusLabel:SetText("Status : TP zone catch...")
            tpTo(CatchPos)
            task.wait(2)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 2 : StartRun
            StatusLabel:SetText("Status : StartRun...")
            pcall(function() RFStartRun:InvokeServer() end)
            task.wait(1.5)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 3 : Re-TP CatchPos (le serveur reset souvent la pos après StartRun)
            StatusLabel:SetText("Status : Repositionnement...")
            forceTpTo(CatchPos, 1)
            task.wait(1.5)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 4 : Caught → devient brainrot
            StatusLabel:SetText("Status : Caught...")
            pcall(function() RFCaught:InvokeServer() end)
            task.wait(1.5)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 5 : TP SafePos immédiat (forcé pour battre le serveur)
            StatusLabel:SetText("Status : Escape SafePos...")
            forceTpTo(SafePos, 1.5)
            task.wait(2)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 6 : TP Base
            local targetPos, targetName = getTargetBase()
            StatusLabel:SetText("Status : TP " .. targetName .. "...")
            forceTpTo(targetPos, 1)
            task.wait(1.5)
            if not Toggles.AutoFarm.Value then break end

            -- ÉTAPE 7 : Cycle done
            farmCycles = farmCycles + 1
            StatusLabel:SetText("Status : ✅ En attente...")
            CycleLabel:SetText("Cycles : " .. farmCycles)
            Library:Notify({
                Title = "Auto Farm",
                Content = "Cycle " .. farmCycles .. " → " .. targetName,
                Duration = 2,
            })

            task.wait(Options.FarmDelay.Value)
        end

        StatusLabel:SetText("Status : Arrêté")
    end)
end)

-- =====================
-- TAB: Escape
-- =====================
local EscapeTab  = Window:AddTab("Escape", "zap")
local EscapeLeft = EscapeTab:AddLeftGroupbox("Auto Escape", "map-pin")
local EscapeRight = EscapeTab:AddRightGroupbox("Info", "info")

EscapeLeft:AddToggle("AutoEscape", {
    Text = "Auto Escape",
    Default = false,
    Tooltip = "TP SafePos dès que tu bouges (mode Brainrot)",
})

EscapeLeft:AddButton("TeleportNow", {
    Text = "⚡ Teleport SafePos",
    Func = function()
        tpTo(SafePos)
        Library:Notify({ Title = "Escape", Content = "✅ TP effectué !", Duration = 2 })
    end,
})

EscapeRight:AddLabel("SafePos :")
EscapeRight:AddLabel("X: 735  Y: 38  Z: -2122")
EscapeRight:AddLabel("CatchPos :")
EscapeRight:AddLabel("X: -454  Y: 46  Z: -2164")

Toggles.AutoEscape:OnChanged(function(state)
    if not state then
        Library:Notify({ Title = "Auto Escape", Content = "Désactivé", Duration = 2 })
        return
    end

    Library:Notify({ Title = "Auto Escape", Content = "Activé !", Duration = 2 })

    task.spawn(function()
        local connection
        local function startWatcher()
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            local lastPos = root.Position

            connection = RunService.Heartbeat:Connect(function()
                if not Toggles.AutoEscape.Value then
                    connection:Disconnect()
                    return
                end
                local c = player.Character
                if not c then return end
                local r = c:FindFirstChild("HumanoidRootPart")
                if not r then return end

                if (r.Position - lastPos).Magnitude > 0.5 then
                    r.CFrame = CFrame.new(SafePos)
                    lastPos = SafePos
                    connection:Disconnect()
                    Library:Notify({ Title = "Auto Escape", Content = "✅ Escaped !", Duration = 1.5 })
                    task.wait(2)
                    if Toggles.AutoEscape.Value then startWatcher() end
                end
            end)
        end
        startWatcher()
    end)
end)

-- =====================
-- TAB: Speed
-- =====================
local SpeedTab   = Window:AddTab("Speed", "gauge")
local SpeedLeft  = SpeedTab:AddLeftGroupbox("Speed Hack", "gauge")
local SpeedRight = SpeedTab:AddRightGroupbox("Presets", "bookmark")

SpeedLeft:AddToggle("SpeedEnabled", {
    Text = "Speed Hack",
    Default = false,
})

SpeedLeft:AddSlider("SpeedValue", {
    Text = "Vitesse",
    Default = 147,
    Min = 16,
    Max = 9999,
    Rounding = 0,
    Suffix = " spd",
})

local function applySpeed(val)
    local s = player.leaderstats and player.leaderstats:FindFirstChild("Speed")
    if s then s.Value = val end
end

Toggles.SpeedEnabled:OnChanged(function(state)
    if state then
        applySpeed(Options.SpeedValue.Value)
        Library:Notify({ Title = "Speed", Content = "Activé : " .. Options.SpeedValue.Value, Duration = 2 })
    else
        applySpeed(147)
        Library:Notify({ Title = "Speed", Content = "Reset à 147", Duration = 2 })
    end
end)

Options.SpeedValue:OnChanged(function(val)
    if Toggles.SpeedEnabled.Value then applySpeed(val) end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if Toggles.SpeedEnabled.Value then applySpeed(Options.SpeedValue.Value) end
end)

SpeedRight:AddButton("P200",  { Text = "⚡ 200",   Func = function() Options.SpeedValue:SetValue(200)  end })
SpeedRight:AddButton("P500",  { Text = "🚀 500",   Func = function() Options.SpeedValue:SetValue(500)  end })
SpeedRight:AddButton("P1000", { Text = "💨 1000",  Func = function() Options.SpeedValue:SetValue(1000) end })
SpeedRight:AddButton("PMAX",  { Text = "☄️ 9999",  Func = function() Options.SpeedValue:SetValue(9999) end })

-- =====================
-- TAB: Upgrades
-- =====================
local UpgTab    = Window:AddTab("Upgrades", "trending-up")
local UpgLeft   = UpgTab:AddLeftGroupbox("Speed Upgrade", "zap-fast")
local UpgRight  = UpgTab:AddRightGroupbox("Brainrot Upgrade", "brain")

UpgLeft:AddSlider("SpeedUpgDelay", {
    Text = "Délai", Default = 10, Min = 1, Max = 60, Rounding = 0, Suffix = "s",
})

UpgLeft:AddToggle("AutoSpeedUpg", { Text = "Auto Upgrade Speed", Default = false })

UpgLeft:AddButton("SpeedUpgOnce", {
    Text = "⚡ Upgrade x1",
    Func = function()
        pcall(function() RFSpeedUpg:InvokeServer("MovementSpeed", 1) end)
        Library:Notify({ Title = "Speed Upgrade", Content = "Upgradé !", Duration = 1.5 })
    end,
})

Toggles.AutoSpeedUpg:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoSpeedUpg.Value do
            pcall(function() RFSpeedUpg:InvokeServer("MovementSpeed", 1) end)
            task.wait(Options.SpeedUpgDelay.Value)
        end
    end)
end)

UpgRight:AddSlider("BrainrotUpgDelay", {
    Text = "Délai", Default = 10, Min = 1, Max = 60, Rounding = 0, Suffix = "s",
})

UpgRight:AddToggle("AutoBrainrotUpg", { Text = "Auto Upgrade Brainrot", Default = false })

UpgRight:AddButton("BrainrotUpgOnce", {
    Text = "🧠 Upgrade x1",
    Func = function()
        pcall(function() RFBrainrot:InvokeServer("7") end)
        Library:Notify({ Title = "Brainrot Upgrade", Content = "Upgradé !", Duration = 1.5 })
    end,
})

Toggles.AutoBrainrotUpg:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoBrainrotUpg.Value do
            pcall(function() RFBrainrot:InvokeServer("7") end)
            task.wait(Options.BrainrotUpgDelay.Value)
        end
    end)
end)

-- =====================
-- TAB: Settings
-- =====================
local SetTab  = Window:AddTab("Settings", "settings")
local ThemeBox = SetTab:AddLeftGroupbox("Thème", "palette")
local SaveBox  = SetTab:AddRightGroupbox("Config", "save")

ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToGroupbox(ThemeBox)

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("GDStudio-LuckyBlock")
SaveManager:BuildConfigSection(SaveBox)
SaveManager:LoadAutoloadConfig()

Library:Notify({
    Title = "GD Studio",
    Content = "Bienvenue " .. player.Name .. " ! v1.2.0",
    Duration = 3,
})
