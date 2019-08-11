TRAIT.name = "Blood Bank"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 5
TRAIT.SkillPointCost = 0
TRAIT.Incompatible = {

}

TRAIT.RequiredTraits = {
    "blooddrinker"
}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
TRAIT.category = "Blessings of Khorne"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

TRAIT.desc = [[
Increases bloodpool.

Bloodpool: +100

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]
TRAIT.class = {
    "chaos_warrior",
    "reaver"
}

local function onAquire(TRAIT, char)
    local bloodPool = char:getData("bloodpool", 0)
    char:setData("bloodpool", bloodPool + 100)
end

TRAIT.onAquire = onAquire