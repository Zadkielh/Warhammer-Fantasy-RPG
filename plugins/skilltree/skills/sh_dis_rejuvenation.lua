SKILL.name = "Rejuvenation"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/spell_nature_rejuvenation.png"
SKILL.category = "Psychic Powers"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "librarian"
}

SKILL.desc = [[
This skill heals nearby targets.

Regen: 50HP/s(+1 Magic) for 10 seconds.
Cost: 50 Energy
Cooldown: 10 Seconds
Ability Slot: 3


Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 10

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

	local pos = ply:GetPos()

	local mana = ply:getLocalVar("mana", 0)
		if mana < 50 then
			return
		end
	ply:setLocalVar("mana", mana - 50)

	if SERVER then
		ply:SetNWBool( "nospamAOE", true )
		print("Cdstart")

		net.Start( "AOEActivated" )
		net.Send( ply )

	end

	
			
	local pos = ply:GetPos()

	if SERVER then
		local Entities = ents.FindInSphere( ply:GetPos(), 500 )

		timer.Create(ply:SteamID().."HealTest", 1, 5, function()
			local Entities = ents.FindInSphere( ply:GetPos(), 500 )
			
			for k, v in pairs(Entities) do
				if ((v:IsNPC() and v:Disposition( ply ) == D_LI) or v:IsPlayer()) then
					if (v:Health() != v:GetMaxHealth() ) then
						v:SetHealth( math.Clamp( v:Health() + (50 + (ply:getChar():getAttrib("mgc") * 1)), 0, v:GetMaxHealth()))
						ParticleEffectAttach( "fantasy_heal", PATTACH_ABSORIGIN_FOLLOW, v, 0 )
					end
				end
			end
		end)

		if timer.Exists(ply:SteamID().."nospamAOE") then return  end
		timer.Create(ply:SteamID().."nospamAOE", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamAOE", false )
			print("ready")
		end)

	end
end

SKILL.ability = ability