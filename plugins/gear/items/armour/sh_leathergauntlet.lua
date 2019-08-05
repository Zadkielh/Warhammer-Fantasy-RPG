ITEM.name = "Leather Gauntlet"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Armour"
ITEM.ability = {
}
ITEM.traits = {
	hp = 20,
	hpregen = 0,
	armorrating = 10,
	shield = 5,
    shieldregen = 0.1,
	damage = 2,
	attribReq = {
		str = 0,
		con = 5
	}
}
local hp, hpregen, armorrating, shield, shieldregen, damage, attribs = ITEM:getItemStats()
local stats = [[

	<color=220, 20, 60> +]] .. hp .. [[ HP </color>
	<color=227, 56, 52> +]] .. hpregen .. [[ HP/5s </color>
	<color=255, 153, 51> ]] .. armorrating .. [[ Armor Rating </color>
	<color=255, 204, 0> +]] .. shield .. [[ Shield </color>
	<color=255, 255, 0> +]] .. shieldregen .. [[ Shield/5s </color>
	<color=204, 255, 255> +]] .. damage .. [[ Damage </color>

	<color=100, 205, 100> ]] .. table.ToString(attribs, "Attribute Requirements", true) .. [[ </color>


]]
ITEM.desc = [[
    This set of armor has a coif with a rounded opening for the eyes, which curves downwards into a narrow opening at the mouth. Attached to its side are straight rows of small metal spikes.
    The shoulders are squared, wide and moderate in size. They're decorated with thick animal fur, a different type on each side.

    ITEM STATS: <color=39, 174, 96>]] .. stats .. [[ </color> 
]]
ITEM.armorCategory = "hands"