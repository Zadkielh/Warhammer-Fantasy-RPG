CreateClientConVar( "zad_ui_extras", "0", true, false)
CreateClientConVar( "zad_ui_squad", "0", true, false)
local UIInformation = GetConVar( "zad_ui_extras" )
local SquadInformation = GetConVar( "zad_ui_squad" )

local width = ScrW()
local height = ScrH()
local maxWidth = (width * 0.05) * 4
local startWidth = width/2 - ((width * 0.05)*2)
local color_dark = Color(0, 0, 0, 225)
local gradient = nut.util.getMaterial("vgui/gradient-u")
local gradient2 = nut.util.getMaterial("vgui/gradient-d")
local surface = surface
local text1 = false

local TEXT_COLOR = Color(240, 240, 240)
local SHADOW_COLOR = Color(20, 20, 20)

local Approach = math.Approach
local hp = nut.util.getMaterial("vgui/redbar.png")
local armor = nut.util.getMaterial("vgui/Armor.png")
local stm = nut.util.getMaterial("vgui/marine.png")
local psy = nut.util.getMaterial("vgui/psyker.png")
local backgroundbar1 = nut.util.getMaterial("vgui/bar_hp_border.png")
local backgroundbar2 = nut.util.getMaterial("vgui/bar_hp_border_layer.png")
local backgroundbar3 = nut.util.getMaterial("vgui/bar_xp_border.png")
local backgroundbar4 = nut.util.getMaterial("vgui/background_bar.png")
local hpbar2 = nut.util.getMaterial("vgui/border_icon_2.png")
local bg_1 = nut.util.getMaterial("vgui/bar_3.png")
local bg_2 = nut.util.getMaterial("vgui/bar_4.png")
local bg_3 = nut.util.getMaterial("vgui/bar_6.png")
local bg_4 = nut.util.getMaterial("vgui/bar_8.png")
local bg_5 = nut.util.getMaterial("vgui/bar_xp_border_layer.png")
local bg_6 = nut.util.getMaterial("vgui/bar_xp.png")
local skill_background = nut.util.getMaterial("vgui/skill_background.png")

local BAR_HEIGHT = 10

function DrawBorder( client )
	local len = ( math.min(client:Health() / client:GetMaxHealth() * 100, client:GetMaxHealth() )) 
	local len2 = 35 + ( client:GetMaxHealth() / 5)

	--surface.SetDrawColor(255, 255, 255, 255)
	--surface.SetMaterial( backgroundbar4 )
	--surface.DrawTexturedRectUV( 0, ScrH() * 0.89 - 10, ScrW(), 96, 0, 0, 1, 1 )
	
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial( backgroundbar3 )
	surface.DrawTexturedRectUV( ScrW() * 0.3, ScrH() - 64, ScrW() * 0.4, 64, 0, 0, 1, 1 )

	/*surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial( bg_2 )
	surface.DrawTexturedRectUV( ScrW() / 2 - 124, ScrH() * 0.855, 248, 128, 0, 0, 1, 1 )


	

	if !IsValid(model) then 

		model = vgui.Create("nutModelPanel")
        model:SetPos(ScrW() / 2 - 47.5, ScrH() * 0.823)
		model:SetSize(95, 105)
		model:SetCamPos( Vector( 15, 15, 70))
		model:SetLookAt( Vector( 0, 0, 65 ) )
		model.enableHook = true

		model:SetModel(LocalPlayer():GetModel())
		model.Entity:SetSkin(LocalPlayer():GetSkin())

			for k, v in ipairs(LocalPlayer():GetBodyGroups()) do
				model.Entity:SetBodygroup(v.id, LocalPlayer():GetBodygroup(v.id))
			end

			local ent = model.Entity
			if (ent and IsValid(ent)) then
				local mats = LocalPlayer():GetMaterials()
				for k, v in pairs(mats) do
					ent:SetSubMaterial(k - 1, LocalPlayer():GetSubMaterial(k - 1))
				end
			end
			if (pac and model) then
				-- If the ModelPanel's Entity is valid, setup PAC3 Function Table.
				if (ent and IsValid(ent)) then
						-- Setup function table.
					pac.SetupENT(ent)
					local parts = client:getParts()

						-- Wear current player's PAC3 Outfits on the ModelPanel's Clientside Model Entity.
					for k, v in pairs(parts) do
						if (client.nutPACParts[k]) then
							ent:AttachPACPart(client.nutPACParts[k])
						end
					end
						
						-- Overrride Model Drawing function of ModelPanel. (Function revision: 2015/01/05)
						-- by setting ent.forcedraw true, The PAC3 outfit will drawn on the model even if it's NoDraw Status is true.
					ent.forceDraw = true
				end
			end
	
		model:ParentToHUD()
		timer.Create("HUDRefresh", 5, 0, function() 
			model:Remove()
		end)
		function model:PaintOver( width, height )
			render.SetMaterial(bg_4)
			render.DrawScreenQuadEx( ScrW() / 2 - 78, ScrH() * 0.8, 156, 156 )
		end
	end

	
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial( bg_1 )
	surface.DrawTexturedRectUV( ScrW() / 2 - 78, ScrH() * 0.8, 156, 156, 0, 0, 1, 1 )
	*/
