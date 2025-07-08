local activeTexts = {}

RegisterNetEvent("qb-me-do:display", function(src, msg, color)
    local clientId = GetPlayerFromServerId(src)
    if clientId == -1 then return end

    local ped = GetPlayerPed(clientId)
    if not ped then return end

    local duration = 5000
    local startTime = GetGameTimer()

    table.insert(activeTexts, {
        ped = ped,
        msg = msg,
        color = color,
        startTime = startTime,
        endTime = startTime + duration
    })
end)

CreateThread(function()
    while true do
        Wait(0)
        local now = GetGameTimer()

        -- Bersihkan teks yang sudah habis waktunya
        for i = #activeTexts, 1, -1 do
            if now > activeTexts[i].endTime then
                table.remove(activeTexts, i)
            end
        end

        -- Render semua teks aktif
        for i = 1, #activeTexts do
            local data = activeTexts[i]
            if data.ped and DoesEntityExist(data.ped) then
                local coords = GetEntityCoords(data.ped)
                -- Tambahkan offset Z berdasarkan urutan teks
                local zOffset = 1.0 + (i * 0.04)
                DrawText3D(coords.x, coords.y, coords.z + zOffset, data.msg, data.color)
            end
        end
    end
end)

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local scale = 0.50
        local padding = 0.005
        local bgWidth = 0.007 * string.len(text) + padding
        local bgHeight = 0.042

        -- Warna background default
        local bgR, bgG, bgB = 0, 0, 0

        -- Deteksi jenis: ME (Hijau), DO (Merah)
        if color.r == 200 and color.g == 50 and color.b == 200 then
            color = { r = 0, g = 100, b = 0 }     -- Hijau tua teks
            bgR, bgG, bgB = 0, 200, 0             -- Hijau muda background
        elseif color.r == 80 and color.g == 180 and color.b == 255 then
            color = { r = 150, g = 0, b = 0 }     -- Merah tua teks
            bgR, bgG, bgB = 255, 100, 100         -- Merah muda background
        end

        -- Background semi-transparan
        DrawRect(_x, _y + 0.012, bgWidth, bgHeight, bgR, bgG, bgB, 90)

        -- Teks
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, 255)
        SetTextCentre(true)
        SetTextDropshadow(2, 0, 0, 0, 150)
        SetTextOutline()

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
