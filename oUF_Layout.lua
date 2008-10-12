local oUF = oUF_embed

local STATUS_BAR = [[Interface\AddOns\Q\Media\Minimalist]]
local FONT       = [[Interface\AddOns\Q\Media\Calibri.ttf]]
local FONT_B     = [[Interface\AddOns\Q\Media\CalibriBold.ttf]]

local SPACING = 5
local PRIMARY_HEIGHT,   PRIMARY_WIDTH   = 26, (((UIParent:GetWidth()/2) * 0.618) - SPACING)
local SECONDARY_HEIGHT, SECONDARY_WIDTH = 10, ((PRIMARY_WIDTH * 0.618) - SPACING)

local menu = function(self)
  local unit = self.unit:sub(1, -2)
  local cunit = self.unit:gsub("(.)", string.upper, 1)

  if(unit == "party" or unit == "partypet") then
    ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
  elseif(_G[cunit.."FrameDropDown"]) then
    ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
  end
end

local updateHealth = function(self, event, unit, bar, min, max)
  local b
  if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
   b = self.colors.tapped
  elseif(UnitIsDead(unit)) then
    bar:SetValue(0)
    bar.value:SetText("Dead")
    b = self.colors.dead
  elseif(UnitIsGhost(unit)) then
    bar:SetValue(0)
    bar.value:SetText("Ghost")
    b = self.colors.dead
  elseif(not UnitIsConnected(unit)) then
    bar.value:SetText("Offline")
    b = self.colors.dead
  else
    local _, class = UnitClass(unit)
    b = self.colors.class[class]
    bar.value:SetFormattedText('%s/%s', min, max)
  end
  
  -- TODO, non players should just use reaction color

  bar:SetStatusBarColor(b[1], b[2], b[3])
  bar.bg:SetVertexColor(b[1] * 0.33, b[2] * 0.33, b[3] * 0.33)
end

