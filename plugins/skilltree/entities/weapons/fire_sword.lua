SWEP.Base = "tfa_melee_base"
SWEP.Category = "Warhammer Fantasy: Magic"
SWEP.PrintName = "Flaming Sword"
SWEP.ViewModel = "models/zadkiel/weapons/c_oren_katana.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
--SWEP.InspectPos = Vector(17.184, -4.891, -11.902) - SWEP.VMPos
--SWEP.InspectAng = Vector(70, 46.431, 70)
SWEP.WorldModel = "models/zadkiel/chaos/weapons/chaos_knights_sword_1h.mdl"
SWEP.HoldType = "melee"
SWEP.Primary.Directional = true
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false
SWEP.VMPos = Vector(5, 5, -6)

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 4.5, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = math.random(201,271), --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.3, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_light_1.wav"), -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(5, 0, 0), --viewpunch angle
		["end"] = 0.6, --time before next attack
		["hull"] = 42, --Hullsize
		["direction"] = "F", --Swing dir,
		["combotime"] = 0.1,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	},
		{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 4.5, -- Trace distance
		["dir"] = Vector(75, 0, 0), -- Trace arc cast
		["dmg"] = math.random(201,271), --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.3, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_light_1.wav"), -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 0.6, --time before next attack
		["hull"] = 42, --Hullsize
		["direction"] = "R", --Swing dir,
		["combotime"] = 0.2,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	},
	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 4.5, -- Trace distance
		["dir"] = Vector(-75, 0, 0), -- Trace arc cast
		["dmg"] = math.random(201,271), --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.3, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_light_1.wav"), -- Sound ID		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, 5, 0), --viewpunch angle
		["end"] = 0.6, --time before next attack
		["hull"] = 42, --Hullsize
		["direction"] = "L", --Swing dir,
		["combotime"] = 0.2,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	},
	{
		["act"] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 4.5, -- Trace distance
		["dir"] = Vector(0, 20, 70), -- Trace arc cast
		["dmg"] = math.random(201,271), --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.3, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_light_1.wav"), -- Sound ID		["snd_delay"] = 0.26,
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(-5, 0, 0), --viewpunch angle
		["end"] = 0.6, --time before next attack
		["hull"] = 42, --Hullsize
		["direction"] = "B", --Swing dir,
		["combotime"] = 0.2,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	}
}

SWEP.Secondary.Attacks = {
	{
		["act"] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 4.5, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = math.random(251,271), --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.7, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_hard_2.wav"), -- Sound ID		["snd_delay"] = 0.26,
		["snd_delay"] = 0.5,
		["viewpunch"] = Angle(5, 0, 0), --viewpunch angle
		["end"] = 0.7, --time before next attack
		["hull"] = 42, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	},
	{
		["act"] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 5.5, -- Trace distance
		["dir"] = Vector(120, 0, 0), -- Trace arc cast
		["dmg"] = math.random(251,271), --Damage
		["dmgtype"] = bit.bor(bit.bor(DMG_SLASH,DMG_ALWAYSGIB), DMG_ALWAYSGIB), --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.7, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_hard_2.wav"), -- Sound ID		["snd_delay"] = 0.26,
		["snd_delay"] = 0.4,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 0.7, --time before next attack
		["hull"] = 42, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	},
	{
		["act"] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 5.5, -- Trace distance
		["dir"] = Vector(-120, 0, 0), -- Trace arc cast
		["dmg"] = math.random(251,271), --Damage
		["dmgtype"] = bit.bor(bit.bor(DMG_SLASH,DMG_ALWAYSGIB), DMG_ALWAYSGIB), --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.65, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_hard_2.wav"), -- Sound ID		["snd_delay"] = 0.26,
		["snd_delay"] = 0.5,
		["viewpunch"] = Angle(1, 5, 0), --viewpunch angle
		["end"] = 0.7, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	},
	{
		["act"] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 5.5, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = math.random(251,271), --Damage
		["dmgtype"] = bit.bor(bit.bor(DMG_SLASH,DMG_ALWAYSGIB), DMG_ALWAYSGIB), --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.7, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_hard_2.wav"), -- Sound ID		["snd_delay"] = 0.26,
		["snd_delay"] = 0.6,
		["viewpunch"] = Angle(10, 0, 0), --viewpunch angle
		["end"] = 0.7, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "B", --Swing dir,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	},
	{
		["act"] = ACT_VM_PULLBACK_HIGH, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 22 * 5.5, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = math.random(251,271), --Damage
		["dmgtype"] = bit.bor(bit.bor(DMG_SLASH,DMG_ALWAYSGIB), DMG_ALWAYSGIB), --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.55, --Delay
		["spr"] = false, --Allow attack while sprinting?
		["snd"] = Sound("zweihander/swing_hard_2.wav"), -- Sound ID		["snd_delay"] = 0.26,
		["snd_delay"] = 0.5,
		["viewpunch"] = Angle(7.5, 0, 0), --viewpunch angle
		["end"] = 0.7, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = Sound("zweihander/hitflesh_2.wav"),
		["hitworld"] = Sound("zweihander/swing_hard_4.wav"),
	}
}

