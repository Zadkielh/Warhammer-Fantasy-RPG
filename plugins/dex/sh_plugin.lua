PLUGIN.name = "Dexterity"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = ""

hook.Add("EntityTakeDamage", "DexDodge", function(client, dmg)
	if (dmg:IsDamageType(DMG_FALL)) then return end
    if (client:IsPlayer()) then
		local uniqueID = client:SteamID()
		local value = (client:getChar():getAttrib("dex", 0) * 0.5)
		if (IsValid(client)) then
			local character = client:getChar()
			local chance = math.random(1, 100)
				
			if (chance + value) >= 90 then
						
				dmg:SetDamage( dmg:GetDamage() * 0)
				client:TakeDamageInfo( dmg )
			end
		end
			
	end
end)


hook.Add("PostPlayerLoadout", "DexJump", function(client)
	local value = client:getChar():getAttrib("dex", 0)
	if (IsValid(client)) then
        client:SetJumpPower( 200 + (value * 2) )
	end
end)