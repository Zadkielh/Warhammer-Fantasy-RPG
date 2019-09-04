PLUGIN.name = "Party System"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = ""

nut.util.includeDir("libs")

nut.party = nut.party or {}
nut.party.list = nut.party.list or {}

if (SERVER) then
    
    util.AddNetworkString("openParty")

end

nut.command.add("party", {
    adminOnly = false,
    syntax = "",
    onRun = function(client, args)
        net.Start( "openParty" )
		net.Send( client )
    end
})

do
    local charMeta = nut.meta.character

    function charMeta:getParty()
        if (self) then
            return self:getData("Party")
        end
    end

    function charMeta:createParty(partyInfo)
        if (self) then
            party = nut.party.list[partyInfo.name] or {}

				party.name = partyInfo.name or "Unknown"
				party.desc = partyInfo.desc or "No description available."
                party.members = {}
                party.owner = self
                party.image = partyInfo.image or ""

				nut.party.list[partyInfo.name] = party
			party = nil 

            self:joinParty(partyInfo.name)

            if (#partyInfo.members > 0) then
                for k, v in pairs(partyInfo.members) do
                    net.Start("Party.SendInvite")
                        net.WriteTable(partyInfo)
                    net.Send(v)
                end
            end
        end
    end

    function charMeta:joinParty(party)
        if (self and nut.party.list[party]) then
            if !(self:getData("Party")) then
                local party = nut.party.list[party]
                party.members[#party.members + 1] = self
                self:setData("Party", party.name)
            end
        end
    end

    function charMeta:leaveParty(party)
        if (self and nut.party.list[party]) then
            local party = nut.party.list[party]
            if (party.members) then
                for k, v in pairs(party.members) do
                    if v == self then
                        party.members[k] = nil
                        self:setData("Party", nil)
                    end
                end
            end
        end
    end
end

if SERVER then
    util.AddNetworkString("Party.SendPartyTable")
    util.AddNetworkString("Party.SendInvite")
    util.AddNetworkString("Party.AcceptInvite")

    net.Receive("Party.SendPartyTable", function(len, ply)
        local partyInfo = net.ReadTable()
        local char = ply:getChar()
        if (char) then
            char:createParty(partyInfo)
        end
    end)

    net.Receive("Party.AcceptInvite", function(len, ply)
        local party = net.ReadTable()
        if (ply:getChar()) then
            ply:getChar():joinParty(party.name)
        end
    end)
end