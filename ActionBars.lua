local _G = getfenv(0);

local ActionBars = {}

ActionBars.SIZE  = 42 -- Blizzard Button Size
ActionBars.SCALE = (UIParent:GetWidth()/(NUM_ACTIONBAR_BUTTONS*4)) / ActionBars.SIZE 

ActionBars.hidden = {
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

  -- Class bar
  ShapeshiftBarFrame,

  -- Backgrounds
  MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2,
  MainMenuBarTexture3,
  -- SlidingActionBarTexture0, SlidingActionBarTexture1 -- ??
  -- BonusActionBarTexture0, BonusActionBarTexture1 -- BLACKED OUT (BELOW)
}

ActionBars.frame = CreateFrame("Frame")
ActionBars.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionBars.frame:SetScript("OnEvent", function()
  ActionBars.frame:UnregisterAllEvents()
  ActionBars.frame:SetScript("OnEvent", nil)

  -- Allow frames to be moved around
  for _, frame in pairs({
    "MainMenuBar", "BonusActionBarFrame",
    "MultiBarBottomLeft", "MultiBarBottomRight",
    "MultiBarLeft", "MultiBarRight" }) do
    UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
    _G[frame]:Show() -- Force the MultiBars to show
  end

  -- Hide most part of the main bar
  for _, frame in pairs(ActionBars.hidden) do
    frame:Hide()
    frame.Show = function() end
  end

  -- Bottom Bars
  ActionBars:position(MultiBarBottomLeft,  "BOTTOMLEFT", UIParent,            "BOTTOMLEFT",  4, 4)
  ActionBars:position(MultiBarBottomRight, "BOTTOMLEFT", MultiBarBottomLeft,  "BOTTOMRIGHT", 0, 0)
  ActionBars:position(MultiBarLeft,        "BOTTOMLEFT", MultiBarBottomRight, "BOTTOMRIGHT", 0, 0)
  ActionBars:position(MultiBarRight,       "BOTTOMLEFT", MultiBarLeft,        "BOTTOMRIGHT", 0, 0)
  ActionBars:flip("MultiBarLeft")
  ActionBars:flip("MultiBarRight")

  -- Main Bar  
  ActionButton1:ClearAllPoints()
  ActionButton1:SetPoint("BOTTOMLEFT")
  ActionBars:position(MainMenuBar,         "BOTTOMLEFT", MultiBarBottomLeft,  "TOPLEFT", 0, 0)

  -- Bonus Bar
  -- -- Keep it hidden, and off screen untill called.
  BonusActionBarFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
  BonusActionBarFrame:Hide()
  -- -- Make sure it slides into the right place
  BONUSACTIONBAR_YPOS = ActionBars.SIZE-4
  BONUSACTIONBAR_XPOS = -6
  -- -- Blackout the background
  BonusActionBarTexture0:SetVertexColor(0,0,0,1)
  BonusActionBarTexture1:SetVertexColor(0,0,0,1)
end)

function ActionBars:position(bar, ...)
  -- Chat frame sits on top of these bars, too lazy to figure out what's
  -- really going on with the frame sizes, the height is a hack.
  bar:SetHeight(ActionBars.SIZE)
  bar:SetWidth(ActionBars.SIZE * NUM_ACTIONBAR_BUTTONS)
  bar:ClearAllPoints()
  bar:SetPoint(...)
  bar:SetScale(ActionBars.SCALE)
end

-- Flip the vertical multibars on their sides
function ActionBars:flip(bar)
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












