local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "Storage"
ENT.Category = "NutScript"
ENT.Spawnable = false
ENT.isStorageEntity = true

function ENT:getInv()
	return nut.inventory.instances[self:getNetVar("id")]
end

function ENT:getStorageInfo()
	
	local storage = {}
	storage.name = "Corpse"
	storage.desc = ""
	storage.invType = "grid"
	storage.invData = {
		w = 4,
		h = 4
	}
	return storage
end
	 
	
