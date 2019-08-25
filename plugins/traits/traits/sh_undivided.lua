TRAIT.name = "Undivided"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 5
TRAIT.SkillPointCost = 0
TRAIT.Incompatible = {
    "khorne",
    "nurgle",
    "slaanesh",
    "tzeentch"
}

TRAIT.RequiredTraits = {

}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
TRAIT.category = "Blessings of Chaos Undivided"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
TRAIT.faction = FACTION_CHAOS
TRAIT.desc = [[
This trait is the entry trait for the Undivided tree. This one locks out all the other gods aswell as the undivided advanced traits.

Armorrating: +100
Damage: +10
Health: +100

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]

local function onAquire(TRAIT, char)
    local naturalArmorRating = char:getData("naturalArmorRating", 0)
    local naturalDamage = char:getData("naturalDamage", 0)
    local naturalHealth = char:getData("naturalHPMax", 0)
    char:setData("naturalArmorRating", naturalArmorRating + 100)
    char:setData("naturalDamage", naturalDamage + 10)
    char:setData("naturalHPMax", naturalHealth + 100)
end

TRAIT.onAquire = onAquire