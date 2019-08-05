PLUGIN.name = "Magic"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Increases magical power."

if (SERVER) then
	function PLUGIN:PostPlayerLoadout(client)
	local uniqueID = ""..client:SteamID()
	local value = client:getLocalVar("mana", 0)
	
	client:setLocalVar("mana", 100)
			
			if !client:getChar():hasTrait("blooddrinker") then
				timer.Create(uniqueID, 0.25, 0, function()
					
					if IsValid(client) then
						local Magic = client:getChar():getAttrib("mgc", 1)
						local Faith = client:getChar():getAttrib("fth", 1)
						local regen = ((client:getChar():getAttrib("mgc", 1)) / 100 * 2.5)
						
						if Magic < Faith then
							regen = ((client:getChar():getAttrib("fth", 1)) / 100 * 2.5)
						end

						local current = client:getLocalVar("mana", 0)
						local value = math.Clamp(current + regen, 0, 100)
						if (current != value) then
							client:setLocalVar("mana", value)
						end
					else
						timer.Remove(uniqueID)
					end
				end
				)
			end
	end
end

nut.command.add("peril", {
    adminOnly = true,
    syntax = "<string name> <number gates>",
    onRun = function(client, args)
        local Target = nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		
		client.Gates = {}
		for i = 1, (tonumber(args[2] ) or 1) do
			local gate = ents.Create( "sent_vj_warp_gate" )
			if ( !IsValid( gate ) )then return end
			gate:SetPos(Target:GetPos() + Vector( math.random(-250, 250), math.random(-250, 250), math.random(10, 20) ) ) 
			gate:SetAngles(Target:GetAngles())
			gate.SingleSpawner = true
			gate:Spawn()
			gate:Activate()
		
			table.insert(client.Gates, gate)
		end

    end
})
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	