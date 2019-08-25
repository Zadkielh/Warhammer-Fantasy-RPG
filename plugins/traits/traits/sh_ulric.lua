TRAIT.name = "The Path of Winter"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 3
TRAIT.SkillPointCost = 1
TRAIT.Incompatible = {
    "tzeentch",
    "khorne",
    "undivided",
    "taal",
    "slaanesh",
    "sigmar",
    "nurgle",
    "moor",
}
TRAIT.faction = FACTION_EMPIRE
TRAIT.RequiredTraits = {

}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
TRAIT.category = "Blessings of Ulric"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

TRAIT.desc = [[
The followers of Ulric are hardened by the ways of war and winter.

Health: +100
Damage: +10

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]

local function onAquire(TRAIT, char)

    local naturalArmorRating = char:getData("naturalDamage", 0)
    char:setData("naturalDamage", naturalArmorRating + 10)

    local HPMax = char:getData("naturalHPMax", 0)
    char:setData("naturalHPMax", HPMax + 100)

end

TRAIT.onAquire = onAquire