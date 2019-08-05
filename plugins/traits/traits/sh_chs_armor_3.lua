TRAIT.name = "Chaotic Alloys III"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 10
TRAIT.SkillPointCost = 2
TRAIT.Incompatible = {

}

TRAIT.RequiredTraits = {
    "chs_armor_1",
    "chs_armor_2",
}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_2.png"
TRAIT.category = "Blessings of Chaos Undivided"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

TRAIT.desc = [[

New methods of crafting and smithing combined with unholy worship of the powers has granted further breakthrough in the arts of metallurgy
making it more resillient and increasing its regnerative abilites vastly. 

Armorrating: +30
Shield Regen: +30

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