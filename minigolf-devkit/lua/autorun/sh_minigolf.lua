if(MiniGolf)then return end -- Don't run if we have the gamemode running
if(not game.GetMap():StartWith("golf_"))then return end -- Only run this file on a minigolf map

-- Ensure that players don't collide with balls
hook.Add("ShouldCollide", "MiniGolf.StopPlayerCollisionWithBalls", function(ent1, ent2)
	if(IsValid(ent1) and IsValid(ent2) 
		and (ent1:IsPlayer() or ent2:IsPlayer()) and (ent1:GetClass() == "sent_minigolf_ball" or ent2:GetClass() == "sent_minigolf_ball")) then 
		return false 
	end
end)

if(SERVER)then
  hook.Add("PlayerLoadout", "MiniGolf.StripWeaponsOnSpawn", function(golfer)
    -- true: Prevents further default Loadout (also from addons)
    return true
  end)

  hook.Add("KeyPress", "MiniGolf.AllowUseBall", function( golfer, key )
    if( key == IN_USE )then
      local tr = golfer:GetEyeTraceNoCursor()
  
      for _, ent in ipairs(ents.FindInSphere(tr.HitPos, 128))do
        if(IsValid(ent) and ent:GetClass() == "sent_minigolf_ball")then
          ent:OnUse(golfer)
        end
      end
    end
  end)
elseif(CLIENT)then
  local HideDefaultHUDElements = {
    CHudHealth = true,
    CHudBattery = true,
    CHudAmmo = true,
    CHudDamageIndicator = true,
    CHudWeaponSelection = true,
  }
  
  hook.Add("HUDShouldDraw", "MiniGolf.HideDefaultHUD", function(name)
    if(HideDefaultHUDElements[name]) then
      return false
    end
  end)
  
  hook.Add("PreDrawHalos", "MiniGolf.AddSentHalos", function()
    halo.Add( ents.FindByClass( "sent_minigolf_*" ), Color( 255, 0, 0 ), 5, 5, 2 )
  end)

  local devKitLogo = Material("minigolf/logo_compact_mapkit.png")
  local logoW, logoH = 256, 256
  local PADDING = 5
  
  hook.Add("HUDPaint", "MiniGolf.DrawDebugUI", function()
    -- Draw indicators that devkit dev is running
    surface.SetDrawColor(255, 255, 255, 25)
    surface.SetMaterial(devKitLogo)

    local logoX = ScrW() - logoW
    surface.DrawTexturedRect(logoX, PADDING, logoW, logoH)

    surface.SetTextColor(255, 255, 255, 25)
    surface.SetFont("Trebuchet24")
    
    local textW = select(1, surface.GetTextSize("MiniGolf DevKit Active"))
    surface.SetTextPos(logoX + (logoW * .5) - (textW * .5) - 25, PADDING + logoH - 30) -- -25 because the logo is off-center due to the flag / -30 because there's a lot of whitespace around the logo
    surface.DrawText("MiniGolf DevKit Active")


    -- Draw start info
    for k,v in pairs(ents.FindByClass( "sent_minigolf_start" )) do
      local vPos = v:GetPos():ToScreen()
      local currentY = vPos.y

      surface.SetTextColor(255, 255, 255, 200)
      surface.SetFont("Trebuchet24")
      local textH = select(2, surface.GetTextSize("Doesn't matter for the height"))
      
      surface.SetTextPos(vPos.x, currentY)
      surface.DrawText("Start of the hole: '" .. v:GetHoleName() .. "'")
      
      currentY = currentY + PADDING + textH
      
      surface.SetTextPos(vPos.x, currentY)
      surface.DrawText("Par: " .. v:GetPar())

      currentY = currentY + PADDING + textH
      
      surface.SetTextPos(vPos.x, currentY)
      surface.DrawText("Maximum tries of: " .. v:GetMaxStrokes() .. " strokes")

      currentY = currentY + PADDING + textH

      surface.SetTextPos(vPos.x, currentY)
      surface.DrawText("Max. Pitch: " .. v:GetMaxPitch() .. " degrees")

      currentY = currentY + PADDING + textH

      surface.SetTextPos(vPos.x, currentY)
      surface.DrawText("Time Limit: " .. v:GetLimit() .. " seconds")

      currentY = currentY + PADDING + textH

      surface.SetTextPos(vPos.x, currentY)
      surface.DrawText("Optional Description: '" .. v:GetDescription() .. "'")

      currentY = currentY + PADDING + textH
    end
    
    -- Draw goal info
    for k,v in pairs(ents.FindByClass( "sent_minigolf_goal" )) do
      local vPos = v:GetPos():ToScreen()
      local currentY = vPos.y

      surface.SetTextColor(255, 255, 255, 200)
      surface.SetFont("Trebuchet24")
      local textH = select(2, surface.GetTextSize("asd"))
      
      surface.SetTextPos(vPos.x, currentY)
      surface.DrawText("Goal of the hole: '" .. v:GetNWString("HoleName") .. "'") 
    end
    
    -- Draw ball info
    for k,v in pairs(ents.FindByClass( "sent_minigolf_ball" )) do
      local vPos = v:GetPos():ToScreen()
      local currentY = vPos.y

      surface.SetTextColor(255, 255, 255, 200)
      surface.SetFont("Trebuchet24")
      local textH = select(2, surface.GetTextSize("asd"))
      
      surface.SetTextPos(vPos.x, currentY)
      surface.DrawText("Ball of golfer:" .. v:GetNWString("GolferName"))
    end
  end)
end