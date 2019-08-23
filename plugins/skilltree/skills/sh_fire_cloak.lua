SKILL.name = "Fire Shield"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_mage_moltenarmor.png"
SKILL.category = "Lore of Fire"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "bright_wizard"
}

SKILL.desc = [[
A shield of flame appears around the wizard, scorching nearby foes. Any projectiles hitting the shield are blocked.

Ability Slot: 1
Class Restriction: Bright Wizard

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 30

local function ability(SKILL, ply )
   local nospam = ply:GetNWBool( "nospamMelee" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamMelee") then return  end
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
			
	local pos = ply:GetShootPos() + ply:GetAimVector() * 50
	local ang = ply:EyeAngles()
	
	timer.Simple(0, function()
		ParticleEffect("fantasy_fire_barrage", pos, ang)
	end)

	sound.Play("ambient/levels/labs/electric_explosion5.wav", ply:GetPos(), 70, 240)

	ply:ViewPunch(Angle(-1, 0, -1))

	SafeRemoveEntity(SKILL.Shield)
			
	local shield = ents.Create("prop_physics")
	shield:SetCustomCollisionCheck(true)

	hook.Add("ShouldCollide", "warhammerfantasy_fire_cloak_physhandler" .. shield:EntIndex(), function(ent1, ent2)
		if IsValid(shield) then
			if ent1 == shield then
				if ent2:IsWorld() then return false end
				if ent2:IsPlayer() then return false end

				sound.Play("weapons/physcannon/energy_bounce" .. math.random(1, 2) .. ".wav", ent2:GetPos(), 60, math.random(110, 150)) 
			end
		else
			hook.Remove("ShouldCollide", "warhammerfantasy_fire_cloak_physhandler" .. shield:EntIndex())
		end
	end)

	shield:SetModel("models/hpwrewrite/misc/protego/protego.mdl")
	shield:SetPos(pos)
	shield:SetAngles(ang)
	shield:SetNoDraw(true)
	shield.PROTEGO_SHIELD = true
	shield:Spawn()
	shield:GetPhysicsObject():EnableMotion(false)

	SKILL.Shield = shield

	SafeRemoveEntityDelayed(shield, 2)

	if (SERVER) then
		ply:SetNWBool( "nospamMelee", true )

		net.Start( "MeleeActivated" )
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamMelee") then return  end
			timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
				ply:SetNWBool( "nospamMelee", false )
			end)

	end
end

SKILL.ability = ability