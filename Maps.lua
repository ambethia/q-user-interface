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
  MinimapBackdrop:SetBackdropBorderColor(0.75, 0.75, 0.75)
  MinimapBackdrop:SetBackdropColor(0.15, 0.15, 0.15, 0.0)
  MinimapBackdrop:SetAlpha(1.0)
  MinimapBackdrop:ClearAllPoints()
  MinimapBackdrop:SetPoint("TOPLEFT",     Minimap, "TOPLEFT",    -4, 4)
  MinimapBackdrop:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 4, -4)

  -- Hide shit
  for _, frame in pairs(Maps.hidden) do
    frame:Hide()
    frame.Show = function() end
  end

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
}

function Maps:TimeManagerClockButton_OnClick(btn)
  if btn == "RightButton" then
    return ToggleCalendar()
  end
  return Maps:TimeManagerClockButton_OriginalOnClick(btn)
end