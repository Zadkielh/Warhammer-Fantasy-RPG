ITEM.name = "Empire Helmet (Uncommon)"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Armour"
ITEM.ability = {
}
ITEM.traits = {
	hp = 250,
	hpregen = 5,
	armorrating = 50,
	shield = 175,
    shieldregen = 5,
	damage = 0,
	attribReq = {
		str = 0,
		con = 0
	},
	speed = 0
}
ITEM.levelRequirement = 5
ITEM.class = {
	"statestroop",
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
	Level: 5
	Class: All
	Strength: 0
	Constitution: 0

    ITEM STATS: <color=39, 174, 96>]] .. stats .. [[ </color> 
]]
ITEM.icon = nut.util.getMaterial("vgui/steelhelm.png")
ITEM.armorCategory = "head"
ITEM.outfitCategory = "head"
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
					[1] = {
							["children"] = {
							},
							["self"] = {
								["ModelIndex"] = 9,
								["UniqueID"] = "202228707",
								["AimPartUID"] = "",
								["Hide"] = false,
								["Name"] = "",
								["ClassName"] = "bodygroup",
								["OwnerName"] = "self",
								["IsDisturbing"] = false,
								["EditorExpand"] = false,
								["BodyGroupName"] = "head",
							},
						},
				},
				["self"] = {
					["BoneMerge"]	=	true,
					["ClassName"]	=	"model",
					["Model"]	=	"models/zadkiel/empire/objects/empire_head.mdl",
					["UniqueID"]	=	"1948360431",
				},		
			},		
		},
		["self"] = {
				["ClassName"]	=	"group",
				["EditorExpand"]	=	true,
				["Name"]	=	"my outfit",
				["UniqueID"]	=	"1683170536",
		},
	},
}

ITEM.bodyGroups = {
	["head"] = 1,
}