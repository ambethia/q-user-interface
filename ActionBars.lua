local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
  f:UnregisterAllEvents()
  f:SetScript("OnEvent", nil)
  
  -- MainMenuBar:Hide() -- Hide Blizzard Bar
end)
