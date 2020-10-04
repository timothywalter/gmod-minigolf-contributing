AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:Initialize()
end

function ENT:Initialize()
end

function ENT:StartTouch(ball)
	if(IsValid(ball) and ball:GetClass() == "minigolf_ball")then
		if(self:GetHoleName() == ball:GetStart():GetHoleName())then
			ball._Golfer:ChatPrint("Finished the hole '" .. self:GetHoleName() .. "'!")
			ball._Golfer.Ball = nil
			ball:Remove()
		end
	end
end

function ENT:KeyValue(key, value)
	if(key == "hole")then
		self:SetHoleName(tostring(value):Trim())
	end
end

function ENT:SetHoleName(holeName)
	self._HoleName = holeName
	self:SetNWString("HoleName", holeName)
end

function ENT:GetHoleName()
	return self._HoleName
end
