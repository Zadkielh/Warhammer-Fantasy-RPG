ITEM.name = "Lootbox base"
ITEM.model = "models/Items/hevsuit.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "An Item"
ITEM.category = "Loot Boxes"
ITEM.boxType = "Standard" // Standard, Superior, Mastercrafted, Relic, Mastercrafted Relic
/*

ITEM.itemTable = { -- [] Item key, Number Rarity 1-10
// Melee
	["chainsword"],
	["crozius"],
	["chainaxe"],
	["forcesword"],
	["shield"],
	["poweraxe"],
	["powerfist"],
	["powerspear"],
	["powersword"],
	["shield_termi"],
	["combatknife"],
	["thunderhammer"],
// Ranged
	["boltpistol"], 
	["rocketlauncher_ist"],
	["ist_shotgun"],
	["bolter_superior"],
	["laspistol"],
	["heavybolter"],
	["bolter_mastercrafted_relic"],
	["hellpistol"],
	["lascannon"],
	["plasmapistol"],
	["plasmagun"],
	["plasmacannon"],
	["phobosbolter"],
	["meltagun"],
	["lascarbine"],
	["lascarbinemk2"],
	["hot_longlas"],
	["bolter_mastercrafted"],
	["lasgun"],
	["hellgun"],
	["rocketlauncher"],
	["astartesshotgun"],
	["sniper"],
	["stalkerbolter"],
	["fraglauncher"],
	["volkite"],
	["dualbolterpistol"],
	["flamer"],
	["bolter"],
	["stormbolter"],
	["bolter_relic"],
	["longlas"],
// Special
	["primaris_boltpistol"],
	["flamergauntlet"],
	["primaris_assault"],
	["heavyflamer"],
	["primaris_boltcarbine"],
	["primaris_heavy_pistol"],
	["primaris_boltrifle"],
	["boltergauntlet"],
// Armour
	["mk7_relic"],
	["mk7_tech_mastercrafted_relic"],
	["mk7_chap_mastercrafted"],
	["mk7_superior"],
	["mk7_tech_mastercrafted"],
	["mk7_apoth_mastercrafted_relic"],
	["mk7_apoth_relic"],
	["mk7_tech_relic"],
	["mk7_apoth_standard"],
	["mk7_standard"],
	["mk7_apoth_superior"],
	["mk7_chap_superior"],
	["mk7_tech_standard"],
	["mk7_tech_superior"],
	["mk7_chap_standard"],
	["mk7_mastercrafted_relic"],
	["mk7_chap_mastercrafted_relic"],
	["mk7_chap_relic"],
	["mk7_apoth_mastercrafted"],
	["mk7_mastercrafted"],
}*/
ITEM.functions.Use = {
	sound = "items/medshot4.wav",
	onRun = function(item)
		net.Start("lootBoxOpen")
			net.WriteString(item.boxType)
		net.Send(ply)
	end
}