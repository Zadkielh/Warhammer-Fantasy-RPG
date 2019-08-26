SKILL.name = "Kraken Rounds"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_kraken_bolts.png"
SKILL.category = "Support"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "devestator",
	"aggressor"
}

SKILL.desc = [[
You replace a limited amount of your bullets with kraken rounds.
Dealing more damage but firing slower.

Duration: 60 Seconds.
Cost: 100 Energy.
Cooldown: 45 Seconds.
Class Restriction: Devastator
Ability Slot: 1
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]


SKILL.coolDown = 120
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamUlt") then return end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
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
	local damage = 200 + ply:getChar():getAttrib("luck")
	local fireRate = 200

	local trueFireRate = weaponTable.Primary.RPM
	local trueDamage = weaponTable.Primary.Damage

	if weaponBase == "tfa_gun_base" then
        weaponTable.Primary.Damage = weaponTable.Primary.Damage + damage
		weaponTable.Primary.RPM = weaponTable.Primary.RPM - fireRate
		weapon:ClearStatCache("Primary.RPM")
    end
	
	timer.Create("krakenRounds"..(ply:SteamID()), 1, 60, function()
		ParticleEffectAttach( "omnissaiahs_blessing", PATTACH_ABSORIGIN_FOLLOW, ply, 0 )
	end)

	timer.Simple(60, function()
		if IsValid(weapon) then
			weaponTable.Primary.Damage = trueDamage
			weaponTable.Primary.RPM = trueFireRate
			weapon:ClearStatCache("Primary.RPM")

			ply:SetNWBool("hasWeaponSteroid", false)
		end
		
	end)



	if (SERVER) then
	    ply:SetNWBool( "nospamUlt", true )
    	net.Start( "UltActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamUlt") then return end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
	end
end
SKILL.ability = ability