SKILL.name = "Blood Cleanse"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/spell_shadow_lifedrain.png"
SKILL.category = "Path of Blood"

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaos_warrior",
    "reaver"
}
SKILL.desc = [[
This skill drains your bloodpool, healing you.
This requires a full bloodpool.

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Chaos Warrior, Reaver
]]


SKILL.coolDown = 45
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamAOE" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamAOE") then return end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
		end)
		return
	end

    local bloodPool = ply:getChar():getData("bloodpool", 0)
    local mana = ply:getLocalVar("mana", 0)
        if mana < bloodPool then
            return
        end
    ply:setLocalVar("mana", mana - bloodPool)

    ply:SetHealth(math.Clamp(bloodPool + ply:Health(), ply:Health(), ply:GetMaxHealth()))
    timer.Simple(0.1, function()
        ParticleEffectAttach( "fantasy_khorne_blood_2", PATTACH_ABSORIGIN_FOLLOW, ply, 0 )
    end)

    

	if (SERVER) then
	    ply:SetNWBool( "nospamAOE", true )
    	net.Start( "AOEActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamAOE") then return end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
		end)
	end
end
SKILL.ability = ability