local function ambethianStyle(settings, self, unit)
  self.unit = unit
  self.menu = menu

  self:SetScript("OnEnter", UnitFrame_OnEnter)
  self:SetScript("OnLeave", UnitFrame_OnLeave)
  self:RegisterForClicks("anyup")
  self:SetAttribute("*type2", "menu")

  if (unit == "focus") or (unit == "targettarget") then
    width = SECONDARY_WIDTH
  else -- player or target
    width = PRIMARY_WIDTH
  end

  self.TaggedStrings = {}

  -- Health Bar
  local health = CreateFrame("StatusBar")
  health:SetWidth(width)
  health:SetHeight(PRIMARY_HEIGHT-1)
  health:SetStatusBarTexture(STATUS_BAR)

  health:SetParent(self)
  health:SetPoint("TOP", self, "BOTTOM", 0, (SECONDARY_HEIGHT + PRIMARY_HEIGHT))

  -- Health Bar Background
  local healthBG = health:CreateTexture(nil, "BORDER")
  healthBG:SetAllPoints()
  healthBG:SetTexture(STATUS_BAR)
  
  -- Health HP Text
  local healthHP = health:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  healthHP:SetFont(FONT, 9)
  healthHP:SetPoint("BOTTOMLEFT", 2, 2)
  healthHP:SetJustifyH("LEFT")
  healthHP:SetTextColor(1, 1, 1, 0.66)

  health.bg    = healthBG
  health.value = healthHP

  self.Health = health
  self.OverrideUpdateHealth = updateHealth

  -- Unit Name
  local name = health:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  name:SetFont(FONT_B, 11)
  name:SetPoint("TOPLEFT", 2, -2)
  name:SetJustifyH("LEFT")
  name:SetTextColor(1, 1, 1, 0.66)
  name:SetText("[name]")
  table.insert(self.TaggedStrings, name)

  -- Info
  local info = health:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  info:SetFont(FONT, 11)
  info:SetPoint("TOPRIGHT", -2, -2)
  info:SetJustifyH("RIGHT")
  info:SetTextColor(1, 1, 1)
  info:SetText("[difficulty][smartlevel] [rare] [raidcolor][smartclass]")
  table.insert(self.TaggedStrings, info)

  self.Info = info
  self.UNIT_LEVEL = updateInfoString
  self:RegisterEvent("UNIT_LEVEL")

  -- Power
  local power = CreateFrame("StatusBar")
  power:SetWidth(width)
  power:SetHeight(SECONDARY_HEIGHT)
  power:SetStatusBarTexture(STATUS_BAR)

  power:SetParent(self)
  power:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)

  local powerBg = power:CreateTexture(nil, "BORDER")
  powerBg:SetAllPoints()
  powerBg:SetTexture(STATUS_BAR)
  powerBg.multiplier = 0.33
  power.bg = powerBg

  self.Power = power
  self.Power.colorPower = true
  
  local leader = self:CreateTexture(nil, "OVERLAY")
  leader:SetHeight(16)
  leader:SetWidth(16)
  leader:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 0)
  leader:SetTexture[[Interface\GroupFrame\UI-Group-LeaderIcon]]
  self.Leader = leader

  -- Raid icon
  local ricon = health:CreateTexture(nil, "OVERLAY")
  ricon:SetHeight(16)
  ricon:SetWidth(16)
  ricon:SetPoint("CENTER", self, "TOP")
  ricon:SetTexture[[Interface\TargetingFrame\UI-RaidTargetingIcons]]
  self.RaidIcon = ricon
  
  -- Cast Bar
  if (unit == "player" or unit == "target" or unit == "focus") then
    local cast = CreateFrame("StatusBar")
    cast:SetWidth(width - (SECONDARY_HEIGHT*2) - 2)
    cast:SetHeight(SECONDARY_HEIGHT*2)
    cast:SetStatusBarTexture(STATUS_BAR)
    cast:SetStatusBarColor(.8, .8, .8)
    cast:SetParent(self)
    cast:SetFrameStrata("MEDIUM")
    cast:SetPoint("BOTTOMRIGHT", health, "TOPRIGHT", 0, 1)
  
    local castBg = cast:CreateTexture(nil, "BORDER")
    castBg:SetAllPoints()
    castBg:SetTexture(STATUS_BAR)
    castBg:SetVertexColor(.3, .3, .3)
    cast.bg = castBg

    local castTime = cast:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    castTime:SetFont(FONT, 10)
    castTime:SetPoint("RIGHT", cast, -SPACING, 0)
    castTime:SetTextColor(1, 1, 1, 0.66)
    cast.Time = castTime

    local castText = cast:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    castText:SetFont(FONT, 10)
    castText:SetPoint("LEFT", cast, SPACING, 0)
    castText:SetPoint("RIGHT", castTime, "LEFT", -SPACING, 0)
    castText:SetJustifyH("LEFT")
    castText:SetTextColor(1, 1, 1, 0.66)
    cast.Text = castText

    local castIcon = cast:CreateTexture(nil, "BORDER")
    castIcon:SetPoint("RIGHT", cast, "LEFT", -2, 0)
    castIcon:SetWidth(SECONDARY_HEIGHT*2)
    castIcon:SetHeight(SECONDARY_HEIGHT*2)
    cast.Icon = castIcon

    self.Castbar = cast
  end
end

oUF:RegisterStyle("Q - Primary", setmetatable({
  ["initial-width"] = PRIMARY_WIDTH,
  ["initial-height"] = PRIMARY_HEIGHT + (SECONDARY_HEIGHT*3),
}, {__call = ambethianStyle}))

oUF:RegisterStyle("Q - Secondary", setmetatable({
  ["initial-width"] = SECONDARY_WIDTH,
  ["initial-height"] = PRIMARY_HEIGHT + (SECONDARY_HEIGHT*3),
}, {__call = ambethianStyle}))

oUF:SetActiveStyle("Q - Primary")

local player = oUF:Spawn("player", "oUF_Player")
player:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOM", -SPACING/2, SPACING)

local target = oUF:Spawn("target", "oUF_Target")
target:SetPoint("BOTTOMLEFT", WorldFrame, "BOTTOM", SPACING/2, SPACING)

oUF:SetActiveStyle("Q - Secondary")

local targettarget = oUF:Spawn("targettarget", "oUF_TargetTarget")
targettarget:SetPoint("TOPLEFT", target, "TOPRIGHT", SPACING, 0)

local focus = oUF:Spawn("focus", "oUF_Focus")
focus:SetPoint("TOPRIGHT", player, "TOPLEFT", -SPACING, 0)
