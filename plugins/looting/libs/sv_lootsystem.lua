
function PLUGIN:OnNPCKilled( npc, attacker, inflictor )
	if npc:IsNPC() and IsValid(npc) then

		local storage = ents.Create("nut_storage_loot")
		storage:SetPos(npc:GetPos() + npc:GetUp()*50)
		storage:SetAngles(npc:EyeAngles())
		storage:SetAngles(npc:GetAngles())
		storage:Spawn()
		storage:SetModel("models/zadkiel/coinpurse/coinpurse.mdl")
		storage:SetSolid(SOLID_VPHYSICS)
		storage:PhysicsInit(SOLID_VPHYSICS)

		

		timer.Create("RemoveCorpse"..storage:EntIndex(), 30, 1, function()
			if IsValid(storage) then
				storage:Remove()
			end
		end)

		storage:SetModelScale(2, 0)

		nut.inventory.instance("grid", {w = 4,h = 4})
			:next(function(inventory)
				if (IsValid(storage)) then
					inventory.isStorage = true
					storage:setInventory(inventory)

					for k, v in pairs(LootTable) do
						if npc:GetClass() == v.class then
							local spawnChance = math.random(0, 100)
							if spawnChance < v.weight then
								local itemTable = v.itemTable
								local item = (itemTable[math.random(#itemTable)])
								if spawnChance < (v.weight/2) then
									for i = 1, 2 do
										inventory:add(item, 1)
										if v.value >= 100 then
											inventory:add("coin_hundred", 1)
										elseif v.value >= 50 then
											inventory:add("coin_fifty", 1)
										elseif v.value >= 10 then
											inventory:add("coin_ten", 1)
										elseif v.value >= 1 then
											inventory:add("coin", 1)
										end
									end
								else
									inventory:add(item, 1)
									if v.value >= 100 then
										inventory:add("coin_hundred", 1)
									elseif v.value >= 50 then
										inventory:add("coin_fifty", 1)
									elseif v.value >= 10 then
										inventory:add("coin_ten", 1)
									elseif v.value >= 1 then
										inventory:add("coin", 1)
									end
									
								end
							else
								storage:Remove()
							end
						end
					end

				end
			end, function(err)
				ErrorNoHalt(
					"Unable to create storage entity for "..client:Name().."\n"..
					err.."\n"
				)
				if (IsValid(storage)) then
					storage:Remove()
				end
			end)
		
		timer.Simple(0.5, function()
			ParticleEffectAttach("default", PATTACH_ABSORIGIN_FOLLOW, storage, 1)
		end)
	end
end