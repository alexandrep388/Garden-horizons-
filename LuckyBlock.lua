-- Être un Lucky Block - GD Studio
-- UI: Obsidian Library | Logique: Phemonaz (open source)
-- Version: v3.0.0

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Toggles = Library.Toggles
local Options = Library.Options
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- RF References
local RFBase = ReplicatedStorage
    :WaitForChild("Packages"):WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit")
    :WaitForChild("Services")

local RFUpgrade      = RFBase.UpgradesService.RF.Upgrade
local RFBrainrotUpg  = RFBase.ContainerService.RF.UpgradeBrainrot
local RFRebirth      = RFBase.RebirthService.RF.Rebirth
local RFClaimGift    = RFBase.PlaytimeRewardService.RF.ClaimGift
local RFRedeem       = RFBase.CodesService.RF.RedeemCode
local RFBuySkin      = RFBase.SkinService.RF.BuySkin
local RFSellBrainrot = RFBase.InventoryService.RF.SellBrainrot
local RFPickup       = RFBase.ContainerService.RF.PickupBrainrot
local RFSeasonPass   = RFBase.SeasonPassService.RF.ClaimPassReward

-- Suffix parser (pour les prix)
local suffix = {K=1e3,M=1e6,B=1e9,T=1e12,Qa=1e15,Qi=1e18,Sx=1e21,Sp=1e24,Oc=1e27,No=1e30,Dc=1e33}
local function parseCash(text)
    text = text:gsub("%$",""):gsub(",",""):gsub("%s+","")
    local num = tonumber(text:match("[%d%.]+"))
    local suf = text:match("%a+")
    if not num then return 0 end
    if suf and suffix[suf] then return num * suffix[suf] end
    return num
end

local skins = {
    "prestige_mogging_luckyblock","mogging_luckyblock","colossus_luckyblock",
    "inferno_luckyblock","divine_luckyblock","spirit_luckyblock",
    "cyborg_luckyblock","void_luckyblock","gliched_luckyblock",
    "lava_luckyblock","freezy_luckyblock","fairy_luckyblock"
}

local codes = {"release"}

-- Helpers TP
local function tpTo(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- =====================
-- LOADING
-- =====================
local Loading = Library:CreateLoading({
    Title = "GD Studio",
    Icon = "zap",
    TotalSteps = 3,
    ShowSidebar = true,
})
Loading:SetMessage("GD Studio")
Loading:SetDescription("Chargement...")
task.wait(0.8)
Loading:SetCurrentStep(1)
Loading:SetDescription("Connexion aux services...")
task.wait(0.8)
Loading:SetCurrentStep(2)
Loading.Sidebar:AddLabel("Joueur : " .. player.Name)
Loading.Sidebar:AddLabel("Jeu : Être un Lucky Block")
Loading.Sidebar:AddLabel("Version : v3.0.0")
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
    Footer = "Être un Lucky Block • v3.0.0",
    Icon = "zap",
    NotifySide = "Right",
    ShowCustomCursor = false,
    MobileButtonsSide = "Right",
    AutoShow = true,
})

-- =====================
-- TAB: Main
-- =====================
local MainTab  = Window:AddTab("Main", "home")
local MainLeft = MainTab:AddLeftGroupbox("Général", "star")
local MainRight = MainTab:AddRightGroupbox("Actions", "zap")

-- Auto Rebirth
MainLeft:AddToggle("AutoRebirth", {
    Text = "Auto Rebirth",
    Default = false,
})
Toggles.AutoRebirth:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoRebirth.Value do
            pcall(function() RFRebirth:InvokeServer() end)
            task.wait(1)
        end
    end)
end)

-- Auto Claim Playtime Rewards
MainLeft:AddToggle("AutoClaimGift", {
    Text = "Auto Claim Playtime Rewards",
    Default = false,
})
Toggles.AutoClaimGift:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoClaimGift.Value do
            for i = 1, 12 do
                if not Toggles.AutoClaimGift.Value then break end
                pcall(function() RFClaimGift:InvokeServer(i) end)
                task.wait(0.25)
            end
            task.wait(1)
        end
    end)
