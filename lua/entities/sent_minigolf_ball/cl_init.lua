if(MiniGolf)then return end -- Don't run if we have the gamemode running

include("shared.lua")

function ENT:Initialize()
	if(self.ModelScale)then
		self:SetModelScale(self.ModelScale)
	end
end

function ENT:GetGolfer()
	return self:GetNWEntity("Golfer")
end

function ENT:GetStart()
	return self:GetNWEntity("HoleStart")
end

local PADDING_FLOOR_TEXT = 256
local FORCE_MAX = 1280
local FORCE_FRACTION_MIN = 0.01
local SCROLL_MODIFIER = 0.01 -- 0.01 = 1% change per scroll
local PITCH_MULTIPLIER = 100
local PITCH_MIN = 0
local PITCH_MAX = 90

local meteringVelocity = false
local arrow = Material("minigolf/direction-arrow.png")
local padding = 15
local currentAngle = Angle()
local lastPersonalForce
local currentForce = 0
local currentPitch = 0

local lastWheelInput = 0

net.Receive("getBallForce", function()
	meteringVelocity = net.ReadEntity()
	currentForce = lastPersonalForce or FORCE_FRACTION_MIN
end)

-- Translate scrolling to adjusting the force
if(game.SinglePlayer())then	ErrorNoHalt("MiniGolf Test Warning: SetupMove is not called in Singleplayer (because it's predicted). Start a listen server!\n") end
hook.Add("SetupMove", "MiniGolf.ScrollToAdjustPower", function(golfer, moveData, userCmd)
	if(meteringVelocity)then
		if(moveData:KeyPressed(IN_RELOAD))then
			currentForce = FORCE_FRACTION_MIN;
			currentPitch = PITCH_MIN;
			return
		end

		local scrollDelta = userCmd:GetMouseWheel()
		local adjust = 0

		if(scrollDelta ~= 0)then
			-- Prevent 4x inputs when doing once scroll notch
			if CurTime() > lastWheelInput then
				lastWheelInput = CurTime() + 0.01
			else scrollDelta = 0 end

			adjust = scrollDelta * SCROLL_MODIFIER
		elseif(input.IsKeyDown(KEY_PAGEUP))then
			adjust = SCROLL_MODIFIER
		elseif(input.IsKeyDown(KEY_PAGEDOWN))then
			adjust = -SCROLL_MODIFIER
		end

		if(adjust ~= 0)then
			if(input.IsKeyDown(KEY_LSHIFT))then
				currentPitch = math.min(PITCH_MAX, math.max(PITCH_MIN, currentPitch + (adjust * -PITCH_MULTIPLIER)))
			else
				currentForce = math.Round(math.max(FORCE_FRACTION_MIN, math.min(1, currentForce + adjust)),2)
			end
		end
	end
end)

hook.Add("PostDrawTranslucentRenderables", "MiniGolf.DrawDirectionArea", function(isDrawingDepth, isDrawSkybox)
	if(isDrawSkybox)then return; end;

	if(IsValid(LocalPlayer()) and meteringVelocity)then
		local ball = LocalPlayer():GetNWEntity("Ball")

		if(IsValid(ball))then
			local directionVector = LocalPlayer():EyeAngles():Forward()
			local angle = directionVector:Angle()
			local forceHeight = FORCE_MAX * currentForce
			local start = ball:GetStart()
			local maxPitch = start:GetMaxPitch()

			angle:RotateAroundAxis(Vector(0,0,1), -90)
			angle = Angle(0, angle.y, maxPitch ~= 0 and currentPitch or 0)

			currentAngle = angle

			local angleNoPitch = Angle(angle)

			angleNoPitch.r = 0

			cam.Start3D2D(ball:GetPos(), angleNoPitch, .03)
				if(currentPitch > 0)then
					surface.SetDrawColor(0, 0, 0, 255)
					surface.SetMaterial(arrow)
					local texWidth = 256
					surface.DrawTexturedRect(-(texWidth * .5), -FORCE_MAX, 256, FORCE_MAX)
				end
			cam.End3D2D()
			
			cam.Start3D2D(ball:GetPos(), angle, .03)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(arrow)
				local texWidth = 256
				surface.DrawTexturedRect(-(texWidth * .5), -FORCE_MAX, 256, FORCE_MAX)

				surface.SetDrawColor(255, 0, 0, 255)
				surface.DrawTexturedRectUV(-(texWidth * .5), FORCE_MAX * -currentForce, 256, forceHeight, 0, 1-currentForce, 1, 1)

			cam.End3D2D()
		end
	end
end)

-- Draw the owner of a ball
local ballOwnerOffset = {
	x = 50,
	y = -25
}

hook.Add("KeyRelease", "MiniGolf.CheckForHit", function(player, key)
	if(key == IN_ATTACK and not drawingName and meteringVelocity)then
		meteringVelocity = false

		lastPersonalForce = currentForce

		net.Start("setBallForce")
			net.WriteFloat(currentForce)
			net.WriteAngle(currentAngle)
		net.SendToServer()
	end
end)
