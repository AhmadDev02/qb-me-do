local QBCore = exports['qb-core']:GetCoreObject()

-- /me
QBCore.Commands.Add('me', 'Roleplay Action (3D Text)', {}, false, function(source, args)
    local msg = table.concat(args, " ")
    TriggerClientEvent("qb-me-do:display", -1, source, msg, { r = 200, g = 50, b = 200 })
end)

-- /do
QBCore.Commands.Add('do', 'Roleplay Scene (3D Text)', {}, false, function(source, args)
    local msg = table.concat(args, " ")
    TriggerClientEvent("qb-me-do:display", -1, source, msg, { r = 80, g = 180, b = 255 })
end)