end)

-- Auto Claim Event Pass
MainLeft:AddToggle("AutoEventPass", {
    Text = "Auto Claim Event Pass",
    Default = false,
})
Toggles.AutoEventPass:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoEventPass.Value do
            local ok, gui = pcall(function()
                return player:WaitForChild("PlayerGui")
                    :WaitForChild("Windows"):WaitForChild("Event")
                    :WaitForChild("Frame"):WaitForChild("Frame")
                    :WaitForChild("Windows"):WaitForChild("Pass")
                    :WaitForChild("Main"):WaitForChild("ScrollingFrame")
            end)
            if ok and gui then
                for i = 1, 10 do
                    if not Toggles.AutoEventPass.Value then break end
                    local item = gui:FindFirstChild(tostring(i))
                    if item and item:FindFirstChild("Frame") and item.Frame:FindFirstChild("Free") then
                        local free = item.Frame.Free
                        local locked = free:FindFirstChild("Locked")
                        local claimed = free:FindFirstChild("Claimed")
                        if claimed and claimed.Visible then continue end
                        if locked and not locked.Visible then
                            pcall(function() RFSeasonPass:InvokeServer("Free", i) end)
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end)

-- Auto Buy Best Luckyblock
MainLeft:AddToggle("AutoBuyBest", {
    Text = "Auto Buy Best Luckyblock",
    Default = false,
})
Toggles.AutoBuyBest:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoBuyBest.Value do
            local ok, scrollingFrame = pcall(function()
                return player.PlayerGui:FindFirstChild("Windows")
                    :FindFirstChild("PickaxeShop"):FindFirstChild("ShopContainer")
                    :FindFirstChild("ScrollingFrame")
            end)
            if ok and scrollingFrame then
                local cash = player.leaderstats.Cash.Value
                local bestSkin, bestPrice = nil, 0
                for _, name in ipairs(skins) do
                    local item = scrollingFrame:FindFirstChild(name)
                    if item then
                        local bb = item:FindFirstChild("Main") and item.Main:FindFirstChild("Buy")
                            and item.Main.Buy:FindFirstChild("BuyButton")
                        if bb and bb.Visible then
                            local cl = bb:FindFirstChild("Cash")
                            if cl then
                                local price = parseCash(cl.Text)
                                if cash >= price and price > bestPrice then
                                    bestSkin, bestPrice = name, price
                                end
                            end
                        end
                    end
                end
                if bestSkin then
                    pcall(function() RFBuySkin:InvokeServer(bestSkin) end)
                end
            end
            task.wait(0.5)
        end
    end)
end)

-- Bouton Redeem Codes
MainRight:AddButton("RedeemCodes", {
    Text = "🎁 Redeem All Codes",
    Func = function()
        for _, code in ipairs(codes) do
            pcall(function() RFRedeem:InvokeServer(code) end)
            task.wait(1)
        end
        Library:Notify({ Title = "Codes", Content = "Tous les codes appliqués !", Duration = 3 })
    end,
})

-- Bouton Sell Held Brainrot
MainRight:AddButton("SellBrainrot", {
    Text = "💰 Sell Held Brainrot",
    Func = function()
        local char = player.Character or player.CharacterAdded:Wait()
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then
            Library:Notify({ Title = "Erreur", Content = "Équipe le Brainrot à vendre !", Duration = 3 })
            return
        end
        local entityId = tool:GetAttribute("EntityId")
        if not entityId then return end
        pcall(function() RFSellBrainrot:InvokeServer(entityId) end)
        Library:Notify({ Title = "Vendu !", Content = "Vendu : " .. tool.Name, Duration = 3 })
    end,
})

