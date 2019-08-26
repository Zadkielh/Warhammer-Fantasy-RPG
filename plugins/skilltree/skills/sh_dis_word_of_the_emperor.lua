SKILL.name = "Word of the Emperor"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2r_ig_impenetrable.png"
SKILL.category = "Faith"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaplain",
}

SKILL.desc = [[
Any ally close to you is completely immune to damage.
This ability is channeled and you are therefore completely immobile.
Any damage done to you will stop the ability.

Duration: Infinite.
Range: 500 Units.
Cost: 1 Energy per second
Cooldown: 120 Seconds.
Class Restriction: Chaplain
Ability Slot: 4
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]


SKILL.coolDown = 120
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" )
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamUlt") then return end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
		return
	end

	local RunSpeed = ply:getChar():GetRunSpeed()
	local WalkSpeed = ply:getChar():GetWalkSpeed()

    local mana = ply:getLocalVar("mana", 0)
		if mana < 1 then
			return
		end
	
	timer.Create("wordemperorMana"..ply:SteamID(), 1, 0, function()
		if mana < 1 then
			hook.Remove("EntityTakeDamage", "wordEmperor"..ply:SteamID())
			ply:Freeze(false)
			timer.Remove("wordemperorMana"..ply:SteamID())
		end
		ply:setLocalVar("mana", mana - 1)
	end
	)

	ply:Freeze(true)

	hook.Add("EntityTakeDamage", "wordEmperor"..ply:SteamID(), function(target, dmg)
		if (target == ply) then
			timer.Remove("wordemperorMana"..ply:SteamID())
			hook.Remove("EntityTakeDamage", "wordEmperor"..ply:SteamID())
			ply:Freeze(false)
		end
        local Entities = ents.FindInSphere( ply:GetPos(), 500 )
        for k, v in pairs(Entities) do
            if ((v == target) and (v:IsPlayer() or (v:IsNPC() and v:Disposition( ply ) >= 3))) then
                dmg:SetDamage(0)
				dmg:SetDamageForce(Vector(0, 0, 0))
            end
        end
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