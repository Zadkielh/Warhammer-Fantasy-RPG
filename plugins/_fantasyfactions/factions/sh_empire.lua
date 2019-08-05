FACTION.name = "Empire"
FACTION.desc = ""
FACTION.color = Color(255, 128, 0)
FACTION.isDefault = true
FACTION.models = {
	"models/zadkiel/deathwatch/players/deathwatch_mk7_aquila_player.mdl"
}
FACTION.maxhealth = 100
FACTION.health = 100

function FACTION:onSpawn(client)
		client:SetMaxHealth(self.maxhealth) -- Sets maxhealth, that means the health you can be healed to.
		client:SetHealth(self.health) -- Sets your health, you can not be healed to this amount unless your maxhealth is the same. This is needed because gmod sets your health to 100 by default.
end

FACTION.pay = 0
FACTION.payTime = 1000000000000000
FACTION.isGloballyRecognized = true
FACTION_EMPIRE = FACTION.index