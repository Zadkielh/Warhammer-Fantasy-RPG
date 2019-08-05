PLUGIN.name = "DS Camera"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Custom Third Person Camera - Activated by pressing f"

hook.Add("PostPlayerLoadout", "ThirdPersonCamera_Zad", function(client)
	client.IsTargettingEnabled = false
end)

if CLIENT then
	local playerMeta = FindMetaTable("Player")

	local maxValues = {
		height = 30,
		horizontal = 30,
		distance = 100
	}
	
	function playerMeta:CanOverrideView()
		local entity = Entity(self:getLocalVar("ragdoll", 0))
		local ragdoll = self:GetRagdollEntity()
		if	(!IsValid(self:GetVehicle()) and
			IsValid(self) and
			self:getChar() and
			!self:getNetVar("actAng") and
			!IsValid(entity) and
			LocalPlayer():Alive()) 
		then
			return true
		end
	end

	local view, traceData, traceData2, aimOrigin, crouchFactor, ft, trace, curAng
	local clmp = math.Clamp
	crouchFactor = 0
	function PLUGIN:CalcView(client, origin, angles, fov)
		ft = FrameTime()
		
		if (client:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer()) then
			
			

			if ((client:OnGround() and client:KeyDown(IN_DUCK)) or client:Crouching()) then
				crouchFactor = Lerp(ft*5, crouchFactor, 1)
			else
				crouchFactor = Lerp(ft*5, crouchFactor, 0)
			end
			
			curAng = owner.camAng or Angle(0, 0, 0)
			view = {}
			traceData = {}
				traceData.start =	client:GetPos() + client:GetViewOffset() + 
									curAng:Up() * clmp(-10, 0, maxValues.height) + 
									curAng:Right() * clmp(0, -maxValues.horizontal, maxValues.horizontal) -
									client:GetViewOffsetDucked()*.5 * crouchFactor
				traceData.endpos = traceData.start - curAng:Forward() * clmp(100, 0, maxValues.distance)
				traceData.filter = client
			view.origin = util.TraceLine(traceData).HitPos
			aimOrigin = view.origin
			
			

			view.angles = curAng + client:GetViewPunchAngles()
			
			traceData2 = {}
				traceData2.start = 	aimOrigin
				traceData2.endpos = aimOrigin + curAng:Forward() * 65535
				traceData2.filter = client

			if (((owner:GetVelocity():Length() >= 10)) ) then
				client:SetEyeAngles((util.TraceLine(traceData2).HitPos - client:GetShootPos()):Angle())
			end
			
			--local TargetVector = self:CalcTargetting(view.origin,(util.TraceLine(traceData2).HitPos - client:GetShootPos()):Angle())

			--if client.IsTargettingEnabled and (TargetVector != nil )then
			--	view.angles = TargetVector:Angle()
			--end

			if (client:GetFOV() > 90) then
				client:SetFOV(90, 0)
			end

			

			return view
		end
	end

	local AllowedClasses = {
		"player",
		"npc_",
	}

	local function DistanceFromCenter(vec)
		local vec2 = vec:ToScreen()
		return math.Clamp((Vector(ScrW()/2, ScrH()/2, 0) - Vector(vec2.x, vec2.y, 0)):Length2D() / 1000, 0, 1)
	end

	local function CheckAim(vec)
		return LocalPlayer():EyeAngles():Forward():DotProduct((vec - LocalPlayer():EyePos()):GetNormalized())
	end

	local function FindValueInTable(tbl, target)
		for key, value in pairs(tbl) do
			if string.find(target, value) then
				return true
			end
		end
	end

	function PLUGIN:CalcTargetting(origin, dir)

		local positions = Vector(0, 0, 0)
		local count = 0

		for key, entity in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 500)) do
			if
				entity ~= LocalPlayer() and
				entity ~= LocalPlayer():GetVehicle() and
				FindValueInTable(AllowedClasses, entity:GetClass())
			then
				local point = entity:IsPlayer() and entity:GetShootPos() or entity:OBBCenter() + entity:GetPos()
				--if CheckAim(point) > 0.8 then
					positions = positions + point
					count = count + 1
				--end
			end
		end

		if count == 0 then return end

		local point = positions / count

		local multiplier = math.Clamp((DistanceFromCenter(point) * CheckAim(point)) + 0.5, 0.5, 1)

		local ang = LerpVector(multiplier * 100 / 100,	dir, (point - origin:GetNormalized()))
		return ang
	end

	local v1, v2, diff, fm, sm
	function PLUGIN:CreateMove(cmd)
		owner = LocalPlayer()

		if (owner:CanOverrideView() and owner:GetMoveType() != MOVETYPE_NOCLIP and LocalPlayer():GetViewEntity() == LocalPlayer()) then
			fm = cmd:GetForwardMove()
			sm = cmd:GetSideMove()
			diff = (owner:EyeAngles() - (owner.camAng or Angle(0, 0, 0)))[2] or 0
			diff = diff/90

			cmd:SetForwardMove(fm + sm*diff)
			cmd:SetSideMove(sm + fm*diff)
			return false
		end
	end

	function PLUGIN:InputMouseApply(cmd, x, y, ang)
		owner = LocalPlayer( )

		if (!owner.camAng) then
		    owner.camAng = Angle( 0, 0, 0 )
		end

		if (owner:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer()) then

			owner.camAng.p = clmp(math.NormalizeAngle( owner.camAng.p + y / 50 ), -85, 85)
			owner.camAng.y = math.NormalizeAngle( owner.camAng.y - x / 50 )

			return true
		end
	end

	function PLUGIN:ShouldDrawLocalPlayer()
		if (
			LocalPlayer():GetViewEntity() == LocalPlayer() and
			not IsValid(LocalPlayer():GetVehicle()) and
			LocalPlayer():CanOverrideView()
		) then
			return true
		end
	end
end

function PLUGIN:PlayerButtonDown( ply, button )
	local ran = false
	if ply:IsValid() and button == KEY_F and ran == false then
		ran = true
		timer.Simple(0.1, function()
			if (ply.IsTargettingEnabled) then
				ply.IsTargettingEnabled = false
			else
				ply.IsTargettingEnabled = true 
			end
			ran = false
		end)
	end
end
-- Configuration for the plugin
