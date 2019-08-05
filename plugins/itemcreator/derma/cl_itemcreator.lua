local PANEL = {}
    local paintFunctions = {}
    paintFunctions[0] = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(0, 0, w, h)
    end
    paintFunctions[1] = function(this, w, h)
    end
 
    function PANEL:Init()
		
		if (IsValid(nut.gui.itemCreator)) then
			nut.gui.itemCreator:Remove()
		end

		nut.gui.itemCreator = self
		
        self:SetSize(ScrW() * 0.5, ScrH() * 0.5)
        self:Center()
		self:MakePopup()
		self:SetTitle("")
		self:SetDraggable(false)

		self.background = self:Add("DPanel")
		self.background:SetSize(ScrW() * 0.20, ScrH() * 0.45)
		self.background:SetPos( ScrW() * 0.15, ScrH() * 0.05  )
		self.background:SetPopupStayAtBack( true )
		self.background.Paint = function(this)

			surface.SetDrawColor(5, 5, 5, 100)
			surface.DrawRect(0, 0, self.background:GetWide(), self.background:GetTall())	

			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawOutlinedRect(0, 0, self.background:GetWide(), self.background:GetTall())
		end

		self.model = self:Add("nutModelPanel")
        self.model:SetSize(ScrW() * 0.20, ScrH() * 0.45)
		self.model:Center()
		self.model:SetCamPos( Vector( 40, 40, 50))
		self.model:SetLookAt( Vector( 0, 0, 45 ) )
		self.model:SetModel(LocalPlayer():GetModel())

		
	end
    function PANEL:Paint(w, h)
        nut.util.drawBlur(self, 10)
 
        surface.SetDrawColor(0, 0, 0, 250)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
vgui.Register("itemCreatorInfo", PANEL, "DFrame")

net.Receive( "openItemCreator", function( len )
	vgui.Create("itemCreatorInfo")
end) 