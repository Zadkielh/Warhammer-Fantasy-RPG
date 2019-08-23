SKILL.name = "Swiftwing"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_shadow_shadowfury.png"
SKILL.category = "Lore of Heavens"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "celestial_wizard"
}

SKILL.desc = [[
The wizard turns into a blur of blue energy which darts into the air, flickering away at incredible speed. 
After 5 seconds you turn back to normal and magically regenerate to full health.

Maxrange: 500 Units.
Cost: 100 Energy
Cooldown: 60 Seconds
Ability Slot: 4
Class Restriction: Aspiring Sorcerer

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 10

local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamUlt") then return  end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
	ply:setLocalVar("mana", mana - 20)

	timer.Simple(0, function()
		ParticleEffectAttach("fantasy_thunderbolt_tail", PATTACH_ABSORIGIN_FOLLOW, ply, 1)
	end)
	ply:SetNoDraw(true)

	local pos = ply:GetPos()

	ply:SetPos(pos + ply:GetUp() * 200)
	ply:SetVelocity(ply:GetAimVector() * 2000)
	ply:SetMoveType(MOVETYPE_FLY)
	timer.Simple(5, function()
		local pos = ply:GetPos()
		ply:KillSilent()
		ply:Spawn()
		ply:SetPos(pos)
	end)
	

	if SERVER then

		ply:SetNWBool( "nospamUlt", true )
		print("Cdstart")

		net.Start( "UltActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )


		if timer.Exists(ply:SteamID().."nospamUlt") then return  end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false ) 
		end)

	end
end

SKILL.ability = ability