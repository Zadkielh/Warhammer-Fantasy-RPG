ITEM.name = "Template" -- Item Name
ITEM.model = "models/Gibs/HGIBS.mdl" -- Model in game when you drop it.
ITEM.width = 1 -- Size in inventory, don't change these
ITEM.height = 1 -- ^
ITEM.category = "Armour" -- Business category, don't change
ITEM.ability = { -- Ignore
}
ITEM.traits = {
	hp = 0, -- Extra HP on Spawn
	hpregen = 0, -- 5 = 5 HP per 5s 10 = 10 HP per 5s etc. 
	armorrating = 0, -- This reduces damage. armorrating / 50 = damage reduction so 100/50 is 2 damage reduced.
	shield = 0, -- Typical GMOD armor
    shieldregen = 0, -- Regen per 5s
	damage = 0, -- Extra damage
}
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
    This set of armor has a coif with a rounded opening for the eyes, which curves downwards into a narrow opening at the mouth. Attached to its side are straight rows of small metal spikes.
    The shoulders are squared, wide and moderate in size. They're decorated with thick animal fur, a different type on each side.

    ITEM STATS: <color=39, 174, 96>]] .. stats .. [[ </color> 
]] -- Edit the point above Item Stats to the item description, make it good.
ITEM.armorCategory = "hands" -- Armor Category, use hands, helmet, chest or legs.

ITEM.icon = nut.util.getMaterial("vgui/steelarmor.png") -- Put the name of your icon after vgui/