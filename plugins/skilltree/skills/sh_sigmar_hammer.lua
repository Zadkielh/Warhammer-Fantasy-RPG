SKILL.name = "Hammer of Sigmar"

SKILL.LevelReq = 2
SKILL.SkillPointCost = 1
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_holy_holysmite.png"
SKILL.category = "Followers of Sigmar"

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
	"cultist_sigmar"
}

SKILL.desc = [[
You implore Sigmar to imbue your weapon with a modicum of divine strength for your next attack.

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Statestroop, Cultist Sigmar
]]


SKILL.coolDown = 15
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamMelee" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamMelee") then return end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
		return
	end

        local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
		ply:setLocalVar("mana", mana - 20)
			

        

		if !(ply:GetNWBool("SigmarHammer" )) then

			local char = ply:getChar()
			local naturalDamage = char:getData("naturalDamage",0)
			local faith = char:getAttrib("fth")
			local damage = naturalDamage + (faith * 2) + 100
					
			char:setData("naturalDamage", damage)

			timer.Simple(0, function()
				ParticleEffectAttach("fantasy_sigmar_enhance_core", PATTACH_POINT_FOLLOW, ply, 5)
			end)

			timer.Simple(10, function()

				if (ply:GetNWBool("SigmarHammer")) then
					char:setData("naturalDamage", naturalDamage)
					ply:SetNWBool("SigmarHammer", false)
				end
			end)
		end

		ply:SetNWBool("SigmarHammer", true )

    

	if (SERVER) then
	    ply:SetNWBool( "nospamMelee", true )
    	net.Start( "MeleeActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamMelee") then return end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
	end
end
SKILL.ability = ability