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
	attribReq = {
		str = 0
	}
}
ITEM.outfitCategory = "head"
ITEM.pacData = {}
ITEM.armorCategory = "head"

ITEM.bodyGroups = {
	["head"] = 1,
}

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
             
        return traits.hp, traits.hpregen, traits.armorrating, traits.shield,  traits.shieldregen,  traits.damage, traits.attribReq
    end

end

ITEM:hook("drop", function(item)
	if (item:getData("equip")) then
		item:setData("equip", nil)
		item:removePart(item.player)
		item.player.armorSlots = item.player.armorSlots or {}

		local armor = item.player:Armor()
		item.player:SetArmor(armor - item.traits.shield)
		item.player:HealthRegeneration()

		local armor = item.player.armorSlots[item.armorCategory]

		if ((armor)) then

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
		for k, v in pairs(item.traits.attribReq) do
			local charValue = char:getAttrib(k)
			if charValue >= v then

			else
				item.player:notifyLocalized("You did not pass the attribute check, please check the requirements.") 
				return  false
				
			end
		end

		if (item.levelRequirement) then
			if (char:getLevel() < item.levelRequirement) then
				item.player:notifyLocalized("Your level is too low to equip this equipment.") 
				return  false
			end
		end

		if (item.class) then
			
			if (istable(item.class)) then
				local bool = false
				for k, v in pairs(item.class) do
					print(v, char:getClass())
					if char:getClass() == v then
						bool = true
						break
					end
				end

				if !(bool) then
					item.player:notifyLocalized("Wrong Class.") 
					return false
				end
			elseif char:getClass() != item.class then
				item.player:notifyLocalized("Wrong Class.") 
				return false
			end
			
		end
		
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

		if (item.bodyGroups) then
			local groups = {}

			for k, value in pairs(item.bodyGroups) do
				local index = item.player:FindBodygroupByName(k)

				if (index > -1) then
					groups[index] = value
				end
			end

			local newGroups = char:getData("groups", {})

			for index, value in pairs(groups) do
				newGroups[index] = value
				item.player:SetBodygroup(index, value)
			end

			if (table.Count(newGroups) > 0) then
				char:setData("groups", newGroups)
			end
		end

		item.player:addPart(item.uniqueID, item)
		item.player.armorSlots[item.armorCategory] = item.name
			
			item:setData("equip", true)
			item.player:notify("Equiping item")
			
			item.player:HealthRegeneration()
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
	item:removePart(item.player)
	item.player.armorSlots = item.player.armorSlots or {}
	item.player.armorSlots[item.armorCategory] = nil
	local armor = item.player:Armor()
		item.player:notify("Unequiping item")
		item.player:SetArmor(armor - item.traits.shield)
		item.player:HealthRegeneration()
		item:setData("equip", nil)
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") == true)
	end

}

function ITEM:removePart(client)
	local char = client:getChar()
	
	self:setData("equip", false)
	client:removePart(self.uniqueID)

	if (self.attribBoosts) then
		for k, _ in pairs(self.attribBoosts) do
			char:removeBoost(self.uniqueID, k)
		end
	end

	for k, v in pairs(self.bodyGroups or {}) do
		local index = client:FindBodygroupByName(k)

		if (index > -1) then
			client:SetBodygroup(index, 0)

			local groups = char:getData("groups", {})

			if (groups[index]) then
				groups[index] = nil
				char:setData("groups", groups)
			end
		end
	end
end

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if (newInventory and self:getData("equip")) then
		return false
	end

	return true
end

function ITEM:onLoadout()
	if (self:getData("equip") and self.player.addPart) then
		self.player:addPart(self.uniqueID)
	end
end

function ITEM:onRemoved()
	local inv = nut.item.inventories[self.invID]
	local receiver = inv.getReceiver and inv:getReceiver()

	if (IsValid(receiver) and receiver:IsPlayer()) then
		if (self:getData("equip")) then
			self:removePart(receiver)
		end
	end
end