-- Bouton Pickup All Brainrots
MainRight:AddButton("PickupAll", {
    Text = "📦 Pickup All Brainrots",
    Func = function()
        local username = player.Name
        local plotsFolder = workspace:WaitForChild("Plots")
        local myPlot
        for i = 1, 5 do
            local plot = plotsFolder:FindFirstChild(tostring(i))
            if plot and plot:FindFirstChild(tostring(i)) then
                local inner = plot[tostring(i)]
                for _, v in pairs(inner:GetDescendants()) do
                    if v:IsA("BillboardGui") and string.find(v.Name, username) then
                        myPlot = inner
                        break
                    end
                end
            end
            if myPlot then break end
        end
        if not myPlot then
            Library:Notify({ Title = "Erreur", Content = "Plot introuvable", Duration = 3 })
            return
        end
        local containers = myPlot:FindFirstChild("Containers")
        if not containers then return end
        for i = 1, 30 do
            local cf = containers:FindFirstChild(tostring(i))
            if cf and cf:FindFirstChild(tostring(i)) then
                local container = cf[tostring(i)]
                local inner = container:FindFirstChild("InnerModel")
                if inner and #inner:GetChildren() > 0 then
                    pcall(function() RFPickup:InvokeServer(tostring(i)) end)
                    task.wait(0.1)
                end
            end
        end
        Library:Notify({ Title = "Done !", Content = "Tous les Brainrots récupérés", Duration = 3 })
    end,
})

-- =====================
-- TAB: Auto Farm
-- =====================
local FarmTab   = Window:AddTab("Auto Farm", "cpu")
local FarmLeft  = FarmTab:AddLeftGroupbox("Farm", "repeat")
local FarmRight = FarmTab:AddRightGroupbox("Brainrots", "bot")

-- Remove Bad Boss Touch Detectors
local storedParts = {}
FarmRight:AddToggle("RemoveBTD", {
    Text = "Remove Bad Boss Detectors",
    Default = false,
    Tooltip = "Seul le dernier boss peut vous attraper",
})
Toggles.RemoveBTD:OnChanged(function(state)
    local folder = workspace:WaitForChild("BossTouchDetectors")
    if state then
        storedParts = {}
        for _, obj in ipairs(folder:GetChildren()) do
            if obj.Name ~= "base14" then
                table.insert(storedParts, obj)
                obj.Parent = nil
            end
        end
    else
        for _, obj in ipairs(storedParts) do
            if obj then obj.Parent = folder end
        end
        storedParts = {}
    end
end)

-- Teleport to End
FarmRight:AddButton("TpToEnd", {
    Text = "⚡ Teleport to End",
    Func = function()
        local modelsFolder = workspace:WaitForChild("RunningModels")
        local target = workspace:WaitForChild("CollectZones"):WaitForChild("base14")
        for _, obj in ipairs(modelsFolder:GetChildren()) do
            if obj:IsA("Model") then
                if obj.PrimaryPart then
                    obj:SetPrimaryPartCFrame(target.CFrame)
                else
                    local part = obj:FindFirstChildWhichIsA("BasePart")
                    if part then part.CFrame = target.CFrame end
                end
            elseif obj:IsA("BasePart") then
                obj.CFrame = target.CFrame
            end
        end
        Library:Notify({ Title = "TP", Content = "Tous les modèles TP à la fin !", Duration = 2 })
    end,
})

local StatusLabel = FarmLeft:AddLabel("Status : En attente")
local CycleLabel  = FarmLeft:AddLabel("Cycles : 0")

FarmLeft:AddToggle("AutoFarm", {
    Text = "Auto Farm Best Brainrots",
    Default = false,
    Tooltip = "TP le modèle brainrot vers base14 automatiquement",
})

local farmCycles = 0

