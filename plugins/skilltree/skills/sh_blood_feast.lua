SKILL.name = "Ravenous Carnivore"

SKILL.LevelReq = 5
SKILL.SkillPointCost = 2
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_racial_cannibalize.png"
SKILL.category = "Path of Blood"

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaos_warrior",
    "reaver"
}
SKILL.desc = [[
You take a quick bite at your enemy during your next attack, regaining 50% of the health you dealt.

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Chaos Warrior, Reaver
]]


SKILL.coolDown = 10
local function ability( SKILL, ply )
    local nospam = ply:GetNWBool( "nospamMelee" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then
		if timer.Exists(ply:SteamID().."nospamMelee") then return end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
		return
	end

        local bloodPool = ply:getChar():getData("bloodpool", 0)
        local mana = ply:getLocalVar("mana", 0)
            if mana < 60 then
                return
            end
        ply:setLocalVar("mana", mana - 60)

        

		if !(ply:GetNWBool("RavCarni" )) then
			local lifeSteal = ply:getChar():getData("lifeSteal", 0)
			ply:getChar():setData("lifeSteal", lifeSteal + 50)
		
			local bone = ply:LookupBone( "ValveBiped.Bip01_R_Hand" )
			local bonePos = ply:GetBonePosition(bone)

			timer.Simple(0, function()
				ParticleEffectAttach("fantasy_khorne_enhance_extra", PATTACH_POINT_FOLLOW, ply, 5)
			end)

			timer.Simple(10, function()

				if (ply:GetNWBool("RavCarni")) then
					print("Carni.Remove1")
					local lifeSteal = ply:getChar():getData("lifeSteal", 0)
					ply:getChar():setData("lifeSteal", math.max(lifeSteal -50))
					ply:SetNWBool("RavCarni", false)
				end
			end)
		end

		ply:SetNWBool("RavCarni", true )

    

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