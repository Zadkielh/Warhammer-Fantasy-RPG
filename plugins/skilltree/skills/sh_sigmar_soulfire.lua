SKILL.name = "Soulfire"

SKILL.LevelReq = 3
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_shadow_shadowwordpain.png"
SKILL.category = "Followers of Sigmar"-- Common Passives, Warrior, Stealth, Lore of Light, Dark Magic

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
	"cultist_sigmar"
}

SKILL.desc = [[
You burn the targets soul with divine power.

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


SKILL.coolDown = 5
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

			sound.Play("fx/spl/spl_mysticism_cast.wav", ply:GetPos(), 80, 100)

			timer.Simple(0, function()
				if IsValid(ply) and IsValid(AbilityPos.Entity) then
					timer.Simple(1.8, function()
						AbilityPos.Entity:TakeDamage(50 + (ply:getChar():getAttrib("fth") * 5) + ((25 * (char:getLevel()*char:getLevel()) / (char:getLevel()+char:getLevel()))), ply, ply)
						sound.Play("fx/spl/spl_mysticism_hit.wav", AbilityPos.HitPos, 80, 100)
					end)

					ParticleEffectAttach("fantasy_sigmar_soulfire", PATTACH_POINT_FOLLOW, AbilityPos.Entity, 0)
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