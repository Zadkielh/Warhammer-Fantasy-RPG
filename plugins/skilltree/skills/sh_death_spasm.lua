SKILL.name = "Death Spasm"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_creature_cursed_03.png"
SKILL.category = "Dark Magic"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "asp_sorcerer"
}

SKILL.desc = [[
A bolt of darkness flies from the caster's fingertips to hit one individual. 
The spasms are so violent that they injure other around the target at half the target's strength.

Ability Slot: 2
Class Restriction: Sorcerer

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 15

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