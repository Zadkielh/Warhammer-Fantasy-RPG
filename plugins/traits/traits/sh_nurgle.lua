TRAIT.name = "The Path of Disease"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 5
TRAIT.SkillPointCost = 0
TRAIT.Incompatible = {
    "khorne",
    "undivided",
    "slaanesh",
    "tzeentch"
}


TRAIT.RequiredTraits = {

}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
TRAIT.category = "Blessings of Nurgle"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
TRAIT.faction = FACTION_CHAOS

TRAIT.desc = [[
This trait is the entry trait for the Nurgle tree. This one locks out all the other gods aswell as the undivided advanced traits.

Health: + 500

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]
TRAIT.class = {
    "chaos_warrior",
    "sh_reaver",
    "asp_sorcerer"
}

local function onAquire(TRAIT, char)
    local HPMax = char:getData("naturalHPMax", 0)
    char:setData("naturalHPMax", HPMax + 500)
end

TRAIT.onAquire = onAquire