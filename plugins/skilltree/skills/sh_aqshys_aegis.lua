SKILL.name = "Aqshy's Aegis"

SKILL.IconX = 1
SKILL.IconY = 1
SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}

SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_mage_livingbomb.png"
SKILL.category = "Lore of Fire"-- Common Passives, Warriors of Chaos, Lore of Light, Dark Magic
SKILL.class = {
    "bright_wizard"
}

SKILL.slot = nil -- ULT, RANGED, MELEE, AOE, PASSIVE


SKILL.desc = [[
You gain immunity from fire. (You can no longer be set on fire.)
Ability Slot: Passive

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

Class Restriction: Bright Wizard
]]

local function onAquire(SKILL, char)
    local client = char:getPlayer()
    local ID = "fireAegis"..client:SteamID()
			
    if timer.Exists( ID ) then
		timer.Remove( ID )
	end

	timer.Create(ID, 0.1, 0, function()
        if !IsValid(client) then return
            timer.Destroy(ID)
        end
		if client:IsOnFire() then
			client:Extinguish()
		end
	end)
end

SKILL.onAquire = onAquire