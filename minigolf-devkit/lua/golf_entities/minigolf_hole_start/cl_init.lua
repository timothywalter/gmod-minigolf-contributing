include("shared.lua")

function ENT:GetMaxStrokes()
	return self:GetNWInt("MaxStrokes", 12)
end

function ENT:GetMaxPitch()
	return self:GetNWInt("MaxPitch", 0)
end

function ENT:GetHoleName()
	return self:GetNWString("HoleName", "Unknown Hole")
end

function ENT:GetPar()
	return self:GetNWInt("HolePar", -1)
end

function ENT:GetLimit()
	return self:GetNWInt("HoleLimit", 60)
end

function ENT:GetDescription()
	return self:GetNWString("HoleDescription", "")
end
