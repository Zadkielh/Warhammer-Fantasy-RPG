/* Custom Functions*/
local function drawShadowedText(txt, font, x, y, col, shadowcol, xalign, yalign)
	draw.SimpleText(txt, font, x + 2, y + 2, shadowcol, xalign, yalign);
	draw.SimpleText(txt, font, x, y, col, xalign, yalign);
end

/* Hooks */
local vectorOffset = 16;
local barWidth, barHeight = 500, 100;
local boxWidth, boxHeight = 250, 195;
local outlineWidth = 20;

local backgroundbar1 = nut.util.getMaterial("vgui/bar_1.png")
local backgroundbar2 = nut.util.getMaterial("vgui/bar_2.png")
local backgroundbar3 = nut.util.getMaterial("vgui/bar_5.png")
local backgroundbar4 = nut.util.getMaterial("vgui/background_bar.png")
local hpbar2 = nut.util.getMaterial("vgui/border_icon_2.png")
local bg_1 = nut.util.getMaterial("vgui/bar_3.png")
local bg_2 = nut.util.getMaterial("vgui/bar_4.png")
local bg_3 = nut.util.getMaterial("vgui/bar_6.png")
local bg_4 = nut.util.getMaterial("vgui/bar_8.png")
local bg_5 = nut.util.getMaterial("vgui/bar_9.png")
local bg_6 = nut.util.getMaterial("vgui/bar_10.png")
local bg_7 = nut.util.getMaterial("vgui/border_bg2.png")

