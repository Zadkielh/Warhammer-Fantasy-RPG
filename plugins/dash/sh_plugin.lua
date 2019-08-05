PLUGIN.name = "Dash"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Enables dashing"

if (SERVER) then
	function PLUGIN:PostPlayerLoadout(client)
	local uniqueID = "nutDash"..client:SteamID()
		client:setNetVar("dash", false)
		client:SetNWBool("CanPound", false)
		timer.Create( uniqueID, 1, 0, function()
			client:setNetVar("dash", false)
		end
		)
	end
	
	function PLUGIN:Move(client, moveData)
	local ang = moveData:GetMoveAngles()
	local pos = moveData:GetOrigin()
	local vel = moveData:GetVelocity()
	local char = client:getChar()

						
	local tr = util.TraceLine({
		start = client:GetPos(),
		endpos = client:GetPos() - Vector(0, 0, 35000),
		filter = client
	})
	local groundpos = tr.HitPos
		

		if (moveData:KeyDown(IN_WALK)) then
			if (client:getChar():hasSkill("dash")) then 
				if client:GetVelocity():Length() < 100 then return end
			
				if client:IsOnGround() then
					if !client:getNetVar("dash") then
					local value = (25 - ((char:getAttrib("end", 0) * 0.1)))

					if client:getLocalVar("stm") <= value then client:setNetVar("dash", true) return end
				
					local value = client:getLocalVar("stm") - (25 - ((char:getAttrib("end", 0) * 0.1)))
					client:setLocalVar("stm", value)
				
					client:setNetVar("dash", true)
					local speed = 0.1 + (char:getAttrib("dex", 0) * 0.0005)
				
					vel = vel + ang:Forward() * moveData:GetForwardSpeed() * speed
					vel = vel + ang:Right() * moveData:GetSideSpeed() * speed
					vel = vel + ang:Up() * moveData:GetUpSpeed() * speed
				
					moveData:SetVelocity( vel - Vector(0, 0, 5000) )
					
					end
				end
			elseif (client:getChar():hasSkill("leap")) then
				if client:GetVelocity():Length() < 100 then return end
			
				if client:IsOnGround() then
					if !client:getNetVar("dash") then
					local value = (40 - ((char:getAttrib("end", 0) * 0.1)))

					if client:getLocalVar("stm") <= value then client:setNetVar("dash", true) return end
				
					local value = client:getLocalVar("stm") - (40 - ((char:getAttrib("end", 0) * 0.1)))
					client:setLocalVar("stm", value)
				
					client:setNetVar("dash", true)
					local speed = 0.1 + (char:getAttrib("str", 0) * 4)

					vel = vel + ang:Forward() * speed
					vel = vel + ang:Up() * moveData:GetUpSpeed() * speed
					
					moveData:SetVelocity( vel + Vector(0, 0, 500) )
					
					
					end
				end
			end

			if client:GetPos():Distance(groundpos) > 800 then
				if (!client:IsOnGround()) and (client:getChar():hasSkill("assault_slam")) then
					client:SetNWBool("CanPound", true)
					moveData:SetVelocity( vel - Vector(0, 0, 400))
				end
			end
		end
	end
	
	hook.Add("GetFallDamage", "DeathWatchFallDamage", function(ply,spd)

		if ply:GetNWBool("CanPound") then
			ply:GodEnable()
			timer.Simple(0.5, function()
				ply:GodDisable()
			end)
									
			local ef = EffectData()
			ef:SetOrigin(ply:GetPos())
			ef:SetScale(600)
			util.Effect("ThumperDust",ef,true,true)
			util.Effect("zad_medium_explosion",ef,true,true)
			util.Effect("ThumperDust",ef,true,true)
			util.Effect("ThumperDust",ef,true,true)
			ply:EmitSound("ambient/explosions/explode_4.wav",511,35)
														
			util.BlastDamage(ply,ply,ply:GetPos(),spd/6,1000)

			ply:SetNWBool("CanPound", false)
			return 0
												
		end

		if ply:GetNWBool("JumpPackEnabled") then
			return 0
		end

		return (spd - 580) * (100 / 444)
	end)
	
end


function PLUGIN:HUDPaintBackground()
	if !(LocalPlayer():getChar()) then return end

	local tr = util.TraceLine({
			start = LocalPlayer():GetPos(),
			endpos = LocalPlayer():GetPos() - Vector(0, 0, 35000),
			filter = LocalPlayer()
		})
	local groundpos = tr.HitPos

	local x = ScrW() * 0.95
	local y = ScrH() * 0.6
	local w = 50
	local h = 250
	local red = 255
	local blue = 0
	local green = 205
	local opacity = 150
	
	if LocalPlayer():GetNWBool("JumpPackEnabled") then
		
		
		local value = LocalPlayer():GetAmmoCount("AirboatGun")

		if value <= 750 then
			blue = 0
			green = 50
			red = 250
			opacity = 150
		end

		if value >= 120 then
			blue = 0
			green = 255
			red = 50
			opacity = 150
		end

		if value < 10 then
			blue = 0
			green = 255
			red = 50
			opacity = 0
		end

		draw.RoundedBox(8, x - 5, y - 5, w + 10, h + 10, Color(10, 10, 10, 230))
		draw.RoundedBox(8, x, y, w, math.max(h * value / 150, 20), Color(red, green, blue, opacity))

	
	end
	
	if LocalPlayer():GetPos():Distance(groundpos) > 800 and LocalPlayer():getChar():hasSkill("assault_slam") then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("vgui/skills/Dow2_sm_jump_icon.png"))
		surface.DrawTexturedRect(x - 8, y - 72, 64, 64)
	end
end