SKILL.name = "Sigmars Smite"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/spell_holy_excorcism_02.png"
SKILL.category = "Followers of Sigmar"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
	"cultist_sigmar"
}

SKILL.desc = [[
All allies are blessed by your courageous chants making increasing their movement speed and health regen

Duration: 10 Seconds.
Regen: 5 (+0.5 Faith)
Speed: 1.0 Faith
Range: 250 Units.
Cost: 60 Energy
Cooldown: 30 Seconds.
Class Restriction: 
Ability Slot: AOE (3)
Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[


]]


SKILL.coolDown = 15
local function ability(SKILL, ply )
   local nospam = ply:GetNWBool( "nospamRanged" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
		timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamRanged", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
	ply:setLocalVar("mana", mana - 20)
			
	local AbilityPos = ply:GetEyeTrace()

	if (AbilityPos.Entity:IsNPC() or AbilityPos.Entity:IsPlayer()) then
		if ply:GetPos():Distance( AbilityPos.Entity:GetPos() ) <= 500 then

			timer.Simple(0, function()
				if IsValid(ply) and IsValid(AbilityPos.Entity) then
					timer.Simple(0.5, function()
						AbilityPos.Entity:TakeDamage(500 + ply:getChar():getAttrib("fth") + (char:getAttrib("mgc") * 1) + ((25 * (char:getLevel()*char:getLevel()) / (char:getLevel()+char:getLevel()))), ply, ply)
						sound.Play("fx/spl/spl_shock_hit.wav", ply:GetPos(), 80, 100)
					end)

					ParticleEffect("fantasy_sigmar_smite", AbilityPos.HitPos, Angle(0,0,0), nil)
				end 
			end)
		end
	end
			
	if (SERVER) then
		ply:SetNWBool( "nospamRanged", true )
		print("Cdstart")

		net.Start( "RangedActivated" )
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
			timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
				ply:SetNWBool( "nospamRanged", false )
			end)
	end
end
SKILL.ability = ability