AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Gibs/HGIBS.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 300 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 500 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_BLAST -- Damage type
ENT.RadiusDamageForce = 90 -- Put the force amount it should apply | false = Don't apply any force
ENT.ShakeWorldOnDeath = true -- Should the world shake when the projectile hits something?
ENT.ShakeWorldOnDeathAmplitude = 16 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.ShakeWorldOnDeathRadius = 3000 -- How far the screen shake goes, in world units
ENT.ShakeWorldOnDeathtDuration = 1 -- How long the screen shake will last, in seconds
ENT.ShakeWorldOnDeathFrequency = 200 -- The frequency
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_Idle = {"fx/spl/spl_fireball_travel_lp.wav"}
ENT.SoundTbl_OnCollide = {"fx/spl/spl_fireball_hit.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	//util.SpriteTrail(self, 0, Color(90,90,90,255), false, 10, 1, 3, 1/(15+1)*0.5, "trails/smoke.vmt")
	//ParticleEffectAttach("rocket_smoke", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("fantasy_fireball_main", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	local char = self:GetOwner():getChar()
	if !(self:GetOwner():IsPlayer()) then return end
	self.RadiusDamage = 500 + (char:getAttrib("mgc") * 2) + ((25 * (char:getLevel()*char:getLevel()) / (char:getLevel()+char:getLevel())))
	self.HasParticle = false

	self:SetMaterial("Models/effects/vol_light001")

	self.velocity = 10
	self.velocityUp = 1
	
	timer.Simple(1, function()
		if IsValid(self) then
			self.velocity = nil 
		end
	end)
	
	self.StartLight1 = ents.Create("light_dynamic")
	self.StartLight1:SetKeyValue("brightness", "5")
	self.StartLight1:SetKeyValue("distance", "200")
	self.StartLight1:SetLocalPos(self:GetPos())
	self.StartLight1:SetLocalAngles( self:GetAngles() )
	self.StartLight1:Fire("Color", "255 200 100")
	self.StartLight1:SetParent(self)
	self.StartLight1:Spawn()
	self.StartLight1:Activate()
	self.StartLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.StartLight1)

	self:EmitSound("fx/spl/spl_fireball_cast.wav", 75, 100, 1, CHAN_AUTO)

	timer.Simple(10, function()
		if(IsValid(self)) then
			self:Remove()
		end
	end
	)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	local effectdata = EffectData()
	effectdata:SetOrigin(data.HitPos)
	effectdata:SetScale( 500 )
	util.Effect( "Explosion", effectdata )
	util.Effect( "ThumperDust", effectdata )
	util.Effect( "ManhackSparks", effectdata )

	self.ExplosionLight1 = ents.Create("light_dynamic")
	self.ExplosionLight1:SetKeyValue("brightness", "6")
	self.ExplosionLight1:SetKeyValue("distance", "300")
	self.ExplosionLight1:SetLocalPos(data.HitPos)
	self.ExplosionLight1:SetLocalAngles(self:GetAngles())
	self.ExplosionLight1:Fire("Color", "255 200 0")
	self.ExplosionLight1:SetParent(self)
	self.ExplosionLight1:Spawn()
	self.ExplosionLight1:Activate()
	self.ExplosionLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.ExplosionLight1)

end

function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(true)
	phys:SetMass( 20 )
	phys:AddAngleVelocity( Vector( math.random( 500, 1000 )))
	phys:EnableDrag( false )
end

function ENT:CustomOnThink()
	if !(self.HasParticle) then
		ParticleEffectAttach("fantasy_fireball_main", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		--ParticleEffectAttach("burning_gib_01_follower1", PATTACH_ABSORIGIN_FOLLOW, self, 0)

		--ParticleEffectAttach("fire_jet_01_flame",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
		ParticleEffectAttach("fire_medium_01_glow",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)	
	--	ParticleEffectAttach("fire_medium_01",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)	
		self.HasParticle = true
	end

	if (self.velocity != nil) then
		self.velocity = self.velocity * 4
		self.velocityUp = self.velocityUp * 2
		local phys = self:GetPhysicsObject()
		phys:SetVelocity(self:GetForward() * self.velocity + self:GetUp()*self.velocityUp) -- Fly straight forward
    end
end

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/