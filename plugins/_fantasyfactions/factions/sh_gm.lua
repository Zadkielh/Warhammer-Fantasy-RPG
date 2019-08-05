FACTION.name = "Game Master"
FACTION.desc = ""
FACTION.color = Color(237, 179, 97)
FACTION.isDefault = false
FACTION.models = {
	"models/breen.mdl"
}
FACTION.maxhealth = 100
FACTION.health = 100

function FACTION:onSpawn(client)
		client:SetMaxHealth(self.maxhealth) -- Sets maxhealth, that means the health you can be healed to.
		client:SetHealth(self.health) -- Sets your health, you can not be healed to this amount unless your maxhealth is the same. This is needed because gmod sets your health to 100 by default.
end
FACTION.pay = 0
FACTION.isGloballyRecognized = true
FACTION.payTime = 0

FACTION_ADMIN = FACTION.index