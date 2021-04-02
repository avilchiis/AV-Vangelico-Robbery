local cooldown = 0
local w = false
local wait = 10000

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('av_vangelico:efecto')
AddEventHandler('av_vangelico:efecto', function(carga)
	w = true
	print('^3[AV-Vangelico]: ^2Cooldown started^0')
	cooldown = os.time()
	TriggerClientEvent('av_vangelico:bombaFx',-1, carga)
end)

RegisterServerEvent('av_vangelico:gas')
AddEventHandler('av_vangelico:gas', function()
	TriggerClientEvent('av_vangelico:humo',-1)
	TriggerClientEvent('av_vangelico:notify',-1)
end)

RegisterServerEvent('av_vangelico:stand')
AddEventHandler('av_vangelico:stand', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RewardMoney then
		xPlayer.addAccountMoney(Config.Account,Config.Money)
		xPlayer.showNotification(Config.Lang['stole']..'$'..Config.Money)
	end
	
	if Config.RewardItem then
		for i = 1, #Config.Items, 1 do
			item = Config.Items[i]
			xPlayer.addInventoryItem(item.item,item.amount)
			xPlayer.showNotification(Config.Lang['stole']..''..item.amount..' '..ESX.GetItemLabel(item.item))
		end
	end
end)

ESX.RegisterServerCallback('av_vangelico:cooldown', function(source,cb)
	local xPlayers = ESX.GetPlayers()
	local cops = 0
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])	
		if xPlayer.job.name == Config.PoliceJobName then
			cops = cops + 1
		end
	end
	if cops >= Config.MinPolice and not w then
		cb(false)
	else
		cb(true)
	end
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(wait)
		if w then
			wait = 1000
			if (os.time() - cooldown) > Config.Cooldown and cooldown ~= 0 then
				print('^3[AV-Vangelico]: ^2Cooldown finished^0')
				w = false
			end
		else
			wait = 10000
		end
	end
end)