end

function DrawHealth( client )
	local len = ( math.min((client:Health() * 400) / client:GetMaxHealth(), client:GetMaxHealth() * 4 ))  
	local len2 = 110 + ( client:GetMaxHealth() / 4)
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( backgroundbar1 )
	surface.DrawTexturedRect( ScrW() * 0.01, ScrH() - 118, 100 * 4, 48)
	
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial( hpbar2 )
	surface.DrawTexturedRectUV( ScrW() * 0.01 + 7, ScrH() - 118, len - 10, 48, 0, 0, 1, 1 )

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial( backgroundbar2 )
	surface.DrawTexturedRect( ScrW() * 0.01, ScrH() - 118, 100 * 4, 48)

	if tobool(UIInformation:GetString()) then
		draw.SimpleText(client:Health() .. "/" .. client:GetMaxHealth(), "CenturyGothicSmall", ScrW() * 0.01 + (100 * 1.4 - 20), ScrH() - (118 - 20), Color(255, 255, 255), 3, 1)
		draw.SimpleText(client:getChar():getHealthRegen() .. "/5s", "CenturyGothicSmall", ScrW() * 0.01 + (100 * 2.5), ScrH() - (118 - 20), Color(255, 255, 255), 3, 1)
	end
end

function DrawXP( client )
	local char = client:getChar()

	local level = char:getLevel()
	local MaxXP = char:getMaxXP(level)
	local xp = char:getXP()
	local len = ((xp - char:getMaxXP(math.max(1, level - 1))) * (ScrW()*0.4)) / (MaxXP - char:getMaxXP(math.max(1, level - 1)))
	if level == 1 then
		len = ((xp) * (ScrW()*0.4)) / (MaxXP)
	end

	render.SetScissorRect( 0, ScrH() - 64, ScrW(), ScrH(), true )
		render.SetMaterial( bg_6 )
		render.DrawScreenQuadEx( ScrW() * 0.3, ScrH() - 64, len, 60 )
	render.SetScissorRect( 0, 0, 0, 0, false )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( bg_5 )
	surface.DrawTexturedRectUV( ScrW() * 0.3, ScrH() - 64, ScrW() * 0.4, 64, 0, 0, 1, 1 )
			
	draw.SimpleText(client:getChar():getLevel(), "Trebuchet24", ScrW() * 0.5 - 5, ScrH() - 40, Color(255, 255, 255), 3, 1)

	if tobool(UIInformation:GetString()) then
		draw.SimpleText(math.Round( client:getChar():getXP(), 2 ) .. "/" .. client:getChar():getMaxXP(client:getChar():getLevel()), "CenturyGothicSmall", ScrW() * 0.4, ScrH() - 40, Color(255, 255, 255), 3, 1)		
	end
