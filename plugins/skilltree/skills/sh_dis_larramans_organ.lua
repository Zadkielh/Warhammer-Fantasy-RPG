SKILL.name = "Larramans Organ"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_apothecary_heal.png"
SKILL.category = "Tactical"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "tactical",
	"apothecary",
	"techmarine",
	"chaplain",
	"librarian",
	"assault",
	"devestator",
	"reiver",
    "intercessor",
    "aggressor",
    "inceptor"
}

SKILL.desc = [[
You quickly regenerate a bit of health. - Idea by Minty

Regen: 200HP/s for 5 seconds.
Cost: 50 Energy
Cooldown: 60 Seconds
Ability Slot: 1


Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 300

local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamAOE" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamMelee") then return  end // nospamRanged, nospamUlt, nospamAOE, nospamMelee
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
		return
	end

	local pos = ply:GetPos()

	local mana = ply:getLocalVar("mana", 0)
		if mana < 50 then
			return
		end
	ply:setLocalVar("mana", mana - 50)

	local pos = ply:GetPos()

	if SERVER then

		timer.Create(ply:SteamID().."skill.LarramansOrgan", 0.25, 20, function()
			ply:SetHealth( math.Clamp( ply:Health() + (50), 0, ply:GetMaxHealth()))
			ParticleEffectAttach( "fantasy_heal", PATTACH_ABSORIGIN_FOLLOW, ply, 0 )
		end)

		if SERVER then
		
			ply:SetNWBool( "nospamMelee", true )

			net.Start( "MeleeActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
			net.Send( ply )

		end

		if timer.Exists(ply:SteamID().."nospamMelee") then return  end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)

	end
end


SKILL.ability = ability