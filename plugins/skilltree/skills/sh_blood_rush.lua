SKILL.name = "Blood Rush"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_nature_shamanrage.png"
SKILL.category = "Path of Blood"

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaos_warrior",
    "reaver"
}
SKILL.desc = [[
You consume all of the blood in your bloodpool, aswell as half your current health, immensely boosting your physical capabilties.

Duration: 10 Seconds
Damage: + 0.5 per BP point
Speed: + 0.5 per BP point
Health: + 1 per BP point
Armorrating: + 100
Lifesteal: + 50%

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Chaos Warrior, Reaver
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

    local bloodPool = ply:getChar():getData("bloodpool", 0)
    local mana = ply:getLocalVar("mana", 0)
        if mana < bloodPool then
            return
        end
    ply:setLocalVar("mana", mana - bloodPool)
    ply:SetHealth(ply:Health() * 0.5)

    local char = ply:getChar()
        
    local targetChar = char
    
    local naturalDamage = targetChar:getData("naturalDamage",0)
    local damage = naturalDamage + (bloodPool * 0.5)
    
    local lifeSteal = targetChar:getData("lifeSteal",0)
    local health = bloodPool
    local MaxHealth = ply:getChar():getMaxHealth()

    local naturalArmorRating = targetChar:getData("naturalArmorRating",0)
    local armorrating = naturalArmorRating + 100
    
    local RunSpeed = ply:GetRunSpeed()
    local WalkSpeed = ply:GetWalkSpeed()
    ply:SetRunSpeed(RunSpeed + (bloodPool * 0.5) )
	ply:SetWalkSpeed(WalkSpeed + (bloodPool * 0.5) )
                
    targetChar:setData("naturalDamage", damage)
    targetChar:setData("lifeSteal", lifeSteal+50)
    targetChar:setData("naturalArmorRating", armorrating)

    ply:SetHealth(ply:Health() + health)
    ply:SetMaxHealth(ply:GetMaxHealth() + health)

    ply:SetMaterial("models/rendertarget")
                
    timer.Create("valiant_resolveParticle"..(ply:SteamID()), 0.25, 4, function()
        ParticleEffectAttach("fantasy_khorne_enhance_ultimate", PATTACH_POINT_FOLLOW, ply, 3)
    end)

    timer.Create("valiant_resolve"..(ply:SteamID()), 10, 1, function()
        if (targetChar) then
            
            targetChar:setData("naturalDamage", naturalDamage)
            targetChar:setData("lifeSteal", lifeSteal)
            targetChar:setData("naturalArmorRating", naturalArmorRating)

            ply:SetRunSpeed(ply:SetNWFloat("runSpeed") or 235 )
	        ply:SetWalkSpeed(ply:GetNWFloat("walkSpeed") or 130 )

            ply:SetHealth(ply:Health() - health)
            ply:SetMaxHealth(MaxHealth)

            ply:SetMaterial("")

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