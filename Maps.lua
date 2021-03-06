local _G = getfenv(0);
local Q  = _G["Q"]

Q.Maps = {}

Q.Maps.frame = CreateFrame("Frame")
Q.Maps.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Q.Maps.frame:SetScript("OnEvent", function()
  Q.Maps.frame:UnregisterAllEvents()
  Q.Maps.frame:SetScript("OnEvent", nil)

  -- Square Minimap
  Minimap:SetMaskTexture([[Interface\Addons\Q\Media\MinimapMask]])
  MinimapBorder:SetTexture(nil)
  MinimapBackdrop:SetBackdrop({
   bgFile   = [[Interface\Tooltips\UI-Tooltip-Background]],
   edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
   tile     = true, tileSize = 16, edgeSize = 16,
   insets   = { left = 3, right = 3, top = 3, bottom = 3 }
  })
  MinimapBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
  MinimapBackdrop:SetBackdropColor(0, 0, 0, 0)
  MinimapBackdrop:SetAlpha(1.0)
  MinimapBackdrop:ClearAllPoints()
  MinimapBackdrop:SetPoint("TOPLEFT",     Minimap, "TOPLEFT",    -4, 4)
  MinimapBackdrop:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 4, -4)

  -- Hide shit
  for _, frame in pairs(Q.Maps.hidden) do
    frame:Hide()
    frame.Show = function() end
  end

  -- Position the map
  Minimap:SetPoint("TOPLEFT", ChatFrame3, "TOPRIGHT", 5, 0)
  Minimap:SetHeight(125) -- Chat.lua (VSIZE + GAP)
  Minimap:SetWidth(125)

  -- Move the zone text
  MinimapZoneTextButton:ClearAllPoints()
  MinimapZoneTextButton:SetParent(MinimapBackdrop) 
  MinimapZoneTextButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -2, -2)
  MinimapZoneText:SetJustifyH("RIGHT")
  MinimapZoneText:SetFont(Q.FONT_B, 9)

  -- Tracking Button
  -- Texture goofs off when down, quick fix
  MiniMapTrackingButton:SetScript("OnMouseDown", nil);
  
  MiniMapTracking:ClearAllPoints();
  MiniMapTracking:SetPoint( "TOPLEFT", Minimap, -6, 6 );
  MiniMapTracking:SetScale(0.75)

  -- Move clock inside the map frame
  TimeManagerClockButton:ClearAllPoints()
  TimeManagerClockButton:SetPoint("CENTER", Minimap, "BOTTOM", 0, 6)
  select(1, TimeManagerClockButton:GetRegions()):SetTexture(nil)

  -- Right click clock to open calendar, left for alarm/time config
  Q.Maps.TimeManagerClockButton_OriginalOnClick = TimeManagerClockButton:GetScript("OnClick")
  TimeManagerClockButton:SetScript("OnClick", Q.Maps.TimeManagerClockButton_OnClick)
end)

Q.Maps.hidden = {
  MinimapZoomOut,
  MinimapZoomIn,
  MiniMapWorldMapButton,
  MinimapNorthTag,
  GameTimeFrame,
  MinimapBorderTop,
  MinimapToggleButton,
  MiniMapTrackingButtonBorder,
  MiniMapTrackingBackground
}

function Q.Maps:TimeManagerClockButton_OnClick(btn)
  if btn == "RightButton" then
    return ToggleCalendar()
  end
  return Q.Maps:TimeManagerClockButton_OriginalOnClick(btn)
end