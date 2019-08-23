PLUGIN.name = "Camera Plugin"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Custom Third Person Camera"

hook.Add("PostPlayerLoadout", "ThirdPersonCamera_Zad", function(client)
	client.IsTargettingEnabled = false
end)

if CLIENT then
	local playerMeta = FindMetaTable("Player")
	
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
		
		if (client:CanOverrideView() and LocalPlayer():GetViewEntity() == LocalPlayer()) then
			if (IsValid(client)) then
				local mul = 1
				local mul2 = mul/2
				local mul3 = mul/3
				local Trace2 = util.QuickTrace(client:GetPos()+Vector(0,0,60), client:GetAimVector() * -100 * mul, {client, client})
				distance = (client:GetPos()+Vector(0,0,60)):Distance(Trace2.HitPos + (Trace2.HitNormal * 2))
				local mul4 = distance
				local Trace = util.QuickTrace(client:GetPos()+Vector(0,0,60), client:GetAimVector() * -(mul4-1), {client, client})
				local View = {}
					
				View.angles = Angles
				startpoint = client:GetPos()+Vector(0,0,60)

				x1 = startpoint.x
				y1 = startpoint.y
				z1 = startpoint.z

				endpoint = Trace.HitPos + (Trace.HitNormal * 2)

				x2 = endpoint.x
				y2 = endpoint.y
				z2 = endpoint.z

				x3 = ((x1 + x2) / 2)
				y3 = ((y1 + y2) / 2)
				z3 = ((z1 + z2) / 2)

				x4 = ((x2 + x3) / 2)
				y4 = ((y2 + y3) / 2)
				z4 = ((z2 + z3) / 2)

				View.origin = Vector(x4, y4, z4) + (Trace.HitNormal * 2)
					
				client.FakePos = View.origin
				return View
			end
		end
	end

end

function PLUGIN:PlayerButtonDown( ply, button )

end
-- Configuration for the plugin
