TRAIT.name = "The Path of Winter"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 3
TRAIT.SkillPointCost = 1
TRAIT.Incompatible = {

}

TRAIT.RequiredTraits = {

}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
TRAIT.category = "Blessings of Ulric"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

TRAIT.desc = [[
The Nature of Chaos alloys and metals grant them an unique ability to restore itself.

Armorrating: +10
Shield Regen: +5

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]
TRAIT.class = {
    "chaos_warrior"
}

local function onAquire(TRAIT, char)
    local naturalArmorRating = char:getData("naturalArmorRating", 0)
    naturalArmorRating = naturalArmorRating + 10
    char:setData("naturalArmorRating", naturalArmorRating)
end

TRAIT.onAquire = onAquire