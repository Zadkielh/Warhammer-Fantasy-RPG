SKILL.name = "Blessing of the Omnissiah"

SKILL.LevelReq = 15
SKILL.SkillPointCost = 4
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_blessing_omnissiah.png"
SKILL.category = "Mechanicus" -- Common Passives, Warrior

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "techmarine",
}
SKILL.desc = [[
You repair/supply a structure instantly to max.

Slowamount: 100 Movement Speed for 2 Seconds.
Cost: 70 Energy. 
Cooldown: 60 Seconds.
Class Restriction: Techmarine
Ability Slot: 1
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]
SKILL.coolDown = 60
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamMelee" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamMelee") then return  end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
		return
	end
			
	local pos = ply:GetPos()
	local ent = ply:GetEyeTraceNoCursor().Entity
	local isMechNPC = false

	if (SERVER) then

		local mana = ply:getLocalVar("mana", 0)
			if mana < 70 then
				return
			end
		ply:setLocalVar("mana", mana - 70)

		if ply:GetPos():Distance( ent:GetPos() ) <= 100 then
			ply:SetNWBool( "nospamMelee", true )

			net.Start( "MeleeActivated" )
			net.Send( ply )

			if (ent:IsNPC()) and (ent.VJ_NPC_Class) then
				for k, v in pairs(ent.VJ_NPC_Class)do
					if v == "CLASS_MECH" then
						isMechNPC = true
					end
				end

				if (isMechNPC) then
					ent:SetHealth(ent:GetMaxHealth())
				end

				timer.Create("repairAdvanced"..ent:EntIndex(), 0.25, 4, function()
					ParticleEffect("techmarine_bless_lightning", ent:GetPos()+ent:GetUp()*5, ent:GetAngles(), ent)
				end)
				
			end

			if (ent.Supplies) then
				ent.Supplies = 1500
			end
				
				


			if timer.Exists(ply:SteamID().."nospamMelee") then return  end
			timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
				ply:SetNWBool( "nospamMelee", false )
			end)
		end
	end
end

SKILL.ability = ability