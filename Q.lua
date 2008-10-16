local Q = CreateFrame("Frame")
Q:RegisterEvent("PLAYER_LOGIN")
Q:SetScript("OnEvent", function()
  Q:UnregisterAllEvents()
  Q:SetScript("OnEvent", nil)

  BuffFrame:Hide()
  TemporaryEnchantFrame:Hide()
end)

Q.STATUS_BAR = [[Interface\AddOns\Q\Media\Minimalist]]
Q.FONT       = [[Interface\AddOns\Q\Media\Calibri.ttf]]
Q.FONT_B     = [[Interface\AddOns\Q\Media\CalibriBold.ttf]]


_G["Q"] = Q