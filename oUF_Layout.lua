local texture      = [[Interface\AddOns\Q\Media\Minimalist]]
local calibri      = [[Interface\AddOns\Q\Media\Calibri.ttf]]
local calibri_bold = [[Interface\AddOns\Q\Media\CalibriBold.ttf]]

local spacing,          baseline        = 5,  (UIParent:GetHeight() - (UIParent:GetHeight() * 0.618))
local primary_height,   primary_width   = 26, (((UIParent:GetWidth()/2) * 0.618) - spacing)
local secondary_height, secondary_width = 10, ((primary_width * 0.618) - spacing)

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
  local b, n
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
  
  -- Reaction Color
  -- For WotLK, replace with UnitSelectionColor(unit)
  if(not (unit == "player")) then
    n = self.colors.reaction[UnitReaction(unit, "player")]
    if(n) then
      bar.value:SetTextColor(n[1], n[2], n[3], 0.66)
    end
  end

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
    width = secondary_width
  else -- player or target
    width = primary_width
  end

  self.TaggedStrings = {}

  -- Health Bar
  local health = CreateFrame("StatusBar")
  health:SetWidth(width)
  health:SetHeight(primary_height-1)
  health:SetStatusBarTexture(texture)

  health:SetParent(self)
  health:SetPoint("TOP", 1, 1)

  -- Health Bar Background
  local healthBG = health:CreateTexture(nil, "BORDER")
  healthBG:SetAllPoints()
  healthBG:SetTexture(texture)
  
  -- Health HP Text
  local healthHP = health:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  healthHP:SetFont(calibri, 10)
  healthHP:SetPoint("BOTTOMLEFT", 1, 1)
  healthHP:SetJustifyH("LEFT")
  healthHP:SetTextColor(1, 1, 1, 0.66)

  health.bg    = healthBG
  health.value = healthHP

  self.Health = health
  self.OverrideUpdateHealth = updateHealth

  -- Unit Name
  local name = health:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  name:SetFont(calibri_bold, 13)
  name:SetPoint("TOPLEFT")
  name:SetJustifyH("LEFT")
  name:SetTextColor(1, 1, 1, 0.66)
  name:SetText("[name]")
  table.insert(self.TaggedStrings, name)

  -- Info
	local info = health:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	info:SetFont(calibri, 13)
	info:SetPoint("TOPRIGHT")
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
  power:SetHeight(secondary_height)
  power:SetStatusBarTexture(texture)

  power:SetParent(self)
  power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -1)

  local powerBg = power:CreateTexture(nil, "BORDER")
  powerBg:SetAllPoints()
  powerBg:SetTexture(texture)
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
    cast:SetWidth(width - (secondary_height*2) - 2)
    cast:SetHeight(secondary_height*2)
    cast:SetStatusBarTexture(texture)
    cast:SetStatusBarColor(.8, .8, .8)
    cast:SetParent(self)
    cast:SetFrameStrata("MEDIUM")
    cast:SetPoint("BOTTOMRIGHT", health, "TOPRIGHT", 0, 1)
  
    local castBg = cast:CreateTexture(nil, "BORDER")
    castBg:SetAllPoints()
    castBg:SetTexture(texture)
    castBg:SetVertexColor(.3, .3, .3)
    cast.bg = castBg

    local castTime = cast:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    castTime:SetFont(calibri, 10)
    castTime:SetPoint("RIGHT", cast, -spacing, 0)
    castTime:SetTextColor(1, 1, 1, 0.66)
    cast.Time = castTime

    local castText = cast:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    castText:SetFont(calibri, 10)
    castText:SetPoint("LEFT", cast, spacing, 0)
    castText:SetPoint("RIGHT", castTime, "LEFT", -spacing, 0)
    castText:SetJustifyH("LEFT")
    castText:SetTextColor(1, 1, 1, 0.66)
    cast.Text = castText

    local castIcon = cast:CreateTexture(nil, "BORDER")
    castIcon:SetPoint("RIGHT", cast, "LEFT", -2, 0)
    castIcon:SetWidth(secondary_height*2)
    castIcon:SetHeight(secondary_height*2)
    cast.Icon = castIcon

    self.Castbar = cast
  end
end

oUF:RegisterStyle("Q - Primary", setmetatable({
  ["initial-width"] = primary_width,
  ["initial-height"] = primary_height + (secondary_height*3),
}, {__call = ambethianStyle}))

oUF:RegisterStyle("Q - Secondary", setmetatable({
  ["initial-width"] = secondary_width,
  ["initial-height"] = primary_height + (secondary_height*3),
}, {__call = ambethianStyle}))

oUF:SetActiveStyle("Q - Primary")

local player = oUF:Spawn("player", "oUF_Player")
player:SetPoint("TOPRIGHT", UIParent, "BOTTOM", -spacing/2, baseline)

local target = oUF:Spawn("target", "oUF_Target")
target:SetPoint("TOPLEFT", UIParent, "BOTTOM", spacing/2, baseline)

oUF:SetActiveStyle("Q - Secondary")

local targettarget = oUF:Spawn("targettarget", "oUF_TargetTarget")
targettarget:SetPoint("TOPLEFT", target, "TOPRIGHT", spacing, 0)

local focus = oUF:Spawn("focus", "oUF_Focus")
focus:SetPoint("TOPRIGHT", player, "TOPLEFT", -spacing, 0)
