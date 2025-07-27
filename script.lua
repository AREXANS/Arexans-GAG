--[[
    ================================================================================================
    SCRIPT UNTUK: Grow a Garden
    DIBUAT OLEH: Arexans
    TANGGAL: 27 Juli 2025

    PENTING:
    1. Anda memerlukan Script Executor (seperti Krnl, Synapse X, dll.) untuk menjalankan skrip ini di Roblox.
    2. Menggunakan skrip ini dapat menyebabkan akun Anda di-ban. Gunakan dengan risiko Anda sendiri.
    3. Nama-nama RemoteEvent/Folder dalam game bisa berubah setelah update. Jika skrip berhenti bekerja,
       kemungkinan besar karena nama-nama ini perlu diperbarui.
    ================================================================================================
]]

-- Memuat library GUI. Kita akan menggunakan Orion Library.
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- ================================================================================================
-- PENGATURAN TEMA (THEME)
-- ================================================================================================
-- Mengatur tema menjadi gelap dan warna aksen menjadi biru cerah untuk efek "glowy"
OrionLib:SetTheme("Midnight") 

-- Warna biru utama yang akan kita gunakan
local accentColor = Color3.fromRGB(0, 150, 255)
local accentColorLighter = Color3.fromRGB(100, 180, 255)

-- Mengganti warna default dari tema Orion
OrionLib.Colors.Accent = accentColor
OrionLib.Colors.AccentContrasting = accentColorLighter
OrionLib.Colors.Button = accentColor
OrionLib.Colors.ButtonHover = accentColorLighter


-- Membuat jendela utama untuk GUI kita
local Window = OrionLib:MakeWindow({
    Name = "Arexans",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "ArexansOrion" -- Folder config yang berbeda agar tidak bentrok
})


-- ================================================================================================
-- TAB FARMING OTOMATIS
-- ================================================================================================
-- Membuat tab untuk fitur-fitur yang berhubungan dengan farming
local FarmTab = Window:MakeTab({
    Name = "Farming",
    Icon = "rbxassetid://6034523644", -- Icon petir biru
    PremiumOnly = false
})

-- Variabel untuk menyimpan status toggle
local autoHarvestEnabled = false
local autoWaterEnabled = false
local autoSellEnabled = false

-- --- Toggle untuk Auto Harvest (Panen Otomatis) ---
FarmTab:AddToggle({
    Name = "Auto Harvest",
    Callback = function(state)
        autoHarvestEnabled = state
        spawn(function()
            while autoHarvestEnabled do
                task.wait(1) 
                local plotsFolder = game.Workspace:FindFirstChild("Plots")
                local localPlayer = game.Players.LocalPlayer
                if plotsFolder and localPlayer and localPlayer.Character then
                    for _, plot in ipairs(plotsFolder:GetChildren()) do
                        if plot.Owner.Value == localPlayer.Name then
                            for _, item in ipairs(plot:GetChildren()) do
                                local harvestPart = item:FindFirstChild("TouchPart")
                                if harvestPart and harvestPart:FindFirstChild("Harvest") then
                                    localPlayer.Character.HumanoidRootPart.CFrame = harvestPart.CFrame
                                    game.ReplicatedStorage.Remotes.Harvest:FireServer(item)
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


-- --- Toggle untuk Auto Water (Siram Otomatis) ---
FarmTab:AddToggle({
    Name = "Auto Water",
    Callback = function(state)
        autoWaterEnabled = state
        spawn(function()
            while autoWaterEnabled do
                task.wait(2)
                local plotsFolder = game.Workspace:FindFirstChild("Plots")
                local localPlayer = game.Players.LocalPlayer
                if plotsFolder and localPlayer then
                    for _, plot in ipairs(plotsFolder:GetChildren()) do
                        if plot.Owner.Value == localPlayer.Name then
                            for _, item in ipairs(plot:GetChildren()) do
                                local waterPrompt = item:FindFirstChild("Water")
                                if waterPrompt then
                                    game.ReplicatedStorage.Remotes.Water:FireServer(item)
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

-- --- Toggle untuk Auto Sell (Jual Otomatis) ---
FarmTab:AddToggle({
    Name = "Auto Sell",
    Callback = function(state)
        autoSellEnabled = state
        spawn(function()
            while autoSellEnabled do
                task.wait(5)
                local sellArea = game.Workspace:FindFirstChild("SellArea")
                if sellArea then
                    game.ReplicatedStorage.Remotes.SellAll:FireServer()
                end
            end
        end)
    end
})


-- ================================================================================================
-- TAB PLAYER
-- ================================================================================================
-- Membuat tab untuk fitur-fitur yang berhubungan dengan player
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://5112192243", -- Icon orang biru
    PremiumOnly = false
})

-- --- Slider untuk Kecepatan Berjalan (WalkSpeed) ---
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 16,
    Color = accentColor, -- Menggunakan warna biru kita
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

-- --- Slider untuk Kekuatan Lompat (JumpPower) ---
PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = accentColor, -- Menggunakan warna biru kita
    Increment = 5,
    ValueName = "Power",
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
    Icon = "rbxassetid://4843400112", -- Icon info biru
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
