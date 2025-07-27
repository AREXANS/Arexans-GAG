--[[
=================================================================================
  Skrip Cheat "Grow a Garden" dengan Jendela Mengambang (GUI)
=================================================================================

  Fitur:
  - Jendela (GUI) yang bisa digeser-geser.
  - Tombol On/Off untuk mengaktifkan/menonaktifkan fitur.
  - Auto Water: Menyiram tanaman secara otomatis saat fitur diaktifkan.

  Cara Kerja:
  1.  **Memuat Library GUI**: Skrip akan mengunduh dan menjalankan library "Rayfield" untuk membuat antarmuka.
  2.  **Membuat Jendela**: Sebuah jendela baru akan dibuat di layar Anda.
  3.  **Membuat Tombol**: Di dalam jendela, akan ada tombol "Toggle" (saklar) untuk fitur "Auto Water".
  4.  **Menjalankan Logika**: Skrip akan terus berjalan di latar belakang. Namun, logika untuk menyiram tanaman HANYA akan dieksekusi jika tombol dalam posisi "On".

  PENTING: Seperti sebelumnya, nama-nama objek game ("WateringCan", "NeedsWater", dll.)
  adalah tebakan dan mungkin perlu disesuaikan agar cocok dengan versi game saat ini.
]]

--================================[ 1. Memuat Library GUI ]=================================
-- Baris ini mengunduh dan memuat library Rayfield UI.
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

--================================[ 2. Membuat Jendela GUI ]=================================
-- Membuat jendela utama yang akan muncul di layar.
local Window = Rayfield:CreateWindow({
    Name = "Grow a Garden - Partner Coding",
    LoadingTitle = "Memuat Antarmuka...",
    LoadingSubtitle = "oleh Partner Coding",
    ConfigurationSaving = {
        Enabled = true, -- Mengizinkan GUI untuk menyimpan posisi & status tombol
        FolderName = nil, -- Menyimpan di folder default Rayfield
        FileName = "GardenHubConfig"
    }
})

-- Membuat tab di dalam jendela untuk menaruh tombol-tombol
local MainTab = Window:CreateTab("Utama", nil)

--================================[ 3. Logika & Tombol Kontrol ]=================================

-- Variabel ini akan melacak status On/Off dari tombol.
-- Kita mulai dengan 'false' (mati).
local isAutoWaterEnabled = false 

-- Membuat tombol saklar (toggle) di dalam tab "Utama"
MainTab:CreateToggle({
    Name = "Auto Water Tanaman",
    CurrentValue = isAutoWaterEnabled,
    Flag = "AutoWaterToggle", -- ID unik untuk menyimpan status tombol ini
    Callback = function(Value)
        -- 'Callback' ini adalah fungsi yang akan dijalankan setiap kali tombol ditekan.
        -- 'Value' akan menjadi 'true' jika On, dan 'false' jika Off.
        isAutoWaterEnabled = Value
        if Value then
            Rayfield:Notify("Auto Water Diaktifkan!", "Skrip akan mulai mencari tanaman.", 5)
        else
            Rayfield:Notify("Auto Water Dinonaktifkan.", "Skrip berhenti menyiram.", 5)
        end
    end,
})

--================================[ 4. Logika Inti Cheat (Dijalankan di Latar Belakang) ]=================================

-- Mendapatkan layanan, pemain, dan karakter (sama seperti skrip sebelumnya)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Kita buat perulangan tanpa henti yang berjalan di latar belakang
-- Ini akan terus memeriksa apakah fitur perlu dijalankan atau tidak.
while wait(3) do -- Cek setiap 3 detik untuk mengurangi lag
    -- Periksa apakah tombol dalam keadaan ON
    if isAutoWaterEnabled then
        -- 'pcall' digunakan untuk mencegah skrip berhenti total jika terjadi error
        pcall(function()
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local backpack = player:FindFirstChildOfClass("Backpack")

            if not (character and humanoid and backpack) then return end

            -- 1. Cari alat penyiram
            local wateringCan = backpack:FindFirstChild("WateringCan") or character:FindFirstChild("WateringCan")

            if wateringCan then
                -- 2. Cari semua plot tanaman
                local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace
                for i, plot in ipairs(plotsFolder:GetChildren()) do
                    -- 3. Periksa apakah plot valid dan butuh air
                    if string.find(plot.Name, "Dirt") and plot:FindFirstChild("Plant") then
                        local plant = plot.Plant
                        local needsWater = plant:FindFirstChild("NeedsWater")

                        if needsWater and needsWater.Value == true then
                            -- 4. Jalankan aksi menyiram
                            humanoid:EquipTool(wateringCan)
                            local waterEvent = ReplicatedStorage:FindFirstChild("WaterEvent")
                            
                            if waterEvent then
                                waterEvent:FireServer(plot)
                                print("Menyiram tanaman: " .. plot.Name)
                                wait(0.5) -- Jeda singkat
                            end
                        end
                    end
                end
            end
        end)
    end
end
