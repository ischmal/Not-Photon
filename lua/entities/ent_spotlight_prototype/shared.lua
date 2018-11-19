print("[NP Spot]: shared.lua")
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Spotlight Prototype"
ENT.Author = "Schmal, et al."
ENT.Category = "Not Photon"
ENT.Spawnable = true

ENT.LightBone = "light"

ENT.LampOffsetPos = Vector(0, 0, 0)
ENT.LampOffsetAng = Angle(0, -90, 0)

ENT.LampSubMaterials = {
	[2] = "np_spotlight/illum"
}

ENT.LampPoseParams = {
	-- Up/Down Arrows
	[1] = "point_pitch",
	-- Left/Right Arrows
	[2] = "point_yaw"
}

ENT.Model = "models/np_spotlight/test_spotlight.mdl"

function ENT:GetLightEnabled()
	return self:GetNW2Bool("lamp.enabled")
end