SKILL.name = "Sigmars Call"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_holy_chastise.png"
SKILL.category = "Followers of Sigmar"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
	"cultist_sigmar"
}

SKILL.desc = [[
With words of passion and fury grant yourself and those around you a speed boost.

Duration: 10 Seconds.
Regen: 5 (+0.5 Faith)
Speed: 1.0 Faith
Range: 250 Units.
Cost: 60 Energy
Cooldown: 30 Seconds.
Class Restriction: 
Ability Slot: AOE (3)
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
			v:SetRunSpeed(RunSpeed + char:getAttrib("fth", 0) + 50)
			v:SetWalkSpeed(WalkSpeed + char:getAttrib("fth", 0) + 50)
			
			timer.Create("emperorsblessing"..(v:SteamID() or v:Nick()), 0.25, 4, function()
				ParticleEffectAttach( "emperors_blessing", PATTACH_ABSORIGIN_FOLLOW, v, 0 )
			end)

			timer.Simple(10, function()
				v:SetRunSpeed(v:SetNWFloat("runSpeed") or 235 )
	        	v:SetWalkSpeed(v:GetNWFloat("walkSpeed") or 130 )
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