SKILL.name = "Orbs of Larraman"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2r_ig_back_in_the_fight.png"
SKILL.category = "Medical"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "apothecary",
	"ist_medic",
}

SKILL.desc = [[
You throw an orb of larraman, rejuvenating any ally near the orb. - Inspired by Wikkyd.

Cost: 30 Energy.
Cooldown: 60 Seconds
Ability Slot: 2
Class Restriction: Apothecary, IST Medic. 

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 60

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

	local mana = ply:getLocalVar("mana", 0)
		if mana < 50 then
			return
		end
	ply:setLocalVar("mana", mana - 50)


	if SERVER then

		ply:SetNWBool( "nospamRanged", true )
		print("Cdstart")

		net.Start( "RangedActivated" )
		net.Send( ply )
			
		local Ent = ents.Create("obj_40k_grenade_larraman")
		
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
				phy:ApplyForceCenter(ply:GetAimVector() * 20000)
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