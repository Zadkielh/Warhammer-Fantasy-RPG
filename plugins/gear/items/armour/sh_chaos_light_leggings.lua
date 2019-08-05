ITEM.name = "Chaos Light Leggings"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Armour"
ITEM.ability = {
}
ITEM.traits = {
	hp = 50,
	hpregen = 2.5,
	armorrating = 25,
	shield = 50,
    shieldregen = 5,
	damage = 0,
	attribReq = {
		str = 0,
		con = 0
	},
	speed = 20
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
	Class: All
	Strength: 0
	Constitution: 0

    ITEM STATS: <color=39, 174, 96>]] .. stats .. [[ </color> 
]]
ITEM.icon = nut.util.getMaterial("vgui/steellegs.png")
ITEM.armorCategory = "legs"
ITEM.outfitCategory = "legs"