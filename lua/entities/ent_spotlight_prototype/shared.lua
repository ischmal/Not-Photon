print("[NP Spot]: shared.lua")
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Spotlight Prototype"
ENT.Author = "Schmal, et. al"
ENT.Category = "Not Photon"
ENT.Spawnable = true

ENT.Model = "models/np_spotlight/test_spotlight.mdl"

function ENT:GetLightEnabled()
	return self:GetNW2Bool("lamp.enabled")
end