--[[
    ================================================================================================
    SCRIPT UNTUK: Grow a Garden
    DIBUAT OLEH: Arexans
    TANGGAL: 27 Juli 2025
    VERSI: 2.0 (Diperbarui dengan Rayfield GUI Library yang stabil)
    ================================================================================================
]]

-- Memuat library GUI Rayfield. Ini adalah pengganti OrionLib yang sudah tidak berfungsi.
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- ================================================================================================
-- !! PENTING JIKA SKRIP TIDAK BEKERJA !!
-- Nama-nama di bawah ini adalah TEBAKAN. Jika game di-update, ganti nama di dalam tanda kutip ("").
-- Gunakan "Remote Spy" dari executor Anda untuk menemukan nama yang benar.
-- ================================================================================================
local GamePaths = {
    RemotesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"),
    PlotsFolder = game:GetService("Workspace"):FindFirstChild("Plots"),
    SellArea = game:GetService("Workspace"):FindFirstChild("SellArea")
}

-- ================================================================================================
-- PENGATURAN TEMA (THEME) & JENDELA UTAMA
-- ================================================================================================
local Window = Rayfield:CreateWindow({
   Name = "Arexans",
   LoadingTitle = "Arexans Script Interface",
   LoadingSubtitle = "by Arexans",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ArexansConfig", 
      FileName = "GrowAGarden"
   },
   -- Mengatur tema biru glowy
   AccentColor = Color3.fromRGB(0, 150, 255),
   KeySystem = false -- Tidak perlu key system
})


-- ================================================================================================
-- TAB FARMING OTOMATIS
-- ================================================================================================
local FarmTab = Window:CreateTab("Farming", "rbxassetid://6034523644")

local autoHarvestEnabled, autoWaterEnabled, autoSellEnabled = false, false, false

FarmTab:CreateToggle({
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
   end,
})

FarmTab:CreateToggle({
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
   end,
})

FarmTab:CreateToggle({
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
   end,
})

-- ================================================================================================
-- TAB PLAYER
-- ================================================================================================
local PlayerTab = Window:CreateTab("Player", "rbxassetid://5112192243")

PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 150},
   Increment = 1,
   Suffix = "Speed",
   Default = 16,
   Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
   end,
})

PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 200},
   Increment = 5,
   Suffix = "Power",
   Default = 50,
   Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
   end,
})

-- ================================================================================================
-- TAB KREDIT
-- ================================================================================================
local CreditsTab = Window:CreateTab("Credits", "rbxassetid://4843400112")

CreditsTab:CreateLabel("Script by Arexans")
CreditsTab:CreateLabel("GUI: Rayfield Library")

-- Notifikasi tidak diperlukan karena Rayfield sudah memiliki layar loading sendiri
