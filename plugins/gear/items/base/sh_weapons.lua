ITEM.name = "Weapon"
ITEM.desc = "A Weapon."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "weapon_pistol"
ITEM.width = 2
ITEM.height = 2
ITEM.isWeapon = true
ITEM.weaponCategory = "sidearm"
ITEM.abilites = {
	Bewitched = false,
	Creature = false,
	Deathlust = false,
	Banishment = false
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
ITEM.playerClass = {

}
/*ITEM.properties = [[None]]*/
-- Inventory drawing
if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:hook("drop", function(item)
	if (item:getData("equip")) then
		item:setData("equip", nil)
		item.player.carryWeapons = item.player.carryWeapons or {}

		local weapon = item.player.carryWeapons[item.weaponCategory]

		if (IsValid(weapon)) then
			item:setData("ammo", weapon:Clip1())

			item.player:StripWeapon(item.class)
			item.player.carryWeapons[item.weaponCategory] = nil
			item.player:EmitSound("items/ammo_pickup.wav", 80)
		end
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	onRun = function(item)
		item.player.carryWeapons = item.player.carryWeapons or {}

		local weapon = item.player.carryWeapons[item.weaponCategory]

		if (!weapon or !IsValid(weapon)) then
			weapon = item.player:GetWeapon(item.class)	
		end

		if (weapon and weapon:IsValid()) then
			item:setData("ammo", weapon:Clip1())

            local ammo = weapon:GetPrimaryAmmoType()
           
            item:setData("reserve",  item.player:GetAmmoCount( ammo ))
		
			item.player:StripWeapon(item.class)
		else
			print(Format("[Nutscript] Weapon %s does not exist!", item.class))
		end

		item.player:EmitSound("items/ammo_pickup.wav", 80)
		item.player.carryWeapons[item.weaponCategory] = nil

		item:setData("equip", nil)

		if (item.onUnequipWeapon) then
			item:onUnequipWeapon(client, weapon)
		end

		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") == true)
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	onRun = function(item)
		local client = item.player
		local char = item.player:getChar()
		local items = client:getChar():getInv():getItems()
		for k, v in pairs(item.traits.attribReq) do
			local charValue = char:getAttrib(k)
			if charValue >= v then

			else
				item.player:notifyLocalized("You did not pass the attribute check, please check the requirements.") 
				return  false
				
			end
		end
		local bool = false 

		if (type(item.playerClass)) == "table" and #item.playerClass > 0 then
			for k, v in pairs(item.playerClass) do
				local class = char:getClass()
				if v == class then
					bool = true
				else
					bool = false
				end
			end
			if !(bool) then
				item.player:notifyLocalized("Wrong class.") 
				return false
			end
		end

		

		
		client.carryWeapons = client.carryWeapons or {}

		for k, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = nut.item.instances[v.id]
				
				if (!itemTable) then
					client:notifyLocalized("tellAdmin", "wid!xt")

					return false
				else
					if (itemTable.isWeapon and client.carryWeapons[item.weaponCategory] and itemTable:getData("equip")) then
						client:notifyLocalized("weaponSlotFilled")

						return false
					end
				end
			end
		end
		
		if (client:HasWeapon(item.class)) then
			client:StripWeapon(item.class)
		end

		local weapon = client:Give(item.class)

		if (IsValid(weapon)) then
			client.carryWeapons[item.weaponCategory] = weapon
			client:SelectWeapon(weapon:GetClass())
			client:SetActiveWeapon(weapon)
			client:EmitSound("items/ammo_pickup.wav", 80)


			-- Remove default given ammo.
            item.player:SetAmmo(item:getData("reserve", 0), weapon:GetPrimaryAmmoType())
            

			if (client:GetAmmoCount(weapon:GetPrimaryAmmoType()) == weapon:Clip1() and item:getData("ammo", 0) == 0) then
				client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			end

            
			item:setData("equip", true)

			weapon:SetClip1(item:getData("ammo", 0))

			if (item.onEquipWeapon) then
				item:onEquipWeapon(client, weapon)
			end
		else
			print(Format("[Nutscript] Weapon %s does not exist!", item.class))
		end
		item:CustomEquip(item, client)
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") != true)
	end
}

function ITEM:CustomEquip(item, client)

end

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if (newInventory and self:getData("equip")) then
		return false
	end

	return true
end

function ITEM:onLoadout()
	if (self:getData("equip")) then
		local client = self.player
		client.carryWeapons = client.carryWeapons or {}

		local weapon = client:Give(self.class)

		if (IsValid(weapon)) then
			client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			client.carryWeapons[self.weaponCategory] = weapon

			weapon:SetClip1(self:getData("ammo", 0))

		else
			print(Format("[Nutscript] Weapon %s does not exist!", self.class))
		end
	end
end

function ITEM:onSave()
	local weapon = self.player:GetWeapon(self.class)

	if (IsValid(weapon)) then
		self:setData("ammo", weapon:Clip1())
	end
end

HOLSTER_DRAWINFO = {}

-- Called after the item is registered into the item tables.
function ITEM:onRegistered()
	if (self.holsterDrawInfo) then
		HOLSTER_DRAWINFO[self.class] = self.holsterDrawInfo
	end
end

hook.Add("PlayerDeath", "nutStripClip", function(client)
	client.carryWeapons = {}

	for k, v in pairs(client:getChar():getInv():getItems()) do
		if (v.isWeapon and v:getData("equip")) then
			v:setData("ammo", nil)
            v:setData("reserve", nil)
		end
	end
end)

function ITEM:onRemoved()
	local inv = nut.item.inventories[self.invID]
	local receiver = inv.getReceiver and inv:getReceiver()

	if (IsValid(receiver) and receiver:IsPlayer()) then
        local weapon = receiver:GetWeapon(self.class)

        if (IsValid(weapon)) then
            weapon:Remove()
        end
	end
end