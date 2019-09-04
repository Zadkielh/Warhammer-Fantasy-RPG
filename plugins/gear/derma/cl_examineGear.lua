local PANEL = {}
    local paintFunctions = {}
    paintFunctions[0] = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 50)
        surface.DrawRect(0, 0, w, h)
    end
    paintFunctions[1] = function(this, w, h)
    end
 
    function PANEL:Init()

		nut.gui.characterGear = self
		local ply = nut.gui.examinePly
		local items = nut.gui.examineItems
		local itemStats = nut.gui.examineItemStats
		local charAttribs = nut.gui.examineAttribs
		

		self:SetSize(self:GetParent():GetSize())

		self:SetAlpha(0)
		self:AlphaTo(255, 0.25, 0)

		self.model = self:Add("nutModelPanel")
        self.model:SetSize(ScrW() * 0.30, ScrH() * 0.6)
		self.model:SetPos(ScrW() * 0.25, 0.6)
		self.model:SetCamPos( Vector( 40, 40, 50))
		self.model:SetLookAt( Vector( 0, 0, 45 ) )
		self.model.enableHook = true

		self.model:SetModel(ply:GetModel())
			self.model.Entity:SetSkin(ply:GetSkin())

			for k, v in ipairs(ply:GetBodyGroups()) do
				self.model.Entity:SetBodygroup(v.id, ply:GetBodygroup(v.id))
			end

			local ent = self.model.Entity
			if (ent and IsValid(ent)) then
				local mats = ply:GetMaterials()
				for k, v in pairs(mats) do
					ent:SetSubMaterial(k - 1, ply:GetSubMaterial(k - 1))
				end
			end
			if (pac and self.model) then
				-- If the Modelpanel's Entity is valid, setup PAC3 Function Table.
				if (ent and IsValid(ent)) then
						-- Setup function table.
					pac.SetupENT(ent)

					local parts = ply:getParts()

						-- Wear current player's PAC3 Outfits on the ModelPanel's Clientside Model Entity.
					for k, v in pairs(parts) do
						if (nut.pac.list[k]) then
							ent:AttachPACPart(nut.pac.list[k])
						end
					end
						
						-- Overrride Model Drawing function of ModelPanel. (Function revision: 2015/01/05)
						-- by setting ent.forcedraw true, The PAC3 outfit will drawn on the model even if it's NoDraw Status is true.
					ent.forceDraw = true
				end
			end

		local levelTextTable = {
			[1] = {"Level ", Color(0, 255, 0)},
			[2] = {"Level ", Color(250, 200, 0)},
			[3] = {"Level ", Color(200, 0, 0)},
			[4] = {"Level ", Color(255, 0, 100)},
			[5] = {"Level ", Color(255, 0, 200)},
			[6] = {"Level ", Color(155, 0, 155)},
			[7] = {"Level ", Color(255, 100, 15)},
			[8] = {"Level ", Color(100, 200, 255)},
			[9] = {"Level ", Color(50, 255, 0)},
			[10] = {"Level ", Color(100, 10, 255)},
			[11] = {"Level ", Color(0, 0, 0)},
		}	
		
		local color = nil 
		local level = ply:getChar():getLevel()
		level = tonumber(level)

		self.background2 = self:Add("DPanel")
		self.background2:SetSize(ScrW() * 0.4625, ScrH() * 0.05)
		self.background2:SetPos( ScrW() * 0.175, 0 )
		self.background2:SetPopupStayAtBack( true )
		self.background2.Paint = function(this)
			surface.SetDrawColor(5, 5, 5, 200)
			surface.DrawRect(0, 0, self.background2:GetWide(), self.background2:GetTall())
	
			surface.SetDrawColor(0, 0, 0, 250)
			surface.DrawOutlinedRect(0, 0, self.background2:GetWide(), self.background2:GetTall())	

		end

		for k, v in pairs(levelTextTable) do
			if (math.ceil( level / 10 ) == k) then
				color = v[2]
			end
		end

		self.classTitle = self.background2:Add("DLabel")
		self.classTitle:SetFont("SeagramMedium")
		self.classTitle:SetTextColor(color)
		self.classTitle:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.classTitle:SetText("Level " .. level .. " " .. nut.classes.list[ply:getChar():getClass()].name)
		self.classTitle:SizeToContentsY()
		self.classTitle:SizeToContentsX()
		self.classTitle:Center()

	
		self.background3 = self:Add("DPanel")
		self.background3:SetSize(ScrW() * 0.125, ScrH() * 0.285)
		self.background3:SetPos( ScrW() * 0.5125, ScrH() * 0.05 )
		self.background3:SetPopupStayAtBack( true )
		self.background3.Paint = function(this)
			local bg1 = nut.util.getMaterial("vgui/border_bg2.png")	
			surface.SetDrawColor(5, 5, 5, 200)
			surface.DrawRect(0, 0, self.background3:GetWide(), self.background3:GetTall())
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawOutlinedRect(0, 0, self.background3:GetWide(), self.background3:GetTall())
		end

		self.attribName = self:Add("DLabel")
		self.attribName:SetFont("SeagramSmall")
		self.attribName:SetTextColor(color_white)
		self.attribName:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.attribName:SetText(L"attribs")
		self.attribName:SetPos( ScrW() * 0.55, ScrH() * 0.08  )
		self.attribName:SetSize(ScrW() * 0.1, ScrH() * 0.02)	

		self.background4 = self:Add("DPanel")
		self.background4:SetSize(ScrW() * 0.4625, ScrH() * 0.05)
		self.background4:SetPos( ScrW() * 0.175, ScrH() * 0.6 )
		self.background4:SetPopupStayAtBack( true )
		self.background4.Paint = function(this)

			surface.SetDrawColor(5, 5, 5, 200)
			surface.DrawRect(0, 0, self.background4:GetWide(), self.background4:GetTall())
			surface.SetDrawColor(0, 0, 0, 250)
			surface.DrawOutlinedRect(0, 0, self.background4:GetWide(), self.background4:GetTall())
			
		end

		self.charName = self.background4:Add("DLabel")
		self.charName:SetFont("SeagramMedium")
		self.charName:SetTextColor(color_white)
		self.charName:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.charName:SetText(ply:Nick())
		self.charName:SizeToContentsY()
		self.charName:SizeToContentsX()
		self.charName:Center()
		

		local char = ply:getChar()
		local attribValue = char:getAttrib(k, 0)
		local container = self:Add("DPanel")
			
		container:SetPos(ScrW() * 0.525, ScrH() * 0.1)
		container:SetWide(ScrW() * 0.1)

		local y2 = 0
		local total = 0
		local maximum = 100
		local boost = char:getBoosts()

		self.attribs = {}

		for k, v in SortedPairsByMemberValue(nut.attribs.list, "name") do
			maximum = v.maxValue or nut.config.get("maxAttribs", 30)
			local attribValue = charAttribs[k]
			local attribBoost = 0
			total = attribValue
			if (boost[k]) then
				for _, bValue in pairs(boost[k]) do
					attribBoost = attribBoost + bValue
				end
			end
			self.attribs[k] = 0

			local bar = container:Add("nutAttribBar")
			bar.sub:Remove()
			bar:setMax(maximum)
			bar:Dock(TOP)
			bar:DockMargin(2, 2, 2, 2)
			bar:setText(L(v.name) .. "  (" .. total .. "/".. maximum .. ")")

			bar:setReadOnly()

			if (attribBoost) then
				bar:setValue(attribValue - attribBoost or 0)
			else
				bar:setValue(attribValue)
			end

			if (attribBoost) then
				bar:setBoost(attribBoost)
			end

			y2 = y2 + bar:GetTall() + 4
		end

		container:SetTall(y2)

		self.background7 = self:Add("DPanel")
		self.background7:SetSize(ScrW() * 0.125, ScrH() * 0.25)
		self.background7:SetPos( ScrW() * 0.5125, ScrH() * 0.35 )
		self.background7:SetPopupStayAtBack( true )
		self.background7.Paint = function(this)
			surface.SetDrawColor(5, 5, 5, 200)
			surface.DrawRect(0, 0, self.background7:GetWide(), self.background7:GetTall())
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawOutlinedRect(0, 0, self.background7:GetWide(), self.background7:GetTall())
			
		end

		local CatList = self:Add("DCategoryList")
		CatList.Paint = function(this)
		end

		CatList:SetPos( ScrW() * 0.5125, ScrH() * 0.35  )
		CatList:SetSize( ScrW() * 0.125, ScrH() * 0.2 )

		local Cat = CatList:Add( "General Stats" )
		local Cat1 = CatList:Add( "Special Stats" )

		Cat:Add( "Max Health:  " .. ply:GetMaxHealth() )
		Cat:Add( "Armor Rating:  " .. itemStats.armorrating )
		Cat:Add( "Health Regen:  " .. itemStats.hpRegen .. "/5s")
		Cat:Add( "Magic Regen:  " .. (ply:getChar():getAttrib("mgc", 0) / 100 * 2.5) * 20 .. "/5s") 
		Cat:Add( "Stamina Regen:  " .. (1 + (ply:getChar():getAttrib("end", 0) / 60)) * 20 .. "/5s") 
		Cat1:Add( "Max Shield:  " .. itemStats.maxShield )
		Cat1:Add( "Shield Regen:  " .. itemStats.shieldRegen )
		Cat1:Add( "Damage:  + " .. itemStats.Damage )
		Cat1:Add( "Critical Strike Chance:  " .. ply:getChar():getCriticalChance() .. "%" )
		Cat1:Add( "Speed: " .. ply:GetRunSpeed() )
		Cat1:Add( "Life Steal: " .. ply:getChar():getLifeSteal() )
		CatList:InvalidateLayout( true )

		self.EquipmentContainer = self:Add("DScrollPanel")
		self.EquipmentContainer:SetSize(ScrW() * 0.1, ScrH() * 0.55)
		self.EquipmentContainer:SetPos( ScrW() * 0.65, ScrH() * 0.05 )
		self.EquipmentContainer.Paint = function(this)
			surface.SetDrawColor(5, 5, 5, 200)
			surface.DrawRect(0, 0, self.EquipmentContainer:GetWide(), self.EquipmentContainer:GetTall())
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawOutlinedRect(0, 0, self.EquipmentContainer:GetWide(), self.EquipmentContainer:GetTall())
			
		end

		local bar = self.EquipmentContainer:GetVBar()
		function bar:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,0) )
		end
		function bar.btnUp:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,0) )
		end
		function bar.btnDown:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,0) )
		end
		function bar.btnGrip:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color(0,0,0,0) )
		end

		self.equipmentName = self.EquipmentContainer:Add("DLabel")
		self.equipmentName:SetFont("SeagramMedium")
		self.equipmentName:SetTextColor(color_white)
		self.equipmentName:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.equipmentName:SetText("Equipment")
		self.equipmentName:SizeToContentsY()
		self.equipmentName:SizeToContentsX()
		self.equipmentName:Dock(TOP)
		self.equipmentName:DockMargin(25, 5, 20, 0)
		for k, v in pairs( items ) do
			setmetatable(v.item, nut.meta.item)
			local item = nut.item.list[v.uniqueID]
			PrintTable(v.item)
			print(v.item:getID(), "ID")
			if (v.item:getData("equip")) then
				self:addItem(v.item, self.EquipmentContainer)
			end
		end

		self.skillsContainer = self:Add("DPanel")
		self.skillsContainer:SetSize(ScrW() * 0.25, ScrH() * 0.45)
		self.skillsContainer:SetPos( ScrW() * 0.05, ScrH() * 0.1 )
		self.skillsContainer.Paint = function(this)
			surface.SetDrawColor(5, 5, 5, 200)
			surface.DrawRect(0, 0, self.skillsContainer:GetWide(), self.skillsContainer:GetTall())
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawOutlinedRect(0, 0, self.skillsContainer:GetWide(), self.skillsContainer:GetTall())
			
		end

		self.desc = self.skillsContainer:Add("DLabel")
		self.desc:Dock(FILL)
		self.desc:DockMargin(65, 0, 48, 0)
		self.desc:SetWrap(true)
		self.desc:SetContentAlignment(7)
		self.desc:SetText(hook.Run("GetDisplayedDescription", ply) or (ply:getChar() and ply:getChar():getDesc()) or "")
		self.desc:SetTextColor(color_white)
		self.desc:SetExpensiveShadow(1, Color(0, 0, 0, 100))
		self.desc:SetFont("SeagramSmall")

		self.descName = self.skillsContainer:Add("DLabel")
		self.descName:SetFont("SeagramMedium")
		self.descName:SetTextColor(color_white)
		self.descName:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.descName:SetText("Description")
		self.descName:SizeToContentsX()
		self.descName:SizeToContentsY()
		self.descName:Dock(TOP)
		self.descName:DockMargin(175, 5, 20, 20)
		
	end

	local PADDING = 5
	function PANEL:addItem(item, panel)

		local icon = panel:Add("nutGridInvItem")
		icon:setItem(item)
		icon:Dock(TOP)
		icon:DockMargin(50, 10, 50, 10)
		icon:SetSize(64, 64)
		
	end

	function PANEL:AddSkill(skill, key, panel, slot)

		if (slot) then
			local slotName = panel:Add("DLabel")
			slotName:SetFont("SeagramSmall")
			slotName:SetTextColor(color_white)
			slotName:SetExpensiveShadow(1, Color(0, 0, 0, 150))
			slotName:SetText(tostring(slot))
			slotName:SizeToContentsY()
			slotName:SizeToContentsX()
			slotName:Dock(TOP)
			slotName:DockMargin(50, 5, 50, 0)
		end

		local icon = panel:Add("DImageButton")
		icon.name = skill.name
		icon.mat = skill.icon
		icon:DockMargin(50, 10, 0, 0)
		icon:Dock(TOP)
		icon:SetSize( 72, 72 )
		icon.Paint = function(this)
			

			draw.RoundedBox( 4, 0, 0, 72, 72, Color(10,10,10,250) )
			
			if (ply:getChar() and (istable(ply:getChar():canClientAquireSkill(key)))) then
				draw.RoundedBox( 4, 0, 0, 72, 72, ply:getChar():canClientAquireSkill(key) )
				draw.RoundedBox( 1, 4, 4, 64, 64, Color(10,10,10,250) )
			end

			local mat = nut.util.getMaterial(skill.icon)
			surface.SetDrawColor(255, 255, 255, 50)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(4, 4, 64, 64)
			
			
			if (ply:getChar() and ply:getChar():hasSkill(key) and !(ply:getChar():SelectedSkill(key, skill.slot))) then
				draw.RoundedBox( 4, 0, 0, 72, 72, Color(255,255,255,230) )
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(4, 4, 64, 64)
			end

			if (ply:getChar() and (ply:getChar():SelectedSkill(key, skill.slot))) then
				
				draw.RoundedBox( 4, 0, 0, 72, 72, Color(255,200,51,230) )
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(4, 4, 64, 64)
				
			end

			if (icon:IsHovered()) then
				surface.SetDrawColor(Color(255,200,51,255))
				surface.DrawOutlinedRect(4, 4, 64, 64)
				surface.SetDrawColor(Color(255,200,51,255))
				surface.DrawOutlinedRect(3, 3, 66, 66)
				surface.SetDrawColor(Color(255,200,51,255))
				surface.DrawOutlinedRect(2, 2, 68, 68)

				surface.SetDrawColor(255, 255, 255, 200)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(4, 4, 64, 64)
			end

			
		end
		icon.OnCursorEntered = function()
			--self:openHelp(panel, skill, x, y)
		end
		icon.OnCursorExited = function()
			--self:closeHelp(panel)
		end
		icon.DoClick = function()
			if ( ply:getChar() ) and ( ply:getChar():hasSkill(key) ) then
				netstream.Start("ChangeAbility", {
					id = id,
					skill = key
				})
				return
			end

			if (self.HelpPanel) then
				self.HelpPanel:Remove()
			end
			self.HelpPanel = self:openHelp(panel, skill, x, y, key)
		end
		icon.DoRightClick = function()
			if ( ply:getChar() ) and ( ply:getChar():hasSkill(key) ) then
				
				if (self.HelpPanel) then
					self.HelpPanel:Remove()
				end
				self.HelpPanel = self:openHelp(panel, skill, x, y, key)

			end
		end
		
		return icon
	end

	function PANEL:openHelp(panel, skill, x, y, key)
			
		panel.help = panel:Add("DFrame")
		panel.help:SetPos(ScrW() * 0.4, ScrH() * 0.3)
		panel.help:SetSize(428, 548)
		panel.help:ShowCloseButton( false )
		panel.help:MakePopup()
		panel.help:SetTitle("")

		local helpTitle = panel.help:Add("DLabel")
		helpTitle:SetFont("nutCharSubTitleFont")
		helpTitle:SetTextColor(color_white)
		helpTitle:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		helpTitle:SetText(tostring(skill.name))
		helpTitle:SizeToContents()
		helpTitle:Dock(TOP)
		helpTitle:DockMargin(125,0,0,0)

		local helpIcon = panel.help:Add("DImage")
		helpIcon:Dock(TOP)
		helpIcon:DockMargin(172,10,172,0)
		helpIcon:SetTall(64)
		helpIcon:SetImage( tostring(skill.icon) )

		
		local helpDesc = panel.help:Add("DLabel")
		helpDesc:Dock(TOP)
		helpDesc:DockMargin(50,10,50,0)
		helpDesc:SetText( tostring(skill.desc) )
		helpDesc:SetTextColor(color_white)
		helpDesc:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		helpDesc:SetWrap(true)
		helpDesc:SetAutoStretchVertical(true)
		helpDesc:SetFont("CenturyGothicVerySmall")
		
		local CloseButton = panel.help:Add("DButton")
		CloseButton:SetText( "Close" )	
		CloseButton:SetFont("nutCharSubTitleFont")				// Set the text on the button
		CloseButton:Dock(BOTTOM)
		CloseButton:SetTextColor(Color(255,200,50,200))
		CloseButton:DockMargin(100,0,100,10)
			
		CloseButton.DoClick = function()
			panel.help:Remove()
		end
		CloseButton.OnCursorEntered = function()
			CloseButton:SetTextColor(Color(255,255,255,255))
		end
		CloseButton.OnCursorExited = function()
			CloseButton:SetTextColor(Color(255,200,50,200))
		end
		CloseButton.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, CloseButton:GetWide(), CloseButton:GetTall(), Color(10,10,10,150) )
		end

		local AquireButton = panel.help:Add("DButton")
		AquireButton:SetText( "Learn" )	
		AquireButton:SetFont("nutCharSubTitleFont")				// Set the text on the button
		AquireButton:Dock(BOTTOM)
		AquireButton:SetTextColor(Color(255,200,50,200))
		AquireButton:DockMargin(100,0,100,10)
		AquireButton.DoClick = function()
			if (ply:getChar() and !(ply:getChar():hasSkill(key))) then
				netstream.Start("AquireSkill", {
					id = id,
					skill = key
				})
			end
		end
		
		AquireButton.OnCursorEntered = function()
			if (ply:getChar() and (ply:getChar():hasSkill(key)) or !ply:getChar()) then return end
			AquireButton:SetTextColor(Color(255,255,255,255))
		end
		AquireButton.OnCursorExited = function()
			if (ply:getChar() and (ply:getChar():hasSkill(key)) or !ply:getChar()) then return end
			AquireButton:SetTextColor(Color(255,200,50,200))
		end
		AquireButton.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, AquireButton:GetWide(), AquireButton:GetTall(), Color(10,10,10,150) )
		end

		if (ply:getChar() and (ply:getChar():hasSkill(key)) or !ply:getChar()) then
			AquireButton:SetTextColor(Color(50,50,50,75))
		end

		panel.help.Paint = function(this)
			if !IsValid(panel.help) then return end
			local bg1 = nut.util.getMaterial("vgui/border_bg2.png")	
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(bg1)
			surface.DrawTexturedRect(0, 0, panel.help:GetWide(), panel.help:GetTall())
		end
		
		panel.help.Think = function()
			if !IsValid(panel) then
				panel.help:Remove()
			end
		end
		
		return panel.help
	end

	function PANEL:closeHelp(panel)
		if (IsValid(panel.help)) then
			panel.help:Remove()
		end
	end

    function PANEL:Paint(w, h)
        nut.util.drawBlur(self)

        surface.SetDrawColor(30, 30, 30, 100)
        surface.DrawRect(0, 0, w, h)
 
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawOutlinedRect(0, 0, w, h)
    end


vgui.Register("examineGear", PANEL, "EditablePanel")