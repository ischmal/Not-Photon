
function CreateSpotlightConfigMenu(ent)
	local window = vgui.Create("DFrame")
	window:SetTitle("Spotlight Configuration: " .. tostring(ent))
	window:SetSize(512, 512)
	window:Center()
	window:SetSizable(true)

	local btn_Left = vgui.Create("DButton", window)
	btn_Left:SetText("LEFT")
	local btn_Right = vgui.Create("DButton", window)
	btn_Right:SetText("RIGHT")
	local btn_Up = vgui.Create("DButton", window)
	btn_Up:SetText("UP")

	function window:Think()

	end

	local logo = vgui.Create("DImage", window)
	logo:SetSize(256, 64)
	logo:SetImage("photon-embedded.png")
	logo:AlignBottom(0)
end

properties.Add("spotlight_options", {
	MenuLabel="Spotlight Config",
	Order = 0,
	Filter = function(self, ent, ply)
		if ( not IsValid( ent ) ) then return false end
		if ( not ent:GetClass() == "ent_spotlight_prototype") then return false end
		return true
	end,
	Action = function(self, ent)
		CreateSpotlightConfigMenu(ent)
	end,
	Receive = function(self, len, ply)

	end
})