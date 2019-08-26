AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Items/AR2_Grenade.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = false -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 50 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_BURN -- Damage type
ENT.SolidType = SOLID_NONE -- Solid type, recommended to keep it as it is
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_Idle = {"fx/spl/spl_restoration_travel_lp.wav"}
ENT.SoundTbl_OnCollide = {"fx/spl/spl_restoration_hit.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetMaterial("Models/effects/vol_light001")
    self.Active = false
	timer.Create("bladewind"..self:EntIndex(), 0.05, 1, function()
		ParticleEffectAttach("fantasy_chillwind", PATTACH_POINT_FOLLOW, self, 1)
	end)
	timer.Simple(10, function()
		if (IsValid(self)) then
			self:Remove()
		end
	end
	)
	timer.Simple(0.5, function()
		self.Active = true 
	end
	)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	--self:SetPos(self:GetUp()*50)
end

function ENT:CustomOnThink()
	ParticleEffectAttach("fantasy_chillwind", PATTACH_POINT_FOLLOW, self, 1)
	self.HasParticle = true
	local char = self:GetOwner():getChar()
	if !(self:GetOwner():IsPlayer()) then return end
	local entities = ents.FindInSphere( self:GetPos(), 150 )
	if (self.Active) then
		for k, v in pairs(entities) do
			if v:IsNPC() or v:IsPlayer() then
				if v == self then return end
				local d = DamageInfo()
				d:SetDamage( 75 + (char:getAttrib("mgc") * 2) + ((25 * (char:getLevel()*char:getLevel()) / (char:getLevel()+char:getLevel())))) 
				d:SetAttacker( self )
				d:SetDamageType( DMG_CRUSH )

				v:TakeDamageInfo( d )

				v:SetColor( Color(0, 161, 255, 255) )
				if v:IsPlayer() then
					v:Freeze(true)
				else
					timer.Create("freezeNPC"..v:EntIndex(), 0.5, 10, function()
						v:AddFlags(FL_FROZEN)
					end)
				end

				timer.Simple(5, function()
					if IsValid(v) then
						v:SetColor( Color(255, 255, 255, 255) )
						if v:IsPlayer() then
							v:Freeze(false)
						else
							v:RemoveFlags(FL_FROZEN)
						end
					end
				end)

			end
		end
	end
	local phys = self:GetPhysicsObject()
    if IsValid(phys) then -- If the physics object is valid
		phys:SetVelocity(self:GetForward() * 500) -- Fly straight forward
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)

end

function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(false)
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag( false )
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/