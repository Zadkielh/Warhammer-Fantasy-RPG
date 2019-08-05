PLUGIN.name = "Fantasy Classes"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = ""

nut.classes = nut.classes or {}
nut.classes.list = nut.classes.list or {}
/*
nut.command.add("classes", {
    adminOnly = true,
    syntax = "",
    onRun = function(client, args)
        net.Start( "openClassMenu" )
		net.Send( client )
    end
})*/
nut.command.add("resetclass", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target =  nut.command.findPlayer(client, args[1]) or client
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		char:setClass(nil)
    end
})
nut.command.add("getclass", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target =  nut.command.findPlayer(client, args[1]) or client
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		print(char:getClass())
    end
})

	nut.flag.add("*", "Psyker flag")
	nut.flag.add("+", "Chaplain flag")
	nut.flag.add("-", "Techmarine flag")
	nut.flag.add("1", "Aggressor flag")
	nut.flag.add("2", "Inceptor flag")
	nut.flag.add("3", "Intercessor flag")
	nut.flag.add("4", "Reiver flag")
	nut.flag.add("?", "Allows 10 Characters")

function PLUGIN:GetMaxPlayerCharacter(client)
	
	if (client:getChar()) and (client:getChar():hasFlags("?")) then
		return 10
	else
		return 5
	end

end


	function nut.classes.loadFromDir(directory)
			for k, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
				local niceName = v:sub(4, -5)

				CLASS = nut.classes.list[niceName] or {}

					nut.util.include(directory.."/"..v)

					CLASS.name = CLASS.name or "Unknown"
					CLASS.desc = CLASS.desc or "No description available."
					CLASS.faction = CLASS.faction or FACTION_REC
					
					nut.classes.list[niceName] = CLASS
				CLASS = nil 
			end
		end
	
		nut.classes.loadFromDir("warhammer-fantasy-rpg/plugins/fantasy_classes/class")

local charMeta = nut.meta.character
function charMeta:getClass()
	local Class = self:getData("Class", nil)
	return Class
end

if SERVER then
	function charMeta:setClass(class)

		if (self:canJoinClass(class)) then
			self:OnJoinClass(class)
			self:setData("Class", class)
			self:getPlayer():notifyLocalized("Class Joined")
		end

		if class == nil then 
			self:setData("Class", class)
			return
		end
	end
end

function charMeta:canJoinClass(class)
	local Class = self:getClass()
	if Class != nil then print("ErrorCanJoinClass.NotFalse") return false end
	if Class == class then
		print("ErrorCanJoinClass.SameClass")
		return false
	end
	
	if (class.flagReq) then
		if !self:hasFlags(class.flagReq) then 
			self:getPlayer():notifyLocalized("Class requirements not met.")
			return false
		end
	end

	return true

end

function charMeta:OnJoinClass(class)
	local class = nut.classes.list[class]
	local attribs = class.attribs

		if (attribs) then
			for k, v in pairs(attribs) do
				self:setAttrib(k, v)
			end
		end
end

if (SERVER)	then
	netstream.Hook("SetClass", function(client, data)
		local character = client:getChar()
		if (character) then
			character:setClass(data.class)
			
		end
	end)

	net.Receive( "ClassUpdatePac", function(num, client)
		netstream.Start(client, "updatePAC")
		client:resetParts()
	end)
end
	
function PLUGIN:ConfigureCharacterCreationSteps(panel)
	panel:addStep(vgui.Create("nutCharacterClasses"), 4)
end

function PLUGIN:GetStartAttribPoints(ply, value)
	return 0
end
	
hook.Add( "OnCharCreated", "SetupClass", function(client, char, data)

	--PrintTable(data)
	if (data.class) then
		local attribs = nut.classes.list[data.class].attribs
		netstream.Start("SetClass", {
			id = id,
			class = data.class
		})
		for k, v in pairs(attribs) do
			char:updateAttrib(k, v)
		end

		if (nut.classes.list[data.class].model) then
			char:setModel(nut.classes.list[data.class].model)
		end
		
		if (istable(nut.classes.list[data.class].bodygroups)) then
			local groups = char:getData("groups", {})
			for k, v in pairs(nut.classes.list[data.class].bodygroups) do
				groups[k] = v
			end
			char:setData("groups", groups)
		end

	end

end
)
nut.char.registerVar("class", {
	field = "_class",
	default = "tactical",
})
do
	if (SERVER) then
		
		

		local SQLITE_ALTER_TABLES = [[
			ALTER TABLE nut_characters ADD COLUMN _class TEXT
		]]

		local MYSQL_ALTER_TABLES = [[
			ALTER TABLE nut_characters ADD COLUMN _class VARCHAR(30) AFTER _attribs;
		]]
		nut.db.waitForTablesToLoad()
			:next(function() 
				print("QUERY - CLASS") 
				nut.db.query(SQLITE_ALTER_TABLES)
				:catch(function() end)
			end)
			:catch(function() end)
			--if (nut.db.module) then
				--nut.db.query(MYSQL_ALTER_TABLES)
			--else

	end
end