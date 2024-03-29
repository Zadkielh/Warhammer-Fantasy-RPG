SKILL.name = "Blood Drain"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 2
SKILL.Incompatible = {
}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_warlock_backdraft.png"
SKILL.category = "Path of Blood"

SKILL.slot = "AOE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "chaos_warrior",
    "reaver"
}
SKILL.desc = [[
Drains nearby foes, filling your bloodpool.

Damage: 50 + (2.0 FTH + 1.0 Str)
Blood: DMG/3

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Chaos Warrior, Reaver
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

    local bloodPool = ply:getChar():getData("bloodpool", 0)
    local mana = ply:getLocalVar("mana", 0)
        
    if mana < 100 then
       ply:TakeDamage(100, ply, ply)
    end
    ply:setLocalVar("mana", mana - 100)

    local char = ply:getChar()
        
    local targetChar = char
    local naturalDamage = targetChar:getData("naturalDamage",0)
    local damage = naturalDamage + (bloodPool * 0.5)

    local Entities = ents.FindInSphere( ply:GetPos(), 500 )

    for k, v in pairs(Entities) do
		if ((v:IsNPC() and v:Disposition( ply ) == D_HT) or v:IsPlayer() and !(v:Team() == ply:Team())) then
			if !(v == ply)  then 
				timer.Create("bloodDrain"..v:EntIndex(), 0.25, 10, function()
					if IsValid(v) then
						v:TakeDamage(10 + (targetChar:getAttrib("str") + (targetChar:getAttrib("fth") *2)) , ply, ply)
					end
				end)
				timer.Simple(0.1, function()
					ParticleEffectAttach( "fantasy_khorne_blood", PATTACH_POINT_FOLLOW, v, 3 )
				end)
			end
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