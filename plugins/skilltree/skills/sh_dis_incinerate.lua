SKILL.name = "Incinerate"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/spell_fire_burnout.png"
SKILL.category = "Psychic Powers"-- Common Passives, Warrior, Lore of Light, Dark Magic

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "librarian"
}

SKILL.desc = [[
This skill burns targets.

Damage: 42(+4.0 Magic)/s.
Duration: 3 Seconds.
Cost: 70 Energy
Cooldown: 30 Seconds
Ability Slot: 3

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]
SKILL.coolDown = 30
local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamAOE" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamAOE") then return  end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
			print("ready")
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 70 then
			return
		end
	ply:setLocalVar("mana", mana - 70)

	local pos = ply:GetPos()

	if SERVER then
		ply:SetNWBool( "nospamAOE", true )
		print("Cdstart")

		net.Start( "UltActivated" )
		net.Send( ply )
		
	end
			
	local pos = ply:GetPos()

	
		

		timer.Create(ply:SteamID().."Incinerate", 0.25, 12, function()
			local Entities = ents.FindInSphere( ply:GetPos(), 500 )
			for k, v in pairs(Entities) do
				if ((v:IsNPC()) or (v:IsPlayer() and v != ply)) then
						v:TakeDamage( 42 + (ply:getChar():getAttrib("mgc", 0) * 1.0), ply, ply )
						ParticleEffectAttach( "fantasy_purple_flame", PATTACH_ABSORIGIN_FOLLOW, v, 0 )
						
				end
			end
		end)
	if SERVER then
		if timer.Exists(ply:SteamID().."nospamAOE") then return  end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
			print("ready")
		end)

	end
end

SKILL.ability = ability