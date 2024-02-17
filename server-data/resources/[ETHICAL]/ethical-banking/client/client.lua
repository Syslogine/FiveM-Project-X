local isInService = false
local rank = "inconnu"
local checkpoints = {}
local existingVeh = nil
local handCuffed = false
local isMedic = false
local isCop = false
local isDoctor = false
local isNews = false
local isDead = false
local canFix = false
local currentCallSign = nil


inMenu			= true
local showblips	= true
local atbank	= false
local bankMenu	= true
local banks = {
	{name="Bank", id=108, x=150.266, y=-1040.203, z=29.374},
	{name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787},
	{name="Bank", id=108, x=-2962.582, y=482.627, z=15.703},
	{name="Bank", id=108, x=-112.202, y=6469.295, z=31.626},
	{name="Bank", id=108, x=314.187, y=-278.621, z=54.170},
	{name="Bank", id=108, x=-351.534, y=-49.529, z=49.042},
	{name="Bank", id=108, x=241.727, y=220.706, z=106.286},
	{name="Bank", id=108, x=1175.0643310547, y=2706.6435546875, z=38.094036102295}
}

local sellX = 150.266
local sellY = -1040.203
local sellZ = 29.374

Citizen.CreateThread(function()
    while true do
		local playerloc = GetEntityCoords(PlayerPedId())
        Citizen.Wait(0)
        local pos = GetEntityCoords(GetPlayerPed(-1))
		for _, search in pairs(banks) do
			local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
			
			if distance <= 1 then
				if (GetDistanceBetweenCoords(pos, search.x ,  search.y , search.z, true) < 3) then
					DrawMarker(26, search.x, search.y, search.z-0.96, 0, 0, 0, 0, 0, 0, 1.20, 1.20, 1.20, 34, 39, 48, 200, 0, 0, 0, 0)
					DrawText3D(search.x, search.y, search.z + 0.2, "~b~[E]~w~Open Bank")
			end
		end

		end
	end
end)

local atmProps = {
	"prop_atm_02",
	"prop_atm_03",
	"prop_fleeca_atm"
}

