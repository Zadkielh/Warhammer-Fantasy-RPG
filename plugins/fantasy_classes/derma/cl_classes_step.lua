local PANEL = {}

local HIGHLIGHT = Color(255, 255, 255, 50)

function PANEL:Init()
	
	self.nameLabel = self:addLabel("Classes")
	self.nameLabel:SetZPos(0)

    self.CatList = self:Add("DScrollPanel")
	self.CatList:Dock(LEFT)
    self.CatList:SetSize( 300, ScrH() * 0.5 )
    self.CatList.Paint = function(this)
		surface.SetDrawColor(0, 0, 0, 0)
		surface.DrawRect(0, 0, self.CatList:GetWide(), self.CatList:GetTall())	

        surface.SetDrawColor(0, 0, 0, 0)
        surface.DrawOutlinedRect(0, 0, self.CatList:GetWide(), self.CatList:GetTall())
	end

    self:InvalidateLayout(true)
end

function PANEL:addClass(panel, class)
		
		local model = panel:Add("nutModelPanel")
		local ent = model.Entity
		model:Dock(FILL)
        --model:SetSize(ScrW() * 0.2, ScrH() * 0.45)
		
		model:SetCamPos( Vector( 75, 75, 60))
		model:SetLookAt( Vector( 0, 0, 45 ) )
		model.enableHook = true

		model:SetModel(nut.classes.list[class].model)
		
		if (istable(nut.classes.list[class].bodygroups)) then
			for k, v in pairs(nut.classes.list[class].bodygroups) do
				model.Entity:SetBodygroup(k, v)
			end
		end

        local ent = model.Entity
		ent:SetPos(ent:GetPos() + Vector(5, -10, 0))

		if (pac and model) then
			pac.SetupENT(ent)
			ent:AttachPACPart(nut.classes.list[class].pacdata)	
			ent.forceDraw = true
		end

		local container = model:Add("DPanel")
			
		container:Dock(RIGHT)
		container:SetWide(ScrW() * 0.1)

		local y2 = 0
		local total = 0
		local maximum = 100

		self.attribs = {}

		for k, v in SortedPairsByMemberValue(nut.attribs.list, "name") do
			maximum = v.maxValue or nut.config.get("maxAttribs", 30)
			local attribValue = nut.classes.list[class].attribs[k]
			local attribBoost = 0
			total = attribValue
			
            self.attribs[k] = 0

			local bar = container:Add("nutAttribBar")
			bar.sub:Remove()
			bar:setMax(maximum)
			bar:Dock(TOP)
			bar:DockMargin(2, 2, 2, 2)
			bar:setText(L(v.name) .. "  (" .. total .. "/".. maximum .. ")")
			bar:setReadOnly()
			bar:setValue(attribValue)

			y2 = y2 + bar:GetTall() + 4
		end

		container:SetTall(y2)
        --container:DockMargin( 0, 0, 0, 285 )

		/*local helpButton = model:Add("DButton")
		helpButton:SetText( "Choose" )	
		helpButton:SetFont("nutCharSubTitleFont")				// Set the text on the button
		helpButton:Dock(BOTTOM)
		helpButton:DockMargin(125,0,125,0)
		helpButton:SizeToContents()
			
		helpButton.DoClick = function()
	       
            --netstream.Start("SetClass", {
			--	id = id,
			--	class = class
			--})
		end
		helpButton.Paint = function(this)
			surface.SetDrawColor(30, 30, 30, 200)
            surface.DrawRect(0, 0, helpButton:GetWide(), helpButton:GetTall())
 
            surface.SetDrawColor(0, 0, 0, 150)
            surface.DrawOutlinedRect(0, 0, helpButton:GetWide(), helpButton:GetTall())
		end*/

        local descFrame = container:Add("DScrollPanel")
        descFrame:Dock( FILL )

        local nameLabel = descFrame:Add("DLabel")
	    nameLabel:Dock(TOP)
		nameLabel:SetFont("CenturyGothicSmall")
		nameLabel:SetText("Class Description:")
		nameLabel:SizeToContents()
		nameLabel:SetTextColor(color_white)
		nameLabel:SetExpensiveShadow(2, Color(0, 0, 0, 200))

        local descLabel = descFrame:Add("DLabel")
	    descLabel:Dock(TOP)
		descLabel:SetFont("CenturyGothicVerySmall")
		descLabel:SetText(nut.classes.list[class].desc)
        descLabel:SetWrap(true)
        descLabel:SetAutoStretchVertical(true)
		descLabel:SetTextColor(color_white)
		descLabel:SetExpensiveShadow(2, Color(0, 0, 0, 200))
        
        local skillButton = container:Add("DButton")
		skillButton:SetText( "Skills" )	
		skillButton:SetFont("nutCharSubTitleFont")				// Set the text on the button
		skillButton:Dock(BOTTOM)
        skillButton:DockMargin( 0,0,0,0 )
		skillButton:SizeToContents()
			
		skillButton.DoClick = function()
			vgui.Create("skillsInfoStep")
		end
		skillButton.Paint = function(this)
			surface.SetDrawColor(30, 30, 30, 200)
            surface.DrawRect(0, 0, skillButton:GetWide(), skillButton:GetTall())
 
            surface.SetDrawColor(0, 0, 0, 150)
            surface.DrawOutlinedRect(0, 0, skillButton:GetWide(), skillButton:GetTall())
		end
	
    return model

