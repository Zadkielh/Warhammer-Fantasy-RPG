local PANEL = {}
    local paintFunctions = {}
    paintFunctions[0] = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 50)
        surface.DrawRect(0, 0, w, h)
    end
    paintFunctions[1] = function(this, w, h)
    end
 
    function PANEL:Init()
		
		if (IsValid(nut.gui.gear)) then
			nut.gui.gear:Remove()
		end

		nut.gui.gear = self
		nut.gui.examinePly = self.ply
		nut.gui.examineItems = self.items
		nut.gui.examineItemStats = self.itemStats
		nut.gui.examineAttribs = self.charAttribs

		local options = {}

		if file.Exists("gearoptions.txt", "DATA") then
			local table = file.Read("gearoptions.txt", "DATA")
			options = util.JSONToTable( table )
		else
			local table = util.TableToJSON( options )
			file.Write( "gearoptions.txt", table )
		end

		if !(options["background"]) then
			options["background"] = "vgui/tree.png"
		end


		self.backgroundMaterial = nut.util.getMaterial(options["background"])
		self.buttonColour = options["colourButton"] or Color( 225, 155, 20 )
		
        self:SetSize(ScrW() * 0.8, ScrH() * 0.8)
        self:Center()
		self:MakePopup()
		self:SetTitle("")
		self:SetDraggable(false)
		self:SetAlpha(0)
		self:AlphaTo(255, 0.25, 0)

		self.tabs = self:Add("DHorizontalScroller")
		self.tabs:SetWide(self:GetWide() * 0.9)
		self.tabs:SetTall(60)
		self.tabs:SetPos(self:GetWide() * 0.05, 0)
		self.tabs.Paint = function(this)
			surface.SetDrawColor(5, 5, 5, 100)
			surface.DrawRect(0, 0, self.tabs:GetWide(), self.tabs:GetTall())	

			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawOutlinedRect(0, 0, self.tabs:GetWide(), self.tabs:GetTall())
		end
		self.tabs:SetOverlap( -32 )

		self.panel = self:Add("EditablePanel")
		self.panel:SetSize(ScrW() * 0.8, ScrH() * 0.8 + 26)
		self.panel:Center()
		self.panel:SetPos(self.panel.x, self.panel.y + 72)
		self.panel:SetAlpha(0)

		local tabs = {}

		tabs["Character"] = function(panel)
			panel:Add("examineGear")
		end
		--tabs["Skills"] = function(panel)
		--	panel:Add("skillsInfo")
		--end
		--tabs["Traits"] = function(panel)
		--	panel:Add("traitsInfo")
		--end
		--tabs["Options"] = function(panel)
		--	panel:Add("optionsGear")
		--end

		local margin = 50
		/*

		tabs["Inventory"] = function(panel)
			if (hook.Run("CanPlayerViewInventory") != false) then
				local inventory = LocalPlayer():getChar():getInv()

				if (inventory) then
					local mainPanel = inventory:show(panel)

					local sortPanels = {}
					local totalSize = {x = 0, y = 0, p = 0}
					table.insert(sortPanels, mainPanel)

					totalSize.x = totalSize.x + mainPanel:GetWide() + margin
					totalSize.y = math.max(totalSize.y, mainPanel:GetTall())

					for id, item in pairs(inventory:getItems()) do
						if (item.isBag and hook.Run("CanOpenBagPanel", item) != false) then
							local inventory = item:getInv()

							local childPanels = inventory:show(mainPanel)
							nut.gui["inv"..inventory:getID()] = childPanels
							table.insert(sortPanels, childPanels)
									
							totalSize.x = totalSize.x + childPanels:GetWide() + margin
							totalSize.y = math.max(totalSize.y, childPanels:GetTall())
						end
					end
							
					local px, py, pw, ph = mainPanel:GetBounds()
					local x, y = px + pw/2 - totalSize.x / 2, py + ph/2 
					for _, panel in pairs(sortPanels) do
						panel:ShowCloseButton(true)
						panel:SetPos(x, y - panel:GetTall()/2)
						panel:SetDraggable(false)

						panel:SetAlpha(0)
						panel:AlphaTo(255, 0.25, 0)
						
						x = x + panel:GetWide() + margin
					end
							
					hook.Add("PostRenderVGUI", mainPanel, function()
						hook.Run("PostDrawInventory", mainPanel)
					end)
				end
			end
		end
		*/

		self.tabList = {}
		for name, callback in SortedPairs(tabs) do
			local tab = self:CreateMenuTabs(name, callback, name)
			self.tabList[name] = tab
		end

		timer.Simple(0.05, function()
			self:setActiveTab("Character")
		end)


		/*
		self.background = self:Add("DPanel")
		self.background:SetSize(ScrW() * 0.20, ScrH() * 0.45)
		self.background:SetPos( ScrW() * 0.15, ScrH() * 0.05  )
		self.background:SetPopupStayAtBack( true )
		self.background.Paint = function(this)

			surface.SetDrawColor(5, 5, 5, 100)
			surface.DrawRect(0, 0, self.background:GetWide(), self.background:GetTall())	

			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawOutlinedRect(0, 0, self.background:GetWide(), self.background:GetTall())
		end*/

		
		

		--nut.gui.gear.character = self:CreateCharacterMenu()
		--nut.gui.gear.inventory = self:CreateInventory()
	end

	function PANEL:OnKeyCodePressed(key)
		self.noAnchor = CurTime() + .5

		if (key == KEY_I) then
			self:Remove()
		end
	end

	function PANEL:Think()
		local key = input.IsKeyDown(KEY_F1)
		if (key and (self.noAnchor or CurTime()+.4) < CurTime() and self.anchorMode == true) then
			self.anchorMode = false
		end
	end

	function PANEL:CreateMenuTabs(name, callback, id)
		local function paintTab(tab, w, h)
			local colour = self.buttonColour
			colour.a = 150
			surface.SetDrawColor(colour)
			surface.DrawRect(0, 0, w, h)

			if (self.activeTab == tab) then
				surface.SetDrawColor(ColorAlpha(Color(255, 200, 50), 200))
				surface.DrawRect(0, h - 8, w, 8)
			elseif (tab.Hovered) then
				surface.SetDrawColor(0, 0, 0, 100)
				surface.DrawRect(0, h - 8, w, 8)
			end
		end

		local tab = self.tabs:Add("DButton")
			tab:SetSize(0, self.tabs:GetTall())
			tab:SetText(name)
			tab:SetPos(self.tabs:GetWide(), 0)
			tab:SetTextColor(Color(250, 250, 250))
			tab:SetFont("CenturyGothicSmall")
			tab:SetExpensiveShadow(1, Color(0, 0, 0, 150))
			tab:SizeToContentsX()
			tab:SetWide(128)
			tab.Paint = paintTab
			tab.DoClick = function(this)

				self.panel:Clear()

				self.panel:AlphaTo(255, 0.5, 0.1)
				self.activeTab = this
				lastMenuTab = uniqueID

				if (callback) then
					callback(self.panel, this)
				end

			end
		self.tabs:AddPanel(tab)
		return tab
	end

	function PANEL:CreateInventory(panel)
		if (nut.gui.inv1) then
			nut.gui.inv1:Remove()
		end

		nut.gui.inv1 = panel:Add("nutInventory")
		nut.gui.inv1.childPanels = {}

		local inventory = LocalPlayer():getChar():getInv()

		if (inventory) then
			nut.gui.inv1:setInventory(inventory)
			nut.gui.inv1:ShowCloseButton(true)
		end
	end

	function PANEL:setActiveTab(key)
		if (IsValid(self.tabList[key])) then
			self.tabList[key]:DoClick()
		end
	end

	local bg = nut.util.getMaterial("vgui/tree.png")

    function PANEL:Paint(w, h)
        
		
		local x, y = self:LocalToScreen(0, 0)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.backgroundMaterial)
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetDrawColor(30, 30, 30, 100)
        surface.DrawRect(0, 0, w, h)
 
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawOutlinedRect(0, 0, w, h)

    end


vgui.Register("examineInfo", PANEL, "DFrame")

net.Receive( "openExamine", function( len )
	local ply = net.ReadEntity()
	local Items = net.ReadTable()
	local itemStats = net.ReadTable()
	local charAttribs = net.ReadTable()
	PANEL.ply = ply
	PANEL.items = Items
	PANEL.itemStats = itemStats
	PANEL.charAttribs = charAttribs
	vgui.CreateFromTable( PANEL )
end) 