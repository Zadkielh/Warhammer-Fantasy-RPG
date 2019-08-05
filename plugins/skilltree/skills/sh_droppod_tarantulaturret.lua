SKILL.name = "Droppod - Tarantula"

SKILL.IconX = 1
SKILL.IconY = 1
SKILL.LevelReq = 15
SKILL.SkillPointCost = 4
SKILL.Incompatible = {

}

SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_tarantula_turret.png"
SKILL.category = "Mechanicus"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "techmarine",
}

SKILL.desc = [[
Calls in a drop pod that brings down a tarantula turret.
The turret has 5000 hp and fires bolter rounds.

Duartion: 60 Seconds
Cost: 100 Energy
Cooldown: 120 Seconds.
Class Restriction: Techmarine
Ability Slot: 4

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
]]


SKILL.coolDown = 120
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamUlt") then return end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 100 then
			return
		end
	ply:setLocalVar("mana", mana - 100)
			
		local Ent = ents.Create("sent_zad_droppod_tarantula")
		
		local OwnerPos = ply:GetPos()
		local OwnerAng = ply:GetAimVector():Angle()
		OwnerPos = OwnerPos + ply:GetForward()*5
		
		Ent:SetPos(OwnerPos)
		Ent:SetOwner(ply)
		Ent:Spawn()

		net.Start("dropPodComingDown")
			net.WriteEntity(ply)
			net.WriteVector(ply:GetPos())
		net.Broadcast()


	if (SERVER) then
	    ply:SetNWBool( "nospamUlt", true )
    	net.Start( "UltActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamUlt") then return end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
	end
end
SKILL.ability = ability