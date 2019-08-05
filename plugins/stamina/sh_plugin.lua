PLUGIN.name = "Stamina"
PLUGIN.author = "Chessnut"
PLUGIN.desc = "Adds a stamina system to limit running."

if (SERVER) then
	function PLUGIN:PostPlayerLoadout(client)
		client:setLocalVar("stm", 100)

		local uniqueID = "nutStam"..client:SteamID()
		local offset = 0
		local runSpeed = client:GetRunSpeed() - 5

		timer.Create(uniqueID, 0.25, 0, function()
			if (not IsValid(client)) then
				timer.Remove(uniqueID)
				return
			end
			local character = client:getChar()
			if (client:GetMoveType() == MOVETYPE_NOCLIP or not character) then
				return
			end

			local current = client:getLocalVar("stm", 0)
			local value = math.Clamp(current + 2, 0, 100)

			if (current != value) then
				client:setLocalVar("stm", value)
			end
		end)
	end

	local playerMeta = FindMetaTable("Player")

	function playerMeta:restoreStamina(amount)
		local current = self:getLocalVar("stm", 0)
		local value = math.Clamp(current + amount, 0, 100)

		self:setLocalVar("stm", value)
	end
elseif (nut.bar) then
	nut.bar.add(function()
		return LocalPlayer():getLocalVar("stm", 0) / 100
	end, Color(200, 200, 40), nil, "stm")
end
