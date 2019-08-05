SKILL.name = "Rally"

SKILL.LevelReq = 2
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_rally.png"
SKILL.category = "Faith"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaplain",
}

SKILL.desc = [[
All allies are blessed by your holy chants, making them stronger in battle.

Duration: 10 Seconds.
Range: 250 Units.
Cost: 40 Energy
Cooldown: 30 Seconds.
Class Restriction: Chaplain
Ability Slot: 3
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]


SKILL.coolDown = 30
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
		if mana < 40 then
			return
		end
	ply:setLocalVar("mana", mana - 40)

	local char = ply:getChar()

	local Entities = ents.FindInSphere( ply:GetPos(), 250 )
	for k, v in pairs(Entities) do
		if v:IsPlayer() then		
			timer.Create("emperorsblessing"..(v:SteamID() or v:Nick()), 0.25, 4, function()
				ParticleEffectAttach( "emperors_blessing", PATTACH_ABSORIGIN_FOLLOW, v, 0 )
			end)
			local naturalDamage = v:getChar():getData("naturalDamage",0)
			local damage = naturalDamage + (char:getAttrib("fth") * 2) 
			v:getChar():setData("naturalDamage", damage)
			timer.Simple(10, function()
				v:getChar():setData("naturalDamage", naturalDamage)
			end)
		end
	end

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