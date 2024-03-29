TRAIT.name = "Blood Drinker"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 5
TRAIT.SkillPointCost = 0
TRAIT.Incompatible = {

}

TRAIT.RequiredTraits = {
    "khorne"
}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
TRAIT.category = "Blessings of Khorne"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic

TRAIT.desc = [[
Grants 30% lifesteal on all attacks. 
Also replaces the mana pool and turns it into a bloodpool. 
A bloodpool can only be filled by attacking.

Lifesteal: +30%
Bloodpool: 100

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
    
    local lifeSteal = char:getData("lifeSteal", 0)
    char:setData("lifeSteal", lifeSteal + 30)
end

TRAIT.onAquire = onAquire