end


function DrawArmor( client )
	local len = ScrW() * 0.015 + ( math.min((client:Armor() * 385) / client:getChar():getMaxShield(), 385) )  
	local len2 = 110 + ( client:getChar():getMaxShield() / 4)
	local col = Color(255, 153, 51)
	local stm = {
		{
			x = ScrW() * 0.015,
			y = ScrH() - 158
		},
		{
			x = math.max ( ScrW() * 0.015 ,len),	
			y = ScrH() - 158
		},
		{
			x = math.max ( ScrW() * 0.015, len),	
			y = ScrH() - 118
		},
		{
			x = ScrW() * 0.015, 	
			y = ScrH() - 118
		},
	}

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( backgroundbar1 )
	surface.DrawTexturedRect( ScrW() * 0.01, ScrH() - 158, 100 * 4, 42)

	surface.SetDrawColor( col )
	draw.NoTexture()
	surface.DrawPoly( stm )

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial( backgroundbar2 )
	surface.DrawTexturedRect( ScrW() * 0.01, ScrH() - 158, 100 * 4, 42)
	if tobool(UIInformation:GetString()) then
		draw.SimpleText(client:Armor() .. "/" .. client:getChar():getMaxShield(), "CenturyGothicSmall", ScrW() * 0.01 + (100 * 1.4 - 20), ScrH() - 138, Color(255, 255, 255), 3, 1)
		draw.SimpleText(client:getChar():getShieldRegen() .. "/5s", "CenturyGothicSmall", ScrW() * 0.01 + (100 * 2.5), ScrH() - 138, Color(255, 255, 255), 3, 1)
	end
	
end

function DrawStm( client )
	local len = ScrW() * 0.78 + LocalPlayer():getLocalVar("stm", 0) * 4 - 5
	local len2 = 90

	local col = Color(0, 115, 0)

	local stm = {
		{
			x = ScrW() * 0.781,
			y = ScrH() - 118
		},
		{
			x = math.max ( ScrW() * 0.781 ,len ),	
			y = ScrH() - 118
		},
		{
			x = math.max ( ScrW() * 0.781, len),	
			y = ScrH() - 74
		},
		{
			x = ScrW() * 0.781, 	
			y = ScrH() - 74
		},
	}
	
	
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( backgroundbar1 )
	surface.DrawTexturedRect( ScrW() * 0.78, ScrH() - 118, 100 * 4, 48)
	
	surface.SetDrawColor( col )
	draw.NoTexture()
	surface.DrawPoly( stm )

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial( backgroundbar2 )
	surface.DrawTexturedRect( ScrW() * 0.78, ScrH() - 118, 100 * 4, 48)

	if tobool(UIInformation:GetString()) then
		draw.SimpleText( math.Round(LocalPlayer():getLocalVar("stm", 0), 2) .. "/ 100", "CenturyGothicSmall", ScrW() * 0.83, ScrH() - 95, Color(255, 255, 255), 3, 1)
		draw.SimpleText( math.Round((1 + (client:getChar():getAttrib("end", 0) / 60)) * 20, 2) .. "/5s", "CenturyGothicSmall", ScrW() * 0.9, ScrH() - 95, Color(255, 255, 255), 3, 1)
	end
	
end

