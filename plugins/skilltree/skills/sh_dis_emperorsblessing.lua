SKILL.name = "Emperors Blessing"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_sprint.png"
SKILL.category = "Faith"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaplain",
}

SKILL.desc = [[
All allies are blessed by your courageous chants making
them move faster and get back into the fight quicker.

Duration: 10 Seconds.
Range: 250 Units.
Cost: 60 Energy
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
		if mana < 60 then
			return
		end
	ply:setLocalVar("mana", mana - 60)

	local char = ply:getChar()

	local Entities = ents.FindInSphere( ply:GetPos(), 250 )
	for k, v in pairs(Entities) do
		if v:IsPlayer() or (v:IsPlayer() and v:IsBot()) then
			local RunSpeed = v:GetRunSpeed()
			local WalkSpeed = v:GetWalkSpeed()
			local regenHealth = (char:getAttrib("fth", 0) /2) + 5
			v:HealthRegeneration(regenHealth)
			v:SetRunSpeed(RunSpeed + char:getAttrib("fth", 0))
			v:SetWalkSpeed(WalkSpeed + char:getAttrib("fth", 0))
			
			timer.Create("emperorsblessing"..(v:SteamID() or v:Nick()), 0.25, 4, function()
				ParticleEffectAttach( "emperors_blessing", PATTACH_ABSORIGIN_FOLLOW, v, 0 )
			end)

			timer.Simple(10, function()
				v:HealthRegeneration(0)
				v:SetRunSpeed(RunSpeed)
				v:SetWalkSpeed(WalkSpeed)
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