--============================================================
-- Please do not touch or edit any of this code, unless you're
-- smarter than me and know what you're doing. Thanks <3
--============================================================

local LOCALE = {
    ERROR_PREFIX = '^1[ERROR]^7: ',
    NO_MESSAGES = 'Disabling automatic message announcement due to missing messages.',
    TOO_SHORT = 'Your message needs to be longer than 3 characters.'
}
local delay = config.delay * (1000 * 60)
local prefix = config.prefix
local aprefix = config.adminPrefix
local messages = config.messages

function capitaliseFirstStrLetter(str)
    return str:gsub("^%l", string.upper)
end

function getSizeOfTable(the_table)
    local size = 0
    for _ in pairs(the_table) do
        size = size + 1
    end

    return size
end

Citizen.CreateThread(function()
    local index = 1
    local last_message = GetGameTimer()

    if getSizeOfTable(messages) == 0 then
        return print(LOCALE.ERROR_PREFIX .. LOCALE.NO_MESSAGES)
    end

    while true do
        if GetGameTimer() - last_message > delay then
            last_message = GetGameTimer()
            local message = messages[index]

            if message == nil then
                index = 1
                message = messages[index]
            end

            message = capitaliseFirstStrLetter(message)
            index = index + 1
            TriggerClientEvent('chat:addMessage', -1, { args = { prefix .. message } })
            print(prefix .. message)
        end

        Citizen.Wait(0)
    end
end)

RegisterCommand('announce', function(source, args, raw)
    -- Set the message to the raw command, but remove the first 10 characters of it. 1 for the /, 8 for announce and 1 for the space
    local message = string.sub(raw, 10)

    if string.len(message) < 3 then
        if source == 0 then
            return print(LOCALE.ERROR_PREFIX .. LOCALE.TOO_SHORT)
        else
            TriggerClientEvent('chat:addMessage', source, { args = { LOCALE.ERROR_PREFIX .. LOCALE.TOO_SHORT } })
        end

        return
    end

    message = message:gsub("^%l", string.upper)
    TriggerClientEvent('chat:addMessage', -1, { args = { aprefix .. message } })

    if source == 0 then
        --Only print to the console if the console was the originator.
        print(aprefix .. message)
    end
end, true)