SKILL.name = "Flame Storm"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/spell_fire_selfdestruct.png"
SKILL.category = "Lore of Fire"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "bright_wizard"
}

SKILL.desc = [[
A column of roiling flame bursts from the battlefield, the roar of its creation almost drowning out the screams of its victims.

Ability Slot: 2
Class Restriction: Bright Wizard

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 2

local function ability(SKILL, ply )
   local nospam = ply:GetNWBool( "nospamRanged" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
		timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamRanged", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
	ply:setLocalVar("mana", mana - 20)
			
	local Ent = ents.Create("sent_zad_deathspasm")
		
	local OwnerPos = ply:GetShootPos()
	local OwnerAng = ply:GetAimVector():Angle()
	OwnerPos = OwnerPos + OwnerAng:Forward()*-20 + OwnerAng:Up()*-9 + OwnerAng:Right()*10
	if ply:IsPlayer() then Ent:SetPos(OwnerPos) end
	if ply:IsPlayer() then Ent:SetAngles(OwnerAng) else Ent:SetAngles(ply:GetAngles()) end

	local ent = nil 
	if ply:GetEyeTrace().Entity:IsPlayer() or ply:GetEyeTrace().Entity:IsNPC() then
		ent = ply:GetEyeTrace().Entity
	else
		local Ents = ents.FindInCone(ply:EyePos(), ply:GetAimVector(), 500, math.cos(math.rad(120)))
		for k, v in pairs(Ents) do
			if ((v:IsPlayer() and v != ply) or v:IsNPC()) then
				ent = v
			end
		end
	end


	Ent:SetOwner(ply)
	Ent:Spawn()
	Ent.InitialTarget = ent

	local phy = Ent:GetPhysicsObject()
	if phy:IsValid() then
		if ply:IsPlayer() then
			phy:ApplyForceCenter(ply:GetAimVector() * 10000)
		else
			phy:ApplyForceCenter(((ply:GetEnemy():GetPos()+ply:GetEnemy():OBBCenter()+ply:GetEnemy():GetUp()*-45) - ply:GetPos()+ply:OBBCenter()+ply:GetEnemy():GetUp()*-45) * 4000)
		end
	end
			
	if (SERVER) then
		ply:SetNWBool( "nospamRanged", true )
		print("Cdstart")

		net.Start( "RangedActivated" )
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
			timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
				ply:SetNWBool( "nospamRanged", false )
			end)

	end
end

SKILL.ability = ability