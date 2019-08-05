SKILL.name = "Omnissiahs Blessing"

SKILL.IconX = 1
SKILL.IconY = 1
SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}

SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_larramans_blessing.png"
SKILL.category = "Mechanicus"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "techmarine",
}

SKILL.desc = [[
The Omnissiah blesses your allies, removing any cooldowns for non-ultimate abilites.

Range: 250 Units.
Cost: 60 Energy
Cooldown: 50 Seconds.
Class Restriction: Techmarine
Ability Slot: 3

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

]]


SKILL.coolDown = 50
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
		if mana < 60 then
			return
		end
	ply:setLocalVar("mana", mana - 60)

	local char = ply:getChar()

	local Entities = ents.FindInSphere( ply:GetPos(), 250 )
	for k, v in pairs(Entities) do
		if v:IsPlayer() and v != ply then
			if timer.Exists(v:SteamID().."nospamAOE")  then
                timer.Remove(v:SteamID().."nospamAOE")
            end
            if timer.Exists(v:SteamID().."nospamRanged") then
                timer.Remove(v:SteamID().."nospamRanged")
            end
            if  timer.Exists(v:SteamID().."nospamMelee") then
                timer.Remove(v:SteamID().."nospamMelee")
            end
			
			timer.Create("Omnissaiahsblessing"..(v:SteamID() or v:Nick()), 0.25, 4, function()
				ParticleEffectAttach( "omnissaiahs_blessing", PATTACH_ABSORIGIN_FOLLOW, v, 0 )
			end)

		end
	end


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