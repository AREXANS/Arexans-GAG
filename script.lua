--[[
    ================================================================================================
    SCRIPT UNTUK: Grow a Garden
    DIBUAT OLEH: Arexans
    TANGGAL: 27 Juli 2025
    VERSI: 1.1 (Dengan perbaikan untuk kemudahan update)
    ================================================================================================
]]

-- Memuat library GUI.
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- ================================================================================================
-- !! PENTING JIKA SKRIP TIDAK BEKERJA !!
-- Nama-nama di bawah ini adalah TEBAKAN. Jika game di-update, nama ini bisa berubah.
-- Gunakan "Remote Spy" dari executor Anda untuk menemukan nama yang benar jika fitur tidak berfungsi,
-- lalu ganti nama yang ada di dalam tanda kutip ("") di bawah ini.
-- ================================================================================================
local GamePaths = {
    -- Path ke folder Remotes
    RemotesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"),
    -- Path ke folder Plots di Workspace
    PlotsFolder = game:GetService("Workspace"):FindFirstChild("Plots"),
    -- Path ke area penjualan
    SellArea = game:GetService("Workspace"):FindFirstChild("SellArea")
}

-- ================================================================================================
-- PENGATURAN TEMA (THEME)
-- ================================================================================================
OrionLib:SetTheme("Midnight") 

local accentColor = Color3.fromRGB(0, 150, 255)
local accentColorLighter = Color3.fromRGB(100, 180, 255)

OrionLib.Colors.Accent = accentColor
OrionLib.Colors.AccentContrasting = accentColorLighter
OrionLib.Colors.Button = accentColor
OrionLib.Colors.ButtonHover = accentColorLighter


-- Membuat jendela utama untuk GUI kita
local Window = OrionLib:MakeWindow({
    Name = "Arexans",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "ArexansOrion"
})


-- ================================================================================================
-- TAB FARMING OTOMATIS
-- ================================================================================================
local FarmTab = Window:MakeTab({
    Name = "Farming",
    Icon = "rbxassetid://6034523644",
    PremiumOnly = false
})

local autoHarvestEnabled, autoWaterEnabled, autoSellEnabled = false, false, false

FarmTab:AddToggle({
    Name = "Auto Harvest",
    Callback = function(state)
        autoHarvestEnabled = state
        spawn(function()
            while autoHarvestEnabled and task.wait(1) do
                local localPlayer = game.Players.LocalPlayer
                if GamePaths.PlotsFolder and localPlayer and localPlayer.Character and GamePaths.RemotesFolder then
                    for _, plot in ipairs(GamePaths.PlotsFolder:GetChildren()) do
                        if plot:FindFirstChild("Owner") and plot.Owner.Value == localPlayer.Name then
                            for _, item in ipairs(plot:GetChildren()) do
                                local harvestPart = item:FindFirstChild("TouchPart")
                                if harvestPart and harvestPart:FindFirstChild("Harvest") then
                                    localPlayer.Character.HumanoidRootPart.CFrame = harvestPart.CFrame
                                    GamePaths.RemotesFolder.Harvest:FireServer(item)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
})

FarmTab:AddToggle({
    Name = "Auto Water",
    Callback = function(state)
        autoWaterEnabled = state
        spawn(function()
            while autoWaterEnabled and task.wait(2) do
                local localPlayer = game.Players.LocalPlayer
                if GamePaths.PlotsFolder and localPlayer and GamePaths.RemotesFolder then
                    for _, plot in ipairs(GamePaths.PlotsFolder:GetChildren()) do
                        if plot:FindFirstChild("Owner") and plot.Owner.Value == localPlayer.Name then
                            for _, item in ipairs(plot:GetChildren()) do
                                if item:FindFirstChild("Water") then
                                    GamePaths.RemotesFolder.Water:FireServer(item)
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
})

FarmTab:AddToggle({
    Name = "Auto Sell",
    Callback = function(state)
        autoSellEnabled = state
        spawn(function()
            while autoSellEnabled and task.wait(5) do
                if GamePaths.SellArea and GamePaths.RemotesFolder then
                    GamePaths.RemotesFolder.SellAll:FireServer()
                end
            end
        end)
    end
})

-- ================================================================================================
-- TAB PLAYER
-- ================================================================================================
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://5112192243",
    PremiumOnly = false
})

PlayerTab:AddSlider({
    Name = "WalkSpeed", Min = 16, Max = 150, Default = 16, Color = accentColor,
    Increment = 1, ValueName = "Speed",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

PlayerTab:AddSlider({
    Name = "JumpPower", Min = 50, Max = 200, Default = 50, Color = accentColor,
    Increment = 5, ValueName = "Power",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
    end
})

-- ================================================================================================
-- TAB KREDIT
-- ================================================================================================
local CreditsTab = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://4843400112",
    PremiumOnly = false
})

CreditsTab:AddLabel("Script by Arexans")
CreditsTab:AddLabel("GUI Library: Orion")

-- Memberi notifikasi bahwa skrip telah berhasil dimuat
OrionLib:MakeNotification({
    Name = "Arexans",
    Content = "Script by Arexans | Loaded Successfully",
    Image = "rbxassetid://6034523644",
    Time = 5
})
