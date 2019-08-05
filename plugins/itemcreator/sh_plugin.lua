PLUGIN.name = "Item Creator"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Item Creator for Admins accompanied with a UI."

nut.util.includeDir("derma")
if SERVER then
	util.AddNetworkString("openItemCreator")
	util.AddNetworkString("itemCreatorCreateItem")
end

nut.command.add("itemcreator", {
    adminOnly = true,
    syntax = "",
    onRun = function(client, args)
        net.Start( "openItemCreator" )
		net.Send( client )
    end
})

net.Receive("itemCreatorCreateItem", function()
	--local ITEM = nut.item.register(uniqueID, nil, nil, nil, true)
end
)