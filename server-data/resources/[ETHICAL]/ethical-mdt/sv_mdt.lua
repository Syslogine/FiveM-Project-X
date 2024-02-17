NPX = nil

TriggerEvent('np:getSharedObject', function(obj) NPX = obj end)


local dwebhook = ""

function sendToDiscord (name,message)
local embeds = {
    {
        ["title"]=message,
        ["type"]="rich",
        ["color"] =4306662,
        ["footer"]=  {
        ["text"]= "NP",
       },
    }
}

  if message == nil or message == '' then return FALSE end
  PerformHttpRequest(dwebhook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

TriggerEvent('es:addCommand', 'mdt', function(source, args, user)
	local src = source
	local pdunit = exports["ethical-base"]:getModule("Player"):GetUser(src)
	local character = pdunit:getCurrentCharacter()
	local officer = character.first_name
    if pdunit:getVar("job") == 'police' or pdunit:getVar("job") == 'judge' then
    	exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
    		for r = 1, #reports do
    			reports[r].charges = json.decode(reports[r].charges)
    		end
    		exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
    			for w = 1, #warrants do
    				warrants[w].charges = json.decode(warrants[w].charges)
    			end
    			TriggerClientEvent('ethical-mdt:toggleVisibilty', src, reports, warrants, officer)
    		end)
    	end)
    end
end)

RegisterServerEvent("ethical-mdt:hotKeyOpen")
AddEventHandler("ethical-mdt:hotKeyOpen", function()
	print("FUCKING OPEN DUDE")
	local src = source
	local pdunit = exports["ethical-base"]:getModule("Player"):GetUser(src)
	local character = pdunit:getCurrentCharacter()
	local officer = character.first_name
	print("WTF ",pdunit:getVar("job") == 'police')
    if pdunit:getVar("job") == 'police' then
    	exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
    		for r = 1, #reports do
    			reports[r].charges = json.decode(reports[r].charges)
    		end
    		exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
    			for w = 1, #warrants do
    				warrants[w].charges = json.decode(warrants[w].charges)
    			end

				print(src, reports, warrants, officer)
    			TriggerClientEvent('ethical-mdt:toggleVisibilty', src, reports, warrants, officer)
    		end)
    	end)
    end
end)

RegisterServerEvent("ethical-mdt:getOffensesAndOfficer")
AddEventHandler("ethical-mdt:getOffensesAndOfficer", function()
	local src = source
	local pdunit = exports["ethical-base"]:getModule("Player"):GetUser(src)
	local character = pdunit:getCurrentCharacter()
	local officer = character.first_name
	local charges = {}
	local jailtime = {}
	exports.ghmattimysql:execute('SELECT * FROM fine_types', {
	}, function(fines)
		for j = 1, #fines do
			if fines[j].category == 0 or fines[j].category == 1 or fines[j].category == 2 or fines[j].category == 3 then
				table.insert(charges, fines[j])
			end
		end
		TriggerClientEvent("ethical-mdt:returnOffensesAndOfficer", src, charges, officer)
	end)
end)

RegisterServerEvent("ethical-mdt:performOffenderSearch")
AddEventHandler("ethical-mdt:performOffenderSearch", function(query)
	local src = source
	local matches = {}
	exports.ghmattimysql:execute("SELECT * FROM `characters` WHERE LOWER(`first_name`) LIKE @query OR LOWER(`last_name`) LIKE @query OR CONCAT(LOWER(`first_name`), ' ', LOWER(`last_name`)) LIKE @query", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for index, data in ipairs(result) do
			table.insert(matches, data)
		end
		print("SEARCHING HERE", json.encode(matches))
		TriggerClientEvent("ethical-mdt:returnOffenderSearchResults", src, result)
	end)
end)

