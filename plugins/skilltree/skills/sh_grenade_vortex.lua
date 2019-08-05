SKILL.name = "Vortex Grenade"

SKILL.LevelReq = 50
SKILL.SkillPointCost = 5
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Dow2_sm_toxin_grenade.png"
SKILL.category = "Tactical"-- Common Passives, Warrior, Lore of Light

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
	"tactical",
	"intercessor"
}

SKILL.desc = [[
You throw a Vortex Grenade. The grenade creates a tear in realspace opening a rift to the warp, instantly removing any target hit from existance.
The Vortex created is highly unstable and unpredictable. Keep distance.
Cost: No Cost
Cooldown: 120 Seconds
Ability Slot: 4
Class Restriction: Tactical

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[

]]
SKILL.coolDown = 120

local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamUlt") then return  end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
			print("ready")
		end)
		return
	end

	local pos = ply:GetPos()

	if SERVER then

		ply:SetNWBool( "nospamUlt", true )
		print("Cdstart")

		net.Start( "UltActivated" )
		net.Send( ply )
			
		local Ent = ents.Create("obj_40k_grenade_vortex")
		
		local OwnerPos = ply:GetShootPos()
		local OwnerAng = ply:GetAimVector():Angle()
		OwnerPos = OwnerPos + OwnerAng:Forward()*-20 + OwnerAng:Up()*-9 + OwnerAng:Right()*10
		if ply:IsPlayer() then Ent:SetPos(OwnerPos) end
		if ply:IsPlayer() then Ent:SetAngles(OwnerAng) else Ent:SetAngles(ply:GetAngles()) end
		Ent:SetOwner(ply)
		
		
		Ent:Activate()
		Ent:Spawn()
		
		local phy = Ent:GetPhysicsObject()
		if phy:IsValid() then
			if ply:IsPlayer() then
				phy:ApplyForceCenter(ply:GetAimVector() * 1000)
			end
		end
		
		

		if timer.Exists(ply:SteamID().."nospamUlt") then return  end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
			print("ready")
		end)

	end
end
SKILL.ability = ability