local _G = getfenv(0);
local Q  = _G["Q"]

Q.ComboPoints = CreateFrame("Frame")

Q.ComboPoints:RegisterEvent("PLAYER_LOGIN")
Q.ComboPoints:SetScript("OnEvent", function()
  Q.ComboPoints:UnregisterAllEvents()
  Q.ComboPoints:SetScript("OnEvent", nil)

  -- oUF Disables this frame, but I like all th shinys.
  ComboFrame.Show = this.Show
  ComboFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
  ComboFrame:RegisterEvent("UNIT_COMBO_POINTS");
  
  ComboFrame:ClearAllPoints()
  ComboFrame:SetPoint("RIGHT", oUF_Target, "LEFT", 6, 0)  
  
  ComboFrame:SetScale(.75)
  
  ComboFrame:SetHeight(12*5)
  ComboFrame:SetWidth(12)
  
  ComboPoint5:SetHeight(12)
  ComboPoint5:SetWidth(12)
  
  ComboPoint1:ClearAllPoints()
  ComboPoint2:ClearAllPoints()
  ComboPoint3:ClearAllPoints()
  ComboPoint4:ClearAllPoints()
  ComboPoint5:ClearAllPoints()
  ComboPoint1:SetPoint("BOTTOMRIGHT", ComboFrame,  "BOTTOMRIGHT", 0, 0)
  ComboPoint2:SetPoint("BOTTOMRIGHT", ComboPoint1, "TOPRIGHT",    0, 0)
  ComboPoint3:SetPoint("BOTTOMRIGHT", ComboPoint2, "TOPRIGHT",    0, 0)
  ComboPoint4:SetPoint("BOTTOMRIGHT", ComboPoint3, "TOPRIGHT",    0, 0)
  ComboPoint5:SetPoint("BOTTOMRIGHT", ComboPoint4, "TOPRIGHT",    0, 0)
end)