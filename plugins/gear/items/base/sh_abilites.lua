ITEM.name = "Armour base"
ITEM.model = "models/Items/hevsuit.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "An Item"
ITEM.category = "Armour"
ITEM.ability = {

}
ITEM.traits = {
	hp = 0,
	hpregen = 0,
	armorrating = 0,
	shield = 0,
    shieldregen = 0,
	damage = 0,
}

ITEM.armorCategory = "helmet"

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
		if (item:getData("shield")) then
			local armor = item:getData("shield") or 100
			draw.SimpleText(item:getData("shield") .. "", "nutSmallFont", x, y, Color((255 / 100) * (100 - shield), (255 / 100) * shield, 0, 255))
			if item:getData("shield") == 0 then
				surface.SetDrawColor(255, 110, 110, 100)
				surface.DrawRect(w - 14, h - 14, 8, 8)
			end
		end
	end
end

do

    local itemMeta = nut.meta.item
    function itemMeta:getItemStats()
        local traits = self.traits
             
        return traits.hp, traits.hpregen, traits.armorrating, traits.shield,  traits.shieldregen,  traits.damage--, traits.faction
    end

end

ITEM:hook("drop", function(item)
	if (item:getData("equip")) then
		item:setData("equip", nil)

		item.player.armorSlots = item.player.armorSlots or {}

		local armor = client.armorSlots[item.armorCategory]

		if (IsValid(armor)) then

			item.player.armorSlots[item.armorCategory] = nil
			item.player:EmitSound("items/ammo_pickup.wav", 80)
		end
	end
end)
		

ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	onRun = function(item)
		local char = item.player:getChar()
		/*for k, v in pairs(item.traits.faction) do
			if v != char:getFaction() then 
				item.player:notify("Invalid Faction")
				return false
			else
				break
			end
		end
		
		
*/		
		local items = item.player:getChar():getInv():getItems()
		item.player.armorSlots = item.player.armorSlots or {}

		local armor = item.player.armorSlots[item.armorCategory]

		for k, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = nut.item.instances[v.id]
				
				if (!itemTable) then
					item.player:notifyLocalized("tellAdmin", "wid!xt")

					return false
				else
					if (item.player.armorSlots[item.armorCategory] and itemTable:getData("equip")) then
						item.player:notifyLocalized("armorSlotFilled")

						return false
					end
				end
			end
		end

		item.player.armorSlots[item.armorCategory] = item.name
			
			item:setData("equip", true)
			item.player:notify("Equiping item")
			
		
			return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") != true)
	end
}

ITEM.functions.EquipUn = {
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	onRun = function(item)
	item.player.armorSlots = item.player.armorSlots or {}

	item.player.armorSlots[item.armorCategory] = nil

		item.player:notify("Unequiping item")
		
		item:setData("equip", nil)
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") == true)
	end

}