SKILL.name = "Merciless Assault"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_powerful_sweep.png"
SKILL.category = "Melee"

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "assault",
}

SKILL.desc = [[
You quickly dash forward, dealing damage to anyone you pass through.

Damage: 200 (+5.0 Strength)
Range: 100 Units.
Cost: 70 Energy
Cooldown: 30 Seconds.
Class Restriction: Assault
Ability Slot: 1

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Assault
]]

SKILL.coolDown = 30
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
		if mana < 70 then
			return
		end
	ply:setLocalVar("mana", mana - 70)

	local char = ply:getChar()

    local aim = ply:GetAimVector()
    
    timer.Create("mercilessAssault"..ply:SteamID(), 0.01, 10, function()
        local ent = ents.FindInSphere(ply:GetPos(), 200)
        for k, v in pairs(ent) do
            if (v:IsNPC() or (v:IsPlayer() and v != ply)) then
                local CollisionGroup = v:GetCollisionGroup()
                v:SetCollisionGroup( COLLISION_GROUP_WORLD  )
                timer.Simple(0.5, function()
                    if (v) then
                        v:SetCollisionGroup( CollisionGroup )
                    end
                end)
            end
        end
        
        local ent = ents.FindInSphere(ply:GetPos(), 100)
        for k, v in pairs(ent) do
            if (v:IsNPC() or (v:IsPlayer() and v != ply)) then
                v:TakeDamage( 42 + (ply:getChar():getAttrib("str", 0) * 5.0), ply, ply )
            end
        end
        
    end)

	ply:SetVelocity( aim * 5000 + Vector(0, 0, -5000))
    timer.Simple(0.05, function()
        ply:SetVelocity( aim * 2500 + Vector(0, 0, -5000))
    end)

    timer.Simple(0.2, function()
        ply:SetVelocity( Vector(0, 0, -1000))
    end)

    timer.Simple(0.5, function()
        ply:SetCollisionGroup( COLLISION_GROUP_PLAYER )
    end)

    
    

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