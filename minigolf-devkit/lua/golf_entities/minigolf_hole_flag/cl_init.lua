include("shared.lua")

function ENT:GetStart()
	return self:GetNWEntity("HoleStart")
end

function ENT:Draw()
	self:DrawModel()

	local correctedAngles = self:GetAngles()

	correctedAngles:RotateAroundAxis(self:GetAngles():Right(), -90)
	correctedAngles:RotateAroundAxis(self:GetAngles():Up(), 90)
	correctedAngles:RotateAroundAxis(self:GetAngles():Right(), -90)
	correctedAngles:RotateAroundAxis(self:GetAngles():Up(), 180)

	local hole = self:GetStart()

	if(IsValid(hole))then
		local teamID = hole:GetActiveTeam()
		
		if(teamID > 0)then
			local color = team.GetColor(teamID)
			
			cam.Start3D2D(self:GetPos() + select(2, self:GetModelBounds()), correctedAngles, .03)
				surface.SetDrawColor(color)
				surface.DrawRect(0, 0, 1024, 512)
			cam.End3D2D()
		end
	end
end