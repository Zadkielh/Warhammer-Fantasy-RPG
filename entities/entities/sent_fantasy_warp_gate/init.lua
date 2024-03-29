AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/

ENT.IsVJBaseSpawner = true
ENT.VJBaseSpawnerDisabled = false -- If set to true, it will stop spawning the entities
ENT.SingleSpawner = true -- If set to true, it will spawn the entities once then remove itself
	-- General ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/Gibs/HGIBS.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.EntitiesToSpawn = {

	{EntityName = "NPC1",SpawnPosition = {vForward=math.Rand(0, 0),vRight=math.Rand(-0, 0),vUp=10},Entities = {"npc_zombie"}},
	
}
ENT.TimedSpawn_Time = 3 -- How much time until it spawns another SNPC?
ENT.TimedSpawn_OnlyOne = true -- If it's true then it will only have one SNPC spawned at a time
ENT.HasIdleSounds = true -- Does it have idle sounds?
ENT.SoundTbl_Idle = {}
ENT.IdleSoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.IdleSoundLevel = 80
ENT.IdleSoundPitch1 = 100
ENT.IdleSoundPitch2 = 100
ENT.NextSoundTime_Idle1 = 0.2
ENT.NextSoundTime_Idle2 = 0.5
ENT.SoundTbl_SpawnEntity = {}
ENT.SpawnEntitySoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.SpawnEntitySoundLevel = 80
ENT.SpawnEntitySoundPitch1 = 80
ENT.SpawnEntitySoundPitch2 = 100
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnEntitySpawn(EntityName,SpawnPosition,Entities,TheEntity) 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize_BeforeNPCSpawn()
	PrecacheParticleSystem( "warp_gate" )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize_AfterNPCSpawn() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_BeforeAliveChecks()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AfterAliveChecks()
end