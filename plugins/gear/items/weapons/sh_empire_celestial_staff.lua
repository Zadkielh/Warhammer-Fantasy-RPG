ITEM.name = "Celestial Staff"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Melee"
ITEM.weaponCategory = "melee"
ITEM.class = "weapon_mage_fire_staff"

ITEM.width = 1
ITEM.price = 0
ITEM.height = 1
ITEM.icon = nut.util.getMaterial("vgui/inv_sword_05.png")

ITEM.playerClass = {
	"celestial_wizard"
}

ITEM.traits = {
	hp = 0,
	hpregen = 0,
	armorrating = 0,
	shield = 0,
    shieldregen = 0,
	damage = 0,
	attribReq = {
		str = 0,
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
	Level: 0
	Class: All
	Strength: 0

    ITEM STATS: <color=39, 174, 96>]] .. stats .. [[ </color> 
]]

function ITEM:CustomEquip(item, client)	
	local weaponTable = client:GetActiveWeapon():GetTable()
	local weaponBase = weaponTable.Base
	local hp, hpregen, armorrating, shield, shieldregen, damage, attribs = item:getItemStats()

	if weaponBase == "tfa_melee_base" then
		local weaponMeleeAttacksPrimary = weaponTable.Primary.Attacks
		--PrintTable(weaponMeleeAttacksPrimary)
		for k, v in pairs(weaponMeleeAttacksPrimary) do
			if (v.dmg) then
				v.dmg = v.dmg + damage
			end
		end
	elseif weaponBase == "tfa_gun_base" then
        print(client:GetActiveWeapon())
        print(weaponTable.Primary.Damage)
        weaponTable.Primary.Damage = weaponTable.Primary.Damage + damage
        print(weaponTable.Primary.Damage)
    end

end
