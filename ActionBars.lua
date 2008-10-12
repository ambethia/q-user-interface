local _G = getfenv(0);

local ActionBars = {}

ActionBars.SIZE  = 42 -- Blizzard Button Size
ActionBars.SCALE = (UIParent:GetWidth()/(NUM_ACTIONBAR_BUTTONS*4)) / ActionBars.SIZE 

ActionBars.hidden = {
  -- XP and Rep
  MainMenuExpBar, ExhaustionTick, ReputationWatchBar,

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
  
  -- Backgrounds
  MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2,
  MainMenuBarTexture3,
  ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
  -- SlidingActionBarTexture0, SlidingActionBarTexture1 -- ??
  BonusActionBarTexture0, BonusActionBarTexture1
}

ActionBars.frame = CreateFrame("Frame")
ActionBars.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionBars.frame:SetScript("OnEvent", function()
  ActionBars.frame:UnregisterAllEvents()
  ActionBars.frame:SetScript("OnEvent", nil)
  
  -- Allow frames to be moved around
  for _, frame in pairs({ "MainMenuBar",
    "MultiBarBottomLeft", "MultiBarBottomRight",
    "ShapeshiftBarFrame", "MultiBarLeft", "MultiBarRight" }) do
    UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
    _G[frame]:Show() -- Force the MultiBars to show
  end
  
  -- Not Worrying about this for now...
  -- -- Blackout the background of Shapeshift/Stance Bars
  -- BonusActionBarTexture0:SetVertexColor(0,0,0,1)
  -- BonusActionBarTexture1:SetVertexColor(0,0,0,1)
  
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
  ActionBars:position(MainMenuBar,         "TOPLEFT",    UIParent,            "TOPLEFT",     4, 0)

  -- Get the stance bar out of the way for now
  ShapeshiftBarFrame:ClearAllPoints()
  ShapeshiftBarFrame:SetPoint("TOPLEFT", MainMenuBar, "BOTTOMLEFT", 0, -8)
end)

function ActionBars:position(bar, ...)
  -- Chat frame sits on top of these bars, too lazy to figure out what's
  -- really going on with the frame sizes, +10 is a hack, looks good to me
  bar:SetHeight(ActionBars.SIZE+10) 
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












