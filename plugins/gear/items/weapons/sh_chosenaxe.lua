ITEM.name = "Chosen Axe (Rare)"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Melee"
ITEM.weaponCategory = "melee"
ITEM.class = "tfa_zad_chaos_chosen_axe"

ITEM.ability = {
}
ITEM.traits = {
	hp = 0,
	hpregen = 15,
	armorrating = 0,
	shield = 0,
    shieldregen = 10,
	damage = 10,
	attribReq = {
		str = 15,
		con = 0
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

]]
ITEM.desc = [[

    ITEM STATS: <color=39, 174, 96>]] .. stats .. [[ </color> 
]]
--ITEM.icon = nut.util.getMaterial("vgui/steelarmor.png")