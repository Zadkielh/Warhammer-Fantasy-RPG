PLUGIN.name = "Luck "
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Adds a luck attribute."

if (SERVER) then
	function PLUGIN:EntityTakeDamage(client, dmg)
		if (dmg:GetAttacker():IsPlayer()) then
			if !(IsValid(dmg:GetAttacker():GetActiveWeapon())) then return end
			if weapons.IsBasedOn( dmg:GetAttacker():GetActiveWeapon():GetClass(), "tfa_melee_base" ) then
				if (dmg:IsDamageType(DMG_FALL)) then 
					return
				end

			local luck = 10 + dmg:GetAttacker():getChar():getAttrib("luck", 0) * 0.8
			local power = dmg:GetAttacker():getChar():getAttrib("str", 0) / 100
			local crit = math.random(0, 100)

			if crit <= luck then
				dmg:ScaleDamage( 2 + power)
				dmg:SetDamageType( DMG_DIRECT )
				dmg:GetAttacker():EmitSound("weapons/gauss/fire1.wav", 100)
			end

			end
		end		
	end

end

do
	local charMeta = nut.meta.character

	function charMeta:getCriticalChance()
		local luck = 10 + self:getAttrib("luck", 0) * 0.8
		return luck
	end

end