nut.util.include("sv_npcs_levels.lua")
nut.util.include("sh_npcs_levels.lua")
local CAlpha = 255
local DeadNpc = nil
hook.Add("PostDrawOpaqueRenderables", "HUDNPCPostDrawOpaqueRenderables", function()	
	local ply = LocalPlayer()
	if !IsValid(ply) then return end
	
	for _, npc in ipairs(ents.FindByClass("npc_*")) do

		netstream.Hook("NpcDieXP", function(attacker, value, npc)
			DeadNpc = npc
			DeadNpc.NpcAlpha = 255
			
			if (attacker) then
				npcxp = value
			end
			
			
		end)
		if IsValid(DeadNpc) then
			DeadNpc.InfoPos = ((DeadNpc:LocalToWorld(DeadNpc:OBBCenter()*2)) + (vector_up * vectorOffset))
			if DeadNpc.NpcAlpha != 0 then
				cam.Start3D2D(DeadNpc.InfoPos, Angle(0, EyeAngles().y - 90, 90), .05)
						drawShadowedText("+ " .. (tostring(npcxp) or 0.5) .. "XP", "CenturyGothicVeryBig", -1 * (barWidth) + boxWidth * 2, (boxHeight) + barHeight / 2 - outlineWidth, Color(230, 0, 230, DeadNpc.NpcAlpha), Color(0, 0, 0, DeadNpc.NpcAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
						DeadNpc.NpcAlpha = math.Approach( DeadNpc.NpcAlpha, 0, 0.25 )
				cam.End3D2D()
			end
		end

		if !IsValid(npc) then continue end

		
		
		local npcID = npc:EntIndex()
		local npcStats = NPC_STATS[npcID]
		if !npcStats then continue end

		local bumpRight = -5; -- Positioning for the bar
		local barColor = Color( 200, 160, 0)
		barColor = Color(barColor.r, barColor.g, barColor.b, 255)
		
		local npcHP, npcMaxHP, npcName = math.max(npc:Health(), 1), math.max(npc:GetMaxHealth(), 1), npc.Name or (language.GetPhrase(npc:GetClass()))
		npc.InfoPos = ((npc:LocalToWorld(npc:OBBCenter()*2)) + (vector_up * vectorOffset))
		
		local outlineColor = Color(66, 66, 66, 255)
		local IsTraced = false
		local TFaded = false
		local plyTrace = ply:GetEyeTrace();

			
		local plyTraceEnt = plyTrace.Entity		
			if plyTraceEnt != npc then
				IsTraced = false
			elseif plyTraceEnt == npc and !IsTraced then
				IsTraced = true
				CAlpha = 255
			end
			
			if IsTraced then
				if !CAlpha then
					CAlpha = 255
				end
				
				if CAlpha != 0 then
					if !TFaded then
						TFaded = true
						CAlpha = 255
						CAStart = CurTime()
						CAEnd = CurTime() + 3
					end
					local frac = math.TimeFraction(CAStart, CAEnd, CurTime());
					frac = math.Clamp(frac, 0, 1)

					CAlpha = Lerp(frac, 255, 0)
					
					if CAlpha == 0 then
						TFaded = true
					end
				end
			else
				if CAlpha > 0 then

					CAlpha = math.Approach( CAlpha, 0, 0.5 )

				end
				
				if !TFaded then
					TFaded = true
				end
			end
		
		local red = 0
		local blue = 0
		local green = 255
		local level = npcStats.Level
			if level >= 10 then
				red = 250
				green = 200
				if level >= 20 then
					red = 200
					green = 0
					if level >= 30 then
						red = 255
						blue = 100
						if level >= 40 then
							red = 255
							blue = 200
							if level >= 50 then
								red = 155
								blue = 155
								if level >= 60 then
									red = 255
									blue = 15
									green = 100
									if level >= 70 then
										red = 100
										green = 200
										blue = 255
										if level >= 80 then
											red = 50
											blue = 255
											green = 0
											if level >= 90 then
												red = 100
												green = 10
												blue = 255
												if level >= 100 then
													red = 0
													green = 0
													blue = 0
													
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		cam.Start3D2D(npc.InfoPos, Angle(0, EyeAngles().y - 90, 90), .05)

			
			/* Health */
			local levelPosY = (boxHeight) - 100
			
			local namePosY = (boxHeight) - 200
			drawShadowedText("Level: " .. (level or 1), "CenturyGothicVeryBig", -1 * (barWidth) + boxWidth * 2, levelPosY, Color(red, green, blue, CAlpha), Color(0, 0, 0, CAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
			drawShadowedText(npcName, "CenturyGothicVeryBig", 2, namePosY, Color(red, green, blue, CAlpha), Color(0, 0, 0, CAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
           
            local len = ( math.max((npcHP * 1000) / npcMaxHP))
            surface.SetDrawColor(255, 255, 255, CAlpha)

	        surface.SetMaterial( backgroundbar1 )
            surface.DrawTexturedRectUV( 0 - 502.5, -1 * (barWidth / 10 + 250), barWidth + 510, barHeight + 120, 0, 0, 1, 1 )

            surface.SetMaterial( hpbar2 )
            surface.DrawTexturedRectUV( 0 - 502.5, -1 * (barWidth / 10 + 210), len - 10, barHeight + 60, 0, 0, 1, 1 )

            surface.SetMaterial( backgroundbar2 )
            surface.DrawTexturedRectUV( 0 - 520, -1 * (barWidth / 10 + 250), barWidth + 530, barHeight + 120, 0, 0, 1, 1 )


			local healthPosY = (boxHeight) - 382
			
			drawShadowedText(npcHP .. "/" .. npcMaxHP, "CenturyGothicVeryBig", 2, healthPosY, Color(233, 233, 233, CAlpha), Color(0, 0, 0, CAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		cam.End3D2D()
		
		
	end
end)

net.Receive("NPC_STATS_send_Info", function(len, CLIENT) // Gets the NPCs info
	local npcID = net.ReadInt(16);
	local npcTable = net.ReadTable();
	
	timer.Simple(0.1, function() // Need to do another slight delay here so the entity becomes valid for the client
		local npc = Entity(npcID);
		if !IsValid(npc) then return; end
		
		NPC_STATS[npcID] = npcTable;
		npc.Name = (language.GetPhrase(npc:GetClass()));
	end);
end);

net.Receive("NPC_STATS_remove_Info", function(len, CLIENT) // Removes the NPCs info from the client's table
	local npcID = net.ReadInt(16);
	
	NPC_STATS[npcID] = nil;
end);
net.Receive("NPC_STATS_receive_Table", function(len, CLIENT) // First joining, you'll receive the table
	NPC_STATS = net.ReadTable();
end);