Toggles.AutoFarm:OnChanged(function(state)
    if not state then
        StatusLabel:SetText("Status : Arrêté")
        Library:Notify({ Title = "Auto Farm", Content = "Arrêté — " .. farmCycles .. " cycles", Duration = 3 })
        return
    end

    Library:Notify({ Title = "Auto Farm", Content = "Démarrage !", Duration = 2 })

    task.spawn(function()
        local modelsFolder = workspace:WaitForChild("RunningModels")
        local target = workspace:WaitForChild("CollectZones"):WaitForChild("base14")
        local userId = player.UserId

        while Toggles.AutoFarm.Value do
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            local humanoid = char:WaitForChild("Humanoid")

            -- ÉTAPE 1 : TP joueur à la safe zone
            StatusLabel:SetText("Status : TP SafeZone...")
            root.CFrame = CFrame.new(715, 39, -2122)
            task.wait(0.3)
            humanoid:MoveTo(Vector3.new(710, 39, -2122))

            -- ÉTAPE 2 : Attendre que notre modèle apparaît dans RunningModels
            StatusLabel:SetText("Status : Attente brainrot...")
            local ownedModel = nil
            local waitStart = tick()
            repeat
                task.wait(0.3)
                for _, obj in ipairs(modelsFolder:GetChildren()) do
                    if obj:IsA("Model") and obj:GetAttribute("OwnerId") == userId then
                        ownedModel = obj
                        break
                    end
                end
                -- Timeout 60s
                if tick() - waitStart > 60 then break end
            until ownedModel ~= nil or not Toggles.AutoFarm.Value

            if not Toggles.AutoFarm.Value then break end

            if not ownedModel then
                StatusLabel:SetText("Status : Timeout, retry...")
                task.wait(2)
                continue
            end

            -- ÉTAPE 3 : TP le modèle vers base14
            StatusLabel:SetText("Status : TP modèle vers base14...")
            if ownedModel.PrimaryPart then
                ownedModel:SetPrimaryPartCFrame(target.CFrame)
            else
                local part = ownedModel:FindFirstChildWhichIsA("BasePart")
                if part then part.CFrame = target.CFrame end
            end
            task.wait(0.7)

            -- ÉTAPE 4 : Re-TP si encore dans le folder
            if ownedModel and ownedModel.Parent == modelsFolder then
                if ownedModel.PrimaryPart then
                    ownedModel:SetPrimaryPartCFrame(target.CFrame)
                else
                    local part = ownedModel:FindFirstChildWhichIsA("BasePart")
                    if part then part.CFrame = target.CFrame end
                end
            end

            -- ÉTAPE 5 : Done
            farmCycles = farmCycles + 1
            StatusLabel:SetText("Status : ✅ Cycle " .. farmCycles)
            CycleLabel:SetText("Cycles : " .. farmCycles)
            Library:Notify({
                Title = "Auto Farm",
                Content = "Cycle " .. farmCycles .. " terminé !",
                Duration = 2,
            })

            task.wait(1)
        end
        StatusLabel:SetText("Status : Arrêté")
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

UpgLeft:AddSlider("SpeedUpgDelay", { Text = "Délai", Default = 1, Min = 0, Max = 5, Rounding = 1, Suffix = "s" })
UpgLeft:AddToggle("AutoSpeedUpg", { Text = "Auto Upgrade Speed", Default = false })
UpgLeft:AddButton("SpeedUpgOnce", {
    Text = "⚡ Upgrade x1",
    Func = function()
        pcall(function() RFUpgrade:InvokeServer("MovementSpeed", 1) end)
        Library:Notify({ Title = "Speed Upgrade", Content = "Upgradé !", Duration = 1.5 })
    end,
})
Toggles.AutoSpeedUpg:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoSpeedUpg.Value do
            pcall(function() RFUpgrade:InvokeServer("MovementSpeed", 1) end)
            task.wait(Options.SpeedUpgDelay.Value)
        end
    end)
end)

UpgRight:AddSlider("BrainrotUpgDelay", { Text = "Délai", Default = 10, Min = 1, Max = 60, Rounding = 0, Suffix = "s" })
UpgRight:AddToggle("AutoBrainrotUpg", { Text = "Auto Upgrade Brainrot", Default = false })
UpgRight:AddButton("BrainrotUpgOnce", {
    Text = "🧠 Upgrade x1",
    Func = function()
        pcall(function() RFBrainrotUpg:InvokeServer("7") end)
        Library:Notify({ Title = "Brainrot Upgrade", Content = "Upgradé !", Duration = 1.5 })
    end,
})
Toggles.AutoBrainrotUpg:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.AutoBrainrotUpg.Value do
            pcall(function() RFBrainrotUpg:InvokeServer("7") end)
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
    Content = "Bienvenue " .. player.Name .. " ! v3.0.0",
    Duration = 3,
})