local atms = {
	{name="ATM", id=277, x=-386.733, y=6045.953, z=31.501},
	{name="ATM", id=277, x=-316.233, y=-586.953, z=42.400},
	{name="ATM", id=277, x=-284.037, y=6224.385, z=31.187},
	{name="ATM", id=277, x=-284.037, y=6224.385, z=31.187},
	{name="ATM", id=277, x=-135.165, y=6365.738, z=31.101},
	{name="ATM", id=277, x=-110.753, y=6467.703, z=31.784},
	{name="ATM", id=277, x=-94.9690, y=6455.301, z=31.784},
	{name="ATM", id=277, x=155.4300, y=6641.991, z=31.784},
	{name="ATM", id=277, x=174.6720, y=6637.218, z=31.784},
	{name="ATM", id=277, x=1703.138, y=6426.783, z=32.730},
	{name="ATM", id=277, x=1735.114, y=6411.035, z=35.164},
	{name="ATM", id=277, x=1702.842, y=4933.593, z=42.051},
	{name="ATM", id=277, x=1967.333, y=3744.293, z=32.272},
	{name="ATM", id=277, x=1821.917, y=3683.483, z=34.244},
	{name="ATM", id=277, x=1174.532, y=2705.278, z=38.027},
	{name="ATM", id=277, x=540.0420, y=2671.007, z=42.177},
	{name="ATM", id=277, x=2564.399, y=2585.100, z=38.016},
	{name="ATM", id=277, x=2558.683, y=349.6010, z=108.050},
	{name="ATM", id=277, x=2558.051, y=389.4817, z=108.660},
	{name="ATM", id=277, x=1077.692, y=-775.796, z=58.218},
	{name="ATM", id=277, x=1139.018, y=-469.886, z=66.789},
	{name="ATM", id=277, x=1168.975, y=-457.241, z=66.641},
	{name="ATM", id=277, x=1153.884, y=-326.540, z=69.245},
	{name="ATM", id=277, x=381.2827, y=323.2518, z=103.270},
	{name="ATM", id=277, x=236.4638, y=217.4718, z=106.840},
	{name="ATM", id=277, x=265.0043, y=212.1717, z=106.780},
	{name="ATM", id=277, x=285.2029, y=143.5690, z=104.970},
	{name="ATM", id=277, x=157.7698, y=233.5450, z=106.450},
	{name="ATM", id=277, x=-164.568, y=233.5066, z=94.919},
	{name="ATM", id=277, x=-1827.04, y=785.5159, z=138.020},
	{name="ATM", id=277, x=-1409.39, y=-99.2603, z=52.473},
	{name="ATM", id=277, x=-1205.35, y=-325.579, z=37.870},
	{name="ATM", id=277, x=-1215.64, y=-332.231, z=37.881},
	{name="ATM", id=277, x=-2072.41, y=-316.959, z=13.345},
	{name="ATM", id=277, x=-2975.72, y=379.7737, z=14.992},
	{name="ATM", id=277, x=-2962.60, y=482.1914, z=15.762},
	{name="ATM", id=277, x=-2955.70, y=488.7218, z=15.486},
	{name="ATM", id=277, x=-3044.22, y=595.2429, z=7.595},
	{name="ATM", id=277, x=-3144.13, y=1127.415, z=20.868},
	{name="ATM", id=277, x=-3241.10, y=996.6881, z=12.500},
	{name="ATM", id=277, x=-3241.11, y=1009.152, z=12.877},
	{name="ATM", id=277, x=-1305.40, y=-706.240, z=25.352},
	{name="ATM", id=277, x=-538.225, y=-854.423, z=29.234},
	{name="ATM", id=277, x=-711.156, y=-818.958, z=23.768},
	{name="ATM", id=277, x=-717.614, y=-915.880, z=19.268},
	{name="ATM", id=277, x=-526.566, y=-1222.90, z=18.434},
	{name="ATM", id=277, x=-256.831, y=-719.646, z=33.444},
	{name="ATM", id=277, x=-203.548, y=-861.588, z=30.205},
	{name="ATM", id=277, x=112.4102, y=-776.162, z=31.427},
	{name="ATM", id=277, x=112.9290, y=-818.710, z=31.386},
	{name="ATM", id=277, x=119.9000, y=-883.826, z=31.191},
	{name="ATM", id=277, x=149.4551, y=-1038.95, z=29.366},
	{name="ATM", id=277, x=-846.304, y=-340.402, z=38.687},
	{name="ATM", id=277, x=-1204.35, y=-324.391, z=37.877},
	{name="ATM", id=277, x=-1216.27, y=-331.461, z=37.773},
	{name="ATM", id=277, x=-56.1935, y=-1752.53, z=29.452},
	{name="ATM", id=277, x=-261.692, y=-2012.64, z=30.121},
	{name="ATM", id=277, x=-273.001, y=-2025.60, z=30.197},
	{name="ATM", id=277, x=314.187, y=-278.621, z=54.170},
	{name="ATM", id=277, x=-351.534, y=-49.529, z=49.042},
	{name="ATM", id=277, x=24.589, y=-946.056, z=29.357},
	{name="ATM", id=277, x=-254.112, y=-692.483, z=33.616},
	{name="ATM", id=277, x=-1570.197, y=-546.651, z=34.955},
	{name="ATM", id=277, x=-1415.909, y=-211.825, z=46.500},
	{name="ATM", id=277, x=-1430.112, y=-211.014, z=46.500},
	{name="ATM", id=277, x=33.232, y=-1347.849, z=29.497},
	{name="ATM", id=277, x=129.216, y=-1292.347, z=29.269},
	{name="ATM", id=277, x=287.645, y=-1282.646, z=29.659},
	{name="ATM", id=277, x=289.012, y=-1256.545, z=29.440},
	{name="ATM", id=277, x=295.839, y=-895.640, z=29.217},
	{name="ATM", id=277, x=1686.753, y=4815.809, z=42.008},
	{name="ATM", id=277, x=-302.408, y=-829.945, z=32.417},
	{name="ATM", id=277, x=5.134, y=-919.949, z=29.557},
	{name="ATM", id=277, x=2683.006, y=3286.578, z=54.35},
	{name="ATM", id=277, x=1171.981, y=2702.681, z=37.27},
	{name="ATM", id=277, x=-3040.736, y=593.140, z=7.01},
	{name="ATM", id=277, x=316.08, y=-587.25, z=43.29},
	{name="ATM", id=277, x=-30.272, y=-723.757, z=43.35},
	{name="ATM", id=277, x=-28.052, y=-724.601, z=43.35},
	{name="ATM", id=277, x=-815.75, y=-1040.76, z=26.75},
	{name="ATM", id=277, x=-1390.66, y=-590.32, z=29.5},
	{name="ATM", id=277, x=815.77, y=-1040.77, z=26.0},
	{name="ATM", id=277, x=106.95, y=-738.93, z=45.75}
	

}

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end



