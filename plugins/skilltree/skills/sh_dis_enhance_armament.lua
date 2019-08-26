SKILL.name = "Enhance Armament"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_brothers_in_arms.png"
SKILL.category = "Support"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "devestator",
}

SKILL.desc = [[
You enhance your weapon, increasing the damage output and firing speed for 10 Seconds.

Enhancement: 100 (+1.0 Luck)
Duration: 10 Seconds.
Cost: 60 Energy
Cooldown: 45 Seconds.
Class Restriction: Devastator
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

	if (ply:GetNWBool("hasWeaponSteroid")) then return end

    local mana = ply:getLocalVar("mana", 0)
		if mana < 60 then
			return
		end
	ply:setLocalVar("mana", mana - 60)

	ply:SetNWBool("hasWeaponSteroid", true)

	local weapon = ply:GetActiveWeapon()
	local weaponTable = weapon:GetTable()
	local weaponBase = weaponTable.Base
	local damage = 100 + ply:getChar():getAttrib("luck")

	if weaponBase == "tfa_gun_base" then
        weaponTable.Primary.Damage = weaponTable.Primary.Damage + damage
    end
	
	timer.Create("enhanceArmament"..(ply:SteamID()), 0.25, 8, function()
		ParticleEffectAttach( "omnissaiahs_blessing", PATTACH_ABSORIGIN_FOLLOW, ply, 0 )
	end)

	timer.Simple(10, function()
		if IsValid(weapon) then
			weaponTable.Primary.Damage = weaponTable.Primary.Damage - damage

			ply:SetNWBool("hasWeaponSteroid", false)
		end
		
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