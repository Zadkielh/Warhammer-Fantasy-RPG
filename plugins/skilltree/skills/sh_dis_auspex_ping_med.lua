SKILL.name = "Auspex Ping"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/auspex.png"
SKILL.category = "Medical"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "apothecary",
	"ist_medic"
}

SKILL.desc = [[
An auspex ping is sent out, highlighting nearby living players, healthy ones are green, injured are orange, severly injured are red.

Range: 500 Units.
Cost: 40 Energy
Cooldown: 60 Seconds.
Class Restriction: Apothecary, IST Medic.
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

	net.Start("skills.AuspexMed")
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
	util.AddNetworkString("skills.AuspexMed")
end

if (CLIENT) then
	net.Receive("skills.AuspexMed", function(ply, len)
		hook.Add( "PreDrawHalos", "skills.AuspexMed", function()
				local healthy = {}
				local injured = {}
				local severly = {}

				local healthycount = 0
				local injuredcount = 0
				local severlycount = 0

				for _, ply in ipairs( player.GetAll() ) do
					if ( ply:Health() >= (ply:GetMaxHealth() * 0.75) ) then
						healthycount = healthycount + 1
						healthy[ healthycount ] = ply
					elseif ( ply:Health() < (ply:GetMaxHealth() * 0.75) and ply:Health() > (ply:GetMaxHealth() * 0.3) ) then
						injuredcount = injuredcount + 1
						injured[ injuredcount ] = ply
					elseif ( ply:Health() <= (ply:GetMaxHealth() * 0.3) ) then
						severlycount = severlycount + 1
						severly[ severlycount ] = ply
					end
				end

				if ( healthycount > 0 ) then
					halo.Add( healthy, Color( 0, 200, 0 ), 0, 0, 2, true, true )
				end
				if ( injuredcount > 0 ) then
					halo.Add( injured, Color( 255, 255, 0 ), 0, 0, 2, true, true )
				end
				if ( severlycount > 0 ) then
					halo.Add( severly, Color( 255, 0, 0 ), 0, 0, 2, true, true )
				end
		end)

			timer.Simple(10, function()
				hook.Remove("PreDrawHalos", "skills.AuspexMed")
			end)
			
	end)
end