SKILL.name = "Sigmars Blessing"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_holy_surgeoflight.png"
SKILL.category = "Followers of Sigmar"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
	"cultist_sigmar"
}

SKILL.desc = [[
You call upon Sigmar to bless your allies with a portion of his divinity, bolstering them in combat.

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


SKILL.coolDown = 10
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
			local regenHealth = (char:getAttrib("fth", 0) /2) + 20
			local maxHealth = v:GetMaxHealth()
			
			local naturalMaxHP = char:getData("naturalHPMax", 0)
			char:setData("naturalHPMax", naturalMaxHP + (maxHealth * 0.2))
			v:SetHealth(v:Health() + (v:Health() * 0.2))
			v:HealthRegeneration(regenHealth)
			
			
			
			timer.Create("emperorsblessing"..(v:SteamID() or v:Nick()), 0.25, 4, function()
				ParticleEffectAttach("fantasy_sigmar_enhance_great", PATTACH_POINT_FOLLOW, ply, 3)
			end)

			timer.Simple(10, function()
				char:setData("naturalHPMax", naturalMaxHP)
				v:SetHealth(maxHealth)
				v:HealthRegeneration(0)
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