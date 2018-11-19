print("[NP Spot]: cl_init.lua")

include("shared.lua")
--
-- client shit
--

function ENT:Initialize()
	self.LightBoneId = self:LookupBone(self.LightBone)
	SPOTLIGHT_TARGET = self
	self.YawParam = 0
	self.PitchParam = 0
end

function ENT:SetupLamp()
	local lamp = ProjectedTexture()
	lamp:SetTexture("effects/flashlight001")
	lamp:SetNearZ(2)
	lamp:SetFarZ(500)
	-- lamp.
	lamp:Update()
	self.ProjectedTexture = lamp
	-- self.ProjectedTexture
end

function ENT:RemoveLamp()
	if IsValid(self.ProjectedTexture) then
		self.ProjectedTexture:Remove()
	end
end

function ENT:UpdateState()
	local state = self:GetLightEnabled()
	if state then
		print("light on")
		self:SetupLamp()
		if istable(self.LampSubMaterials) then
			for matId, mat in pairs(self.LampSubMaterials) do
				self:SetSubMaterial(matId, mat)
			end
		end
	else
		print("light off")
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
	-- local deg = (math.sin(CurTime()) * 90)
	-- self:SetPoseParameter("point_yaw", deg)
	self:SetPoseParameter("point_yaw", self.YawParam)
	-- self:SetPoseParameter("point_pitch", deg)
	self:SetPoseParameter("point_pitch", self.PitchParam)
end

function ENT:OnRemove()
	self:RemoveLamp()
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

local move_amt = 2

hook.Add("Tick", "SpotlightPrototype", function()
	if not IsValid(SPOTLIGHT_TARGET) then return end
	local ent = SPOTLIGHT_TARGET
	local val_yaw = ent.YawParam
	local val_pitch = ent.PitchParam
	if input.IsKeyDown(KEY_LEFT) then
		print("LEFT")
		ent.YawParam = val_yaw + move_amt
	elseif input.IsKeyDown(KEY_RIGHT) then
		print("RIGHT")
		ent.YawParam = val_yaw - move_amt
	elseif input.IsKeyDown(KEY_UP) then
		print("UP")
		ent.PitchParam = val_pitch - move_amt
	elseif input.IsKeyDown(KEY_DOWN) then
		print("DOWN")
		ent.PitchParam = val_pitch + move_amt
	end
end)