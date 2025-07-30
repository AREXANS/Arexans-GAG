local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Variabel Lokal
local lp = Players.LocalPlayer

-- ==================================================
-- FUNGSI UTAMA
-- ==================================================

-- Fungsi untuk melakukan teleportasi dengan mulus (smooth)
local function teleportTo(targetCFrame)
    -- Pastikan karakter pemain ada dan memiliki HumanoidRootPart
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        print("Karakter tidak ditemukan, teleportasi dibatalkan.")
        return
    end
    
    local rootPart = char.HumanoidRootPart
    
    -- Membuat animasi pergerakan (tween) untuk teleportasi yang halus
    local tweenInfo = TweenInfo.new(
        0.3, -- Durasi teleportasi dalam detik
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    -- Menambahkan sedikit ketinggian (Y+5) agar tidak terjebak di dalam tanah
    local finalCFrame = targetCFrame * CFrame.new(0, 5, 0)
    
    local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = finalCFrame})
    tween:Play()
end

-- ==================================================
-- LOKASI TELEPORTASI
-- ==================================================
-- Di sini kita mendefinisikan CFrame (koordinat dan rotasi) untuk setiap lokasi.
-- Menggunakan WaitForChild untuk memastikan objek sudah ada sebelum skrip berjalan.

-- Lokasi Toko Gear (Anda mungkin perlu menyesuaikan nama 'Gear' jika berbeda)
local gearLocation = Workspace.NPCS:WaitForChild("Gear").PrimaryPart.CFrame

-- Lokasi Toko Pet (Anda mungkin perlu menyesuaikan nama 'Pet Stand' jika berbeda)
local petLocation = Workspace.NPCS:WaitForChild("Pet Stand").PrimaryPart.CFrame

-- Lokasi Event Zen. Saya set di tengah peta (0, 100, 0).
-- Anda bisa mengubah koordinat X, Y, Z di bawah ini jika lokasinya berbeda.
local zenLocation = CFrame.new(0, 100, 0)


-- ==================================================
-- TAMPILAN ANTARMUKA (UI) MENGGUNAKAN RAYFIELD
-- ==================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Grow a Garden | Teleport Menu",
   LoadingTitle = "Teleport Menu",
   LoadingSubtitle = "by RzkyO (Disederhanakan)",
   Theme = "default"
})

-- Membuat Tab utama untuk tombol teleport
local TeleportTab = Window:CreateTab("Teleport", "map-pin") -- Ikon pin peta

TeleportTab:CreateSection("Lokasi Cepat")

-- Tombol untuk teleport ke Toko Gear
TeleportTab:CreateButton({
   Name = "Teleport ke Gear",
   Callback = function()
      print("Teleportasi ke Gear...")
      teleportTo(gearLocation)
   end
})

-- Tombol untuk teleport ke Toko Pet
TeleportTab:CreateButton({
   Name = "Teleport ke Pets",
   Callback = function()
      print("Teleportasi ke Pets...")
      teleportTo(petLocation)
   end
})

-- Tombol untuk teleport ke Event Zen
TeleportTab:CreateButton({
   Name = "Teleport ke Events Zen",
   Callback = function()
      print("Teleportasi ke Events Zen...")
      teleportTo(zenLocation)
   end
})

-- Tombol untuk menghancurkan UI jika diperlukan
TeleportTab:CreateButton({
    Name = "Tutup UI",
    Callback = function()
        Rayfield:Destroy()
    end
})
