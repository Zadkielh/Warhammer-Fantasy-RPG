SKILL.name = "Meltabomb"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_melta_bomb.png"
SKILL.category = "Support"

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "assault",
	"inceptor",
	"ist_specialist"
}

SKILL.desc = [[
You place down a meltabomb, priming it.
It will blow up 5 seconds after being planted.


Blast: 5000 Damage
Radius: 500 Units

Cost: 50 Energy
Cooldown: 60 Seconds
Ability Slot: 3

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Assault, Inceptor, IST Specialist
]]


SKILL.coolDown = 10

local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamAOE" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamAOE") then return  end // nospamRanged, nospamUlt, nospamAOE, nospamMelee
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
		end)
		return
	end

	local pos = ply:GetPos()

	if SERVER then
		
		local stm = ply:getLocalVar("mana", 0)
		if stm < 50 then
			return
		end
		ply:setLocalVar("mana", stm - 50)

		ply:SetNWBool( "nospamAOE", true )

		net.Start( "AOEActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )

			
		local Ent = ents.Create("obj_40k_melta_bomb")
		
		local OwnerPos = ply:GetShootPos()
		local OwnerAng = ply:GetAimVector():Angle()
		OwnerPos = OwnerPos + OwnerAng:Forward()*100 + OwnerAng:Up()*-20 + OwnerAng:Right()*10
		if ply:IsPlayer() then Ent:SetPos(OwnerPos) end
		if ply:IsPlayer() then Ent:SetAngles(OwnerAng) else Ent:SetAngles(ply:GetAngles()) end
		Ent:SetOwner(ply)
		
		
		Ent:Activate()
		Ent:Spawn()

		local phy = Ent:GetPhysicsObject()

		if timer.Exists(ply:SteamID().."nospamAOE") then return  end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
		end)

	end
end
SKILL.ability = ability