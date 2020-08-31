if(isMiniGolfGamemodeActive())then return end -- Don't run if we have the gamemode running

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + (tr.HitNormal * 15) )
	ent:Spawn()

	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetModelScale(self.ModelScale)
	self:SetAngles(Angle(90,0,0))
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(Color(255, 255, 255, 200))
 
    local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:EnableMotion(false)
		phys:Wake()
	end
	self:Activate()
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