function DrawPsy( client )
	local len = ScrW() * 0.78 + LocalPlayer():getLocalVar("mana", 0) * 4 -5

	local col = Color(0, 102, 255)

	if client:getChar():hasTrait("khorne") then
		col = Color(200, 10, 10)
	end

	local stm = {
		{
			x = ScrW() * 0.781,
			y = ScrH() - 158
		},
		{
			x = math.max ( ScrW() * 0.781 ,len ),	
			y = ScrH() - 158
		},
		{
			x = math.max ( ScrW() * 0.781, len),	
			y = ScrH() - 118
		},
		{
			x = ScrW() * 0.781, 	
			y = ScrH() - 118
		},
	}
	
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( backgroundbar1 )
			surface.DrawTexturedRect( ScrW() * 0.78, ScrH() - 158, 100 * 4, 42)

			surface.SetDrawColor( col )
			draw.NoTexture()
			surface.DrawPoly( stm )

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial( backgroundbar2 )
			surface.DrawTexturedRect( ScrW() * 0.78, ScrH() - 158, 100 * 4, 42)
			if tobool(UIInformation:GetString()) then
				draw.SimpleText(math.Round(LocalPlayer():getLocalVar("mana", 0), 2) .. "/ 100", "CenturyGothicSmall", ScrW() * 0.83, ScrH() - 138, Color(255, 255, 255), 3, 1)
				local magic = client:getChar():getAttrib("mgc", 1)
				local faith = client:getChar():getAttrib("fth", 1)
				local regen = (client:getChar():getAttrib("mgc", 0) / 100 * 2.5) * 20
				if faith > magic then
					regen = (client:getChar():getAttrib("fth", 0) / 100 * 2.5) * 20
				end
				if !client:getChar():hasTrait("blooddrinker") then
					draw.SimpleText(regen .. "/5s", "CenturyGothicSmall", ScrW() * 0.9, ScrH() - 138, Color(255, 255, 255), 3, 1)
				end
			end
	
end

local opacity = 230
local opacityUp = false 

local UltIsOnCD = false
local UltCoolDown
local RangedIsOnCD = false
local RangedCoolDown
local MeleeIsOnCD = false
local MeleeCoolDown
local AOEIsOnCD = false
local AOECoolDown

local AOEToggle = false
local MeleeToggle = false
local ULTToggle = false
local RangedToggle = false
local toggleColor = Color(255, 180, 0, 230)

function DrawUlt( client )
	local char = client:getChar()
	

	if (char) then
		local ult = char:GetAbility("ULT")
		
		if (ult) then
			
			UltCoolDown = UltCoolDown or nut.skills.list[ult].coolDown
			if !(UltIsOnCD) then

				if !(opacityUp) and opacity != 0 then
					opacity = math.max(opacity - 1, 0)
				else
					opacityUp = true
				end

				if (opacityUp) and opacity != 230 then
					opacity =  math.min(opacity + 1, 230) 
				else
					opacityUp = false
				end
				local ultIcon = nut.util.getMaterial(nut.skills.list[ult].icon)
				
				if (nut.skills.list[ult].toggle != nil and (ULTToggle)) then
					draw.RoundedBox( 4, ScrW() * 0.73 - 5, ScrH() - 146, 72, 72, toggleColor )
				else
					draw.RoundedBox( 4, ScrW() * 0.73 - 5, ScrH() - 146, 72, 72, Color(255,180,0,opacity) )
				end

				surface.SetDrawColor(255, 255, 255, opacity)
				surface.SetMaterial( skill_background )
				surface.DrawTexturedRect( ScrW() * 0.73 - 32, ScrH() - 175, 128, 128)
				
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial( ultIcon )
				surface.DrawTexturedRect( ScrW() * 0.73, ScrH() - 142, 64, 64)

				net.Receive( "UltActivated", function()
					UltIsOnCD = true
					opacity = 0

					if !(ULTToggle) then
						ULTToggle = true
					else
						ULTToggle = false 
					end
					
					
					timer.Simple(nut.skills.list[ult].coolDown, function()
						UltIsOnCD = false
						UltCoolDown = nut.skills.list[ult].coolDown
					end)
				end)
			elseif (ult) and (UltIsOnCD) then
				local ultIcon = nut.util.getMaterial(nut.skills.list[ult].icon)
				
				draw.RoundedBox( 4, ScrW() * 0.73 - 5, ScrH() - 146, 72, 72, Color(0,0,0,200) )

				surface.SetDrawColor(0, 0, 0, 200)
				surface.SetMaterial( skill_background )
				surface.DrawTexturedRect( ScrW() * 0.73 - 32, ScrH() - 175, 128, 128)

				surface.SetDrawColor(255, 255, 255, 100)
				surface.SetMaterial( ultIcon )
				surface.DrawTexturedRect( ScrW() * 0.73, ScrH() - 142, 64, 64)
				if !timer.Exists(LocalPlayer():SteamID().."UltCoolDown") then
					
					timer.Create(LocalPlayer():SteamID().."UltCoolDown", 1, nut.skills.list[ult].coolDown, function()
						UltCoolDown = UltCoolDown - 1
					end)

					
				end
				draw.SimpleText(UltCoolDown, "CenturyGothic", ScrW() * 0.7375, ScrH() - 111, Color(255, 255, 255), 3, 1)
			end
		end 
	end
	
