AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/zadkiel/tarantula.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 5000
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 5000 -- How far it can see
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = true -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.PlayerFriendly = true
ENT.SightAngle = 180
ENT.HasDeathRagdoll = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_IMPERIUM", "CLASS_MECH"}
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeDistance = 5000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 1 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = 0.025 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = 0.05 -- How much time until it can use a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code

//ENT.SoundTbl_RangeAttack = {"vj_emplacements/m2/m2_tp.wav"}

ENT.RangeAttackPitch1 = 100
ENT.RangeAttackPitch2 = 100
ENT.RangeAttackSoundLevel = 80

-- Custom
ENT.Emp_MaxAmmo = 500
ENT.Emp_CurrentAmmo = 0
ENT.Emp_Reloading = false

ENT.Emp_Lerp_Yaw = 0
ENT.Emp_Lerp_Ptich = 0
ENT.Emp_Lerp_Ptich_Previous = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(20, 20, 60), Vector(-20, -20, 1))
	self:SetBodygroup(1, 1)

	self.ExtraGunModel = ents.Create("prop_vj_animatable")
	--self.ExtraGunModel:SetModel("models/gameplay/tarantula.mdl")
	self.ExtraGunModel:SetModel("models/zadkiel/tarantula.mdl")
	self.ExtraGunModel:SetBodygroup(0, 1)

	self.ExtraGunModel:SetPos(self:GetPos() - self:GetUp()*10)
	self.ExtraGunModel:SetAngles(Angle(0,0,0))
	self.ExtraGunModel:SetOwner(self)
	//self.ExtraGunModel:SetParent(self)

	//self.ExtraGunModel:Fire("SetParentAttachmentMaintainOffset","hookup")
	//self.ExtraGunModel:Fire("SetParentAttachment","hookup")
	self.ExtraGunModel:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self.ExtraGunModel:Spawn()
	self.ExtraGunModel:Activate()
	//self.ExtraGunModel:SetSolid(SOLID_NONE)
	//self.ExtraGunModel:AddEffects(EF_BONEMERGE)
	
	self.Emp_CurrentAmmo = self.Emp_MaxAmmo
	timer.Simple(0.1, function()
		self:SetHealth(5000)
		self:SetMaxHealth((5000))
	end)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if IsValid(self.ExtraGunModel) then
		self.ExtraGunModel:SetAngles(Angle(0,0,0))
		if self.Emp_CurrentAmmo <= 0 && self.Emp_Reloading == false then
			self.Emp_Reloading = true
			VJ_EmitSound(self,"vj_emplacements/m2/m2_reload.wav")
			
			timer.Simple(2.67,function()
				if IsValid(self) then
					self.Emp_CurrentAmmo = self.Emp_MaxAmmo
					self.Emp_Reloading = false
				end
			end)
		end
		if IsValid(self:GetEnemy()) then
			local bone = self:LookupBone( "Turret" )
			local pos = self:GetEnemy():GetPos():Angle()
			self:ManipulateBoneAngles( bone, Angle(pos.p,0,pos.r) )
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	if self.Emp_CurrentAmmo > 0 then return true end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	if !IsValid(self.ExtraGunModel) then return end
	self.Emp_CurrentAmmo = self.Emp_CurrentAmmo - 2
	local bone = self:LookupBone( "L_Muzzle" )
	local pos = self:GetBonePosition( bone ) + self:GetForward()*10
	local ang = self:GetBonePosition( bone ):Angle()

	local fSpread = ((self:GetPos():Distance(self:GetEnemy():GetPos()))/100) 
	local bullet = {}
		bullet.Attacker = self
		bullet.Num = 1
		bullet.Src = pos + self:GetRight()*50 //self.ExtraGunModel:GetAttachment(self.ExtraGunModel:LookupAttachment("muzzle")).Pos
		bullet.Dir = (self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) - (self:GetPos() + self:OBBCenter())
		bullet.Spread = Vector(fSpread,fSpread,fSpread)
		bullet.Tracer = 1
		bullet.TracerName = ""
		bullet.Force = 5
		bullet.Damage = math.random(120,140)
		bullet.AmmoType = "ar2"
		bullet.Callback = function(attacker,tr,dmginfo)
			util.Decal("SmallScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
			local effectdata = EffectData()
			effectdata:SetOrigin( tr.HitPos )
			effectdata:SetStart( pos )
			util.Effect( "effect_t_boltgun", effectdata )
		end
		

	local bullet2 = {}
		bullet2.Attacker = self
		bullet2.Num = 1
		bullet2.Src = pos //self.ExtraGunModel:GetAttachment(self.ExtraGunModel:LookupAttachment("muzzle")).Pos
		bullet2.Dir = (self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) - (self:GetPos() + self:OBBCenter())
		bullet2.Spread = Vector(fSpread,fSpread,fSpread)
		bullet2.Tracer = 1
		bullet2.TracerName = ""
		bullet2.Force = 5
		bullet2.Damage = math.random(120,140)
		bullet2.AmmoType = "ar2"
		bullet2.Callback = function(attacker,tr,dmginfo)
			util.Decal("SmallScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		end

	self.ExtraGunModel:FireBullets(bullet)
	self.ExtraGunModel:FireBullets(bullet2)

	
	
	self:RangeAttackSoundCode({"40k/krk_fire"..math.random(1, 6)..".wav"},{UseEmitSound=true})
	
	ParticleEffect( "muzzleflash_bar_3p", pos, ang, self.ExtraGunModel )
	
	local BulletShell = EffectData()
	BulletShell:SetEntity(self.ExtraGunModel)
	BulletShell:SetOrigin(self.ExtraGunModel:GetPos() + self:GetForward()*-2 + self:GetUp()*2)
	util.Effect("RifleShellEject",BulletShell)
	
	local FireLight1 = ents.Create("light_dynamic")
	FireLight1:SetKeyValue("brightness", "4")
	FireLight1:SetKeyValue("distance", "120")
	FireLight1:SetPos(self:GetPos() + self:GetUp() * 50)
	FireLight1:SetLocalAngles(self.ExtraGunModel:GetAngles())
	FireLight1:Fire("Color", "255 150 60")
	FireLight1:SetParent(self.ExtraGunModel)
	FireLight1:Spawn()
	FireLight1:Activate()
	FireLight1:Fire("TurnOn","",0)
	FireLight1:Fire("Kill","",0.07)
	self.ExtraGunModel:DeleteOnRemove(FireLight1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	if IsValid(self.ReloadAmmoBox) then self.ReloadAmmoBox:Remove() end
	if IsValid(self.ExtraGunModel) then
		self.ExtraGunModel:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
		self.ExtraGunModel:SetOwner(NULL)
		self.ExtraGunModel:SetParent(NULL)
		self.ExtraGunModel:Fire("ClearParent")
		self.ExtraGunModel:SetMoveType(MOVETYPE_VPHYSICS)
		self:CreateExtraDeathCorpse("prop_physics",self.ExtraGunModel:GetModel(),{Pos=self.ExtraGunModel:GetPos(), Ang=self.ExtraGunModel:GetAngles(), HasVel=false})
		self.ExtraGunModel:Remove()
	end
end

function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)
	self:DeathEffects()
	return false
end

function ENT:DeathEffects() 
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetScale( 500 )
	util.Effect( "HelicopterMegaBomb", effectdata )
	util.Effect( "ThumperDust", effectdata )
	util.Effect( "Explosion", effectdata )
	util.Effect( "VJ_Small_Explosion1", effectdata )

	self.ExplosionLight1 = ents.Create("light_dynamic")
	self.ExplosionLight1:SetKeyValue("brightness", "4")
	self.ExplosionLight1:SetKeyValue("distance", "300")
	self.ExplosionLight1:SetLocalPos(self:GetPos())
	self.ExplosionLight1:SetLocalAngles( self:GetAngles() )
	self.ExplosionLight1:Fire("Color", "255 150 0")
	self.ExplosionLight1:SetParent(self)
	self.ExplosionLight1:Spawn()
	self.ExplosionLight1:Activate()
	self.ExplosionLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.ExplosionLight1)
	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)

	self:Remove()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/