function DrawText2(text)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.45)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.40, 0.10)
end








local isNearATM = false
local isNearBank = false




RegisterNetEvent('ethical-banking:showATM')
AddEventHandler('ethical-banking:showATM', function()
	inMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openGeneral'})
	TriggerServerEvent('bank:balance')
end)

if bankMenu then
	Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
	if isNearBank then
		DisplayHelpText(Config.HelpText1)
	
		if IsControlJustPressed(1, 38) then
			inMenu = true
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			pokazdowodbankanim()
			portfeldowodbankprop()
		end
	end
				
		if IsControlJustPressed(1, 322) then
			inMenu = false
			SetNuiFocus(false, false)
			SendNUIMessage({type = 'close'})
		end
	end
	end)
end



RegisterCommand('atm', function()
    Citizen.CreateThread(function()
        TriggerEvent('ethical-banking:ATMCheck')
    end)
end, false)

RegisterNetEvent('ethical-banking:ATMCheck')
AddEventHandler('ethical-banking:ATMCheck', function()
    playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for k, v in pairs(Config.Models) do
        local model = GetHashKey(v)
        entity = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 1.5, model, false, false, false)

        if entity ~= 0 then
            atmFound = true
            break
        else
            atmFound = false
        end
    end
    
    if atmFound == true then
		inMenu = true
		SetNuiFocus(true, true)
		SendNUIMessage({type = 'openatm'})
	else
		TriggerEvent("DoLongHudText","No ATM.",2)
	end
end)


if bankMenu then
	Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if nearBank() then
			isNearBank = true
		elseif nearATM() then
			isNearATM = true
		else
			isNearATM = false
			isNearBank = false
		end	
	end
	end)
end

RegisterNetEvent('atm:uiui')
AddEventHandler('atm:uiui', function()
	inMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openGeneral'})
end)




RegisterNUICallback('login', function(data)
	TriggerServerEvent('bank:login', data.login, data.password)
	TriggerServerEvent('ethical-:getAccount', data.login)
end)

RegisterNUICallback('loginatm', function(data)
	TriggerServerEvent('bank:loginatm', data.login, data.password)
	TriggerServerEvent('ethical-banking:getAccount', data.login)
end)

RegisterNUICallback('loginbus', function(data)
	if isCop then
		TriggerServerEvent('bank:loginbus', data.login, data.password)
		TriggerServerEvent('ethical-banking:getAccount', data.login)

	elseif isMedic or isDoctor or isNews then
		TriggerServerEvent('bank:loginbus', data.login, data.password)
		TriggerServerEvent('ethical-banking:getAccount', data.login)

	
	
	


	
	
	

	else
		
		
		
	end


end)




















		







