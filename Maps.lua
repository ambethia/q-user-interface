local Maps = {}

Maps.frame = CreateFrame("Frame")
Maps.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Maps.frame:SetScript("OnEvent", function()
  Maps.frame:UnregisterAllEvents()
  Maps.frame:SetScript("OnEvent", nil)

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
  for _, frame in pairs(Maps.hidden) do
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
  MinimapZoneText:SetFont([[Interface\AddOns\Q\Media\CalibriBold.ttf]], 9)

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
  Maps.TimeManagerClockButton_OriginalOnClick = TimeManagerClockButton:GetScript("OnClick")
  TimeManagerClockButton:SetScript("OnClick", Maps.TimeManagerClockButton_OnClick)
end)

Maps.hidden = {
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

function Maps:TimeManagerClockButton_OnClick(btn)
  if btn == "RightButton" then
    return ToggleCalendar()
  end
  return Maps:TimeManagerClockButton_OriginalOnClick(btn)
end