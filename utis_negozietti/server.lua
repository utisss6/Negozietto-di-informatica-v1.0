ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('utis:compracontanti')
AddEventHandler('utis:compracontanti', function(prezzo, item)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local soldicontanti = xPlayer.getMoney()

        if soldicontanti >= prezzo then

            xPlayer.removeMoney(prezzo)
            xPlayer.addInventoryItem(item, 1)
            TriggerClientEvent('esx:showNotification', source, "Acquisto Effettuato in contanti!")

        else

            TriggerClientEvent('esx:showNotification', _source, 'Non hai abbastanza soldi in contanti')
        
        end
    
end)

RegisterNetEvent('utis:comprabanca')
AddEventHandler('utis:comprabanca', function(prezzo, item)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local soldibanca = xPlayer.getAccount('bank').money

        if soldibanca >= prezzo then

            xPlayer.removeAccountMoney('bank', prezzo)
            xPlayer.addInventoryItem(item, 1)
            TriggerClientEvent('esx:showNotification', source, "Acquisto Effettuato Con i soldi della banca!")

        else

            TriggerClientEvent('esx:showNotification', _source, 'Non hai abbastanza soldi in banca')
        
        end
    
end)
