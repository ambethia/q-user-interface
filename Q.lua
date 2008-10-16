local Q = CreateFrame("Frame")
Q:RegisterEvent("PLAYER_LOGIN")
Q:SetScript("OnEvent", function()
  Q:UnregisterAllEvents()
  Q:SetScript("OnEvent", nil)

  BuffFrame:Hide()
  TemporaryEnchantFrame:Hide()
end)

_G["Q"] = Q