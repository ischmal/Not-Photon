AddCSLuaFile()

local edit_mode = true

-- Must match entity folder name
ENT.Class = "ent_spotlight_prototype"

ENT.Model = "models/np_spotlight/test_spotlight.mdl"

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Spotlight Prototype"
ENT.Author = "Schmal, et al."
ENT.Category = "Not Photon"
ENT.Spawnable = true

-- How fast/slow turning should be
-- (percent per tick)
ENT.ManipulationRate = 0.01

-- Name of bone that light emits from
ENT.LightBone = "light"

ENT.LampOffsetPos = Vector(0, 0, 0)
ENT.LampOffsetAng = Angle(0, -90, 0)

-- Material index and name to use when light is active
ENT.LampSubMaterials = {
	[2] = "np_spotlight/illum"
}

-- Configures turn axes with pose parameters
ENT.LampPoseParams = {
	-- Up/Down Arrows
	[1] = "point_pitch",
	-- Left/Right Arrows
	[2] = "point_yaw"
}

-- Add modifications to ProjectedTexture here.
-- (see: http://wiki.garrysmod.com/page/Category:ProjectedTexture)
-- Note: ProjectedTexture:Update() is automatically called after this function.
function ENT:OnConfigureLamp(lamp)
	lamp:SetNearZ(2)
	lamp:SetBrightness(10)
	lamp:SetFarZ(1000)
	lamp:SetFOV(45)

end

-- MISC FUNCTIONS

function ENT:ReloadUpdate()
	if self.ProjectedTexture then 
		self:OnConfigureLamp(self.ProjectedTexture)
		self.ProjectedTexture:Update()
	end
end

-- fucking dumb
function ENT:SetupPoseParamsMap()
	self.PoseParamsMap = {}
	for i=0, self:GetNumPoseParameters() - 1 do
		local name = self:GetPoseParameterName(i)
		self.PoseParamsMap[name] = 0
	end
	self.PoseManipulationRates = {}
	for _, param in pairs(self.LampPoseParams) do
		local min, max = self:GetPoseParameterRange(self.PoseParamsMap[param])
		local range = max - min
		self.PoseManipulationRates[param] = range * self.ManipulationRate
	end
	self.PoseReady = true
end

function ENT:GetLightEnabled()
	return self:GetNW2Bool("lamp.enabled")
end

if edit_mode then
	local this = ENT
	timer.Simple(0, function()
		for _, ent in pairs(ents.GetAll()) do
			if IsValid(ent) and ent:GetClass() == this.Class then
				ent:ReloadUpdate()
			end
		end
	end)
end