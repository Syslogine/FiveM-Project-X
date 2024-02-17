local alreadyRegisted = false

AddEventHandler("playerSpawned", function()
	if not alreadyRegisted then
		TriggerServerEvent('ethical-queue:removeConnected')
		alreadyRegisted = true
	end
end)