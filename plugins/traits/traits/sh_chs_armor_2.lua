TRAIT.name = "Chaotic Alloys II"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 10
TRAIT.SkillPointCost = 2
TRAIT.Incompatible = {

}

TRAIT.RequiredTraits = {
    "chs_armor_1"
}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_2.png"
TRAIT.category = "Blessings of Chaos Undivided"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

TRAIT.desc = [[

Further blessings and improvements have vastly improved the material granting higher resistance and regenerative ability.

Armorrating: +30
Shield Regen: +10

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

Class Restriction: Tactical
]]
TRAIT.class = {
    "chaos_warrior"
}


local function onAquire(TRAIT, char)
    local naturalArmorRating = char:getData("naturalArmorRating", 0)
    naturalArmorRating = naturalArmorRating + 30
    char:setData("naturalArmorRating", naturalArmorRating)
end

TRAIT.onAquire = onAquire