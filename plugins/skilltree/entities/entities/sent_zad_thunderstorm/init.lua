AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/Gibs/HGIBS.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesDirectDamage = true -- Should it do a direct damage when it hits something?
ENT.DirectDamage = 0 -- How much damage should it do when it hits something
ENT.DirectDamageType = DMG_DISSOLVE -- Damage type
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_Idle = {"farseer/storm1.mp3", "farseer/storm2.mp3"}
ENT.SoundTbl_OnCollide = {"fx/spl/spl_conjuration_cast.wav"}
ENT.RemoveOnHit = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetMaterial("Models/effects/vol_light001")
    self.Active = false
	ParticleEffect("fantasy_lightning_storm_cloud", self:GetPos(), self:GetAngles())
	timer.Create("vortex"..self:EntIndex(), 1, 5, function()
		ParticleEffect("fantasy_lightning_storm_cloud", self:GetPos(), self:GetAngles())
	end)
	timer.Simple(10, function()
		self:Remove()
	end
	)
	timer.Simple(1, function()
		self.Active = true 
	end
	)
	self:SetMoveType(MOVETYPE_NONE)

end

function ENT:CustomOnThink()
	local entities = ents.FindInSphere( self:GetPos(), 150 )
	if (self.Active) then
		for k, v in pairs(entities) do
			if v:IsNPC() or v:IsPlayer() then
				if v == self then return end
				local d = DamageInfo()
				d:SetDamage( 100 )
				d:SetAttacker( self.Owner )
				d:SetDamageType( DMG_DISSOLVE )

				v:TakeDamageInfo( d )
			end
		end
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