RegisterServerEvent("ethical-mdt:getOffenderDetails")
AddEventHandler("ethical-mdt:getOffenderDetails", function(offender)
	local src = source
	print("IDENTIFIER:",offender.owner)
	exports.ghmattimysql:execute("SELECT * FROM user_licenses WHERE identifier = @identifier;", {["identifier"] = offender.owner}, function(license_result)
		if license_result ~= nil then
			if license_result[1].weapon == 1 then
				print("i have weapon")
				local data = {label = "Weapon"}
				offender.licenses = data
			end
		end
	
	-- while offender.licenses == nil do Citizen.Wait(0) end
		print("LICENSE",offender.licenses)
		exports.ghmattimysql:execute('SELECT * FROM `user_mdt` WHERE `cid` = @cid', {
			['@cid'] = offender.id
		}, function(result)
			offender.notes = ""
			offender.mugshot_url = ""
			if result[1] then
				offender.notes = result[1].notes
				offender.mugshot_url = result[1].mugshot_url
			end
			exports.ghmattimysql:execute('SELECT * FROM `user_convictions` WHERE `cid` = @cid', {
				['@cid'] = offender.id
			}, function(convictions)
				if convictions[1] then
					offender.convictions = {}
					for i = 1, #convictions do
						local conviction = convictions[i]
						offender.convictions[conviction.offense] = conviction.count
					end
				end

				exports.ghmattimysql:execute('SELECT * FROM `mdt_warrants` WHERE `cid` = @cid', {
					['@cid'] = offender.id
				}, function(warrants)
					if warrants[1] then
						offender.haswarrant = true
					end
					-- print("MDT SERVER GETTING TO SEND OFFERNDER DETAILS? 2")
					TriggerClientEvent("ethical-mdt:returnOffenderDetails", src, offender)
				end)
			end)
		end)
	end)
end)

RegisterServerEvent("ethical-mdt:getOffenderDetailsById")
AddEventHandler("ethical-mdt:getOffenderDetailsById", function(char_id)
	local src = source
	exports.ghmattimysql:execute('SELECT * FROM `characters` WHERE `id` = @id', {
		['@id'] = char_id
	}, function(result)
		local offender = result[1]
		GetLicenses(offender.identifier, function(licenses) offender.licenses = licenses end)
		while offender.licenses == nil do Citizen.Wait(0) end
		exports.ghmattimysql:execute('SELECT * FROM `user_mdt` WHERE `cid` = @id', {
			['@id'] = offender.id
		}, function(result)
			offender.notes = ""
			offender.mugshot_url = ""
			if result[1] then
				offender.notes = result[1].notes
				offender.mugshot_url = result[1].mugshot_url
			end
			exports.ghmattimysql:execute('SELECT * FROM `user_convictions` WHERE `cid` = @id', {
				['@id'] = offender.id
			}, function(convictions)
				if convictions[1] then
					offender.convictions = {}
					for i = 1, #convictions do
						local conviction = convictions[i]
						offender.convictions[conviction.offense] = conviction.count
					end
				end

				TriggerClientEvent("ethical-mdt:returnOffenderDetails", src, offender)
			end)
		end)

	end)
end)

RegisterServerEvent("ethical-mdt:saveOffenderChanges")
AddEventHandler("ethical-mdt:saveOffenderChanges", function(id, changes, identifier)
	local src = source
	local pdunit = exports["ethical-base"]:getModule("Player"):GetUser(src)
	local character = pdunit:getCurrentCharacter()
	
	exports.ghmattimysql:execute('SELECT * FROM `user_mdt` WHERE `cid` = @id', {
		['@id']  = id
	}, function(result)
		if result[1] then
			exports.ghmattimysql:execute('UPDATE `user_mdt` SET `notes` = @notes, `mugshot_url` = @mugshot_url WHERE `cid` = @id', {
				['@id'] = id,
				['@notes'] = changes.notes,
				['@mugshot_url'] = changes.mugshot_url
			})
		else
			exports.ghmattimysql:execute('INSERT INTO `user_mdt` (`cid`, `notes`, `mugshot_url`) VALUES (@id, @notes, @mugshot_url)', {
				['@id'] = id,
				['@notes'] = changes.notes,
				['@mugshot_url'] = changes.mugshot_url
			})
		end
		for i = 1, #changes.licenses_removed do
			local license = changes.licenses_removed[i]
			exports.ghmattimysql:execute('DELETE FROM `user_licenses` WHERE `type` = @type AND `owner` = @identifier', {
				['@type'] = license.type,
				['@identifier'] = identifier
			})
		end

		for conviction, amount in pairs(changes.convictions) do	
			exports.ghmattimysql:execute('UPDATE `user_convictions` SET `count` = @count WHERE `cid` = @id AND `offense` = @offense', {
				['@id'] = id,
				['@count'] = amount,
				['@offense'] = conviction
			})
		end

		for i = 1, #changes.convictions_removed do
			exports.ghmattimysql:execute('DELETE FROM `user_convictions` WHERE `cid` = @id AND `offense` = @offense', {
				['@id'] = id,
				['offense'] = changes.convictions_removed[i]
			})
		end
	end)
end)

