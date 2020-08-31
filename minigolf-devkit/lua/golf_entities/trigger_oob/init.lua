if(isMiniGolfGamemodeActive())then return end -- Don't run if we have the gamemode running

DEFINE_BASECLASS( "base_brush" )

ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:StartTouch(ent)
	if ent and ent:IsValid()then
		if(ent:GetClass() == "sent_minigolf_ball")then
			ent:GetGolfer():ChatPrint("Ball went out of bounds! Resetting in a second...")

			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:SetColor(Color(255, 0, 0, 150))

			timer.Simple(1, function()
				if(IsValid(ent))then
					ent:MoveToPos(ent:GetStart():GetPos())
					ent:SetColor(Color(255,255,255, 255))
				end
			end)
		end
	end
end