SWEP.AllowSprintAttack = false

SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_HYBRID-- ANI = mdl, Hybrid = ani + lua, Lua = lua only
SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_loop", --Number for act, String/Number for sequence
		["is_idle"] = true
	},--looping animation
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_out", --Number for act, String/Number for sequence
		["transition"] = true
	} --Outward transition
}
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-10, -2.5, 2.5)


SWEP.CanBlock = true
SWEP.BlockAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_DEPLOY, --Number for act, String/Number for sequence
		["transition"] = true
	}, --Inward transition
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_IDLE_DEPLOYED, --Number for act, String/Number for sequence
		["is_idle"] = true
	},--looping animation
	["hit"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_DEPLOYED, --Number for act, String/Number for sequence
		["is_idle"] = true
	},--when you get hit and block it
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_UNDEPLOY, --Number for act, String/Number for sequence
		["transition"] = true
	} --Outward transition
}
SWEP.BlockCone = 100 --Think of the player's view direction as being the middle of a sector, with the sector's angle being this
SWEP.BlockDamageMaximum = 0.0 --Multiply damage by this for a maximumly effective block
SWEP.BlockDamageMinimum = 0.7 --Multiply damage by this for a minimumly effective block
SWEP.BlockTimeWindow = 0.3 --Time to absorb maximum damage
SWEP.BlockTimeFade = 1 --Time for blocking to do minimum damage.  Does not include block window
SWEP.BlockSound = Sound("block_1.wav")
SWEP.BlockDamageCap = 40
SWEP.BlockDamageTypes = {
	DMG_SLASH,DMG_CLUB,DMG_BULLET
}

SWEP.Secondary.CanBash = true
SWEP.Secondary.BashDamage = 130
SWEP.Secondary.BashDelay = 0.25
SWEP.Secondary.BashLength = 16 * 5.5

SWEP.SequenceLengthOverride = {
	[ACT_VM_HITCENTER] = 0.8,
	[ACT_VM_DRAW] = 0.75,
	[ACT_VM_UNDEPLOY] = 0.5
}

SWEP.ViewModelBoneMods = {
	["RW_Weapon"] = { scale = Vector(0.01, 0.01, 0.01), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}
SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/zadkiel/empire/weapons/emp_state_troops_sword.mdl", bone = "RW_Weapon", rel = "", pos = Vector(0.218, 0.518, 21), angle = Angle(0, 90, 90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/effects/splode1_sheet", skin = 1, bodygroup = {[0] = 0} }
}

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/zadkiel/empire/weapons/emp_state_troops_sword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3,1,-20), angle = Angle(0,90,-90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/effects/splode1_sheet", skin = 1, bodygroup = {[0] = 0} }
}
SWEP.InspectionActions = {ACT_VM_RECOIL1, ACT_VM_RECOIL2, ACT_VM_RECOIL3}

local base = baseclass.Get("tfa_melee_base")
if (CLIENT) then
	function SWEP:PreDrawViewModel(viewModel, weapon, client)
		base.PreDrawViewModel(self)
		local hands = player_manager.TranslatePlayerHands(player_manager.TranslateToPlayerModelName(client:GetModel()))

		if (hands and hands.model) then
            viewModel:SetMaterial("models/effects/portalrift_sheet")
		end
	end
end

function SWEP:PrimaryAttack()
	base.PrimaryAttack(self)
	
	local staminaUse = 20

	if (staminaUse > 0) then
		local value = self.Owner:getLocalVar("stm", 0) - staminaUse

		if (value < 0) then
			return
		elseif (SERVER) then
			self.Owner:setLocalVar("stm", value)
		end
	end
end

function SWEP:OnRemove()

	base.OnRemove(self)
    local viewModel = self.Owner:GetViewModel()
    viewModel:SetMaterial("")
end


function SWEP:Initialize()
	base.Initialize(self)
    timer.Simple(10, function()
        if (IsValid(self)) then
            self:Holster()
        end
    end
    )
	if CLIENT then
		local weapon = self.Owner:GetViewModel()
		timer.Simple(0.5, function()
			ParticleEffectAttach("fire_small_02", PATTACH_ABSORIGIN_FOLLOW, weapon, 1)
		end)
	end

end

ACT_VM_FISTS_DRAW = 3
ACT_VM_FISTS_HOLSTER = 2

function SWEP:Holster()
	base.Holster(self)
	if (!IsValid(self.Owner)) then
		return
	end

    if (SERVER) then
        self:Remove()
    end
    
    return true
end
