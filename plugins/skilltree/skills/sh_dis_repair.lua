SKILL.name = "Repair"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_repair_icon.png"
SKILL.category = "Mechanicus" -- Common Passives, Warrior

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "techmarine",
}
SKILL.desc = [[
You repair/supply a structure, healing it over time.

Feartime: 2 Seconds
Slowamount: 100 Movement Speed for 2 Seconds.
Cost: 50 Energy. 
Cooldown: 30 Seconds.
Class Restriction: Chaplain, Assault.
Ability Slot: 1
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]
SKILL.coolDown = 30
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
		
		if ply:GetPos():Distance( ent:GetPos() ) <= 100 then
			local mana = ply:getLocalVar("mana", 0)
			if mana < 50 then
				return
			end
			ply:setLocalVar("mana", mana - 50)

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
					timer.Create("repair"..ent:EntIndex(), 1, 30, function()
						
						if ent:Health() < ent:GetMaxHealth() then
							local hp = math.Clamp(ent:Health() + 100, 0, ent:GetMaxHealth())
							ent:SetHealth(hp)
							ParticleEffect("techmarine_blessed", ent:GetPos()+ent:GetUp()*5, ent:GetAngles(), ent)
						end
					end)
				end

			end

			if (ent.Supplies) then
				ent.Supplies = 500
			end

			if timer.Exists(ply:SteamID().."nospamMelee") then return  end
			timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
				ply:SetNWBool( "nospamMelee", false )
			end)
		end
	end
end

SKILL.ability = ability