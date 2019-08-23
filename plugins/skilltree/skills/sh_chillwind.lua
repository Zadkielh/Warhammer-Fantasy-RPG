SKILL.name = "Chillwind"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_hunter_glacialtrap.png"
SKILL.category = "Dark Magic"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "asp_sorcerer",
}

SKILL.desc = [[
The wizard assails the enemy with a freezing gale.

Range: 500 Units.
Cost: 100 Energy
Cooldown: 60 Seconds.
Class Restriction: Aspiring Sorcerer
Ability Slot: 4
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]

SKILL.coolDown = 30

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
			
		local Ent = ents.Create("sent_zad_chillwind")
		
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