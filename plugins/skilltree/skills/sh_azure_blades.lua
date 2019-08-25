SKILL.name = "Azure Blades"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/spell_frost_icestorm.png"
SKILL.category = "Lore of Heavens"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "celestial_wizard"
}

SKILL.desc = [[
Thin, razor-like shards fill the air around the wizard, 
whirling in orbit around him like miniature stars, and dealing damage to any who come close for a hand-to-hand combat attack.

Ability Slot: 2
Class Restriction: Bright Wizard

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 15

local function ability(SKILL, ply )
   local nospam = ply:GetNWBool( "nospamRanged" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
		timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamRanged", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
	ply:setLocalVar("mana", mana - 20)
	
	timer.Create("AzureBlades"..ply:SteamID(), 0.1, 50, function()
		local ents = ents.FindInSphere(ply:GetPos(), 125)
		ParticleEffectAttach("fantasy_azure_blades", PATTACH_ABSORIGIN, ply, -1)
		for k, v in pairs(ents) do
			if v:IsNPC() or (v:IsPlayer() and v != ply) then
				local dmg = DamageInfo()
				dmg:SetDamageType(DMG_SLASH)
				dmg:SetDamage(10)
				dmg:SetAttacker(ply)
				v:TakeDamageInfo(dmg)
			end
		end
	end)
	
			
	if (SERVER) then
		ply:SetNWBool( "nospamRanged", true )
		print("Cdstart")

		net.Start( "RangedActivated" )
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
			timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
				ply:SetNWBool( "nospamRanged", false )
			end)

	end
end

SKILL.ability = ability