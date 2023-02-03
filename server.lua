-- GET GOOD, GET FIVEGUARD
--  ______ _______      ________ _____ _    _         _____  _____   _   _ ______ _______ 
-- |  ____|_   _\ \    / /  ____/ ____| |  | |  /\   |  __ \|  __ \ | \ | |  ____|__   __|
-- | |__    | |  \ \  / /| |__ | |  __| |  | | /  \  | |__) | |  | ||  \| | |__     | |   
-- |  __|   | |   \ \/ / |  __|| | |_ | |  | |/ /\ \ |  _  /| |  | || . ` |  __|    | |   
-- | |     _| |_   \  /  | |___| |__| | |__| / ____ \| | \ \| |__| || |\  | |____   | |   
-- |_|    |_____|   \/   |______\_____|\____/_/    \_\_|  \_\_____(_)_| \_|______|  |_|   
                                                                                        
                                                                                        
local currentRes = GetCurrentResourceName()
local checking_players = {}
local bans = {}
local function LoadBans()
    local bans_file = LoadResourceFile(currentRes, "bans.json")
    if bans_file ~= nil then
        bans = json.decode(bans_file)
    else
        SaveResourceFile(currentRes, "bans.json", "[]", -1)
    end
end
LoadBans()
local function GetIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = "",
    }

    for k,v in pairs(GetPlayerIdentifiers(src)) do   
        if string.sub(v, 1, #"steam:") == "steam:" then
            identifiers.steam = v
        elseif string.sub(v, 1, #"license:") == "license:" then
            identifiers.license = v
        elseif string.sub(v, 1, #"xbl:") == "xbl:" then
            identifiers.xbl  = v
        elseif string.sub(v, 1, #"discord:") == "discord:" then
            identifiers.discord = v
        elseif string.sub(v, 1, #"live:") == "live:" then
            identifiers.live = v
        elseif string.sub(v, 1, #"ip:") == "ip:" then
            identifiers.ip = v
        end
    end

    identifiers.discord = string.gsub(identifiers.discord, "discord:", "")
    identifiers.ip = string.gsub(identifiers.ip, "ip:", "")

    return identifiers
end

local function Ban_eulen(src)
    src = tonumber(src)
    if src == nil or src == 0 then
        return
    end
    if src > 0 then
        if GetNumPlayerIdentifiers(src) > 0 then
            if Config.UseFiveguardBanSystem then
                exports[Config.FiveguardResourceName]:fg_BanPlayer(
                    src --[[ integer ]],
                    "Eulen Detected" --[[ string ]],
                    true --[[ boolean ]]
                )
            else
                local ids = GetIdentifiers(src)
                local banData = {
                    steam = "Invalid",
                    license = "Invalid",
                    discord = "Invalid",
                    ip = "Invalid",
                    live = "Invalid",
                    xbl = "Invalid"
                }
                for k,v in pairs(ids) do
                    if v ~= "" then
                        banData[k] = v
                    end
                end
                bans[#bans+1] = banData
                Wait(100)
                SaveResourceFile(currentRes, "bans.json", json.encode(bans, { indent = true }), -1)
                DropPlayer(src, "[fiveguard.net] Eulen Detected")
            end
        end
    end
end
local ScanForBan = function(src, ids)
    for k, v in pairs(bans) do
        local id = k
        for k, v in pairs(v) do
            if ids[k] == v then
                return {
                    data = bans[id]
                }
            end 
        end
    end

    return false
end
RegisterNetEvent("fg:start_eulen_check", function()
    local _source = source
    Wait(1500)
    if not checking_players[_source] then
        print(_source .. " Eulen Detected.")
        Ban_eulen(_source, "Eulen detected")
    else
        checking_players[_source] = nil
    end
end)
RegisterNetEvent("fg:not_eulen", function()
    checking_players[source] = true
end)
AddEventHandler('playerConnecting', function(name, dropplayer, d)
    local _source = source
    local ids = GetIdentifiers(_source)
    local ban_info = ScanForBan(_source, ids)
    d.defer()
    Wait(0)
    if ban_info then
        d.done("[fiveguard.net] Banned: Eulen Detected")
        CancelEvent()
        return
    else
        d.done()
    end
end)