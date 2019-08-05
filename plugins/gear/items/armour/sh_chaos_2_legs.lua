ITEM.name = "Chaos Leggings"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Armour"
ITEM.ability = {
}
ITEM.traits = {
	hp = 150,
	hpregen = 5,
	armorrating = 50,
	shield = 150,
    shieldregen = 5,
	damage = 0,
	attribReq = {
		str = 0,
		con = 0
	},
	speed = 0
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
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
					[1] = {
							["children"] = {
							},
						["self"] = {
							["ModelIndex"] = 22,
							["UniqueID"] = "202228707",
							["AimPartUID"] = "",
							["Hide"] = false,
							["Name"] = "",
							["ClassName"] = "bodygroup",
							["OwnerName"] = "self",
							["IsDisturbing"] = false,
							["EditorExpand"] = false,
							["BodyGroupName"] = "legs",
						},
					},
				},
				["self"] = {
					["BoneMerge"]	=	true,
					["ClassName"]	=	"model",
					["Model"]	=	"models/zadkiel/chaos/objects/heavy_legs.mdl",
					["UniqueID"]	=	"1948360432",
				},		
			},		
		},
		["self"] = {
				["ClassName"]	=	"group",
				["EditorExpand"]	=	true,
				["Name"]	=	"my outfit",
				["UniqueID"]	=	"1683170537",
		},
	},
}

ITEM.bodyGroups = {
	["legs"] = 1,
}