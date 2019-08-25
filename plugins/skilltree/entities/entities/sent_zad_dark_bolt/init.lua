AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Gibs/HGIBS.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 100 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_BULLET -- Damage type
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_Idle = {"fx/spl/spl_restoration_travel_lp.wav"}
ENT.SoundTbl_OnCollide = {"fx/spl/spl_restoration_hit.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	//util.SpriteTrail(self, 0, Color(90,90,90,255), false, 10, 1, 3, 1/(15+1)*0.5, "trails/smoke.vmt")
	//ParticleEffectAttach("rocket_smoke", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("death_spasm", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	
	self.HasParticle = false

	self:SetMaterial("Models/effects/vol_light001")
	
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
	//effectdata:SetScale( 500 )

	self.ExplosionLight1 = ents.Create("light_dynamic")
	self.ExplosionLight1:SetKeyValue("brightness", "6")
	self.ExplosionLight1:SetKeyValue("distance", "300")
	self.ExplosionLight1:SetLocalPos(data.HitPos)
	self.ExplosionLight1:SetLocalAngles(self:GetAngles())
	self.ExplosionLight1:Fire("Color", "255 200 100")
	self.ExplosionLight1:SetParent(self)
	self.ExplosionLight1:Spawn()
	self.ExplosionLight1:Activate()
	self.ExplosionLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.ExplosionLight1)

end

function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(false)
	phys:SetMass( 20 )
	phys:AddAngleVelocity( Vector( math.random( 500, 1000 )))
	phys:EnableDrag( false )
end

function ENT:CustomOnThink()
	if !(self.HasParticle) then
		ParticleEffectAttach("death_spasm", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		self.HasParticle = true
	end

	local phys = self:GetPhysicsObject()
    if IsValid(phys) then -- If the physics object is valid
         phys:SetVelocity(self:GetForward() * 750) -- Fly straight forward
    end
end


/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/