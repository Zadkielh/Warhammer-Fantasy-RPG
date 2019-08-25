ITEM.name = "Empire Mage Platemail (Uncommon)"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Armour"
ITEM.ability = {
}
ITEM.traits = {
	hp = 300,
	hpregen = 5,
	armorrating = 75,
	shield = 200,
    shieldregen = 15,
	damage = 0,
	attribReq = {
		str = 0,
		con = 0
	},
	speed = 0
}
ITEM.levelRequirement = 0
ITEM.class = {
	"bright_wizard",
	"celestial_wizard"
}
local hp, hpregen, armorrating, shield, shieldregen, damage, attribs = ITEM:getItemStats()
local stats = [[

	<color=220, 20, 60> +]] .. hp .. [[ HP </color>
	<color=227, 56, 52> +]] .. hpregen .. [[ HP/5s </color>
	<color=255, 153, 51> ]] .. armorrating .. [[ Armor Rating </color>
	<color=255, 204, 0> +]] .. shield .. [[ Shield </color>
	<color=255, 255, 0> +]] .. shieldregen .. [[ Shield/5s </color>
	<color=204, 255, 255> +]] .. damage .. [[ Damage </color>

]]
ITEM.desc = [[
	Level: 0
	Class: Bright Wizard, Celestial Wizard
    ITEM STATS: <color=39, 174, 96>]] .. stats .. [[ </color> 
]]
ITEM.icon = nut.util.getMaterial("vgui/steelarmor.png")
ITEM.armorCategory = "torso"
ITEM.outfitCategory = "torso"