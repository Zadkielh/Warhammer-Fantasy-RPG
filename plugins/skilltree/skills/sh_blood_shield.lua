SKILL.name = "Shield of Blood"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_creature_cursed_04.png"
SKILL.category = "Path of Blood"

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaos_warrior",
    "reaver"
}
SKILL.desc = [[
You consume all of the blood in your bloodpool to create a anti-projectile aura around you.
Any projectile that enters the aura is immediatly dispelled.

Duration: 10 Seconds

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Chaos Warrior, Reaver
]]


SKILL.coolDown = 10
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamRanged" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamRanged") then return end
		timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamRanged", false )
		end)
		return
	end

    local bloodPool = ply:getChar():getData("bloodpool", 0)
    local mana = ply:getLocalVar("mana", 0)
        if mana < bloodPool then
            return
        end
    ply:setLocalVar("mana", mana - bloodPool)

    local char = ply:getChar()
        
    local targetChar = char

    ply:SetCustomCollisionCheck( true )

    hook.Add("ShouldCollide", "warhammerfantasy_bloodShield_physhandler" .. ply:SteamID(), function(ent1, ent2)
		if ( IsValid( ent1 ) and IsValid( ent2 ) ) then
            if ent1 == ply and !( ent2:IsNPC() or ent2:IsPlayer() ) and (ent2:GetVelocity() > 300)then
                local effectdata = EffectData()
                effectdata:SetOrigin( ent2:GetPos() )
                util.Effect( "cball_explode", effectdata )
                ent2:Remove()
                return false 
            end
        end
	    return true
	end)
    
    timer.Simple(10, function()
        ply:SetCustomCollisionCheck( false )
        hook.Remove("ShouldCollide", "warhammerfantasy_bloodShield_physhandler" .. ply:SteamID())
    end)


    timer.Create("valiant_resolveParticle"..(ply:SteamID()), 0.25, 4, function()
        ParticleEffectAttach( "40k_assault_valiant", PATTACH_ABSORIGIN_FOLLOW, ply, 0 )
    end)
    

	if (SERVER) then
	    ply:SetNWBool( "nospamRanged", true )
    	net.Start( "RangedActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamRanged") then return end
		timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamRanged", false )
		end)
	end
end
SKILL.ability = ability