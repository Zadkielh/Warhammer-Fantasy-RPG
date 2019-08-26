SKILL.name = "Rapid Fire"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_cyclone_missile_barrage.png"
SKILL.category = "Support"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "devestator",
}

SKILL.desc = [[
You enhance your weapon, increasing the fire rate and decreasing recoil.

Enhancement: 100 (+1.0 Luck) / 0.2 (+0.01 Luck)
Duration: 5 Seconds.
Cost: 40 Energy
Cooldown: 25 Seconds.
Class Restriction: Devastator
Ability Slot: 1
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]


SKILL.coolDown = 25
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

	local fireRate = 100 + ply:getChar():getAttrib("luck")
	local recoil = 0.5 + (ply:getChar():getAttrib("luck") / 150)

	local trueRecoil = weaponTable.Primary.KickUp
	local trueFireRate = weaponTable.Primary.RPM

	if weaponBase == "tfa_gun_base" then
        weaponTable.Primary.KickUp = math.max(weaponTable.Primary.KickUp - recoil,0)
		weaponTable.Primary.RPM = weaponTable.Primary.RPM + fireRate

		weapon:ClearStatCache("Primary.RPM")
		weapon:ClearStatCache("Primary.KickUp")
    end
	
	timer.Create("rapidFire"..(ply:SteamID()), 0.25, 4, function()
		ParticleEffectAttach( "omnissaiahs_blessing", PATTACH_ABSORIGIN_FOLLOW, ply, 0 )
	end)

	timer.Simple(5, function()
		if IsValid(weapon) then
			weaponTable.Primary.KickUp = trueRecoil
			weaponTable.Primary.RPM = trueFireRate
			
			weapon:ClearStatCache("Primary.RPM")
			weapon:ClearStatCache("Primary.KickUp")

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