SKILL.name = "Wall of Protection"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_holy_powerwordshield.png"
SKILL.category = "Followers of Sigmar"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
	"cultist_sigmar"
}

SKILL.desc = [[
A crackling shield of energy forms on the wizards left arm. It blocks any most magic and physical attacks.

Ability Slot: 1
Class Restriction: Celestial Wizard

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 30

local function ability(SKILL, ply )
   local nospam = ply:GetNWBool( "nospamUlt" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamUlt") then return  end
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
			
	local pos = ply:GetShootPos() + ply:GetAimVector() * 50
	local ang = ply:EyeAngles()
	
	local Positions = {}
	Positions[1] = pos
	Positions[2] = (pos - ply:GetRight()*50)
	Positions[3] = (pos + ply:GetRight()*50) 
	Positions[4] = (pos + ply:GetUp()*50) 
	Positions[5] = (pos + ply:GetRight()*25) + ply:GetUp()*50
	Positions[6] = (pos - ply:GetRight()*25) + ply:GetUp()*50
	Positions[7] = (pos - ply:GetRight()*25) - ply:GetUp()*50
	Positions[8] = (pos + ply:GetRight()*25) - ply:GetUp()*50
	Positions[9] = (pos - ply:GetUp()*50) 
	local Angles = {}
	Angles[1] = ang
	--Angles[2] = ang + Angle(0, 45, 0) 
	--Angles[3] = ang +Angle(0, 90, 0) 
	--Angles[4] = ang + Angle(0, 315, 0) 
	--Angles[5] = ang + Angle(0, 270, 0) 
	--Angles[6] = ang + Angle(0, 135, 0) 
	--Angles[7] = ang + Angle(0, 180, 0) 
	--Angles[8] = ang + Angle(0, 225, 0) 

	local i = 1

	for i = 1, 9 do
		

		ply:ViewPunch(Angle(-1, 0, -1))
				
		local shield = ents.Create("prop_physics")
		shield:SetCustomCollisionCheck(true)

		hook.Add("ShouldCollide", "warhammerfantasy_ceruleanShield_physhandler" .. shield:EntIndex(), function(ent1, ent2)
			if IsValid(shield) then
				if ent1 == shield then
					if ent2:IsWorld() then return false end
					--if ent2:IsPlayer() then return false end
					if (!ent2:IsNPC() or !ent2:IsPlayer()) then
						if ent2.DoesRadiusDamage then
							ent2.RadiusDamage = 0
						end
					end
					--sound.Play("weapons/physcannon/energy_bounce" .. math.random(1, 2) .. ".wav", ent2:GetPos(), 60, math.random(110, 150)) 
				end
			else
				hook.Remove("ShouldCollide", "warhammerfantasy_ceruleanShield_physhandler" .. shield:EntIndex())
			end
		end)

		shield:SetModel("models/hpwrewrite/misc/protego/protego.mdl")
		shield:SetPos(Positions[i])
		shield:SetAngles(Angles[1])
		shield:SetModelScale(1, 0)
		shield:SetMaterial("Models/effects/vol_light001")
		shield:SetNoDraw(false)
		shield.PROTEGO_SHIELD = true
		shield:Spawn()
		shield:GetPhysicsObject():EnableMotion(false)
		--shield:SetCollisionBounds( Vector(-300, 0, 0), Vector(300, 0, 300) )
		--shield:DropToFloor()

		if i == 1 then
			timer.Simple(0, function()
				sound.Play("ambient/levels/labs/electric_explosion5.wav", ply:GetPos(), 70, 240)
				ParticleEffectAttach("fantasy_sigmar_wall", PATTACH_ABSORIGIN_FOLLOW, shield, 1)
			end)
		end

		SafeRemoveEntityDelayed(shield, 10)
	end
	local plyPos, plyDir = ply:GetPos(), ply:GetAimVector()
	timer.Create("sigmarShieldFlame", 0.5, 20, function()
		local Ents = ents.FindInCone( plyPos, plyDir, 300, math.cos( math.rad( 60 ) ) )

		for k, v in pairs(Ents) do
			if v:IsNPC() or v:IsPlayer() then
				local damageTable = DamageInfo()
				damageTable:SetDamage( 75 + ply:getChar():getAttrib("fth") + ((25 * (char:getLevel()*char:getLevel()) / (char:getLevel()+char:getLevel()))) )
				damageTable:SetAttacker( ply )
				damageTable:SetDamageType( DMG_DISSOLVE )
				v:TakeDamageInfo(damageTable)
			end
		end
	end)


	if (SERVER) then
		ply:SetNWBool( "nospamUlt", true )

		net.Start( "UltActivated" )
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamUlt") then return  end
			timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
				ply:SetNWBool( "nospamUlt", false )
			end)

	end
end

SKILL.ability = ability