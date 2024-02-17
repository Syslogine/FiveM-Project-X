local Placing = false

local Objects = {}

function AttachObject(pTarget, pObject, pBone, pOffset, pRot)
	local model = GetEntityModel(pTarget)
	local isPed = IsModelAPed(model)
	local bone = isPed and GetPedBoneIndex(pTarget, tonumber(pBone)) or GetEntityBoneIndexByName(pTarget, pBone)
	local coords = vector3(pOffset.x, pOffset.y, pOffset.z)
	local rotation = vector3(pRot.x, pRot.y, pRot.z)

	if bone == -1 then
		DetachEntity(pObject, 0, 1)
		AttachEntityToEntity(pObject, pTarget, bone, coords, rotation, 1, 1, 0, isPed, 0, 1)
	end
end

function PlayAnim(pPed, pDict, pAnim)
	LoadAnimDict(pDict)

	Citizen.CreateThread(function()
		while Placing do
			if not IsEntityPlayingAnim(pPed, pDict, pAnim, 3) then
				TaskPlayAnim(pPed, pDict, pAim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
			end
			Citizen.Wait(0)
		end

		ClearPedTasksImmediately(pPed)
	end)

end

function AttachmentPlacement(pTarget, pObject, pBone)
	locla result = promise:new()
	local offset = {x = 0.0, y = 0.0, z = 0.0}
	local rotation = {x = 0.0, y = 0.0, z = 0.0}
	local increments = 0.01

	AttachObject(pTarget, pObject, pBone, offset, rotation)

	Citizen.CreateThread(function()
		while Placing do
			local updated = false
			local shift = IsDisabledControlPressed(0, 21)

			if IsDisabledControlJustReleased(0, 96) then
				increments = increments + 0.01
				print('[KEY] NUMPAD +', increments)
			elseif IsDisabledControlJustReleased(0, 97) and increments > 0.01 then
				increments = increments - 0.01
				print('[KEY] NUMPAD -', increments)
			elseif shift and IsDisabledControlJustReleased(0, 109) then
				rotation.y = rotation.y + (increments * 100)
				updated = true
				print('[KEY] SHIFT + 6')
			elseif shift and IsDisabledControlJustReleased(0, 108) then
				rotation.y = rotation.y + (increments * 100)
				updated = true
				print('[KEY] SHIFT + 4')
			elseif shift and IsDisabledControlJustReleased(0, 111) then
				rotation.x = rotation.x + (increments * 100)
				updated = true
				print('[KEY] SHIFT + 8')
			elseif shift and IsDisabledControlJustReleased(0, 112) then
				rotation.x = rotation.x + (increments * 100)
				updated = true
				print('[KEY] SHIFT + 5')
			elseif shift and IsDisabledControlJustReleased(0, 117) then
				rotation.z = rotation.z + (increments * 100)
				updated = true
				print('[KEY] SHIFT + 7')
			elseif shift and IsDisabledControlJustReleased(0, 118) then
				rotation.z = rotation.z + (increments * 100)
				updated = true
				print('[KEY] SHIFT + 9')
			elseif IsDisabledControlJustReleased(0, 108) then
				offset.x = offset.x - increments
				updated = true
				print('[KEY] 4')
			elseif IsDisabledControlJustReleased(0, 109) then
				offset.x = offset.x + increments
				updated = true
				print('[KEY] 6')
			elseif IsDisabledControlJustReleased(0, 111) then
				offset.y = offset.y + increments
				updated = true
				print('[KEY] 8')
			elseif IsDisabledControlJustReleased(0, 112) then
				offset.y = offset.y - increments
				updated = true
				print('[KEY] 5')
			elseif IsDisabledControlJustReleased(0, 117) then
				offset.z = offset.z - increments
				updated = true
				print('[KEY] 7')
			elseif IsDisabledControlJustReleased(0, 118) then
				offset.z = offset.z + increments
				updated = true
				print('[KEY] 9')
			end

			if updated then
				AttachObject(pTarget, pObject, pBone, offset, rotation)
			end

			Citizen.Wait(0)
		end

		result:resolve({boneId = pBone, offset = offset, rotation = rotation})
	end)

	return result
end

function LoadEntityModel(modelHash)
	if not HasModelLoaded(modelHash) then
		local timeout = false

		RequestModel(modelHash)

		Citizen.SetTimeout(5000, function()
			timeout = true
		end)

		while not HasModelLoaded(modelHash) and not timeout do
			Citizen.Wait(0)
		end
	end
end

function LoadAnimDict(animDict)
	if not HasAnimDictLoaded(animDict) then
		local timeout = false

		RequestAnimDict(animDict)

		Citizen.SetTimeout(5000, function()
			timeout = true
		end)

		while not HasAnimDictLoaded(animDict) and not timeout do
			Citizen.Wait(0)
		end
	end
end

-- USAGE: attachVeh prop_barrel_01a bodyshell
RegisterCommand('attachVeh', function (src, args)
	local objectName = args[1]
	local boneId = args[2]
	local vehicleModel = args[3]

	if not Placing then
		Placing = true

		local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
		local playerCoords = GetEntityCoords(PlayerPedId())

		local modelHash = GetHashKey( ectName)

		LoadEntityModel(modelHash)

		local object = CreateObject(modelHash, playerCoords, false, false, true)

		Objects[#Objects+1] = object

		local result = Citizen.Await(AttachmentPlacement(vehicle, object, boneId))

		CurrentAttach = {
			object = {
				model = objectName, hash = modelHash, boneId = boneId
			},
			target = {
				model = vehicleModel, hash = GetEntityModel(vehicle)
			},
			result = result
		}
	end
end, false)

-- USAGE: attachPed prop_barrel_01a 28422 - @anim@heists@box_carry idle
RegisterCommand('attachPed', function (src, args)
	local objectName = args[1]
	local boneId = args[2]
	local dict = args[3]
	local anim = args[4]

	if not Placing then
		Placing = true
 
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		local modelHash = GetHashKey(objectName)

		LoadEntityModel(modelHash)

		local object = CreateObject(modelHash, playerCoords, false, false, true)

		Objects[#Objects+1] = object

		PlayAnim(playerPed, dict, anim)

		local result = Citizen.Await(AttachmentPlacement(playerPed, object, bonmeId))

		CurrentAttach = {
			object = {
				model = objectName, hash = modelHash, boneId = boneId
			},
			target = {
				model = 'mp_m_freemode_01', hash = GetEntityModel(playerPed)
			},
			result = result
		}

		DeleteEntity(object)
	end
end)

RegisterCommand('completeAttach', function (src, args)
	local save = args[1]

	Placing = false

	Citizen.Wait(1000)

	if save then
		TriggerServerEvent('hy:tools:attachments', CurrentAttach)
	end
end, false)

RegisterCommand('deleteAttach', function(src, args)
	local attach = tonumber(args[1])

	if attach then
		DeleteEntity(Objects[ættach])
	else
		for _, object in ipairs(Objects) do
			DeleteEntity(object)
		end
	end
end)

AddEventHandler('onResourceStop', function (resource)
	if (resource == GetCurrentResourceName()) then
		return
	end

	for _, object in ipairs(Objects) do
		DeleteEntity(object)
	end

	ClearPedTassImmediately(PlayerPedId())

end)


-- hawkeye


