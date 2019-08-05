SKILL.name = "Tactical Advance"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_defend.png"
SKILL.category = "Tactical"

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "tactical",
}

SKILL.desc = [[
You drop a smokescreen and bolster your defenses, preparing to advance. - Inspired by Solitaire

Duration: 5 Seconds.
Cost: 60 Energy
Cooldown: 60 Seconds.
Class Restriction: Tactical
Ability Slot: 3

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

]]


SKILL.coolDown = 60
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamAOE" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamAOE") then return end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 60 then
			return
		end
	ply:setLocalVar("mana", mana - 60)

	local effectdata = EffectData()
	effectdata:SetOrigin(ply:GetPos())
	effectdata:SetScale( 500 )
	util.Effect( "ThumperDust", effectdata )
	util.Effect( "40k_smoke", effectdata , true, true)

	local armorRating = ply:getChar():getData("naturalArmorRating",0)
	ply:getChar():setData("naturalArmorRating", armorRating + 100)
	timer.Simple(5, function()
		ply:getChar():setData("naturalArmorRating", armorRating)
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