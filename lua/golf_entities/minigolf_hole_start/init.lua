AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( not tr.Hit ) then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + (tr.HitNormal * 15) )
	ent:Spawn()

	return ent
end

function ENT:Initialize()
	if ( CLIENT ) then return end

	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType( SIMPLE_USE )
	self:SetSolid(SOLID_BBOX);
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON);
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(Color(255, 255, 255, 50))
end

function ENT:SpawnBall(activator)
	local ball = ents.Create("minigolf_ball")
	ball:SetPos(self:GetPos())
	ball:Spawn()

	ball:SetStart(self)
	ball:SetGolfer(activator)
	activator:SetNWEntity("Ball", ball)
	ball:ShowForceMeter(true)

	return ball
end

function ENT:Use(activator, caller)
	local ball = self:GetBall()

	if(not IsValid(ball) and activator:IsPlayer())then
		local ball = self:SetBall(self:SpawnBall(activator))
		ball:ShowForceMeter(true)
	end
end

function ENT:KeyValue(key, value)
	if(key == "hole")then
		self:SetHoleName(tostring(value):Trim())
	elseif(key == "par")then
		self:SetPar(tonumber(value))
	elseif(key == "limit")then
		self:SetLimit(tonumber(value))
	elseif(key == "description")then
		self:SetDescription(tostring(value):Trim())
	elseif(key == "maxStrokes")then
		self:SetMaxStrokes(tonumber(value))
	elseif(key == "maxPitch")then
		self:SetMaxPitch(tonumber(value))
	end
end

function ENT:SetBall(ball)
	self._Ball = ball

	return ball
end

function ENT:GetBall()
	return self._Ball
end

function ENT:SetMaxStrokes(maxStrokes)
	self._MaxStrokes = maxStrokes
	self:SetNWInt("MaxStrokes", maxStrokes)
end

function ENT:GetMaxStrokes()
	return self._MaxStrokes or 12
end

function ENT:SetMaxPitch(maxPitch)
	self._MaxPitch = maxPitch
	self:SetNWInt("MaxPitch", maxPitch)
end

function ENT:GetMaxPitch()
	return self._MaxPitch or 0
end

function ENT:SetHoleName(holeName)
	self._HoleName = holeName
	self:SetNWString("HoleName", holeName)
end

function ENT:GetHoleName()
	return self._HoleName
end

function ENT:SetPar(par)
	self._HolePar = par
	self:SetNWInt("HolePar", par)
end

function ENT:GetPar()
	return self._HolePar or 3
end

function ENT:SetLimit(limitInSeconds)
	self._HoleLimit = limitInSeconds
	self:SetNWInt("HoleLimit", limitInSeconds)
end

function ENT:GetLimit()
	return self._HoleLimit or 60
end

function ENT:SetDescription(description)
	self._HoleDescription = description
	self:SetNWString("HoleDescription", description)
end

function ENT:GetDescription()
	return self._HoleDescription
end
