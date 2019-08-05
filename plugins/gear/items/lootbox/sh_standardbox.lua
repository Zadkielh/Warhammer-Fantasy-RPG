ITEM.name = "Tactical Weapons Box (Standard)"
ITEM.class = {
	"tactical"
}
ITEM.model = "models/Items/hevsuit.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "An Loot Box dropping standard issue items."
ITEM.category = "Loot Boxes"
ITEM.boxType = "Standard" // Standard, Superior, Mastercrafted, Relic, Mastercrafted Relic
ITEM.itemTable = { -- [] Item key, Number Rarity 1-10

}


ITEM.functions.Use = {
	sound = "items/medshot4.wav",
	onRun = function(item)
		
	end
}