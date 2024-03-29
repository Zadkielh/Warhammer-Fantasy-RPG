TRAIT.name = "The Path of Blood"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 5
TRAIT.SkillPointCost = 0
TRAIT.Incompatible = {
    "nurgle",
    "slaanesh",
    "tzeentch",
    "undivided"
}

TRAIT.RequiredTraits = {

}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
TRAIT.category = "Blessings of Khorne"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
TRAIT.faction = FACTION_CHAOS

TRAIT.desc = [[
This trait is the entry trait for the khorne tree. This one locks out all the other gods aswell as the undivided advanced traits.

Health Regen: +10
Damage: +50

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]
TRAIT.class = {
    "chaos_warrior",
    "reaver"
}

local function onAquire(TRAIT, char)
    local naturalHPRegen = char:getData("naturalHPRegen", 0)
    local naturalDamage = char:getData("naturalDamage", 0)
    naturalHPRegen = naturalHPRegen + 10
    naturalDamage = naturalDamage + 50
    char:setData("naturalHPRegen", naturalHPRegen)
    char:setData("naturalDamage", naturalDamage)
end

TRAIT.onAquire = onAquire