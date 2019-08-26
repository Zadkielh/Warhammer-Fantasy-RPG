SKILL.name = "Mortal Strike"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 1
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Ability_warrior_savageblow.png"
SKILL.category = "Warriors Path"

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "statestroop",
	"reaver"
}

SKILL.desc = [[
Empowers your next attack dealing high damage.
If used on a player it removes their natural health regen
for 10 seconds.

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
			

        

		if !(ply:GetNWBool("MortalStrike" )) then

			local char = ply:getChar()
			local naturalDamage = char:getData("naturalDamage",0)
			local str = char:getAttrib("str")
			local damage = naturalDamage + (str * 5) + 100 + ((25 * (char:getLevel()*char:getLevel()) / (char:getLevel()+char:getLevel())))
					
			char:setData("tempDamage", damage)

			timer.Simple(0, function()
				ParticleEffectAttach("fantasy_warrior_mortal_strike", PATTACH_POINT_FOLLOW, ply, 5)
			end)

			timer.Simple(10, function()

				if ( ply:GetNWBool("MortalStrike") ) then
					if SERVER then
						char:setData("tempDamage", math.max(0,naturalDamage))
						ply:SetNWBool("MortalStrike", false)
					end
				end
			end)
		end

		ply:SetNWBool("MortalStrike", true )

    

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