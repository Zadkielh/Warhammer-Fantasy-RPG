SKILL.name = "Doombolt"

SKILL.IconX = 1
SKILL.IconY = 1
SKILL.LevelReq = 2
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}

SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/spell_fire_burnout.png"
SKILL.category = "Dark Magic"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "asp_sorcerer",
}

SKILL.desc = [[
The caster hurls a bolt of blazing black fire at his foe.

Cost: 20 Energy
Cooldown: 120 Seconds.
Class Restriction: Sorcerer
Ability Slot: 2

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
]]


SKILL.coolDown = 5
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamRanged" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamRanged") then return end
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
			
		local Ent = ents.Create("sent_zad_doombolt")
		
		local OwnerPos = ply:GetShootPos()
		local OwnerAng = ply:GetAimVector():Angle()
		OwnerPos = OwnerPos + OwnerAng:Forward()*-20 + OwnerAng:Up()*-9 + OwnerAng:Right()*10
		if ply:IsPlayer() then Ent:SetPos(OwnerPos) end
		if ply:IsPlayer() then Ent:SetAngles(OwnerAng) else Ent:SetAngles(ply:GetAngles()) end

		Ent:SetOwner(ply)
		Ent:Spawn()

		local phy = Ent:GetPhysicsObject()
		if phy:IsValid() then
			if ply:IsPlayer() then
				phy:ApplyForceCenter(ply:GetAimVector() * 40000)
			else
				phy:ApplyForceCenter(((ply:GetEnemy():GetPos()+ply:GetEnemy():OBBCenter()+ply:GetEnemy():GetUp()*-45) - ply:GetPos()+ply:OBBCenter()+ply:GetEnemy():GetUp()*-45) * 4000)
			end
		end


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