RegisterServerEvent("ethical-mdt:saveReportChanges")
AddEventHandler("ethical-mdt:saveReportChanges", function(data)
    local src = source
	local author = GetCharacterName(source)
	exports.ghmattimysql:execute('UPDATE `mdt_reports` SET `title` = @title, `incident` = @incident WHERE `id` = @id', {
		['@id'] = data.id,
		['@title'] = data.title,
		['@incident'] = data.incident
	})
	sendToDiscord('ethical- Report Logs', author .. ' Updated a report with id: '..data.id..' Title: '..data.title..' Incident: '..data.incident..'')
end)

RegisterServerEvent("ethical-mdt:deleteReport")
AddEventHandler("ethical-mdt:deleteReport", function(id)
    local src = source
	local author = GetCharacterName(source)
	exports.ghmattimysql:execute('DELETE FROM `mdt_reports` WHERE `id` = @id', {
		['@id']  = id
	})
	sendToDiscord('ethical- Report Logs', author .. ' Deleted a report with id: '..id..'')
end)

RegisterServerEvent("ethical-mdt:submitNewReport")
AddEventHandler("ethical-mdt:submitNewReport", function(data)
	local src = source
	local author = GetCharacterName(source)
	if tonumber(data.sentence) and tonumber(data.sentence) > 0 then
		data.sentence = tonumber(data.sentence)
	else 
		data.sentence = nil
	end
	charges = json.encode(data.charges)
	data.date = os.date('%m-%d-%Y %H:%M:%S', os.time())
	exports.ghmattimysql:execute('INSERT INTO `mdt_reports` (`cid`, `title`, `incident`, `charges`, `officer`, `name`, `date`, `jailtime`) VALUES (@id, @title, @incident, @charges, @officer, @name, @date, @sentence)', {
		['@id']  = data.char_id,
		['@title'] = data.title,
		['@incident'] = data.incident,
		['@charges'] = charges,
		['@officer'] = officer,
		['@name'] = data.name,
		['@date'] = data.date,
		['@sentence'] = data.sentence
	}, function(id)
		TriggerEvent("ethical-mdt:getReportDetailsById", id, src)
		-- sendToDiscord('ethical- Report Logs', officer .. ' Created a report with id: '..data.char_id..' Title: '..data.title..' Incident: '..data.incident..' Author of report: '..officer..' Date of report: '..data.date..' Name: '..data.name..'')
	end)

	for offense, count in pairs(data.charges) do
		exports.ghmattimysql:execute('SELECT * FROM `user_convictions` WHERE `offense` = @offense AND `cid` = @id', {
			['@offense'] = offense,
			['@id'] = data.char_id
		}, function(result)
			if result[1] then
				exports.ghmattimysql:execute('UPDATE `user_convictions` SET `count` = @count WHERE `offense` = @offense AND `cid` = @id', {
					['@id']  = data.char_id,
					['@offense'] = offense,
					['@count'] = count + 1
				})
			else
				exports.ghmattimysql:execute('INSERT INTO `user_convictions` (`cid`, `offense`, `count`) VALUES (@id, @offense, @count)', {
					['@id']  = data.char_id,
					['@offense'] = offense,
					['@count'] = count
				})
			end
		end)
	end
end)

