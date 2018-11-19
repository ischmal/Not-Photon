print("[NP Spot]: init.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetModelScale(self.Scale or 1)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetPoseParameter("point_yaw", -45)
	self:SetPoseParameter("point_pitch", -45)
end

function ENT:SetLightEnabled(b)
	self:SetNW2Bool("lamp.enabled", b)
end