RegisterNetEvent('successlogin')
AddEventHandler('successlogin', function(login, playerName, debit, pinC, accNum)	
	
	TriggerServerEvent('bank:balance')
	SendNUIMessage({
		type = "succlogin",
		account = login,
		player = playerName,
		debitcard = debit,
		pin = pinC,
		accNum = accNum
	})
end)

RegisterNetEvent('successloginatm')
AddEventHandler('successloginatm', function(login, playerName, debit, pinC, accNum)	
	TriggerServerEvent('bank:balance')
	SendNUIMessage({
		type = "succloginatm",
		account = login,
		player = playerName,
		debitcard = debit,
		pin = pinC,
		accNum = accNum
	})
end)

RegisterNetEvent('successloginbus')
AddEventHandler('successloginbus', function(login, playerName, debit, pinC, accNum)	
	TriggerServerEvent('bank:balance')
	SendNUIMessage({
		type = "succloginbus",
		account = login,
		player = playerName,
		debitcard = debit,
		pin = pinC,
		accNum = accNum
	})
end)

RegisterNUICallback('createaccountnew', function(data)
	
	
	TriggerServerEvent('ethical-banking:createnewaccount', data.login12, data.password1, data.pin)
end)



RegisterNUICallback('changepassword', function(data)
	TriggerServerEvent('ethical-banking:login', data.login, data.password)
end)


RegisterNetEvent('accountdeleted')
AddEventHandler('accountdeleted', function()

	SendNUIMessage({
		type = "deletedatall"
		})
end)

RegisterNetEvent('deletefail')
AddEventHandler('deletefail', function()

	SendNUIMessage({
		type = "failed"
		})
end)





Citizen.CreateThread(function()
	if showblips then
		for k,v in ipairs(banks)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		if v.principal ~= nil and v.principal then
			SetBlipColour(blip, 77)
		end
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
		end
	end
end)





RegisterNUICallback('getname', function()
	TriggerServerEvent('getmycasualname')
end)

RegisterNetEvent('myname')
AddEventHandler('myname', function(playerName)
	SendNUIMessage({
		type = "saymyname",
		player = playerName
		})
end)





RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	SendNUIMessage({
		type = "balanceHUD",
		balance = balance
		})
		
end)




RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:deposit', tonumber(data.amount))
end)

RegisterNetEvent('depositDONE')
AddEventHandler('depositDONE', function(balance)
	SendNUIMessage({
		type = "depodone"
		})
		Citizen.Wait(1000)
	TriggerServerEvent('bank:balance')
end)




RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('bank:withdraw', tonumber(data.amountw))
end)

RegisterNUICallback('withdrawlatm', function(data)
	TriggerServerEvent('bank:withdrawatm', tonumber(data.amountwatm))
end)

RegisterNetEvent('withdrawDONE')
AddEventHandler('withdrawDONE', function(balance)
	SendNUIMessage({
		type = "withdone"
		})
		Citizen.Wait(1000)
	TriggerServerEvent('bank:balance')
end)




RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)





RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('bank:transfer', data.to, data.amountt)
end)

RegisterNetEvent('transferDONE')
AddEventHandler('transferDONE', function(balance)
	SendNUIMessage({
		type = "transdone"
		})
		Citizen.Wait(1000)
	TriggerServerEvent('bank:balance')
end)




RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)




RegisterNUICallback('NUIFocusOff', function()
	TriggerServerEvent('ethical-banking:updateLoggedFalse')
end)

RegisterNetEvent('focusoff')
AddEventHandler('focusoff', function()
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)





function nearBank()
	local playerloc = GetEntityCoords(PlayerPedId())
	
	for _, search in pairs(banks) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 2 then
			return true
		end
	end
end

