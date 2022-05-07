ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




RegisterServerEvent('trf_emploi:setjob')
AddEventHandler('trf_emploi:setjob', function(setjob, Nom)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.setJob(setjob, 0)
    
    sendToDiscordWithSpecialURL("Pôle emploi"," Un nouveau employer au "..Nom, 1752220, trf_emploi.webhooks)

end)




RegisterServerEvent('trf_emploi:cho')
AddEventHandler('trf_emploi:cho', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.setJob(trf_emploi.chomage, 0)

    sendToDiscordWithSpecialURL("Pôle emploi"," Un nouveau chommeur son nom est "..xPlayer.getName(), 1752220, trf_emploi.webhooks)

    TriggerClientEvent('esx:showAdvancedNotification', source, 'Pole emploi', 'Message', 'Vous etes actuellement au chomage', 'CHAR_BRYONY', 8)


end)


RegisterServerEvent('trf_emploi:wl')
AddEventHandler('trf_emploi:wl', function(test, motiv, dispo, Nom)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)


    sendToDiscordWithSpecialURL("Pôle emploi"," Voici la candidature de "..xPlayer.getName().."__\n Société __: "..Nom.."__\n Pourquoi lui ?__: "..test.."__\n Motivations __: "..motiv.."__\n Vos disponibilité__ :"..dispo, 1752220, trf_emploi.webhooks)

    TriggerClientEvent('esx:showAdvancedNotification', source, 'Pole emploi', 'Message', 'Votre candidature a bien été recu', 'CHAR_BRYONY', 8)

end)

function sendToDiscordWithSpecialURL(name,message,color,url)
    local DiscordWebHook = url
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "Pole emploi treifa",
			},
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "Treifa ",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end


