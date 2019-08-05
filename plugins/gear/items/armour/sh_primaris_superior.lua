ITEM.name = "MK X Tacticus - Superior" -- Item Name
ITEM.model = "models/Gibs/HGIBS.mdl" -- Model in game when you drop it.
ITEM.width = 3 -- Size in inventory, don't change these
ITEM.height = 4 -- ^
ITEM.category = "Armour" -- Business category, don't change
ITEM.ability = { -- Ignore
}
ITEM.traits = {
	hp = 2500, -- Extra HP on Spawn
	hpregen = 10, -- 5 = 5 HP per 5s 10 = 10 HP per 5s etc. 
	armorrating = 750, -- This reduces damage. armorrating / 50 = damage reduction so 100/50 is 2 damage reduced.
	shield = 2000, -- Typical GMOD armor
    shieldregen = 25, -- Regen per 5s
	damage = 0, -- Extra damage
	attribReq = {
		str = 50,
		con = 50
	}
}
ITEM.levelRequirement = 20
ITEM.class = "intercessor"

local hp, hpregen, armorrating, shield, shieldregen, damage = ITEM:getItemStats() -- Ignore
local stats = [[

	<color=220, 20, 60> +]] .. hp .. [[ HP </color>
	<color=227, 56, 52> +]] .. hpregen .. [[ HP/5s </color>
	<color=255, 153, 51> ]] .. armorrating .. [[ Armor Rating </color>
	<color=255, 204, 0> +]] .. shield .. [[ Shield </color>
	<color=255, 255, 0> +]] .. shieldregen .. [[ Shield/5s </color>
	<color=204, 255, 255> +]] .. damage .. [[ Damage </color>

]]
ITEM.desc = [[
	Level: 20
	Class: Intercessor
	Strength: 50
	Constitution: 50

    ITEM STATS: <color=39, 174, 96>]] .. stats .. [[ </color> 
]] -- Edit the point above Item Stats to the item description, make it good.
ITEM.armorCategory = "full" -- Armor Category, use hands, helmet, chest or legs.

ITEM.icon = nut.util.getMaterial("icons/armour/primaris_blue.png") -- Put the name of your icon after vgui/