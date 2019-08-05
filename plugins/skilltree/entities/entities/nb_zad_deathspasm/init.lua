AddCSLuaFile("shared.lua")
include("shared.lua")
AddCSLuaFile()
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

ENT.DirectDamage = 50 -- How much damage should it do when it hits something
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	print(self.Owner)
	print(self, "Initialize")
	self:SetModel( "models/Gibs/HGIBS.mdl" )
	ParticleEffectAttach("death_spasm", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	
	--self:SetMaterial("Models/effects/vol_light001")

	self.HasParticle = false
	self:SetMoveType(MOVETYPE_FLY)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0)
	end

	self.LoseTargetDist	= 300	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 200	-- How far to search for enemies

	timer.Simple(10, function()
		self:Remove()
	end
	)
end

function ENT:SetEnemy( ent )
	self.Enemy = ent
end
function ENT:GetEnemy()
	return self.Enemy
end

function ENT:HaveEnemy()
	-- If our current enemy is valid
	if ( self:GetEnemy() and IsValid( self:GetEnemy() ) ) then
		-- If the enemy is too far
		if ( self:GetRangeTo( self:GetEnemy():GetPos() ) > self.LoseTargetDist ) then
			-- If the enemy is lost then call FindEnemy() to look for a new one
			-- FindEnemy() will return true if an enemy is found, making this function return true
			return self:FindEnemy()
		-- If the enemy is dead( we have to check if its a player before we use Alive() )
		elseif ( self:GetEnemy():IsPlayer() and !self:GetEnemy():Alive() ) then
			return self:FindEnemy()		-- Return false if the search finds nothing
		end
		-- The enemy is neither too far nor too dead so we can return true
		return true
	else
		-- The enemy isn't valid so lets look for a new one
		return self:FindEnemy()
	end
end

function ENT:FindEnemy()
	-- Search around us for entities
	-- This can be done any way you want eg. ents.FindInCone() to replicate eyesight
	local _ents = ents.FindInSphere(self:GetPos(), self.SearchRadius)
	-- Here we loop through every entity the above search finds and see if it's the one we want
	for k, v in pairs( _ents ) do
		if ( v:IsPlayer() or v:IsNPC() and (v != self:GetOwner())) then
			-- We found one so lets set it as our enemy and return true
			self:SetEnemy( v )
			return true
		end
	end
	-- We found nothing so we will set our enemy as nil ( nothing ) and return false
	self:SetEnemy( nil )
	return false
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

function ENT:OnContact( ent )
	if ent:IsPlayer() or ent:IsNPC() then
		ent:TakeDamage(self.DirectDamage, self.Owner, self.Owner)
	end
end

function ENT:FindTarget(dir)
	local Entities = ents.FindInSphere(self:GetPos(), 200)
	for k, v in pairs(Entities) do
		if v:IsNPC() or v:IsPlayer() then return v end
	end
end

function ENT:RunBehaviour()

	print("test")
	-- This function is called when the entity is first spawned, it acts as a giant loop that will run as long as the NPC exists
	while ( true ) do
		
		-- Lets use the above mentioned functions to see if we have/can find a enemy
		if ( self:HaveEnemy() ) then
			-- Now that we have a enemy, the code in this block will run
			self.loco:FaceTowards( self:GetEnemy():GetPos() )	-- Face our enemy
			self.loco:SetDesiredSpeed( 300 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
			self.loco:SetAcceleration( 500 )			-- We are going to run at the enemy quickly, so we want to accelerate really fast
			self:ChaseEnemy() 						-- The new function like MoveToPos that will be looked at soon.
			self.loco:SetAcceleration( 200 )			-- Set this back to its default since we are done chasing the enemy
			-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
			-- unless you put stuff after the if statement. Then that will be run before it loops
		else
			-- Since we can't find an enemy, lets wander
			-- Its the same code used in Garry's test bot
			self.loco:SetDesiredSpeed( 200 )		-- Walk speed
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 ) -- Walk to a random place within about 400 units ( yielding )
		end
		-- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
		-- Using this next function we are going to wait 2 seconds until we go ahead and repeat it
		coroutine.wait( 1 )

	end

end	

function ENT:ChaseEnemy( options )

	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self:GetEnemy():GetPos() )		-- Compute the path towards the enemy's position

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() and self:HaveEnemy() ) do

		if ( path:GetAge() > 0.1 ) then					-- Since we are following the player we have to constantly remake the path
			path:Compute( self, self:GetEnemy():GetPos() )-- Compute the path towards the enemy's position again
		end
		path:Update( self )								-- This function moves the bot along the path

		if ( options.draw ) then path:Draw() end
		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"

end

function ENT:Think()
	if !(self.HasParticle) then
		ParticleEffectAttach("death_spasm", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		self.HasParticle = true
	end
end

function ENT:CustomOnDoDamage(data,phys,hitent) 
	
end

list.Set( "NPC", "sent_zad_deathspasm", {
	Name = "Deathspasm",
	Class = "sent_zad_deathspasm",
	Category = "NextBot"
} )
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/