end

function DrawRanged( client )
	local char = client:getChar()
	

	if (char) then
		local ranged = char:GetAbility("RANGED")
		if (ranged) then
			RangedCoolDown = RangedCoolDown or nut.skills.list[ranged].coolDown
			if !(RangedIsOnCD) then

				local rangedIcon = nut.util.getMaterial(nut.skills.list[ranged].icon)
				
				if (nut.skills.list[ranged].toggle != nil and (RangedToggle)) then
					draw.RoundedBox( 4, ScrW() * 0.62 - 5, ScrH() - 146, 72, 72, toggleColor )
				else
					draw.RoundedBox( 4, ScrW() * 0.62 - 5, ScrH() - 146, 72, 72, Color(100,100,100,255) )
				end
				
				surface.SetDrawColor(0,0,0,100)
				surface.SetMaterial( skill_background )
				surface.DrawTexturedRect( ScrW() * 0.62 - 32, ScrH() - 175, 128, 128)
				
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial( rangedIcon )
				surface.DrawTexturedRect( ScrW() * 0.62, ScrH() - 142, 64, 64)

				net.Receive( "RangedActivated", function()
					RangedIsOnCD = true
					
					if !(RangedToggle) then
						RangedToggle = true
					else
						RangedToggle = false 
					end
					
					timer.Simple(nut.skills.list[ranged].coolDown, function()
						RangedIsOnCD = false
						RangedCoolDown = nut.skills.list[ranged].coolDown
					end)
				end)
			elseif (ranged) and (RangedIsOnCD) then
				local rangedIcon = nut.util.getMaterial(nut.skills.list[ranged].icon)
				surface.SetDrawColor(0, 0, 0, 200)
				surface.SetMaterial( skill_background )
				surface.DrawTexturedRect( ScrW() * 0.62 - 32, ScrH() - 175, 128, 128)

				surface.SetDrawColor(255, 255, 255, 100)
				surface.SetMaterial( rangedIcon )
				surface.DrawTexturedRect( ScrW() * 0.62, ScrH() - 142, 64, 64)
				if !timer.Exists(LocalPlayer():SteamID().."RangedCoolDown") then
					
					timer.Create(LocalPlayer():SteamID().."RangedCoolDown", 1, nut.skills.list[ranged].coolDown, function()
						RangedCoolDown = RangedCoolDown - 1
					end)

					
				end
				draw.SimpleText(RangedCoolDown, "CenturyGothic", ScrW() * 0.628, ScrH() - 111, Color(255, 255, 255), 3, 1)
			end
		end
	end
	
end

