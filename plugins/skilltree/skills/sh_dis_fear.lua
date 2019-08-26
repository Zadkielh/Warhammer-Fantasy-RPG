SKILL.name = "Fear"

SKILL.LevelReq = 2
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_power_fist_tank_shock.png"
SKILL.category = "Melee" -- Common Passives, Warrior

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaplain",
	"assault"
}
SKILL.desc = [[
This skill fears NPCs and slows players. Large NPCs cannot be feared.

Feartime: 2 Seconds
Slowamount: 100 Movement Speed for 2 Seconds.
Cost: No cost. 
Cooldown: 10 Seconds.
Class Restriction: Chaplain, Assault.
Ability Slot: 1
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]
SKILL.coolDown = 10
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamMelee" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamMelee") then return  end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
			print("ready")
		end)
		return
	end
			
	local pos = ply:GetPos()
	local ent = ply:GetEyeTraceNoCursor().Entity

	

	if (CLIENT) then
		if (ent:IsNPC() or ent:IsPlayer()) then
			if ply:GetPos():Distance( ent:GetPos() ) <= 250 then
				ParticleEffectAttach( "fantasy_warcry", PATTACH_POINT_FOLLOW, ent, 1 )
			end
		end
	end

	if (SERVER) then
		

		if (ent:IsNPC() or ent:IsPlayer()) then
			if ply:GetPos():Distance( ent:GetPos() ) <= 250 then

				ply:SetNWBool( "nospamMelee", true )
				print("Cdstart")

				net.Start( "MeleeActivated" )
				net.Send( ply )
				local runSpeed
				local walkSpeed

				if ent:IsPlayer() then
					runSpeed = ent:GetRunSpeed()
					walkSpeed = ent:GetWalkSpeed()
				end

					if (ent:IsPlayer()) then
						ent:SetRunSpeed(runSpeed - 100)
						ent:SetWalkSpeed(walkSpeed - 100)
					elseif (ent:IsNPC()) then
						ent:AddEntityRelationship( ply, D_FR, 99 )
					end

				timer.Create(ply:SteamID().."warcry", 2, 1, function()
					if ent:IsPlayer() then	
						ent:SetRunSpeed(runSpeed)
						ent:SetWalkSpeed(walkSpeed)
					elseif ent:IsNPC() then
						ent:AddEntityRelationship( ply, D_HT, 99 )
					end
				end)

				if timer.Exists(ply:SteamID().."nospamMelee") then return  end
				timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
					ply:SetNWBool( "nospamMelee", false )
					print("ready")
				end)
			end
		end

	end
end

SKILL.ability = ability