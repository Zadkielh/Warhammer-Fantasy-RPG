PLUGIN.name = "Constitution "
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Adds a toughness attribute."

if (SERVER) then
	hook.Add("PostPlayerLoadout", "ConHealth", function(client)
			--client:SetMaxHealth(client:GetMaxHealth() + (client:getChar():getAttrib("con", 0) * 20) )
			client:SetHealth(client:Health() + (client:getChar():getAttrib("con", 0) * 20) )
	end)
end