function DrawMelee( client )
	local char = client:getChar()
	

	if (char) then
		local melee = char:GetAbility("MELEE")
		if (melee) then
			MeleeCoolDown = MeleeCoolDown or nut.skills.list[melee].coolDown
			if !(MeleeIsOnCD) then

				local meleeIcon = nut.util.getMaterial(nut.skills.list[melee].icon)
				
				if (nut.skills.list[melee].toggle != nil and (MeleeToggle)) then
					draw.RoundedBox( 4, ScrW() * 0.565 - 4, ScrH() - 146, 72, 72, toggleColor )
				else
					draw.RoundedBox( 4, ScrW() * 0.565 - 4, ScrH() - 146, 72, 72, Color(100,100,100,255) )
				end
				
				surface.SetDrawColor(0,0,0,100)
				surface.SetMaterial( skill_background )
				surface.DrawTexturedRect( ScrW() * 0.565 - 32, ScrH() - 175, 128, 128)
				
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial( meleeIcon )
				surface.DrawTexturedRect( ScrW() * 0.565, ScrH() - 142, 64, 64)

				net.Receive( "MeleeActivated", function()
					MeleeIsOnCD = true
					if !(MeleeToggle) then
						MeleeToggle = true
					else
						MeleeToggle = false 
					end

					timer.Simple(nut.skills.list[melee].coolDown, function()
						MeleeIsOnCD = false
						MeleeCoolDown = nut.skills.list[melee].coolDown
					end)
				end)
			elseif (melee) and (MeleeIsOnCD) then
				local meleeIcon = nut.util.getMaterial(nut.skills.list[melee].icon)
				surface.SetDrawColor(0, 0, 0, 200)
				surface.SetMaterial( skill_background )
				surface.DrawTexturedRect( ScrW() * 0.565 - 32, ScrH() - 175, 128, 128)

				surface.SetDrawColor(255, 255, 255, 100)
				surface.SetMaterial( meleeIcon )
				surface.DrawTexturedRect( ScrW() * 0.565, ScrH() - 142, 64, 64)
				if !timer.Exists(LocalPlayer():SteamID().."MeleeCoolDown") then
					
					timer.Create(LocalPlayer():SteamID().."MeleeCoolDown", 1, nut.skills.list[melee].coolDown, function()
						MeleeCoolDown = MeleeCoolDown - 1
					end)

					
				end
				draw.SimpleText(MeleeCoolDown, "CenturyGothic", ScrW() * 0.57, ScrH() - 111, Color(255, 255, 255), 3, 1)
			end
		end
	end
	
end

function DrawAOE( client )
	local char = client:getChar()
	

	if (char) then
		local melee = char:GetAbility("AOE")
		if (melee) then
			AOECoolDown = AOECoolDown or nut.skills.list[melee].coolDown
			if !(AOEIsOnCD) then

				local meleeIcon = nut.util.getMaterial(nut.skills.list[melee].icon)
				
				if (nut.skills.list[melee].toggle != nil and (AOEToggle)) then
					draw.RoundedBox( 4, ScrW() * 0.675 - 4, ScrH() - 146, 72, 72, toggleColor )
				else
					draw.RoundedBox( 4, ScrW() * 0.675 - 4, ScrH() - 146, 72, 72, Color(100,100,100,255) )
				end

				surface.SetDrawColor(0,0,0,100)
				surface.SetMaterial( skill_background )
				surface.DrawTexturedRect( ScrW() * 0.675 - 32, ScrH() - 175, 128, 128)
				
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial( meleeIcon )
				surface.DrawTexturedRect( ScrW() * 0.675, ScrH() - 142, 64, 64)

				net.Receive( "AOEActivated", function()
					AOEIsOnCD = true
					
					if !(AOEToggle) then
						AOEToggle = true
					else
						AOEToggle = false 
					end
					
					timer.Simple(nut.skills.list[melee].coolDown, function()
						AOEIsOnCD = false
						AOECoolDown = nut.skills.list[melee].coolDown
					end)
				end)
			elseif (melee) and (AOEIsOnCD) then
				local meleeIcon = nut.util.getMaterial(nut.skills.list[melee].icon)
				surface.SetDrawColor(0, 0, 0, 200)
				surface.SetMaterial( skill_background )
				surface.DrawTexturedRect( ScrW() * 0.675 - 32, ScrH() - 175, 128, 128)

				surface.SetDrawColor(255, 255, 255, 100)
				surface.SetMaterial( meleeIcon )
				surface.DrawTexturedRect( ScrW() * 0.675, ScrH() - 142, 64, 64)
				if !timer.Exists(LocalPlayer():SteamID().."AOECoolDown") then
					
					timer.Create(LocalPlayer():SteamID().."AOECoolDown", 1, nut.skills.list[melee].coolDown, function()
						AOECoolDown = AOECoolDown - 1
					end)

					
				end
				draw.SimpleText(AOECoolDown, "CenturyGothic", ScrW() * 0.685, ScrH() - 111, Color(255, 255, 255), 3, 1)
			end
		end
	end
	
