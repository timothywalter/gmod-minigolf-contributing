--[[
	Credits:

	- Some ball physics borrowed from MBilliards to get better physics on the balls
--]]
physenv.AddSurfaceData([["minigolf_ball"
{
	"scraperough"	"DoorSound.Null"
	"scrapesmooth"	"DoorSound.Null"
	"impacthard"	"DoorSound.Null"
	"impactsoft"	"DoorSound.Null"

	"audioreflectivity"		"0.66"
	"audiohardnessfactor"	"0.0"
	"audioroughnessfactor"	"0.0"

	"elasticity"	"1000"
	"friction"		"0.4"
	"density"		"10000"
}]])

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

util.AddNetworkString("setBallForce")
util.AddNetworkString("getBallForce")

local function rollBallInDirection(ball, directionVector)
	local phys = ball:GetPhysicsObject()

	if(IsValid(phys))then
		phys:SetVelocity(directionVector)

		return true
	end

	ErrorNoHalt("Ball has no physics, can't roll in direction")

	return false
end

function ENT:Initialize()
	self:SetModel(self.Model)

	if(self.ModelScale)then
		self:SetModelScale(self.ModelScale)
	end

	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS ) -- Automatically called by PhysicsInitSphere
	self:SetSolid( SOLID_VPHYSICS ) -- Overriden by PhysicsInitSphere to SOLID_BBOX
	self:SetCustomCollisionCheck(true)
	self.trail = util.SpriteTrail(self, 0, Color(255, 255, 255), false, 15, 1, 4, 0.125, "minigolf/devkit/test_trail")

 	-- Set perfect sphere collisions (54mm of diameter)
	self:PhysicsInitSphere(0.94, "minigolf_ball")
	self:SetCollisionBounds(Vector(-0.94, -0.94, -0.94), Vector(0.94, 0.94, 0.94))

	local physObj = self:GetPhysicsObject()
 
	if (physObj:IsValid()) then
		physObj:SetMass(1)
		physObj:SetDamping(0, 1.2)
		physObj:Wake()
	end

	self:Activate()
end

function ENT:OnRemove()
	SafeRemoveEntity(self.trail)
end

function ENT:PhysicsCollide(data, physObj)
	local speed, hitEnt = data.Speed, data.HitEntity
	local newVelocity = physObj:GetVelocity()
	local oldVelocityLength = data.OurOldVelocity:Length()

	newVelocity = physObj:GetVelocity():GetNormal() * math.max(oldVelocityLength, speed)

	if(oldVelocityLength <= 0.14) then
		physObj:SetVelocity(Vector(0, 0, 0))
		physObj:EnableMotion(false)
		return physObj:EnableMotion(true)
	end

	newVelocity = newVelocity * 0.75
	
	return physObj:SetVelocity(newVelocity)
end

function ENT:Think()
	local velocity = self:GetVelocity()
	local velocityLength = velocity:Length()

	if(velocityLength < 5)then
		local phys = self:GetPhysicsObject()

		if(IsValid(phys))then
			phys:AddVelocity(-velocity)
		end
		
		if(not self:GetStationary())then
			self:SetStationary(true)

			local physObj = self:GetPhysicsObject()
			physObj:EnableMotion(false)
			physObj:SetVelocityInstantaneous(Vector(0,0,0))
			physObj:EnableMotion(true)
		end
	else
		self:SetStationary(false)
	end
end

function ENT:MoveToPos(position)
	local physObj = self:GetPhysicsObject()

	physObj:EnableMotion(false)
	self:SetPos(position)
	physObj:SetVelocityInstantaneous(Vector(0,0,0))
	physObj:EnableMotion(true)
end

function ENT:ReturnToStart()
	local startPos = self:GetStart():GetPos();

	self:MoveToPos(startPos)
end

function ENT:OnUse(activator)
	-- Make sure the activator is a player and is in range
	if(activator:IsPlayer() and activator:GetPos():DistToSqr(self:GetPos()) < (DISTANCE_TO_BALL_MAX*DISTANCE_TO_BALL_MAX))then
		if(activator:KeyDown(IN_RELOAD))then
			if(activator == self:GetGolfer())then
				self:ReturnToStart()
			end

			return
		end

		if(activator == self:GetGolfer())then
			self:ShowForceMeter(not IsValid(activator.GivingForce))
		end
	end
end

function ENT:ShowForceMeter(shouldShow)
	local golfer = self:GetGolfer();

	if(shouldShow)then
		golfer.GivingForce = self

		net.Start("getBallForce")
		net.WriteEntity(self)
		net.Send(golfer)
	else
		golfer.GivingForce = nil
	end
end

function ENT:SetStationary(stationary)
	self._Stationary = stationary;
end

function ENT:GetStationary()
	return self._Stationary
end

function ENT:SetGolfer(golfer)
	self._Golfer = golfer;
	self._Golfer.Ball = self

	golfer:SetNWEntity("Ball", self)
	self:SetNWString("GolferName", golfer:Nick())
	self:SetNWEntity("Golfer", golfer)
	self:SetMaterial("minigolf/devkit/test_ball_skin")
	self:SetColor(Color(255, 255, 255))
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
end

function ENT:GetGolfer()
	return self._Golfer
end

function ENT:SetStart(start)
	self._Start = start;
	self:SetNWEntity("HoleStart", start)
end

function ENT:GetStart()
	return self._Start
end

function ENT:OnTakeDamage(dmgInfo)
	dmgInfo:ScaleDamage(0);
end

net.Receive("setBallForce", function(len, ply)
	local ball = ply.GivingForce

	if(IsValid(ball))then
		local givenForce = net.ReadFloat()

		if(givenForce == -1)then
			ball:ShowForceMeter(false)
			return
		end

		local ballForce = math.min(givenForce * 1000, 2048);
		local ballAngle = net.ReadAngle()

		ballAngle.p = 0

		if(hookCall ~= false)then
			rollBallInDirection(ball, -ballAngle:Right() * ballForce)
		end

		ball = nil
	end
end)