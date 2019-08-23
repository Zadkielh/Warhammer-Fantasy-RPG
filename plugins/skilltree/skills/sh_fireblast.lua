SKILL.name = "Fireblast"

SKILL.LevelReq = 2
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/spell_fire_soulburn.png"
SKILL.category = "Lore of Fire"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "bright_wizard"
}

SKILL.desc = [[
A torrent of fire erupt from your hands in a straight line, blasting anything in its path.

Ability Slot: 2
Class Restriction: Bright Wizard

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
		local pos = nil
		local BoneID = ply:LookupBone( "ValveBiped.Bip01_R_Hand" )
		local bullet = {}
			bullet.Attacker = ply
			bullet.Num = 5
			bullet.Src = ply:GetBonePosition(BoneID) + ply:GetForward()*10
			bullet.Dir = ply:GetAimVector()
			bullet.Spread = Vector(0.025,0.025,0.025)
			bullet.Tracer = 1
			bullet.TracerName = ""
			bullet.Force = 5
			bullet.Damage = 50
			bullet.AmmoType = "ar2"
			bullet.Callback = function(attacker,tr,dmginfo)
				util.Decal("SmallScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
				

				pos = tr.HitPos
			end

		timer.Simple(0.05, function()
			local effectdata = EffectData()
			effectdata:SetOrigin( pos )
			effectdata:SetStart( ply:GetBonePosition(BoneID) + ply:GetForward()*10 )
			util.Effect( "effect_zad_fire_blast", effectdata )
		end)

		ply:FireBullets(bullet)
		ply:EmitSound("fx/spl/spl_fireball_hit.wav", 75, 100, 1, CHAN_AUTO)

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