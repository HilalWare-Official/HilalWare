-- Basit kalıcı selam scripti
local teleportFonk = (syn and syn.queue_on_teleport) or queue_on_teleport

if teleportFonk then
    teleportFonk([[
        print("selam")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kullanici/repoadi/main/script.lua"))()
    ]])
end

print("selam")
