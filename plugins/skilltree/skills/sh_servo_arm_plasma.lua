SKILL.name = "Plasma Blast"

SKILL.LevelReq = 15
SKILL.SkillPointCost = 4
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_overcharge.png"
SKILL.category = "Mechanicus"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "techmarine",
}

SKILL.desc = [[
You use one a plasmagun fitted on your servoarm and fire a bolt of plasma. - Idea by Cards

Cost: 50 Energy
Cooldown: 12 Seconds.
Class Restriction: Techmarine
Ability Slot: 2
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]


SKILL.coolDown = 12

local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamRanged" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
		timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamRanged", false )
		end)
		return
	end

	local pos = ply:GetPos()

	if SERVER then

		
		local mana = ply:getLocalVar("mana", 0)
		if mana < 50 then
			return
		end
		ply:setLocalVar("mana", mana - 50)

		ply:SetNWBool( "nospamRanged", true )

		net.Start( "RangedActivated" )
		net.Send( ply )
			
		local Ent = ents.Create("obj_vj_plasma_bolt")
		
		local OwnerPos = ply:GetShootPos()
		local OwnerAng = ply:GetAimVector():Angle()
		OwnerPos = OwnerPos + OwnerAng:Forward()*-20 + OwnerAng:Up()*-9 + OwnerAng:Right()*10
		if ply:IsPlayer() then Ent:SetPos(OwnerPos) end
		if ply:IsPlayer() then Ent:SetAngles(OwnerAng) else Ent:SetAngles(ply:GetAngles()) end
		Ent:SetOwner(ply)
		
		
		Ent:Activate()
		Ent:Spawn()
		
		local phy = Ent:GetPhysicsObject()
		if phy:IsValid() then
			if ply:IsPlayer() then
				phy:ApplyForceCenter(ply:GetAimVector() * 20000)
			else
				phy:ApplyForceCenter(((ply:GetEnemy():GetPos()+ply:GetEnemy():OBBCenter()+ply:GetEnemy():GetUp()*-45) - ply:GetPos()+ply:OBBCenter()+ply:GetEnemy():GetUp()*-45) * 4000)
			end
		end
		
		

		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
		timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamRanged", false )
		end)

	end
end
SKILL.ability = ability