end

function PANEL:addClassCat(panel, class, key)
    
                local button = panel:Add( "DButton" )
				button:SetText( "  "..class.name )
				button:Dock(TOP)	
				button:DockMargin(0,10,10,10)
                button:SetTall(82)
				button:SetTextColor(Color(255,200,51,200))
				--button:SetWide(420)
                button:SetFont("nutCharSubTitleFont")
                button:SetWrap(true)
				button.Paint = function(this)
					draw.RoundedBox( 8, 0, 0, button:GetWide(), button:GetTall(), Color(10,10,10,150) )

					if (button.isSelected or button:IsHovered()) then
						surface.SetDrawColor(Color(255,200,51,200))
						surface.DrawOutlinedRect(0, 0, button:GetWide(), button:GetTall())
					end
				end
                
				button.OnCursorEntered = function()
					button:SetTextColor(Color(255,255,255,200))
				end
				button.OnCursorExited = function()
					button:SetTextColor(Color(255,200,51,200))
				end
                button.DoClick = function()
                    if (panel.ClassModel or panel.nameClassLabel) then
                        panel.ClassModel:Remove()
                    end
					self:setSelected(button)
					self:setContext("class", key)
                    panel.ClassModel = self:addClass(self, key)
                end
		
				if (class.icon) then
					self:addClassImage(button, class.icon)
				end

    panel:InvalidateLayout(true)

	return panel
end

function PANEL:addClassImage(panel, icon)
	local Image = panel:Add("DImage")
	Image:SetImage( icon )
	Image:Dock(RIGHT)
	Image:DockMargin(0, 10, 10, 10)
	return Image
end

function PANEL:onDisplay()
	local char = LocalPlayer():getChar()
	local parent = self:GetParent()
    local model = self:getModelPanel()
    --model:Hide()
    model:SetVisible( false )

	if (self.CatList.ClassCat) then
		self.CatList.ClassCat:Show()
	else
		for k, v in pairs(nut.classes.list) do
			if istable(v.faction) then
				
				for k2, v2 in pairs(v.faction) do
					print("Class.IsTable.FactionCheck", self:getContext("faction"), v2)
					if v2 == self:getContext("faction") then
						print("Class.IsTable.FactionApproved")
						if (v.flagReq) then
							if (char) then
								if char:hasFlags(v.flagReq) then 
									self.CatList.ClassCat = self:addClassCat(self.CatList, v, k)
								end
							end
						else
							self.CatList.ClassCat = self:addClassCat(self.CatList, v, k)
						end
					end
				end
			elseif (v.faction and v.faction == self:getContext("faction")) then
				
				if (v.flagReq) then
					if (char) then
						if char:hasFlags(v.flagReq) then 
							self.CatList.ClassCat = self:addClassCat(self.CatList, v, k)
						end
					end
				else
					self.CatList.ClassCat = self:addClassCat(self.CatList, v, k)
				end
			elseif !(v.faction) then
				
				if (v.flagReq) then
					if (char) then
						if char:hasFlags(v.flagReq) then 
							self.CatList.ClassCat = self:addClassCat(self.CatList, v, k)
						end
					end
				else
					self.CatList.ClassCat = self:addClassCat(self.CatList, v, k)
				end
			end
		end
		
	end
    
	--nut.gui.charCreate.content:DockMargin(40,64,40,0)
end

function PANEL:onHide()
    local model = self:getModelPanel()
    if !(model:IsVisible()) then
        model:SetVisible( true )
    end

	if (self.CatList.ClassCat) then
		self.CatList.ClassCat:Hide()
	end

end

function PANEL:onSelected(callback)
	self.callback = callback
end

function PANEL:setSelected(panel, isSelected)
	if (isSelected == nil) then isSelected = true end
	if (isSelected and panel.isSelected) then return end

	local menu = self.CatList
	if (isSelected and IsValid(menu)) then
		if (IsValid(menu.lastTab)) then
			menu.lastTab:SetTextColor(Color(255,200,51,200))
			menu.lastTab.isSelected = false
		end
		menu.lastTab = panel
	end

	panel:SetTextColor(
		isSelected
		and Color(255,255,255,200)
		or Color(255,200,51,200)
	)
	panel.isSelected = isSelected
	if (isfunction(self.callback)) then
		self:callback()
	end
end


vgui.Register("nutCharacterClasses", PANEL, "nutCharacterCreateStep")