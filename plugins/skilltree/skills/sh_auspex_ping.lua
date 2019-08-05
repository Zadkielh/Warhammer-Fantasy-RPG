SKILL.name = "Auspex Ping"

SKILL.LevelReq = 15
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/auspex.png"
SKILL.category = "Tactical"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "tactical",
	"techmarine",
	"ist_specialist"
}

SKILL.desc = [[
An auspex ping is sent out, highlighting nearby living creatures. - Idea by Visserin.

Range: 500 Units.
Cost: 40 Energy
Cooldown: 60 Seconds.
Class Restriction: Tactical, Techmarine, IST Specialist
Ability Slot: 3
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]

SKILL.coolDown = 60
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamAOE" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamAOE") then return end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
		end)
		return
	end


	local mana = ply:getLocalVar("mana", 0)
		if mana < 40 then
			return
		end
	ply:setLocalVar("mana", mana - 40)

	net.Start("skills.Auspex")
	net.Send(ply)

	if (SERVER) then
	    ply:SetNWBool( "nospamAOE", true )
    	net.Start( "AOEActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamAOE") then return end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
		end)
	end
end
SKILL.ability = ability

if (SERVER) then
	util.AddNetworkString("skills.Auspex")
end

if (CLIENT) then
	net.Receive("skills.Auspex", function(ply, len)
		hook.Add( "PreDrawHalos", "skills.Auspex", function()
				local Enemies = {}
				local Allies = {}

				local EnemiesCount = 0
				local AlliesCount = 0

				for _, ent in ipairs( ents.FindInSphere(LocalPlayer():GetPos(), 2000) ) do
					if (ent != (LocalPlayer())) then
						if ( ent:IsNPC() ) then
							EnemiesCount = EnemiesCount + 1
							Enemies[ EnemiesCount ] = ent
						elseif (ent:IsPlayer()) then
							AlliesCount = AlliesCount + 1
							Allies[ AlliesCount ] = ent
						end
					end
				end

				if ( AlliesCount > 0 ) then
					halo.Add( Allies, Color( 0, 200, 0 ), 0, 0, 4, true, true )
				end

				if ( EnemiesCount > 0 ) then
					halo.Add( Enemies, Color( 255, 0, 0 ), 0, 0, 4, true, true )
				end
		end)

			timer.Simple(10, function()
				hook.Remove("PreDrawHalos", "skills.Auspex")
			end)
			
	end)
end