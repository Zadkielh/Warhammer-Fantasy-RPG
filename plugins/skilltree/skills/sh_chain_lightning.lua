SKILL.name = "Chain Lightning"

SKILL.LevelReq = 8
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Inv_enchant_essenceeternallarge.png"
SKILL.category = "Lore of Heavens"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "celestial_wizard"
}

SKILL.desc = [[
Lightning bursts from the wizard's hands and arcs across the battlefield, leaping from foe to foe with crackling fury.

Ability Slot: 2
Class Restriction: Bright Wizard

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 10

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
			bullet.Num = 1
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
			util.Effect( "effect_zad_celestial_lightning", effectdata )

			local Ents = ents.FindInSphere(pos, 500)
			local hits = 0
			for k, v in pairs(Ents) do
				if hits > 10 then break end
				if ((v:IsPlayer() and v != ply) or v:IsNPC()) then
					local effectdata = EffectData()
					effectdata:SetOrigin( v:GetPos() + v:OBBCenter() )
					effectdata:SetStart( pos )
					util.Effect( "effect_zad_celestial_lightning", effectdata )

					v:TakeDamage(50, ply, ply)

					hits = hits + 1
				end
			end
		end)

		ply:FireBullets(bullet)
		ply:EmitSound("fx/spl/spl_shock_hit.wav", 75, 100, 1, CHAN_AUTO)

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