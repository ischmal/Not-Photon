print("[NP Spot]: cl_init.lua")

include("shared.lua")
include("cl_debug_panel.lua")
--
-- client shit
--

function ENT:Initialize()
	self.LightBoneId = self:LookupBone(self.LightBone)
	SPOTLIGHT_TARGET = self
	self.HorizontalParam = 0
	self.VerticalParam = 0
	timer.Simple(0, function()
		self:SetupPoseParamsMap()
	end)
end

function ENT:SetupLamp()
	local lamp = ProjectedTexture()
	lamp:SetTexture("effects/flashlight001")
	lamp:SetNearZ(2)
	lamp:SetFarZ(500)
	lamp:Update()
	self.ProjectedTexture = lamp
end

function ENT:RemoveLamp()
	if IsValid(self.ProjectedTexture) then
		self.ProjectedTexture:Remove()
	end
end

function ENT:UpdateState()
	local state = self:GetLightEnabled()
	if state then
		self:SetupLamp()
		if istable(self.LampSubMaterials) then
			for matId, mat in pairs(self.LampSubMaterials) do
				self:SetSubMaterial(matId, mat)
			end
		end
	else
		if istable(self.LampSubMaterials) then
			for matId, mat in pairs(self.LampSubMaterials) do
				self:SetSubMaterial(matId, nil)
			end
		end
		self:RemoveLamp()
	end
end

function ENT:UpdateLamp()
	if not IsValid(self.ProjectedTexture) then return end
	local pos, ang = self:GetLampPosition()
	self.ProjectedTexture:SetPos(pos)
	self.ProjectedTexture:SetAngles(ang)
	self.ProjectedTexture:Update()
end

function ENT:GetLampPosition()
	local pos, ang = self:GetBonePosition(self.LightBoneId)
	pos, ang = LocalToWorld(self.LampOffsetPos, self.LampOffsetAng, pos, ang)
	return pos, ang
end

function ENT:Think()
	if self:GetLightEnabled() then
		self:UpdateLamp()
	end
	self:SetPoseParameter(self.LampPoseParams[2], self.HorizontalParam)
	self:SetPoseParameter(self.LampPoseParams[1], self.VerticalParam)
	self:InvalidateBoneCache()
end

function ENT:OnRemove()
	self:RemoveLamp()
end

local MOVE_UP = 0
local MOVE_DOWN = 1
local MOVE_LEFT = 2
local MOVE_RIGHT = 3

function ENT:Adjust(dir)
	local min, max
	if (dir == MOVE_UP or dir == MOVE_DOWN) then
		local manip = self.PoseManipulationRates[self.LampPoseParams[1]]
		min, max = self:GetPoseParameterRange(self.PoseParamsMap[self.LampPoseParams[1]])
		if dir == MOVE_UP then
			local newVal = self.VerticalParam - manip
			if newVal >= min then
				self.VerticalParam = newVal
			else
				self.VerticalParam = min
			end
		else
			local newVal = self.VerticalParam + manip
			if newVal <= max then
				self.VerticalParam = newVal
			else
				self.VerticalParam = max
			end
		end
	elseif (dir == MOVE_LEFT or dir == MOVE_RIGHT) then
		local manip = self.PoseManipulationRates[self.LampPoseParams[2]]
		min, max = self:GetPoseParameterRange(self.PoseParamsMap[self.LampPoseParams[2]])
		if dir == MOVE_LEFT then
			local newVal = self.HorizontalParam + manip
			if newVal <= max then
				self.HorizontalParam = newVal
			else
				self.HorizontalParam = max
			end
		else
			local newVal = self.HorizontalParam - manip
			if newVal >= min then
				self.HorizontalParam = newVal
			else
				self.HorizontalParam = min
			end
		end
	end
end

hook.Add("EntityNetworkedVarChanged", "SpotlightPrototype", function(ent, name, oldval, newval)
	if ent:GetClass() == "ent_spotlight_prototype" then
		timer.Simple(0, function()
			if IsValid(ent) then
				ent:UpdateState()
			end
		end)
	end
end)

hook.Add("Tick", "SpotlightPrototype", function()
	if not IsValid(SPOTLIGHT_TARGET) then return end
	local ent = SPOTLIGHT_TARGET
	if not ent.PoseReady then return end
	if input.IsKeyDown(KEY_LEFT) then
		ent:Adjust(MOVE_LEFT)
	elseif input.IsKeyDown(KEY_RIGHT) then
		ent:Adjust(MOVE_RIGHT)
	elseif input.IsKeyDown(KEY_UP) then
		ent:Adjust(MOVE_UP)
	elseif input.IsKeyDown(KEY_DOWN) then
		ent:Adjust(MOVE_DOWN)
	end
end)