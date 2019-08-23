SKILL.name = "Taunt"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 1
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_nature_reincarnation.png"
SKILL.category = "Warriors Path"

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "statestroop",
	"reaver"
}

SKILL.desc = [[
Taunts NPCs around you.

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Statestroop, Reaver
]]


SKILL.coolDown = 30
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
		if mana < 20 then
			return
		end
		ply:setLocalVar("mana", mana - 20)
		if (SERVER) then
			local Entities = ents.FindInSphere(ply:GetPos(), 500)
			for k, v in pairs(Entities) do
				if v:IsNPC() and v:Disposition(ply) != D_LI then
					v:SetEnemy( ply, true )
					v:UpdateEnemyMemory( ply, ply:GetPos() )
				end
			end
		end

		timer.Simple(0, function()
				ParticleEffectAttach("fantasy_warrior_taunt", PATTACH_POINT_FOLLOW, ply, 0)
		end)

    

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