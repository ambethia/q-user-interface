local _G = getfenv(0);
local Q  = _G["Q"]

Q.ActionBars = {}
Q.ActionBars.SIZE  = 42 -- Blizzard Button Size
Q.ActionBars.SCALE = (UIParent:GetWidth()/(NUM_ACTIONBAR_BUTTONS*4)) / Q.ActionBars.SIZE 

Q.ActionBars.hidden = {
  -- XP and Rep
  MainMenuExpBar, ExhaustionTick, ReputationWatchBar, MainMenuBarMaxLevelBar,

  -- Gryphons
  MainMenuBarLeftEndCap, MainMenuBarRightEndCap,

  -- Bags
  CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot,
  CharacterBag3Slot, MainMenuBarBackpackButton, KeyRingButton,

  -- Micro Menu
  CharacterMicroButton, SpellbookMicroButton, TalentMicroButton,
  AchievementMicroButton, QuestLogMicroButton, SocialsMicroButton,
  PVPMicroButton, LFGMicroButton, MainMenuMicroButton, HelpMicroButton,

  -- Bar Controls
  ActionBarUpButton, ActionBarDownButton, MainMenuBarPageNumber,

  -- Class Bar
  -- ShapeshiftBarFrame, 

  -- Backgrounds
  MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3,
  -- SlidingActionBarTexture0, SlidingActionBarTexture1 -- ??
  -- BonusActionBarTexture0, BonusActionBarTexture1 -- BLACKED OUT (BELOW)
}

Q.ActionBars.frame = CreateFrame("Frame")
Q.ActionBars.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Q.ActionBars.frame:SetScript("OnEvent", function()
  Q.ActionBars.frame:UnregisterAllEvents()
  Q.ActionBars.frame:SetScript("OnEvent", nil)

  -- Allow frames to be moved around
  for _, frame in pairs({ "MainMenuBar",
    "BonusActionBarFrame", "ShapeshiftBarFrame", "PossessBarFrame",
    "MultiBarBottomLeft", "MultiBarBottomRight", 
    "MultiBarLeft", "MultiBarRight" }) do
    UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
  end

  -- Hide parts of the main bar that are save to hide.
  for _, frame in pairs(Q.ActionBars.hidden) do
    frame:Hide()
    frame.Show = function() end
  end

  -- Bottom Bars
  Q.ActionBars:position(MultiBarBottomLeft,  "BOTTOMLEFT", UIParent,            "BOTTOMLEFT",  4, 4)
  Q.ActionBars:position(MultiBarBottomRight, "BOTTOMLEFT", MultiBarBottomLeft,  "BOTTOMRIGHT", 0, 0)
  Q.ActionBars:position(MultiBarLeft,        "BOTTOMLEFT", MultiBarBottomRight, "BOTTOMRIGHT", 0, 0)
  Q.ActionBars:position(MultiBarRight,       "BOTTOMLEFT", MultiBarLeft,        "BOTTOMRIGHT", 0, 0)
  Q.ActionBars:flip("MultiBarLeft")
  Q.ActionBars:flip("MultiBarRight")

  -- Main Bar  
  ActionButton1:ClearAllPoints()
  ActionButton1:SetPoint("BOTTOMLEFT")
  Q.ActionBars:position(MainMenuBar,         "BOTTOMLEFT", MultiBarBottomLeft,  "TOPLEFT", 0, 0)

  -- Bonus Bar
  -- -- Keep it hidden, and off screen untill called.
  BonusActionBarFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
  if not BonusActionBarFrame:IsShown() then
    BonusActionBarFrame:Hide()
  end
  -- -- Make sure it slides into the right place
  BONUSACTIONBAR_YPOS = Q.ActionBars.SIZE-4
  BONUSACTIONBAR_XPOS = -6
  -- -- Blackout the background
  BonusActionBarTexture0:SetVertexColor(0,0,0,1)
  BonusActionBarTexture1:SetVertexColor(0,0,0,1)
  
  -- Class Bar
  ShapeshiftBarFrame:ClearAllPoints()
	ShapeshiftBarFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -8);
	
end)

function Q.ActionBars:position(bar, ...)
  -- Chat frame sits on top of these bars, too lazy to figure out what's
  -- really going on with the frame sizes, the height is a hack.
  bar:SetHeight(Q.ActionBars.SIZE)
  bar:SetWidth(Q.ActionBars.SIZE * NUM_ACTIONBAR_BUTTONS)
  bar:ClearAllPoints()
  bar:SetPoint(...)
  bar:SetScale(Q.ActionBars.SCALE)
end

-- Flip the vertical multibars on their sides
function Q.ActionBars:flip(bar)
  local button1 = _G[bar.."Button1"]
  button1:ClearAllPoints()
  button1:SetPoint("BOTTOMLEFT", _G[bar])
  for i = 2, NUM_ACTIONBAR_BUTTONS do
    local f = _G[bar.."Button"..i]
    local _, relativeTo = f:GetPoint(1)
    f:ClearAllPoints()
    f:SetPoint("BOTTOMLEFT", relativeTo, "BOTTOMRIGHT", 6, 0)
  end
end