end

----------- SQUAD ------------------

	
function nut.bar.drawSquadHP(x, y, w, h, client)
		nut.util.drawBlurAt(x, y, w, h)

		surface.SetDrawColor(255, 255, 255, 15)
		surface.DrawRect(x, y, w, h)
		surface.DrawOutlinedRect(x, y, w, h)

		x, y, w, h = x + 2, y + 2, (w - 4) * (client:Health() / client:GetMaxHealth()), (h - 4)

		surface.SetDrawColor(150, 30, 20, 250)
		surface.DrawRect(x, y, w, h)
	
		surface.SetDrawColor(255, 255, 255, 8)
		surface.SetMaterial(gradient)
		surface.DrawTexturedRect(x, y, w, h)
		
		
end	

function nut.bar.drawSquadArmor(x, y, w, h, client)
		nut.util.drawBlurAt(x, y, w, h)

		surface.SetDrawColor(255, 255, 255, 15)
		surface.DrawRect(x, y, w, h)
		surface.DrawOutlinedRect(x, y, w, h)

		x, y, w, h = x + 2, y + 2, (w - 4) * (client:Armor() / 500), (h - 4)

		surface.SetDrawColor(255, 215, 0, 250)
		surface.DrawRect(x, y, w, h)
	
		surface.SetDrawColor(255, 255, 255, 8)
		surface.SetMaterial(gradient)
		surface.DrawTexturedRect(x, y, w, h)
		
		draw.SimpleText(client:Nick(), "CenturyGothicSmall", x + w*.03, y + h + 15, color_white, 3, 1)
end

function nut.bar.drawSummonerHP(x, y, w, h, client)
		nut.util.drawBlurAt(x, y, w, h)

		surface.SetDrawColor(255, 255, 255, 15)
		surface.DrawRect(x, y, w, h)
		surface.DrawOutlinedRect(x, y, w, h)

		x, y, w, h = x + 2, y + 2, (w - 4) * (client:Health() / client:GetMaxHealth()), (h - 4)

		surface.SetDrawColor(150, 30, 20, 250)
		surface.DrawRect(x, y, w, h)
	
		surface.SetDrawColor(255, 255, 255, 8)
		surface.SetMaterial(gradient)
		surface.DrawTexturedRect(x, y, w, h)
		
		draw.SimpleText(client.Name, "CenturyGothicSmall", x + w*.03, y + h + 15, color_white, 3, 1)

end	

--------------------------------------------------------------------

-- Compass --
local width = ScrW()
local height = ScrH()
local maxWidth = (width * 0.05) * 4
local startWidth = width/2 - ((width * 0.05)*2)

local aimDirs = {}

aimDirs[360] = "N"
aimDirs[0] = "N"
aimDirs[45] = "NE"
aimDirs[90] = "E"
aimDirs[135] = "SE"
aimDirs[180] = "S"
aimDirs[225] = "SW"
aimDirs[270] = "W"
aimDirs[315] = "NW"

