SKILL.name = "Cleave"

SKILL.LevelReq = 2
SKILL.SkillPointCost = 1
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Ability_warrior_cleave.png"
SKILL.category = "Warriors Path"

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "statestroop",
	"reaver"
}

SKILL.desc = [[
Empowers your next attack.

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Statestroop, Reaver
]]


SKILL.coolDown = 20
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamMelee" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamMelee") then return end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
		return
	end

        local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
		ply:setLocalVar("mana", mana - 20)
			

        

		if !(ply:GetNWBool("WarriorCleave" )) then

			local char = ply:getChar()
			local naturalDamage = char:getData("naturalDamage",0)
			local str = char:getAttrib("str")
			local damage = naturalDamage + (str * 2) + 100
					
			char:setData("naturalDamage", damage)

			timer.Simple(0, function()
				ParticleEffectAttach("fantasy_warrior_enhance_core", PATTACH_POINT_FOLLOW, ply, 5)
			end)

			timer.Simple(10, function()

				if (ply:GetNWBool("WarriorCleave")) then
					char:setData("naturalDamage", naturalDamage)
					ply:SetNWBool("WarriorCleave", false)
				end
			end)
		end

		ply:SetNWBool("WarriorCleave", true )

    

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