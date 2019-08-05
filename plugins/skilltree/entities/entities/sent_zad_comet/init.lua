if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include('shared.lua')
/*--------------------------------------------------
	=============== Test Entity ===============
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to Test Things
--------------------------------------------------*/

---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Supplies = 1200

function ENT:Initialize()
	self:EmitSound("comet/comet_travel_long.wav", 100, 100, 1, CHAN_AUTO)
	self:SetNoDraw(true)
	timer.Simple(0,function() self:SetPos(self:GetPos() +self:GetUp()*5000) end)
	timer.Simple(10, function()
		self:SetNoDraw(false)
		self:SetModel("models/props_foliage/rock_forest03.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionBounds(Vector(500, 500, 200), Vector(-500, -500, 1))

		ParticleEffectAttach("fire_large_01", PATTACH_ABSORIGIN, self, -1)
		ParticleEffectAttach("env_fire_large", PATTACH_ABSORIGIN, self, -1)

		self.DoParticles = true 
		
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableGravity(true)
			phys:SetBuoyancyRatio(0)
			phys:ApplyForceCenter(Vector(0,0,-500))
		end
	end)
end

function ENT:Think()
	if self.DoParticles then
		ParticleEffectAttach("fire_large_01", PATTACH_ABSORIGIN, self, -1)
		ParticleEffectAttach("env_fire_large", PATTACH_ABSORIGIN, self, -1)
		ParticleEffectAttach("fantasy_fireball_main", PATTACH_ABSORIGIN, self, -1)
	end

	self:NextThink( CurTime() )
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	return false
end

function ENT:PhysicsUpdate( phys )
	local phys = self:GetPhysicsObject()
	phys:ApplyForceCenter( Vector( 0, 0, phys:GetMass()*-200 ) )
end

function ENT:PhysicsCollide(data,phys)
	if data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() then
		data.HitEntity:TakeDamage(10000, self.Owner, self.Owner)
	end
	getvelocity = phys:GetVelocity()
	velocityspeed = getvelocity:Length()
	if velocityspeed > 500 and !(data.HitEntity:IsPlayer() or data.HitEntity:IsNPC()) then -- Or else it will go flying!
		self:SetMoveType(MOVETYPE_NONE)
		self:LandEffects(data.HitPos)
	end
	
end

function ENT:LandEffects(pos)
	timer.Simple(0, function()
		local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetScale( 1000 )
		util.Effect( "HelicopterMegaBomb", effectdata )
		util.Effect( "ThumperDust", effectdata )
		util.Effect( "VJ_Medium_Explosion1", effectdata )
		--util.Effect( "Explosion", effectdata )
		--util.Effect("string effectName", effectdata)
	end)
	self:EmitSound("comet/comet_impact_"..math.random(1, 2)..".wav", 100, 100, 1, CHAN_AUTO)

	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)

	local Entities = ents.FindInSphere( self:GetPos(), 250 )
	for k, v in pairs(Entities) do
		v:TakeDamage(2000, self.Owner, self.Owner)
	end
	self:Remove()
end