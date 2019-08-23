SKILL.name = "Blood Sacrifice"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_warrior_focusedrage.png"
SKILL.category = "Path of Blood"

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaos_warrior",
    "reaver"
}
SKILL.desc = [[
This skill enables drains half your health in exchange for great power.
If you are a follower of Khorne, it will consume all your bloodpool instead.

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Chaos Warrior, Reaver
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

    if ply:getChar():hasTrait("khorne") then
        local bloodPool = ply:getChar():getData("bloodpool", 0)
        local mana = ply:getLocalVar("mana", 0)
            if mana < bloodPool then
                return
            end
        ply:setLocalVar("mana", mana - bloodPool)

        local char = ply:getChar()
        
        local targetChar = char
        local naturalDamage = targetChar:getData("naturalDamage",0)
        local damage = naturalDamage + (bloodPool * 0.5)
                
        targetChar:setData("naturalDamage", damage)
                
        timer.Simple(0, function()
            ParticleEffectAttach("fantasy_khorne_enhance_great", PATTACH_POINT_FOLLOW, ply, 3)
        end)

        timer.Create("blood_sacrifice"..(ply:SteamID()), 10, 1, function()
            if (targetChar) then
                targetChar:setData("naturalDamage", naturalDamage)
            end
                    
        end)
    
    else
        local health = ply:Health()
       
        ply:SetHealth(health * 0.5)

        local char = ply:getChar()
        
        local targetChar = char
        local naturalDamage = targetChar:getData("naturalDamage",0)
        local damage = naturalDamage + (health * 0.1)
                
        targetChar:setData("naturalDamage", damage)
                
        timer.Simple(0, function()
            ParticleEffectAttach("fantasy_khorne_enhance_great", PATTACH_POINT_FOLLOW, ply, 3)
        end)

        timer.Create("blood_sacrifice"..(ply:SteamID()), 10, 1, function()
            if (targetChar) then
                targetChar:setData("naturalDamage", naturalDamage)
            end
                    
        end)
    end

    

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