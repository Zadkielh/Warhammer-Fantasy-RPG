SKILL.name = "Bladewind"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_warrior_bladestorm.png"
SKILL.category = "Dark Magic"

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "asp_sorcerer"
}

SKILL.desc = [[
A clutch of hungry swords sweep across the battlefield.

Cost: 100 Energy
Cooldown: 60 Seconds
Ability Slot: 3
Class Restriction: Aspiring Sorcerer

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

]]

SKILL.coolDown = 5

local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamAOE" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamAOE") then return  end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
	ply:setLocalVar("mana", mana - 20)
			
		local Ent = ents.Create("sent_zad_bladewind")
		
		local OwnerPos = ply:GetShootPos()
        local OwnerAng = ply:GetAimVector():Angle()
        OwnerPos = OwnerPos + OwnerAng:Forward()*-20 + OwnerAng:Up()*-9 + OwnerAng:Right()*10
        if ply:IsPlayer() then Ent:SetPos(OwnerPos) end
        if ply:IsPlayer() then Ent:SetAngles(OwnerAng) else Ent:SetAngles(ply:GetAngles()) end
		Ent:SetOwner(ply)
		Ent:Spawn()

	if SERVER then

		ply:SetNWBool( "nospamAOE", true )
		print("Cdstart")

		net.Start( "AOEActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )


		if timer.Exists(ply:SteamID().."nospamAOE") then return  end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false ) 
		end)

	end
end

SKILL.ability = ability