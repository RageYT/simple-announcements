--============================================================
-- Please do not touch or edit any of this code, unless you're
-- smarter than me and know what you're doing. Thanks <3
--============================================================

local delay     = config.delay * 600000
local prefix    = config.prefix
local messages  = config.messages

Citizen.CreateThread(function()
    while true do
        for a = 1, #config.messages do
            TriggerEvent('chat:addMessage', {args = { prefix .. messages[a] }})
            Citizen.Wait(delay)
        end
        Citizen.Wait(0)
    end
end)
