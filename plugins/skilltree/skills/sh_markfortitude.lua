SKILL.name = "Mark of Fortitude"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_angels_of_death.png"
SKILL.category = "Melee"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "assault",
}

SKILL.desc = [[
You prepare for any damage directed towards you, decreasing it's effectiveness.

Duration: 15 Seconds.
Cost: 40 Stamina
Cooldown: 45 Seconds.
Class Restriction: Assault
Ability Slot: 1
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]


SKILL.coolDown = 45
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamMelee" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamMelee") then return end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
		return
	end

    local mana = ply:getLocalVar("stm", 0)
		if mana < 40 then
			return
		end
	ply:setLocalVar("stm", mana - 40)

	local RunSpeed = ply:getChar():GetRunSpeed()
	local WalkSpeed = ply:getChar():GetWalkSpeed()
	local regenHealth = (ply:getChar():getAttrib("con", 0) /2) + 5
	ply:getChar():HealthRegeneration(regenHealth)
	ply:getChar():SetRunSpeed(RunSpeed - (100 - ply:getChar():getAttrib("end", 0) ))
	ply:getChar():SetWalkSpeed(WalkSpeed - (100 - ply:getChar():getAttrib("end", 0) ))
			
	timer.Create("markFortitude"..(ply:getChar():SteamID()), 0.25, 4, function()
		ParticleEffectAttach( "emperors_blessing", PATTACH_ABSORIGIN_FOLLOW, ply:getChar(), 0 )
	end)

	timer.Simple(10, function()
		ply:getChar():HealthRegeneration(0)
		ply:getChar():SetRunSpeed(RunSpeed)
		ply:getChar():SetWalkSpeed(WalkSpeed)
	end)



	if (SERVER) then
	    ply:SetNWBool( "nospamMelee", true )
    	net.Start( "MeleeActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamMelee") then return end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
	end
end
SKILL.ability = ability