RegisterServerEvent("ethical-mdt:sentencePlayer")
AddEventHandler("ethical-mdt:sentencePlayer", function(jailtime, charges, char_id, fine, players)
	local src = source
	local jailmsg = ""
	local xPlayer = NPX.GetPlayerFromId(source)
	for offense, amount in pairs(charges) do
		jailmsg = jailmsg .. " "..offense.." x"..amount.." |"
	end
	for _, src in pairs(players) do
		if src ~= 0 and GetPlayerName(src) then
			exports.ghmattimysql:execute('SELECT * FROM `characters` WHERE `identifier` = @identifier', {
				['@identifier'] = GetPlayerIdentifiers(src)[1]
			}, function(result)
				if result[1].id == char_id then
					if jailtime and jailtime > 0 then
						jailtime = math.ceil(jailtime)
						TriggerEvent("ethical-jail:jailPlayer", src, jailtime, jailmsg)
					end
					if fine > 0 then
						TriggerClientEvent("ethical-mdt:billPlayer", src, src, 'society_police', 'Fine: '..jailmsg, fine)
					end
					return
				end
			end)
		end
	end
end)

RegisterServerEvent("ethical-mdt:performReportSearch")
AddEventHandler("ethical-mdt:performReportSearch", function(query)
	local src = source
	local matches = {}
	print("FUCK IS NOT READING?", query)
	exports.ghmattimysql:execute("SELECT * FROM `mdt_reports` WHERE `cid` LIKE @query OR LOWER(`title`) LIKE @query OR LOWER(`name`) LIKE @query OR LOWER(`officer`) LIKE @query or LOWER(`charges`) LIKE @query", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for index, data in ipairs(result) do
			data.charges = json.decode(data.charges)
			table.insert(matches, data)
		end

		TriggerClientEvent("ethical-mdt:returnReportSearchResults", src, matches)
	end)
end)

RegisterServerEvent("ethical-mdt:performVehicleSearch")
AddEventHandler("ethical-mdt:performVehicleSearch", function(query)
	local src = source
	local matches = {}
	exports.ghmattimysql:execute("SELECT * FROM `characters_cars` WHERE LOWER(`license_plate`) LIKE @query", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for index, car in ipairs(result) do

			local data_decoded = json.decode(car.data)

			if data_decoded.colors then
					car.color = colors[tostring(data_decoded.colors[1])] .. " on " .. colors[tostring(data_decoded.colors[2])]
			end
			table.insert(matches, car)
		end


		TriggerClientEvent("ethical-mdt:returnVehicleSearchResults", src, matches)
	end)
end)

RegisterServerEvent("ethical-mdt:performVehicleSearchInFront")
AddEventHandler("ethical-mdt:performVehicleSearchInFront", function(query)
	local src = source
	local target = exports["ethical-base"]:getModule("Player"):GetUser(src)
	local character = target:getCurrentCharacter()
	local playerName = character.first_name
    if pdunit:getVar("job") == 'police' then
		exports.ghmattimysql:execute("SELECT * FROM `characters_cars` WHERE `license_plate` = @query", {
			['@query'] = query
		}, function(result)
			TriggerClientEvent("ethical-mdt:toggleVisibilty", src)
			TriggerClientEvent("ethical-mdt:returnVehicleSearchInFront", src, result, query)
		end)
	end
end)

RegisterServerEvent("ethical-mdt:getVehicle")
AddEventHandler("ethical-mdt:getVehicle", function(vehicle)
	local src = source
	exports.ghmattimysql:execute("SELECT * FROM `characters` WHERE `owner` = @query", {
		['@query'] = vehicle.owner
	}, function(result)
		if result[1] then
			vehicle.owner = result[1].first_name .. ' ' .. result[1].last_name
			vehicle.owner_id = result[1].id
		end

		vehicle.type = types[vehicle.type]
		TriggerClientEvent("ethical-mdt:returnVehicleDetails", src, vehicle)
	end)
end)

