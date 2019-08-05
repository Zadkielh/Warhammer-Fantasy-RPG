SKILL.name = "Firestorm"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_explosive_cannon_barrage.png"
SKILL.category = "Primaris"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "aggressor",
}
SKILL.toggle = false

SKILL.desc = [[
A toggle ability, you have increased Fire Rate and Accuracy though you're locked immobile. - Inspired by Sgtteddybear

Class Restriction: Aggressor
Ability Slot: 1
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]
SKILL.coolDown = 1
local function ability( SKILL, ply )

    local nospam = ply:GetNWBool( "nospamMelee" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	local active = ply:GetNWBool( "meleeActive") // meleeActive, rangedActive, aoeActive, ultActive

	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamMelee") then return end 
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
		return
	end

	local RunSpeed = ply:GetNWFloat("runSpeed")
	local WalkSpeed = ply:GetNWFloat("walkSpeed")

	local weapon = ply:GetActiveWeapon()
	local weaponTable = weapon:GetTable()
	local weaponBase = weaponTable.Base

	local fireRate = 100
	local recoil = 0.5

		if !(active) then
			if weaponBase == "tfa_gun_base" and (weapon) then

				weapon.trueRecoil = weaponTable.Primary.KickUp
				weapon.trueFireRate = weaponTable.Primary.RPM

				weaponTable.Primary.RPM = weaponTable.Primary.RPM + fireRate
				weaponTable.Primary.KickUp = math.max(weaponTable.Primary.KickUp - recoil,0)

				weapon:ClearStatCache("Primary.RPM")
				weapon:ClearStatCache("Primary.KickUp")

				ply:SetRunSpeed(1)
				ply:SetWalkSpeed(1)

				ply:SetNWBool( "meleeActive", true )
				SKILL.toggle = true
			end
		else
			if weaponBase == "tfa_gun_base" and (weapon) then
				weaponTable.Primary.RPM = weapon.trueFireRate
				weaponTable.Primary.KickUp = weapon.trueRecoil

				weapon:ClearStatCache("Primary.RPM")
				weapon:ClearStatCache("Primary.KickUp")

				ply:SetRunSpeed(RunSpeed)
				ply:SetWalkSpeed(WalkSpeed)

				ply:SetNWBool( "meleeActive", false )
				SKILL.toggle = false
			end
		end

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