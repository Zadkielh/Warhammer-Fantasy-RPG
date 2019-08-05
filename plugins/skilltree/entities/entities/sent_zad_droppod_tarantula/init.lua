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
	self:EmitSound("Drop pod animation.mp3", 100, 100, 1, CHAN_AUTO)
	self:SetNoDraw(true)
	timer.Simple(4.7, function()
		self:SetNoDraw(false)
		self:SetModel("models/zadkiel/deathwatch/veh_droppod.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionBounds(Vector(500, 500, 200), Vector(-500, -500, 1))

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableGravity(true)
			phys:SetBuoyancyRatio(0)
			phys:ApplyForceCenter(Vector(0,0,-500))
		end

		timer.Simple(0,function() self:SetPos(self:GetPos() +self:GetUp()*5000) end)
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local DenySound = Sound( "WallHealth.Deny" )
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
		timer.Simple(0.1, function()
			self:Remove()
		end)
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
	self:EmitSound("ambient/explosions/exp"..math.random(1, 4)..".wav", 100, 100, 1, CHAN_AUTO)

	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)

	local Ent = ents.Create("npc_zad_40k_tarantula")
		
	Ent:SetPos(pos)
	Ent:SetAngles(self:GetAngles())
	Ent:SetMoveType(MOVETYPE_VPHYSICS)
	Ent:SetOwner(self.Owner)

	Ent:Spawn()
	Ent:SetAngles(Angle(0,0,0))
	Ent.ExtraGunModel:SetPos(Ent:GetPos() + Ent:GetUp()*2.5)
	timer.Simple(60, function()
		if (IsValid(Ent)) then
			Ent:Remove()
		end
	end
	)

end