function nearATM()
	local playerloc = GetEntityCoords(PlayerPedId())

	if Config.UseObjects then
		for i = 1, #atmProps do
			local entity = GetClosestObjectOfType(playerloc, 1.0, GetHashKey(atmProps[i]), false, false, false)
			local entityCoords = GetEntityCoords(entity)

			if DoesEntityExist(entity) then
				return true
			end
		end
	else
		for _, search in pairs(atms) do
			local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
			
			if distance <= 1 then
				return true
			end
		end
	end
end


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function pokazdowodbankanim()
	RequestAnimDict("random@atmrobberygen")
	while (not HasAnimDictLoaded("random@atmrobberygen")) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), "random@atmrobberygen", "a_atm_mugging", 8.0, 3.0, 2000, 0, 1, false, false, false)
end

function portfeldowodbankprop()
	portfel = CreateObject(GetHashKey('prop_ld_wallet_01'), GetEntityCoords(PlayerPedId()), true)
	AttachEntityToEntity(portfel, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.17, 0.0, 0.019, -120.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
	Citizen.Wait(500)
	dowod = CreateObject(GetHashKey('prop_michael_sec_id'), GetEntityCoords(PlayerPedId()), true)
	AttachEntityToEntity(dowod, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.150, 0.045, -0.015, 0.0, 0.0, 180.0, 1, 0, 0, 0, 0, 1)
	Citizen.Wait(1300)
	usuwaniebankprop()
end

function usuwaniebankprop()
	DeleteEntity(dowod)
	DeleteEntity(telefon)
	Citizen.Wait(200)
	DeleteEntity(portfel)
end

function usuwanieallbankprop()
	DeleteEntity(dowod)
	DeleteEntity(telefon)
	DeleteEntity(portfel)
end
 
function przelewkomendaanim()
	RequestAnimDict("amb@world_human_stand_mobile@male@text@base")
	while (not HasAnimDictLoaded("amb@world_human_stand_mobile@male@text@base")) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), "amb@world_human_stand_mobile@male@text@base", "base", 8.0, 3.0, 5000, 51, 1, false, false, false)
	Citizen.Wait(5000)
	usuwanieallbankprop()
end

function przelewtelefonprop()
	usuwanieallbankprop()
	Citizen.Wait(1)
	telefon = CreateObject(GetHashKey('prop_amb_phone'), GetEntityCoords(PlayerPedId()), true)
	AttachEntityToEntity(telefon, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.01, -0.005, 0.0, -10.0, 8.0, 0.0, 1, 0, 0, 0, 0, 1)
end


function EnterATM(entity)
    if Config.UsePogressBars == true then
        TaskTurnPedToFaceEntity(playerPed, entity, -1)
        LoadAnim('amb@prop_human_atm@male@enter')
        TaskPlayAnim(playerPed, "amb@prop_human_atm@male@enter", "enter", 8.0, -8.0, Config.AnimationEnterTime, 120, 0, false, false, false)
        exports['pogressBar']:drawBar(Config.AnimationEnterTime, 'Inserting Card', function()
            LoadAnim("amb@prop_human_atm@male@idle_a")
            TaskPlayAnim(playerPed, "amb@prop_human_atm@male@idle_a", "idle_a", 8.0, -8.0, -1, 3, 0, false, false, false)
        end)
    else
        TaskTurnPedToFaceEntity(playerPed, entity, -1)
        LoadAnim('amb@prop_human_atm@male@enter')
        TaskPlayAnim(playerPed, "amb@prop_human_atm@male@enter", "enter", 8.0, -8.0, Config.AnimationEnterTime, 120, 0, false, false, false)
        Citizen.Wait(Config.AnimationEnterTime)
        LoadAnim("amb@prop_human_atm@male@idle_a")
        TaskPlayAnim(playerPed, "amb@prop_human_atm@male@idle_a", "idle_a", 8.0, -8.0, -1, 3, 0, false, false, false)
    end
end