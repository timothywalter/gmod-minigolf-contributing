AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

local DURATION = 1

function ENT:Initialize()
	if ( CLIENT ) then return end

	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_BBOX)
end

function ENT:OnHoleEndTouched(holeEnd)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetNWEntity("HoleStart", holeEnd:GetStart())
end

function ENT:RaiseDown()
	self._MoveUntil = CurTime() + DURATION
	self._MovingFrom = self:GetPos()
	self._MovingTo = self._OldPos
	self._OldPos = nil
	self._RaisedBy = nil
end

function ENT:RaiseUp(activator)
	-- Raise self in the air
	self._OldPos = self:GetPos()
	self._MovingFrom = self._OldPos
	self._MovingTo = self._OldPos + Vector(0,0, 77)
	self._MoveUntil = CurTime() + DURATION
	self._RaisedBy = activator
end

function ENT:Use(activator, caller)
	if(self._MoveUntil)then
		return
	end

	if(self._OldPos)then
		self:RaiseDown()
		return
	end

	self:RaiseUp(activator)
end

function ENT:Think()
	if(self._MoveUntil)then
		if(self._MoveUntil - CurTime() <= 0)then
			self:SetPos(self._MovingTo)
			self._MoveUntil = nil
			self._MovingTo = nil
			self._MovingFrom = nil
			return
		end

		local fraction = 1 - ((self._MoveUntil - CurTime()) / DURATION)
		
		self:SetPos(LerpVector(fraction, self._MovingFrom, self._MovingTo))
	elseif(self._RaisedBy)then
		if(not IsValid(self._RaisedBy) or self._RaisedBy:GetPos():Distance(self:GetPos()) > 128)then
			self:RaiseDown()
			return
		end
	end
end