local numsDir = {}
numsDir[0] = -3
numsDir[1] = -2
numsDir[2] = -1
numsDir[3] = 0
numsDir[4] = 1
numsDir[5] = 2
numsDir[6] = 3
-----------------------------------------------------------------------

hook.Add( "PreDrawHalos", "HUDTarget", function()
	local options = {}

	if file.Exists("gearoptions.txt", "DATA") then
		local table = file.Read("gearoptions.txt", "DATA")
		options = util.JSONToTable( table )
	end

	local haloColour = options["colourTargetButton"] or Color( 225, 255, 255 )
	haloColour.a = 255

	local Target = LocalPlayer():GetEyeTrace().Entity
	if (Target:IsNPC() or Target:IsPlayer()) then
		local Entities = {}
		Entities[1] = Target
		halo.Add( Entities, haloColour, 0, 0, 4, true, true )
	end
end)



function nut.bar.drawAll()
	if (hook.Run("ShouldHideBars")) then
		return
	end
	if !(LocalPlayer():getChar()) then return end
	if !LocalPlayer():Alive() then return end
	
	DrawBorder( LocalPlayer() )
	DrawXP( LocalPlayer() )
	DrawStm( LocalPlayer() )
	DrawHealth( LocalPlayer() )
	DrawArmor(LocalPlayer())
	DrawPsy( LocalPlayer() )
	DrawUlt( LocalPlayer() )
	DrawRanged( LocalPlayer() )
	DrawMelee( LocalPlayer() )
	DrawAOE( LocalPlayer() )
	
	local w, h = surface.ScreenWidth() * 0.10, BAR_HEIGHT
	local x, y = ScrW() * 0.02 + 70, ScrH() * 0.2
	local deltas = nut.bar.delta
	local frameTime = FrameTime()
	local curTime = CurTime()
	
	nut.bar.drawAction() 

	---- SQUAD -----

	local players = (team.NumPlayers(LocalPlayer():Team()))
	if !IsValid(iconmodel) then 
	
			/*

			*/
	end
	local SummonerPool = LocalPlayer():getChar():GetSummonerPool()

	for k, v in pairs(SummonerPool) do
		if(Entity(k):IsNPC()) then
			nut.bar.drawSummonerHP(x, y, w, h, Entity(k))
			y = y + 65
		end
	end

	if !tobool(SquadInformation:GetString()) then
		for k, v in ipairs(team.GetPlayers(LocalPlayer():Team())) do
			--print(v)
			--print(LocalPlayer())
			if v == LocalPlayer() then
			
			else
				nut.bar.drawSquadHP(x, y, w, h, v)
				y = y + h
				nut.bar.drawSquadArmor(x, y, w, h, v)
				
				y = y - h + 65
				
			end
		end
	end

	-- Compass --

	/*
	local dirWidth = (width / 20) 
	local dirStartWidth = (dirWidth* 10) + (dirWidth * 3)

	local aimDir =   359 - math.floor(math.NormalizeAngle( LocalPlayer():EyeAngles().yaw) + 180)

	draw.SimpleText( aimDir,"CenturyGothicSmall",width/2, 16,Color(255, 255, 255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
	local offset = 0

	for i=0,6 do
		local dived = (math.floor((aimDir )/45)) 
		local tempDir = 45 * ((dived - numsDir[(i )] + offset) % 9)


		if aimDir <= 134 && tempDir >= 270 then
			offset = -45
		else
			if aimDir <= 90 then
				offset = 0
			end
		end 
		if aimDir >= 270 && tempDir <  135 then
			offset = 45
		else
			if aimDir >= 270 then
				offset = 0
			end
		end 


		tempDir = tempDir + offset

		draw.SimpleText( aimDirs[tempDir] or tempDir ,"CenturyGothic",dirStartWidth - (i* dirWidth) - (((aimDir % 45)/45) * dirWidth) , 16 + 25,Color(255, 255, 255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
	end*/


end