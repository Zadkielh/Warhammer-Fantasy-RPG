SKILL.name = "Bolt of Light"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/holy_fire.png"
SKILL.category = "Psychic Powers"-- Common Passives, Warrior, Lore of Light

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "librarian"
}

SKILL.desc = [[
Shoots a circling bolt of light that damages first enemy hit.

Damage: 200(+2.0 Magic).
Cost: 20 Energy
Cooldown: 2 Seconds
Ability Slot: 2
Class Restriction: Librarian
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
			print("ready")
		end)
		return
	end

	local pos = ply:GetPos()

	if SERVER then

		
		local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
		ply:setLocalVar("mana", mana - 20)

		ply:SetNWBool( "nospamRanged", true )
		print("Cdstart")

		net.Start( "RangedActivated" )
		net.Send( ply )
			
		local Ent = ents.Create("obj_vj_lib_holysmite")
		
		local OwnerPos = ply:GetShootPos()
		local OwnerAng = ply:GetAimVector():Angle()
		OwnerPos = OwnerPos + OwnerAng:Forward()*-20 + OwnerAng:Up()*-9 + OwnerAng:Right()*10
		if ply:IsPlayer() then Ent:SetPos(OwnerPos) end
		if ply:IsPlayer() then Ent:SetAngles(OwnerAng) else Ent:SetAngles(ply:GetAngles()) end
		Ent:SetOwner(ply)
		
		
		Ent:Activate()
		Ent:Spawn()

		Ent.DirectDamage = 200 + (ply:getChar():getAttrib("mgc", 0) * 2)
		Ent.DirectType = DMG_BULLET
		Ent.CustomOnDoDamage = function(data,phys,hitent) end
		
		local phy = Ent:GetPhysicsObject()
		if phy:IsValid() then
			if ply:IsPlayer() then
				phy:ApplyForceCenter(ply:GetAimVector() * 60000)
			else
				phy:ApplyForceCenter(((ply:GetEnemy():GetPos()+ply:GetEnemy():OBBCenter()+ply:GetEnemy():GetUp()*-45) - ply:GetPos()+ply:OBBCenter()+ply:GetEnemy():GetUp()*-45) * 4000)
			end
		end
		
		

		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
		timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamRanged", false )
			print("ready")
		end)

	end
end
SKILL.ability = ability