RegisterServerEvent("ethical-mdt:getWarrants")
AddEventHandler("ethical-mdt:getWarrants", function()
	local src = source
	exports.ghmattimysql:execute("SELECT * FROM `mdt_warrants`", {}, function(warrants)
		for i = 1, #warrants do
			warrants[i].expire_time = ""
			warrants[i].charges = json.decode(warrants[i].charges)
		end
		TriggerClientEvent("ethical-mdt:returnWarrants", src, warrants)
	end)
end)

RegisterServerEvent("ethical-mdt:submitNewWarrant")
AddEventHandler("ethical-mdt:submitNewWarrant", function(data)
	local src = source
	data.charges = json.encode(data.charges)
	data.author = GetCharacterName(source)
	data.date = os.date('%m-%d-%Y %H:%M:%S', os.time())
	print("DATA",data.name,data.char_id)
	exports.ghmattimysql:execute('INSERT INTO `mdt_warrants` (`name`, `cid`, `report_id`, `report_title`, `charges`, `date`, `expire`, `notes`, `officer`) VALUES (@name, @char_id, @report_id, @report_title, @charges, @date, @expire, @notes, @officer)', {
		['@name']  = data.name,
		['@char_id'] = data.char_id,
		['@report_id'] = data.report_id,
		['@report_title'] = data.report_title,
		['@charges'] = data.charges,
		['@date'] = data.date,
		['@expire'] = data.expire,
		['@notes'] = data.notes,
		['@officer'] = data.author
	}, function()
		TriggerClientEvent("ethical-mdt:completedWarrantAction", src)
		sendToDiscord('ethical- Warrant Logs', data.author .. ' Created a Warrant with id: '..data.name..' Report id: '..data.report_id..' Title: '..data.report_title..' Author of report: '..data.author..' Date of report: '..data.date..'')
	end)
end)

RegisterServerEvent("ethical-mdt:deleteWarrant")
AddEventHandler("ethical-mdt:deleteWarrant", function(id)
	local src = source
	local author = GetCharacterName(source)
	exports.ghmattimysql:execute('DELETE FROM `mdt_warrants` WHERE `id` = @id', {
		['@id']  = id
	}, function()
		TriggerClientEvent("ethical-mdt:completedWarrantAction", src)
		sendToDiscord('ethical- Warrant Logs', author .. ' Deleted a warrant with id: '..id..'')
	end)
end)

RegisterServerEvent("ethical-mdt:getReportDetailsById")
AddEventHandler("ethical-mdt:getReportDetailsById", function(query, _source)
	if _source then source = _source end
	local src = source
	exports.ghmattimysql:execute("SELECT * FROM `mdt_reports` WHERE `id` = @query", {
		['@query'] = query
	}, function(result)
		if result and result[1] then
			result[1].charges = json.decode(result[1].charges)
			TriggerClientEvent("ethical-mdt:returnReportDetails", src, result[1])
		end
	end)
end)

function GetLicenses(identifier, cb)
	exports.ghmattimysql:execute('SELECT * FROM user_licenses WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		local licenses   = {}
		local asyncTasks = {}
		for k,v in ipairs(result) do
			print("LICENSE THAT NEEDED",json.encode(v))
		end
		-- for i=1, #result, 1 do

		-- 	local scope = function(type)
		-- 		table.insert(asyncTasks, function(cb)
		-- 			exports.ghmattimysql:execute('SELECT * FROM user_licenses WHERE identifier = @identifier', {
		-- 				['@identifier'] = identifier
		-- 			}, function(result2)
		-- 				print(json.encode("RESULT LICENSE", json.encode(result2)))
		-- 				table.insert(licenses, {
		-- 					label = result2
		-- 				})
		-- 				cb()
		-- 			end)
		-- 		end)
		-- 	end
		-- end
			cb(licenses)
	end)
end

function GetCharacterName(source)
	local src = source
	local user = exports["ethical-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
	-- local char = exports.ghmattimysql:execute('SELECT first_name, last_name FROM characters WHERE id = @identifier', {
	-- 	['@identifier'] = characterId
	-- })

	if char and char.first_name and char.last_name then
		return ('%s %s'):format(char.first_name, char.last_name)
	end
end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end
