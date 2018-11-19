print("[NP Spot]: init.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_debug_panel.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetModelScale(self.Scale or 1)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	-- self:SetPoseParameter("point_yaw", -45)
	-- self:SetPoseParameter("point_pitch", 0)
end

function ENT:SetLightEnabled(b)
	self:SetNW2Bool("lamp.enabled", b)
end

function ENT:ToggleLight()
	self:SetLightEnabled(not self:GetLightEnabled())
end

function ENT:Use()
	self:ToggleLight()
end

function ENT:Think()
	-- local deg = (math.sin(CurTime()) * 180) - 90
	-- self:SetPoseParameter("point_yaw", deg)
	-- self:SetPoseParameter("point_pitch", deg)
end