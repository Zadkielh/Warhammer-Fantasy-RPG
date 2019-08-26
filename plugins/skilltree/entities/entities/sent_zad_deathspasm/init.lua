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
ENT.DirectDamageType = DMG_BURN -- Damage type
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_Idle = {"fx/spl/spl_restoration_travel_lp.wav"}
ENT.SoundTbl_OnCollide = {"fx/spl/spl_restoration_hit.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	//util.SpriteTrail(self, 0, Color(90,90,90,255), false, 10, 1, 3, 1/(15+1)*0.5, "trails/smoke.vmt")
	//ParticleEffectAttach("rocket_smoke", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("death_spasm", PATTACH_ABSORIGIN_FOLLOW, self, 0)

	local char = self:GetOwner():getChar()
	if !(self:GetOwner():IsPlayer()) then return end
	self.DirectDamage = 100 + (char:getAttrib("mgc") * 2) + ((25 * (char:getLevel()*char:getLevel()) / (char:getLevel()+char:getLevel())))
	
	self.HasParticle = false

	self:SetMaterial("Models/effects/vol_light001")

	
	local enttarget1 = ents.Create("info_target")
				enttarget1:SetParent(self)
				enttarget1:SetPos(self:GetPos() + Vector(0,0,10))
				enttarget1:Spawn()
				
	local enttarget2 = ents.Create("info_target")
				enttarget2:SetParent(self)
				enttarget2:SetPos(self:GetPos() + Vector(-10,0,-10))
				enttarget2:Spawn()
				
	local enttarget3 = ents.Create("info_target")
				enttarget3:SetParent(self)
				enttarget3:SetPos(self:GetPos() + Vector(10,0,-10))
				enttarget3:Spawn()
				
	local enttarget4 = ents.Create("info_target")
				enttarget4:SetParent(self)
				enttarget4:SetPos(self:GetPos() + Vector(10, 10,-10))
				enttarget4:Spawn()
				
	local enttarget5 = ents.Create("info_target")
				enttarget5:SetParent(self)
				enttarget5:SetPos(self:GetPos() + Vector(10, 10, 10))
				enttarget5:Spawn()
				
	local enttarget6 = ents.Create("info_target")
				enttarget6:SetParent(self)
				enttarget6:SetPos(self:GetPos() + Vector(-10, 10,-10))
				enttarget6:Spawn()
	local enttarget7 = ents.Create("info_target")
				enttarget6:SetParent(self)
				enttarget6:SetPos(self:GetPos() + Vector(-20, 10,-10))
				enttarget6:Spawn()
	local enttarget8 = ents.Create("info_target")
				enttarget6:SetParent(self)
				enttarget6:SetPos(self:GetPos() + Vector(-10, 10,-20))
				enttarget6:Spawn()
	local enttarget9 = ents.Create("info_target")
				enttarget6:SetParent(self)
				enttarget6:SetPos(self:GetPos() + Vector(-10, 20,-10))
				enttarget6:Spawn()
	----------------------------------------------------------------------
	local enttarget10 = ents.Create("info_target")
				enttarget1:SetParent(self)
				enttarget1:SetPos(self:GetPos() + Vector(30,0,10))
				enttarget1:Spawn()
				
	local enttarget11 = ents.Create("info_target")
				enttarget2:SetParent(self)
				enttarget2:SetPos(self:GetPos() + Vector(-30,0,-10))
				enttarget2:Spawn()
				
	local enttarget12 = ents.Create("info_target")
				enttarget3:SetParent(self)
				enttarget3:SetPos(self:GetPos() + Vector(10,0,-30))
				enttarget3:Spawn()
				
	local enttarget13 = ents.Create("info_target")
				enttarget4:SetParent(self)
				enttarget4:SetPos(self:GetPos() + Vector(10, 40,-10))
				enttarget4:Spawn()
				
	local enttarget14 = ents.Create("info_target")
				enttarget5:SetParent(self)
				enttarget5:SetPos(self:GetPos() + Vector(40, 10, 10))
				enttarget5:Spawn()
				
	local enttarget15 = ents.Create("info_target")
				enttarget6:SetParent(self)
				enttarget6:SetPos(self:GetPos() + Vector(-10, 10,-40))
				enttarget6:Spawn()
	local enttarget16 = ents.Create("info_target")
				enttarget6:SetParent(self)
				enttarget6:SetPos(self:GetPos() + Vector(-50, 10,-10))
				enttarget6:Spawn()
	local enttarget17 = ents.Create("info_target")
				enttarget6:SetParent(self)
				enttarget6:SetPos(self:GetPos() + Vector(-10, 50,-20))
				enttarget6:Spawn()
	local enttarget18 = ents.Create("info_target")
				enttarget6:SetParent(self)
				enttarget6:SetPos(self:GetPos() + Vector(-10, 20,-50))
				enttarget6:Spawn()

				util.SpriteTrail( enttarget1, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget2, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget3, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget4, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget5, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget6, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget7, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget8, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget9, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				
				util.SpriteTrail( enttarget10, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget11, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget12, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget13, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget14, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget15, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget16, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget17, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
				util.SpriteTrail( enttarget18, 0, Color( 200, 105, 105, 255 ), false, 10, 1, 1, 1/(10+1)*0.5, "trails/laser.vmt" )
	
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

	local char = self:GetOwner():getChar()
	if !(self:GetOwner():IsPlayer()) then return end

	local Ents = ents.FindInSphere(self:GetPos(), 500)
	local hits = 0
	for k, v in pairs(Ents) do
		if hits > 10 then break end
		if ((v:IsPlayer() and v != self:GetOwner() and !(v:Team() == self:GetOwner():Team())) or v:IsNPC())  then
			local effectdata = EffectData()
			effectdata:SetOrigin( v:GetPos() + v:OBBCenter() )
			effectdata:SetStart( data.HitPos )
			util.Effect( "effect_zad_dark_lightning", effectdata )

			v:TakeDamage(50 + (char:getAttrib("mgc") * 2) + ((25 * (char:getLevel()*char:getLevel()) / (char:getLevel()+char:getLevel()))), self:GetOwner(), self:GetOwner())
			v:Ignite(5)

			hits = hits + 1
		end
	end

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
        if SERVER and IsValid(self.InitialTarget) then  -- Is the VictimToTarget a valid entity?
            local pos = Vector(self.InitialTarget:GetPos().x,self.InitialTarget:GetPos().y,-50)
            phys:SetVelocity((pos - Vector(self:GetPos().x,self:GetPos().y,0)):GetNormal() * 200) -- Home in on the target
        elseif SERVER and not IsValid(self.InitialTarget) then

			local Ents = ents.FindInSphere(self:GetPos(), 200)
				for k, v in pairs(Ents) do
					if ((v:IsPlayer() and v != self:GetOwner()) or v:IsNPC()) then
						self.InitialTarget = v
					end
				end
            phys:SetVelocity(self:GetForward() * 500) -- Fly straight forward
        end
    end
end

function ENT:CustomOnDoDamage(data,phys,hitent) 
	hitent:Ignite(10)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/