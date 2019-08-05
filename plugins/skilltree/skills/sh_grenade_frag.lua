SKILL.name = "Frag Grenade"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_frag_grenade.png"
SKILL.category = "Tactical"-- Common Passives, Warrior, Lore of Light

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "apothecary",
	"assault",
	"chaplain",
	"devestator",
	"ist_cqc",
	"ist_heavy",
	"ist_marksman",
	"ist_medic",
	"ist_specialist",
	"tactical",
	"techmarine",
	"inceptor",
	"intercessor",
	"aggressor",
	"reiver"
}

SKILL.desc = [[
You throw a frag grenade. The grenade has a large blast radius and is great
against poorly armoured targets.

Damage: 300 at center.
Blast: 400
Cost: 25 Stamina
Cooldown: 45 Seconds
Ability Slot: 2
Class Restriction: None.
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

]]
SKILL.coolDown = 45

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
		
		local stm = ply:getLocalVar("stm", 0)
		if stm < 25 then
			return
		end
		ply:setLocalVar("stm", stm - 25)

		ply:SetNWBool( "nospamRanged", true )
		print("Cdstart")

		net.Start( "RangedActivated" )
		net.Send( ply )
			
		local Ent = ents.Create("obj_40k_grenade_frag")
		
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
				phy:ApplyForceCenter(ply:GetAimVector() * 75000)
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