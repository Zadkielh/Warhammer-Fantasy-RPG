local PANEL = {}
    local paintFunctions = {}
    paintFunctions[0] = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 50)
        surface.DrawRect(0, 0, w, h)
    end
    paintFunctions[1] = function(this, w, h)
    end
 
    function PANEL:Init()
		
		if (IsValid(nut.gui.classes)) then
			nut.gui.classes:Remove()
		end

		nut.gui.classes = self

        self:SetSize(ScrW() * 0.5, ScrH() * 0.5)
        self:Center()
		self:MakePopup()
		self:SetDraggable(false)

		local CatList = self:Add("DCategoryList")
		CatList:Dock(LEFT)
		CatList:SetSize( ScrW() * 0.1, ScrH() * 0.2 )
		CatList.Paint = function(this)
			local bg1 = nut.util.getMaterial("vgui/border_bg2.png")	
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(bg1)
			surface.DrawTexturedRect(0, 0, CatList:GetWide(), CatList:GetTall())
			
			--draw.SimpleText("Stat Points: "..LocalPlayer():getChar():getStatPoints(), "CenturyGothicSmall",ScrW() * 0.1, ScrH() * 0.1, Color(255,255,255,255), 1, 1)
		end
		local Cat = CatList:Add( "Classes" )

			for k, v in pairs(nut.classes.list) do
				local button = Cat:Add( v.name )
				button.DoClick = function()
					if (self.model) then
						self.model:Remove()
					end
					self.model = self:addClass(self, k)
				end
			end
		CatList:InvalidateLayout( true )
	end

    function PANEL:Paint(w, h)
		local bg1 = nut.util.getMaterial("vgui/background_equipment.png")
        nut.util.drawBlur(self, 10)

			surface.SetDrawColor(255, 255, 255, 200)
			surface.SetMaterial(bg1)
			surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(30, 30, 30, 100)
        surface.DrawRect(0, 0, w, h)
 
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
vgui.Register("classInfo", PANEL, "DPanel")

net.Receive( "openClassMenu", function( len )
	vgui.Create("classInfo")
end) 

function PANEL:addClass(panel, class)
		
		
		
		local model = panel:Add("nutModelPanel")
		local ent = model.Entity
        model:SetSize(ScrW() * 0.25, ScrH() * 0.45)
		model:Dock(FILL)
		
		model:SetCamPos( Vector( 50, 50, 60))
		model:SetLookAt( Vector( 0, 0, 45 ) )
		model.enableHook = true

		model:SetModel(LocalPlayer():GetModel())
			model.Entity:SetSkin(LocalPlayer():GetSkin())

			for k, v in ipairs(LocalPlayer():GetBodyGroups()) do
				model.Entity:SetBodygroup(v.id, 1)
			end

			local ent = model.Entity
			ent:SetPos(ent:GetPos() + Vector(5, -10, 0))
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
					PrintTable(nut.classes.list[class].pacdata)
					ent:AttachPACPart(nut.classes.list[class].pacdata)
						
						-- Overrride Model Drawing function of ModelPanel. (Function revision: 2015/01/05)
						-- by setting ent.forcedraw true, The PAC3 outfit will drawn on the model even if it's NoDraw Status is true.
					ent.forceDraw = true
				end
			end
			
			
		
		local char = LocalPlayer():getChar()
		local container = model:Add("DPanel")
			
			container:Dock(RIGHT)
			container:SetWide(ScrW() * 0.1)

			local y2 = 0
			local total = 0
			local maximum = 100
			local boost = char:getBoosts()

			self.attribs = {}

			for k, v in SortedPairsByMemberValue(nut.attribs.list, "name") do
				maximum = v.maxValue or nut.config.get("maxAttribs", 30)
				local attribValue = nut.classes.list[class].attribs[k]
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
				bar:setValue(attribValue)

				y2 = y2 + bar:GetTall() + 4
			end

		local background = model:Add("DPanel")
			background:SetSize(panel:GetWide(), panel:GetTall())
			background:Dock(FILL)
			background.Paint = function(this)
			local bg1 = nut.util.getMaterial("vgui/border_bg.png")	
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(bg1)
			surface.DrawTexturedRect(0, 0, background:GetWide(), background:GetTall())
		end

		container:SetTall(y2)

		helpButton = background:Add("DButton")
			helpButton:SetText( "Choose this class." )	
			helpButton:SetFont("CenturyGothicMedium")				// Set the text on the button
			helpButton:Dock(BOTTOM)
			helpButton:DockMargin(125,0,125,0)
			helpButton:SizeToContents()
			
			helpButton.DoClick = function()
				netstream.Start("SetClass", {
					id = id,
					class = class
				})
			end
			helpButton.Paint = function(this)
				local bg1 = nut.util.getMaterial("vgui/border_bg2.png")	
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(bg1)
				surface.DrawTexturedRect(0, 0, helpButton:GetWide(), helpButton:GetTall())
			end
		return model
end
