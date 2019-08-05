local PANEL = {}
    local paintFunctions = {}
    paintFunctions[0] = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 50)
        surface.DrawRect(0, 0, w, h)
    end
    paintFunctions[1] = function(this, w, h)
    end
 
function PANEL:Init()

		nut.gui.traits = self
		
		self:SetSize(self:GetParent():GetSize())
        self:SetAlpha(0)
		self:AlphaTo(255, 0.25, 0)
		self:DockPadding(50, 50, 50, 25)

		self.ScrollPanel = self:Add("DScrollPanel")
		self.ScrollPanel:Dock( FILL )
		self.ScrollPanel:DockMargin(0, 0, 0, 25)   
		self.ScrollPanel:DockPadding(0, 0, 0, 0)       
		self.ScrollPanel.Paint = function(this)
		end

		local bar = self.ScrollPanel:GetVBar()
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

		self.panels = {}
		local lastpanel
		local x, y = 10, 60
		local test = 1
		for k, v in pairs(nut.traitCategories.list) do
			local char = LocalPlayer():getChar()
			if (char) then
				if v.class == char:getClass() then
					v.order = 1
				end
			end
		end

		for k, v in SortedPairsByMemberValue(nut.traitCategories.list, "order") do
			if !IsValid(self.panels[v.name]) then
				
				local panel = self:AddCategory(self.ScrollPanel, v)
				self.panels[v.name] = panel
				
				
			end
	    end
	    
		for k, v in pairs(nut.traits.list) do
			print("Traits:", k, v)
		end

		for k, v in pairs( nut.traits.list) do
			if IsValid(self.panels[v.category]) then
				if self.panels[v.category].x == (nil or 0) then
					self.panels[v.category].x = 50
				else
					self.panels[v.category].x = self.panels[v.category].x + 64 + 44
				end
				
				if self.panels[v.category].y == (nil or 0) then
					self.panels[v.category].y = 200
				end
				
				if self.panels[v.category].x > (self.panels[v.category]:GetWide() - 64 - 50) then
					self.panels[v.category].y = self.panels[v.category].y + 64 + 30
					self.panels[v.category].x = 50
				end

				self.panels[v.category].traits = {}

				local trait = self:AddTrait(v, k, (self.panels[v.category].x), self.panels[v.category].y, self.panels[v.category])
				self.panels[v.category].traits[k] = trait
			end
			
		end
		
	    if (LocalPlayer():getChar()) then
			self.SkillPoints = self:Add("DButton")
			self.SkillPoints:SetText( "SkillPoints: " .. LocalPlayer():getChar():getSkillPoints() )	
			self.SkillPoints:SetFont("nutCharSubTitleFont")				// Set the text on the button
			self.SkillPoints:Dock(TOP)
			self.SkillPoints:SetTextColor(Color(255,255,255,200))
			self.SkillPoints:DockMargin(ScrW() * 0.25,ScrH() * 0,ScrW() * 0.25,ScrH() * 0.02)
		

    		self.SkillPoints.Paint = function(this)
    			draw.RoundedBox( 8, 0, 0, self.SkillPoints:GetWide(), self.SkillPoints:GetTall(), Color(10,10,10,200) )
    		end
		end

		self.CloseButton = self:Add("DButton")
		self.CloseButton:SetText( "Close" )	
		self.CloseButton:SetFont("nutCharSubTitleFont")				// Set the text on the button
		self.CloseButton:Dock(BOTTOM)
		self.CloseButton:SetTextColor(Color(255,200,50,200))
		self.CloseButton:DockMargin(ScrW() * 0.25,0,ScrW() * 0.25,0)

		self.CloseButton.DoClick = function()
			self:Remove()
		end
		self.CloseButton.OnCursorEntered = function()
			self.CloseButton:SetTextColor(Color(255,255,255,255))
		end
		self.CloseButton.OnCursorExited = function()
			self.CloseButton:SetTextColor(Color(255,200,50,200))
		end
		self.CloseButton.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, self.CloseButton:GetWide(), self.CloseButton:GetTall(), Color(10,10,10,150) )
		end
		
		
	end

	function PANEL:AddCategory(panel, cat)
		local ScrollPanel = panel:Add("DScrollPanel")
		ScrollPanel:Dock(TOP)
		ScrollPanel:DockMargin(150, 100, 150, 200)
		ScrollPanel:SetSize(1080, ScrH() * 0.5)
		ScrollPanel.Paint = function(this)
			if (cat.background) then
				local mat = nut.util.getMaterial(cat.background)
				surface.SetDrawColor(255, 255, 255, 200)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(8, 8, ScrollPanel:GetWide() - 16, ScrollPanel:GetTall() - 16)
			end
			draw.RoundedBox( 8, 0, 0, ScrollPanel:GetWide(), ScrollPanel:GetTall(), Color(10,10,10,230) )
		end

		local bar = ScrollPanel:GetVBar()
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

		local Title = ScrollPanel:Add("DLabel")
		Title:SetFont("CenturyGothicMedium")
		Title:SetTextColor(color_white)
		--Title:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		Title:SetText(tostring(cat.name))
		Title:Dock(TOP)
		Title:SizeToContents()
		Title:DockMargin(400, 10, 0, 0)
		
		local icon = ScrollPanel:Add("DImageButton")
		icon:DockMargin(50, 10, 0, 0)
		icon:Dock(LEFT)

		if (cat.iconx and cat.icony) then
			icon:SetSize( cat.iconx + 40, cat.icony + 40)
		else
			icon:SetSize( 128, 128 )
		end
		
		icon.Paint = function(this)
			local mat = nut.util.getMaterial(cat.icon or "vgui/Crest.png")
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(mat)
			if (cat.iconx and cat.icony) then
				surface.DrawTexturedRect(0, 0, cat.iconx, cat.icony)
			else
				surface.DrawTexturedRect(0, 0, 128, 128)
			end

		end

		local Desc = ScrollPanel:Add("DLabel")
		Desc:Dock(TOP)
		Desc:DockMargin(100,20,100,0)
		Desc:SetText( tostring(cat.desc) )
		Desc:SetTextColor(color_white)
		Desc:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		Desc:SetWrap(true)
		Desc:SetAutoStretchVertical(true)
		Desc:SetFont("CenturyGothicSmall")

		ScrollPanel:InvalidateLayout()
		return ScrollPanel
	end

	function PANEL:AddTrait(trait, key, x, y, panel)
		local icon = panel:Add("DImageButton")
		icon.name = trait.name
		icon.mat = trait.icon
		--icon:Dock(TOP)
		icon:DockMargin(10, 0, 0, 5)
		icon:SetPos( x, y )
		icon:SetSize( 72, 72 )
		icon.Paint = function(this)
			

			draw.RoundedBox( 4, 0, 0, 72, 72, Color(10,10,10,250) )
			
			if (LocalPlayer():getChar() and (istable(LocalPlayer():getChar():canClientAquireTrait(key)))) then
				draw.RoundedBox( 4, 0, 0, 72, 72, LocalPlayer():getChar():canClientAquireTrait(key) )
				draw.RoundedBox( 1, 4, 4, 64, 64, Color(10,10,10,250) )
			end

			local mat = nut.util.getMaterial(trait.icon)
			surface.SetDrawColor(255, 255, 255, 50)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(4, 4, 64, 64)
			
			
			if (LocalPlayer():getChar() and LocalPlayer():getChar():hasTrait(key)) then
				draw.RoundedBox( 4, 0, 0, 72, 72, Color(255,255,255,230) )
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
			if (self.HelpPanel) then
				self.HelpPanel:Remove()
			end
			self.HelpPanel = self:openHelp(panel, trait, x, y, key)
		end
		icon.DoRightClick = function()
			if ( LocalPlayer():getChar() ) and ( LocalPlayer():getChar():hasTrait(key) ) then
				
				if (self.HelpPanel) then
					self.HelpPanel:Remove()
				end
				self.HelpPanel = self:openHelp(panel, trait, x, y, key)

			end
		end

		/*
		local Title = panel:Add("DLabel")
		Title:SetFont("CenturyGothicVerySmall")
		Title:SetTextColor(color_white)
		--Title:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		Title:SetText(icon.name)
		Title:SetPos( x, y + 64)
		Title:SizeToContents()
		*/

		

		return icon
	end

    function PANEL:Paint(w, h)
	local bg1 = nut.util.getMaterial("vgui/background_bar.png")
        nut.util.drawBlur(self, 10)

		--surface.SetDrawColor(255, 255, 255, 200)
		--surface.SetMaterial(bg1)
		--surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(5, 5, 5, 200)
        surface.DrawRect(0, 0, w, h)
 
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

	function PANEL:openHelp(panel, trait, x, y, key)
			
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
		helpTitle:SetText(tostring(trait.name))
		helpTitle:SizeToContents()
		helpTitle:Dock(TOP)
		helpTitle:DockMargin(125,0,100,0)

		local helpIcon = panel.help:Add("DImage")
		helpIcon:Dock(TOP)
		helpIcon:DockMargin(172,10,172,0)
		helpIcon:SetTall(64)
		helpIcon:SetImage( tostring(trait.icon) )

		
		local helpDesc = panel.help:Add("DLabel")
		helpDesc:Dock(TOP)
		helpDesc:DockMargin(50,10,50,0)
		helpDesc:SetText( tostring(trait.desc) )
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
			if (LocalPlayer():getChar() and !(LocalPlayer():getChar():hasTrait(key))) then
				netstream.Start("AquireTrait", {
					id = id,
					trait = key
				})
			end
		end
		
		AquireButton.OnCursorEntered = function()
			if (LocalPlayer():getChar() and (LocalPlayer():getChar():hasTrait(key)) or !LocalPlayer():getChar()) then return end
			AquireButton:SetTextColor(Color(255,255,255,255))
		end
		AquireButton.OnCursorExited = function()
			if (LocalPlayer():getChar() and (LocalPlayer():getChar():hasTrait(key)) or !LocalPlayer():getChar()) then return end
			AquireButton:SetTextColor(Color(255,200,50,200))
		end
		AquireButton.Paint = function(this)
			draw.RoundedBox( 8, 0, 0, AquireButton:GetWide(), AquireButton:GetTall(), Color(10,10,10,150) )
		end

		if (LocalPlayer():getChar() and (LocalPlayer():getChar():hasTrait(key)) or !LocalPlayer():getChar()) then
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

vgui.Register("traitsInfo", PANEL, "EditablePanel")

-------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------

