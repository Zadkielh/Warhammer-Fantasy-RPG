SKILL.name = "Bolstered Resolve"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_defend.png"
SKILL.category = "Followers of Sigmar"

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "statestroop",
}

SKILL.desc = [[
This bolsters your resolve, increasing your defences greatly.

Duration: 10 Seconds.
Range: 250 Units.
Cost: 60 Energy
Cooldown: 60 Seconds.
Class Restriction: Assault
Ability Slot: 3

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Statestroop
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
        
	local targetChar = char
    local naturalArmorRating = targetChar:getData("naturalArmorRating",0)
    local armorrating = naturalArmorRating + 200
            
    targetChar:setData("naturalArmorRating", armorrating)
			
    timer.Create("valiant_resolveParticle"..(ply:SteamID()), 0.25, 4, function()
		ParticleEffectAttach( "40k_assault_valiant", PATTACH_ABSORIGIN_FOLLOW, ply, 0 )
	end)

    timer.Create("valiant_resolve"..(ply:SteamID()), 10, 1, function()
        if (targetChar) then
			targetChar:setData("naturalArmorRating", naturalArmorRating)
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