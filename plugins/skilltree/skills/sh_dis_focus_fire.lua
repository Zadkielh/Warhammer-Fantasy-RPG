SKILL.name = "Focus Fire"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_focused_fire.png"
SKILL.category = "Support"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "devestator",
}

SKILL.desc = [[
You ready your weapon, drastically increasing firerate but moving incredibly slow.

Duration: 5 Seconds.
Cost: 50 Energy.
Cooldown: 30 Seconds.
Class Restriction: Devastator
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

	if (ply:GetNWBool("hasWeaponSteroid")) then return end

    local mana = ply:getLocalVar("mana", 0)
		if mana < 50 then
			return
		end
	ply:setLocalVar("mana", mana - 50)
	
	ply:SetNWBool("hasWeaponSteroid", true)

	local weapon = ply:GetActiveWeapon()
	local weaponTable = weapon:GetTable()
	local weaponBase = weaponTable.Base

	local fireRate = 300 + ply:getChar():getAttrib("luck")

	local trueMoveSpeed = weaponTable.MoveSpeed
	local trueFireRate = weaponTable.Primary.RPM

	if weaponBase == "tfa_gun_base" then
		weaponTable.Primary.RPM = weaponTable.Primary.RPM + fireRate
		weaponTable.MoveSpeed = 0

		weapon:ClearStatCache("Primary.RPM")
		weapon:ClearStatCache("MoveSpeed")
    end
	
	timer.Create("rapidFire"..(ply:SteamID()), 0.25, 4, function()
		ParticleEffectAttach( "omnissaiahs_blessing", PATTACH_ABSORIGIN_FOLLOW, ply, 0 )
	end)

	timer.Simple(5, function()
		if IsValid(weapon) then
			weaponTable.Primary.RPM = trueFireRate
			weaponTable.MoveSpeed = trueMoveSpeed
			
			weapon:ClearStatCache("Primary.RPM")
			weapon:ClearStatCache("MoveSpeed")

			ply:SetNWBool("hasWeaponSteroid", false)
		end
		
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