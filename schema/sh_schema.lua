SCHEMA.name = "Warhammer Fantasy"
SCHEMA.introName = "Warhammer Fantasy"
SCHEMA.author = "Zadkiel"
SCHEMA.desc = ""

nut.currency.set("", "Crown", "Crowns")

nut.util.includeDir("libs")
nut.util.includeDir("lua/commands")
nut.util.include("lua/sh_flags.lua")
nut.util.include("lua/sh_models.lua")
nut.util.includeDir("lua/server")
--nut.util.includeDir("derma")
print([[

////////////////////////////////////////////
//// Zadkiel's Schema has been loaded	////
//// succesfully, if there are any		////
//// problems, report them to Zadkiel	////
////									////
//// Have a good day!					////
////									////
////////////////////////////////////////////

]]
)




local vCat = "Warhammer Fantasy"
VJ.AddNPC("Innkeeper","sent_zad_innkeeper",vCat)




function SCHEMA:GetGameDescription()
	return "Warhammer: Tides of Battle"
end

function SCHEMA:PlayerSwitchFlashlight(client, enabled)
		return true
end

function SCHEMA:GetSalaryInterval(client, faction)
	return 0
end

function SCHEMA:EntityTakeDamage(client, dmg)
	if IsValid(client) and client:IsPlayer() then
		local uniqueID = "HPRegen"..client:SteamID()
	    if timer.Exists(uniqueID) then
		    timer.Stop(uniqueID)
	    end
		if timer.Exists(uniqueID.."HPRegenRestart") then
			timer.Remove(uniqueID.."HPRegenRestart")
		end
	    timer.Create(uniqueID.."HPRegenRestart", 5, 1, function()
	    	timer.Start(uniqueID)
    	end)
    end
end

--------------------------------------------------------------------------------------------------------------------------------------------
function HideThings( name )
	if (name == "CHudDamageIndicator" ) then
		return false
	end

	/*
	if (name == "CHudWeaponSelection" ) then
		return false
	end*/
	
end
hook.Add( "HUDShouldDraw", "HideThings", HideThings ) 
/*

function SCHEMA:PlayerLoadedChar(client, netChar, prevChar)
    if (prevChar) then
        client:notifyLocalized("Loaded Character")
    end

	
    local char = client:getChar()
	
	
    if (char) then
       return char
    end
end
*/
----------------------------
---- Spawn related ---------
----------------------------


function SCHEMA:PostPlayerLoadout(client)
	--nut.trait.onSpawn(client)
	if !client:getChar():hasFlags("P") then
		client:getChar():giveFlags("P")
	end
	if client:HasGodMode() then
		client:GodDisable()
	end
end