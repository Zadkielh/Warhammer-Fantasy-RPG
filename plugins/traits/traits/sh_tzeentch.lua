TRAIT.name = "The Path of Knowledge"

TRAIT.IconX = 1
TRAIT.IconY = 1
TRAIT.LevelReq = 5
TRAIT.SkillPointCost = 0
TRAIT.Incompatible = {
    "khorne",
    "nurgle",
    "slaanesh",
    "undivided"
}


TRAIT.RequiredTraits = {

}
TRAIT.icon = "vgui/skills/ability_warrior_defensivestance_1.png"
TRAIT.category = "Blessings of Tzeentch"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
TRAIT.faction = FACTION_CHAOS
TRAIT.desc = [[
This trait is the entry trait for the Tzeentch tree. This one locks out all the other gods aswell as the undivided traits.

Attrib Boost: Magic Power + 10

Level Requirement: ]] .. TRAIT.LevelReq .. [[

Skill Point Cost:]] .. TRAIT.SkillPointCost .. [[

]]
TRAIT.class = {
    "chaos_warrior",
    "sh_reaver",
    "asp_sorcerer"
}

local function onAquire(TRAIT, char)
    local attribBoost = char:getData("tzeentchAttribBoost")
    if attribBoost then
        return
    else
        char:setData("tzeentchAttribBoost", true)
        char:setAttrib("mgc", char:getAttrib("mgc") + 10)
    end
end

TRAIT.onAquire = onAquire