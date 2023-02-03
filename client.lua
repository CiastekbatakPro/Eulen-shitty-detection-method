-- GET GOOD, GET FIVEGUARD
--  ______ _______      ________ _____ _    _         _____  _____   _   _ ______ _______ 
-- |  ____|_   _\ \    / /  ____/ ____| |  | |  /\   |  __ \|  __ \ | \ | |  ____|__   __|
-- | |__    | |  \ \  / /| |__ | |  __| |  | | /  \  | |__) | |  | ||  \| | |__     | |   
-- |  __|   | |   \ \/ / |  __|| | |_ | |  | |/ /\ \ |  _  /| |  | || . ` |  __|    | |   
-- | |     _| |_   \  /  | |___| |__| | |__| / ____ \| | \ \| |__| || |\  | |____   | |   
-- |_|    |_____|   \/   |______\_____|\____/_/    \_\_|  \_\_____(_)_| \_|______|  |_|   
                                                                                        
-- Should Crash Eulencheats
local function trigger_null_event()
    TriggerServerEventInternal(nil, "?", 1)
end
local _szp_xc = function()
    local s, r, e = xpcall(
        function()
            trigger_null_event()
            return true
        end,
        function()
            return false
        end)
    return r
end
CreateThread(function()
    TriggerServerEvent("fg:start_eulen_check")
    Wait(10)
    _szp_xc()
    Wait(50)
    TriggerServerEvent("fg:not_eulen")
end)