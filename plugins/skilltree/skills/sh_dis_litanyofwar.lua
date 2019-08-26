SKILL.name = "Litany of War"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_paladin_shieldofvengeance.png"
SKILL.category = "Faith"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaplain",
}

SKILL.desc = [[
Any ally close to you will get the courage to fight on
even when fataly wounded.

Duration: 10 Seconds.
Range: 500 Units.
Cost: 100 Energy.
Cooldown: 60 Seconds.
Class Restriction: Chaplain
Ability Slot: 4
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]


SKILL.coolDown = 60
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" )
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamUlt") then return end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
		return
	end

    local mana = ply:getLocalVar("mana", 0)
		if mana < 100 then
			return
		end
	ply:setLocalVar("mana", mana - 100)

	hook.Add("EntityTakeDamage", "litanyOfWar"..ply:SteamID(), function(target, dmg)
        local Entities = ents.FindInSphere( ply:GetPos(), 500 )
        for k, v in pairs(Entities) do
            if ((v == target) and (v:IsPlayer() or (v:IsNPC() and v:Disposition( ply ) >= 3))) and dmg:GetDamage() >= target:Health() then
                dmg:SetDamage(0)
            end
        end
        if (target == ply) and dmg:GetDamage() >= target:Health() then
            dmg:SetDamage(0)
        end
    end)

    timer.Simple(10, function()
        hook.Remove("EntityTakeDamage", "litanyOfWar"..ply:SteamID())
    end)



	if (SERVER) then
	    ply:SetNWBool( "nospamUlt", true )
    	net.Start( "UltActivated" )
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamUlt") then return end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
	end
end
SKILL.ability = ability