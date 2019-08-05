AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/joazzz/warhammer40k/weapons/grenade.mdl"} -- The models it should spawn with | Picks a random one from the table
--ENT.MoveCollideType = nil -- Move type | Some examples: MOVECOLLIDE_FLY_BOUNCE, MOVECOLLIDE_FLY_SLIDE
ENT.CollisionGroupType = nil -- Collision type, recommended to keep it as it is
ENT.SolidType = SOLID_VPHYSICS -- Solid type, recommended to keep it as it is
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 400 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 500 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_BLAST -- Damage type
ENT.RadiusDamageForce = 90 -- Put the force amount it should apply | false = Don't apply any force
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_OnCollide = {"weapons/hegrenade/he_bounce-1.wav"}

-- Custom
ENT.FussTime = 3
ENT.TimeSinceSpawn = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(true)
	phys:SetBuoyancyRatio(0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	//if self:GetOwner():IsValid() && (self:GetOwner().GrenadeAttackFussTime) then
	//timer.Simple(self:GetOwner().GrenadeAttackFussTime,function() if IsValid(self) then self:DeathEffects() end end) else
	timer.Simple(self.FussTime,function() if IsValid(self) then self:DeathEffects() end end)
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.TimeSinceSpawn = self.TimeSinceSpawn + 0.2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data,phys)
	getvelocity = phys:GetVelocity()
	velocityspeed = getvelocity:Length()
	//print(velocityspeed)
	if velocityspeed > 500 then -- Or else it will go flying!
		phys:SetVelocity(getvelocity * 0.9)
	end
	
	if velocityspeed > 100 then -- If the grenade is going faster than 100, then play the touch sound
		self:OnCollideSoundCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects()
	local Entities = ents.FindInSphere( self:GetPos(), 500 )
	for k, v in pairs(Entities) do
		if v:IsPlayer() then
			if (v:Health() != v:GetMaxHealth() ) then
				v:SetHealth( math.Clamp( v:Health() + (1500), 0, v:GetMaxHealth()))
				ParticleEffectAttach( "fantasy_heal", PATTACH_ABSORIGIN_FOLLOW, v, 0 )
			end
		end
	end
	
	--self:DoDamageCode()
	self:SetDeathVariablesTrue(nil,nil,false)
	self:Remove()
end


/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/