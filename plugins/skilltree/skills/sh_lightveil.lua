SKILL.name = "Infiltration"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_infiltrate.png"
SKILL.category = "Stealth"-- Common Passives, Warrior, Lore of Light, Dark Magic, Stealth

SKILL.slot = "MELEE" -- SLOT_ULT, SLOT_RANGED, SLOT_MELEE, SLOT_AOE
SKILL.class = {
    "tactical",
    "ist_specialist",
	"reiver"
}

SKILL.desc = [[
Temporarily stealths you.

Cost: No cost. 
Cooldown: 20 Seconds.
Class Restriction: Tactical, IST Specialist.
Ability Slot: 1
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]


SKILL.coolDown = 60
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamMelee" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamMelee") then return  end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
		return
	end
	local duration = 5

	if ply:getChar():hasSkill("infiltration_2") then
		duration = 10
	end
	if ply:getChar():hasSkill("infiltration_3") then
		duration = 20
	end
	local pos = ply:GetPos()

    local effectdata = EffectData()
    effectdata:SetOrigin( pos )
    --util.Effect( "timestop", effectdata ) 

    ply:SetNoDraw(true)
    ply:DrawShadow(false)

	ply:SetNoTarget(true)

    timer.Simple(duration, function()
        ply:SetNoDraw(false)
        ply:DrawShadow(true)
        ply:SetNoTarget(false)
        local pos = ply:GetPos()
        local effectdata = EffectData()
        effectdata:SetOrigin( pos )
        --util.Effect( "timestop", effectdata ) 
		if ply:getChar():hasSkill("infiltration_3") then
			local weapon = ply:GetActiveWeapon()
			local weaponTable = weapon:GetTable()
			local weaponBase = weaponTable.Base

			local DamageMod = weaponTable.Primary.Damage + ply:getChar():getAttrib("luck")
			weapon.trueDamage = weaponTable.Primary.Damage

			weaponTable.Primary.Damage = weaponTable.Primary.Damage + DamageMod
			weapon:ClearStatCache("Primary.Damage")
			timer.Simple(5, function()
				weaponTable.Primary.Damage = weapon.trueDamage
				weapon:ClearStatCache("Primary.Damage")
			end
			)
		end
		
    end)

	if (SERVER) then
	    ply:SetNWBool( "nospamMelee", true )
    	net.Start( "MeleeActivated" )
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamMelee") then return end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
	end
end

SKILL.ability = ability