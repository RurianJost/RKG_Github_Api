RegisterServerEvent('RKG_Api:Notify', function(text)
    print(text)
    
    local playerList = vRP.getUsers()

	if table.length(playerList) > 0 then
        for userId, userSource in pairs(playerList) do
            if vRP.hasPermission(userId, 'Admin') then
                TriggerClientEvent('Notify', userSource, 'dev', text, 10000)
            end
        end
    end
end)