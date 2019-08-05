/* Custom Functions */

/*
	Name: removeEntityFromTable (sv)
	Arguments: ent (entity)
	Returns: exists (boolean)
	Desc: Removes the NPC from the table, returns if it succeeded or not
*/
NPC_STATS = {}
nut.util.include("sh_npcs_levels.lua")

local function removeEntityFromTable(ent)
	local entID = ent:EntIndex()
	local exists = false
	
	for k, v in pairs(NPC_STATS) do
		if k != entID then continue end
		
		exists = true
	end
	
	if exists then		
		NPC_STATS[entID] = nil
		
		net.Start("NPC_STATS_remove_Info")
			net.WriteInt(entID, 16)
		net.Broadcast()
	end
	
	return exists
end

/* Hooks */
hook.Add("EntityRemoved", "NPC_XP.CleanOnRemove", function(ent)
	removeEntityFromTable(ent)
end)

hook.Add("PlayerInitialSpawn", "NPC_XP.PlayerInitialSpawn", function(ply)
	net.Start("NPC_STATS_receive_Table")
		net.WriteTable(NPC_STATS)
	net.Send(ply)
end)

hook.Add("OnNPCKilled", "NPC_XP.CleanOnKill", function(ent, attacker, inflictor)
	removeEntityFromTable(ent)
end)

hook.Add("OnEntityCreated", "NPC_XP.OnEntityCreated", function(ent)
	if !ent:IsNPC() or !IsValid(ent) then return end
	
	
	local NPC_Level, NPC_MaxHealth = math.random(1,100), 1

	

	local entID = ent:EntIndex()
	local size = false
	local baselevel = 1
	local healthmulti = 1

	for k,v in pairs(NPC_XP) do
		if ent:GetClass() == v.class then
			NPC_Level = math.random(v.baselevel, v.maxlevel)
			healthmulti = v.healthmulti
			if (v.size) then
				size = true
				baselevel = v.baselevel
			end
			break
		end
	end
	
	timer.Simple(0, function() // We need to do this for a frame later, network lag
		if !IsValid(ent) then
			print("Non-existant NPC found.") // Error catching, on certain NPCs it will error.
			return
		end

		if (ent.IsSummoned) then
			NPC_Level = ent.SummonerLevel
		end
		
		NPC_MaxHealth = math.Round(ent:Health() + (ent:Health() / 5 * (NPC_Level - baselevel)) * healthmulti)
		
		ent:SetHealth(NPC_MaxHealth)
		ent:SetMaxHealth(NPC_MaxHealth)
		if (size) then
			
			scale = (NPC_Level - baselevel) / 100 + 1
			ent:SetModelScale( scale, 0 )
		end

		NPC_STATS[entID] = {
			Level = NPC_Level
		}
		
		// Instead of just sending the whole table of NPCs, we're just going to send the one we gave the values to
		net.Start("NPC_STATS_send_Info")
			net.WriteInt(entID, 16)
			net.WriteTable(NPC_STATS[entID])
		net.Broadcast()
	end)
	
end)




util.AddNetworkString("NPC_STATS_receive_Table")
util.AddNetworkString("NPC_STATS_send_Info")
util.AddNetworkString("NPC_STATS_remove_Info")