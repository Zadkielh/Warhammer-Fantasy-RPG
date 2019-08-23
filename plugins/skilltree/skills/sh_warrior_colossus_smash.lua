SKILL.name = "Colossus Smash"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 1
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Ability_warrior_colossussmash.png"
SKILL.category = "Warriors Path"

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
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


SKILL.coolDown = 10
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamUlt") then return end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
		return
	end

        local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
		ply:setLocalVar("mana", mana - 20)
			

        

		if !(ply:GetNWBool("ColiSmash" )) then

			local char = ply:getChar()
			local naturalDamage = char:getData("naturalDamage",0)
			local str = char:getAttrib("str")
			local damage = naturalDamage + (str * 5) + 100
					
			char:setData("naturalDamage", damage)

			timer.Simple(0, function()
				ParticleEffectAttach("fantasy_warrior_colossus_smash", PATTACH_POINT_FOLLOW, ply, 5)
			end)

			timer.Simple(10, function()

				if (ply:GetNWBool("ColiSmash")) then
					char:setData("naturalDamage", naturalDamage)
					ply:SetNWBool("ColiSmash", false)
				end
			end)
		end

		ply:SetNWBool("ColiSmash", true )

    

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