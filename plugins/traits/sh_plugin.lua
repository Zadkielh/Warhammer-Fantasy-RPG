PLUGIN.name = "Traits"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Traits that complement the fantasy gamemode."

nut.traits = nut.traits or {}
nut.traits.list = nut.traits.list or {}

nut.traitCategories = nut.traitCategories or {}
nut.traitCategories.list = nut.traitCategories.list or {}

nut.command.add("cleartraittables", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, args)
        local Target = client or nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		char:setData("Traits", {})
    end
})

nut.command.add("chargettraits", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, args)
        local Target = client or nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		
		local traits = char:getData("Traits", {})

		for k, v in pairs(traits) do
			print(k)
		end
    end
})

	function nut.traits.loadFromDir(directory)
		for k, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
			local niceName = v:sub(4, -5)

			TRAIT = nut.traits.list[niceName] or {}

				nut.util.include(directory.."/"..v)

				TRAIT.name = TRAIT.name or "Unknown"
				TRAIT.desc = TRAIT.desc or "No description available."

				nut.traits.list[niceName] = TRAIT
			TRAIT = nil 
		end
	end

	function nut.traitCategories.loadFromDir(directory)
		for k, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
			local niceName = v:sub(4, -5)

			CAT = nut.traitCategories.list[niceName] or {}

				nut.util.include(directory.."/"..v)

				CAT.name = CAT.name or "Unknown"
				CAT.desc = CAT.desc or "No description available."
				CAT.icon = CAT.icon or "vgui/white"

				nut.traitCategories.list[niceName] = CAT
			CAT = nil 
		end
	end

nut.traits.loadFromDir("warhammer-fantasy-rpg/plugins/traits/traits")
nut.traitCategories.loadFromDir("warhammer-fantasy-rpg/plugins/traits/categories")

local charMeta = nut.meta.character

function charMeta:canClientAquireTrait(key)
local trait = nut.traits.list[key]
local color = Color(0,200,0, 200)
local class = false

	if (self:hasTrait(key)) then
		return false 
	end

	if (trait.class) then
		for k, v in pairs(trait.class) do
			if self:getClass() == v then
				class = true
			end
        end
	else
		class = true
	end

	if (trait.SkillPointCost) then
		if self:getData("SkillPoints", 0) < trait.SkillPointCost then
			color = Color(223, 180, 127, 230)
		end
	end

	if (trait.RequiredTraits) then
		local traits = self:getData("Traits", {})
	
		for k, v in pairs(trait.RequiredTraits) do
			if !(traits[v]) then
				color = Color(50, 50, 100, 230)
			end
		end
	end

	

	if (trait.Incompatible) then
		for k,v in pairs(trait.Incompatible) do
			if self:hasTrait(v) then
				color = Color(200, 10, 10, 230) 
			end
		end
	end

	if (trait.LevelReq) then 
		if tonumber(self:getLevel()) < trait.LevelReq then 
			color = Color(180, 11, 209, 230)
		end
	end

	if !(class) then
		color = Color(10, 10, 10, 230)
	end

	return color 
end

function charMeta:canAquireTrait(key)
	local trait = nut.traits.list[key]
	
	if (self:hasTrait(key)) then
		self:getPlayer():notify("You have already aquired this trait.") return false 
	end
 
	if (trait.LevelReq) then 
		if tonumber(self:getLevel()) < trait.LevelReq then self:getPlayer():notify("Level Requirement not met.") return false end
	end

	if (trait.SkillPointCost) then
		if self:getData("SkillPoints", 0) < trait.SkillPointCost then self:getPlayer():notify("You require more Skill Points.") return false end
	end

	if (trait.Incompatible) then
		for k,v in pairs(trait.Incompatible) do
			if self:hasTrait(v) then self:getPlayer():notify("You have one or more incompatible traits.") return false end
		end
	end

	if (trait.RequiredSkills) then
		local traits = self:getData("Traits", {})

		for k, v in pairs(trait.RequiredSkills) do
			if !(traits[v]) then
				self:getPlayer():notify("You are missing a required trait.") return false
			end
		end
	end

	if (trait.class) then
		for k, v in pairs(trait.class) do
			if self:getClass() == v then
				return true 
			end
        end
        self:getPlayer():notify("Wrong class.")
	    return false
	end

	return true 
end

function charMeta:hasTrait(key)
	
	local trait = nut.traits.list[key]
	local traits = self:getData("Traits", {})

	if (traits) then
		for k, v in pairs(traits) do
			if k == key then return true end
		end
	end
		
	return false
end

function charMeta:getTraits()
	
	local traits = self:getData("Traits", {})
		
	return traits
end

function charMeta:OnAquireTrait(key)
	local trait = nut.traits.list[key]
	local traits = self:getData("Traits", {})
	if !self:canAquireTrait(key) then print("errorTraitAquired") return false end
	if !(table.HasValue( traits, trait)) then
	
		traits[key] = true

		self:setData("Traits", traits)
		if (trait.SkillPointCost) then
			
			local SkillPoints = self:getData("SkillPoints", 0) - trait.SkillPointCost
			self:setData("SkillPoints", SkillPoints)
			
		end
	    
	    if (trait.onAquire) then
			trait.onAquire(trait, self)
		end
	else
		print("errorSkillAquired")
	end
end

function charMeta:getLifeSteal()
	return self:getData("lifeSteal", 0)
end


if (SERVER)	then
	netstream.Hook("AquireTrait", function(client, data)
		local character = client:getChar()
		if (character) then
			if (character:canAquireTrait(data.trait)) then
				character:OnAquireTrait(data.trait)
				client:notifyLocalized("You gained ".. tostring(data.trait))
			end
		end
	end)
end

function PLUGIN:PostPlayerLoadout(client)
	
	client:getChar():setData("bloodpool", 0)
	client:getChar():setData("lifeSteal", 0)

	if !(istable(client:getChar():getTraits())) then
		self:setData("Traits", {})
	end

	for k, v in pairs(client:getChar():getTraits()) do
		local trait = nut.traits.list[k]
		if (trait.onAquire) then
			timer.Simple(0.05, function()
				trait.onAquire(trait, client:getChar())
			end)
		end
	end

end



hook.Add("EntityTakeDamage", "traitModifiers", function(Entity, dmg)

	if dmg:GetAttacker():IsPlayer() then
		
        local ply = dmg:GetAttacker()
		local char = ply:getChar()

		if char:hasTrait("blooddrinker") then
			local lifeSteal = char:getData("lifeSteal", 0)
			local heal = (dmg:GetDamage()*(lifeSteal / 100) ) 
			ply:SetHealth(math.Clamp(heal + ply:Health(), ply:Health(), ply:GetMaxHealth()))
			local bloodPool = char:getData("bloodpool", 0)
			local current = ply:getLocalVar("mana", 0)
			local blood = math.Clamp(current + (heal *0.5), 0, bloodPool)
			ply:setLocalVar("mana", blood)
		end
    end
end)

