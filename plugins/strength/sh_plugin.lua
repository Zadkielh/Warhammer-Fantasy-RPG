PLUGIN.name = "Strength"
PLUGIN.author = "Chessnut"
PLUGIN.desc = "Adds a strength attribute."

if (SERVER) then
	function PLUGIN:PlayerGetFistDamage(client, damage, context)
		if (client:getChar()) then
			-- Add to the total fist damage.
			context.damage = context.damage + (client:getChar():getAttrib("str", 0) * 1.5)
		end
	end
	function PLUGIN:PlayerThrowPunch(client, hit)
		return
	end
end

-- Configuration for the plugin