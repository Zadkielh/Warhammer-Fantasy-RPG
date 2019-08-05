SKILL.name = "Comet of Casandora"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/spell_fire_fireball02.png"
SKILL.category = "Lore of Heavens"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "celestial_wizard"
}

SKILL.desc = [[
Reaching out across the Winds of Magic into the highest heavens, the wizard draws a wandering meteorite down towards the battlefield.
Ability Slot: 2
Class Restriction: Bright Wizard

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 2

local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamUlt") then return end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 10 then
			return
		end
	ply:setLocalVar("mana", mana - 10)
			
		local Ent = ents.Create("sent_zad_comet")
		
		local OwnerPos = ply:GetShootPos() + ply:GetAimVector() * 1000
		
		

		Ent:SetPos(OwnerPos)
		Ent:SetOwner(ply)
		Ent:Spawn()

		net.Start("dropPodComingDown")
			net.WriteEntity(ply)
			net.WriteVector(OwnerPos)
		net.Broadcast()


	if (SERVER) then
	    ply:SetNWBool( "nospamUlt", true )
    	net.Start( "UltActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamUlt") then return end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
	end
end
SKILL.ability = ability