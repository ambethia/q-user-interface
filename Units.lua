local _G = getfenv(0);
local Q  = _G["Q"]

Q.Units = {}

local oUF = oUF_embed

local SPACING = 5
local PRIMARY_HEIGHT,   PRIMARY_WIDTH   = 28, (((UIParent:GetWidth()/2) * 0.61803399))
local SECONDARY_HEIGHT, SECONDARY_WIDTH = 12, ((PRIMARY_WIDTH * 0.61803399))

Q.Units.PlayerFrames = function(settings, self, unit)
  self.unit = unit
  self.menu = Q.Units.Menu

  self:SetScript("OnEnter", UnitFrame_OnEnter)
  self:SetScript("OnLeave", UnitFrame_OnLeave)
  self:RegisterForClicks("anyup")
  self:SetAttribute("*type2", "menu")

  self:SetBackdrop({
   bgFile   = [[Interface\Tooltips\UI-Tooltip-Background]],
   edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
   tile     = true, tileSize = 16, edgeSize = 16,
   insets   = { left = 4, right = 4, top = 4, bottom = 4 }
  })
  
  -- self:SetBackdropBorderColor(0.1, 0.1, 0, 1)
  self:SetBackdropColor(0, 0, 0, 1)

  if (unit == "focus") or (unit == "targettarget") then
    width = SECONDARY_WIDTH-SPACING*2
  else -- player or target
    width = PRIMARY_WIDTH-SPACING*2
  end

  self.TaggedStrings = {}

  -- Unit Name
  local name = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  name:SetFont(Q.FONT_B, 11)
  name:SetPoint("TOPLEFT", SPACING, -SPACING)
  name:SetJustifyH("LEFT")
  name:SetTextColor(1, 1, 1, 0.66)
  name:SetText("[raidcolor][name]")
  table.insert(self.TaggedStrings, name)

  -- Info
  local info = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  info:SetFont(Q.FONT, 11)
  info:SetPoint("TOPRIGHT", -SPACING, -SPACING)
  info:SetJustifyH("RIGHT")
  info:SetTextColor(1, 1, 1)
  info:SetText("[difficulty][smartlevel][shortclassification] [rare] [raidcolor][smartclass]")
  table.insert(self.TaggedStrings, info)

  self.Info = info
  self.UNIT_LEVEL = updateInfoString
  self:RegisterEvent("UNIT_LEVEL")

  -- Health Bar
  local health = CreateFrame("StatusBar")
  health:SetWidth(width)
  health:SetHeight(SECONDARY_HEIGHT)
  health:SetStatusBarTexture(Q.STATUS_BAR)

  health:SetParent(self)
  health:SetPoint("BOTTOM", self, "BOTTOM", 0, SECONDARY_HEIGHT + SPACING + 2)

  -- Health Bar Background
  local healthBG = health:CreateTexture(nil, "BORDER")
  healthBG:SetAllPoints(health)
  healthBG:SetTexture(Q.STATUS_BAR)
  healthBG.multiplier = 0.33
  health.bg = healthBG
  
  -- Percent HP Text
  local healthHP = health:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  healthHP:SetFont(Q.FONT, 9)
  healthHP:SetPoint("BOTTOMLEFT", 2, 2)
  healthHP:SetJustifyH("LEFT")
  healthHP:SetTextColor(1, 1, 1, 0.66)
  healthHP:SetText("[perhp]%")
  table.insert(self.TaggedStrings, healthHP)

  -- Min/Max HP Text
  local healthMaxHP = health:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  healthMaxHP:SetFont(Q.FONT, 9)
  healthMaxHP:SetPoint("BOTTOMRIGHT", -2, 2)
  healthMaxHP:SetJustifyH("RIGHT")
  healthMaxHP:SetTextColor(1, 1, 1, 0.66)
  healthMaxHP:SetText("[curhp] : [maxhp]")
  table.insert(self.TaggedStrings, healthMaxHP)

  health.colorTapping      = true
  health.colorDisconnected = true
  health.colorHappiness    = true
  health.colorSmooth       = true
  health.frequentUpdates   = true

  self.Health = health
  self.PostUpdateHealth = Q.Units.PostUpdateHealth

  -- Power
  local power = CreateFrame("StatusBar")
  power:SetWidth(width)
  power:SetHeight(SECONDARY_HEIGHT)
  power:SetStatusBarTexture(Q.STATUS_BAR)

  power:SetParent(self)
  power:SetPoint("BOTTOM", self, "BOTTOM", 0, SPACING)

  local powerBg = power:CreateTexture(nil, "BORDER")
  powerBg:SetAllPoints()
  powerBg:SetTexture(Q.STATUS_BAR)
  powerBg.multiplier = 0.33
  power.bg = powerBg

  -- Percent Power Text
  local powerPP = power:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  powerPP:SetFont(Q.FONT, 9)
  powerPP:SetPoint("BOTTOMLEFT", 2, 2)
  powerPP:SetJustifyH("LEFT")
  powerPP:SetTextColor(1, 1, 1, 0.66)
  powerPP:SetText("[perpp]%")
  table.insert(self.TaggedStrings, powerPP)

  -- Min/Max Power Text
  local powerMaxPP = power:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  powerMaxPP:SetFont(Q.FONT, 9)
  powerMaxPP:SetPoint("BOTTOMRIGHT", -2, 2)
  powerMaxPP:SetJustifyH("RIGHT")
  powerMaxPP:SetTextColor(1, 1, 1, 0.66)
  powerMaxPP:SetText("[curpp] : [maxpp]")
  table.insert(self.TaggedStrings, powerMaxPP)

  power.colorTapping      = true
  power.colorDisconnected = true
  power.colorPower        = true
  power.frequentUpdates   = true

  self.Power = power

  local leader = self:CreateTexture(nil, "OVERLAY")
  leader:SetHeight(16)
  leader:SetWidth(16)
  leader:SetPoint("LEFT", name, "RIGHT", SPACING/2, 0)
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
    cast:SetWidth(width*0.61803399)
    cast:SetHeight(SECONDARY_HEIGHT)
    cast:SetStatusBarTexture(Q.STATUS_BAR)
    cast:SetStatusBarColor(.3, .3, .3)
    cast:SetParent(self)
    cast:SetFrameStrata("HIGH")
    cast:SetPoint("CENTER", self, "TOP", SECONDARY_HEIGHT, 0)
  
    local castBg = cast:CreateTexture(nil, "BORDER")
    castBg:SetAllPoints()
    castBg:SetTexture(Q.STATUS_BAR)
    castBg:SetVertexColor(.1, .1, .1)
    cast.bg = castBg

    local castTime = cast:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    castTime:SetFont(Q.FONT, 10)
    castTime:SetPoint("RIGHT", cast, -SPACING, 0)
    castTime:SetTextColor(1, 1, 1, 0.88)
    cast.Time = castTime

    local castText = cast:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    castText:SetFont(Q.FONT, 10)
    castText:SetPoint("LEFT", cast, SPACING, 0)
    castText:SetPoint("RIGHT", castTime, "LEFT", -SPACING, 0)
    castText:SetJustifyH("LEFT")
    castText:SetTextColor(1, 1, 1, 0.66)
    cast.Text = castText

    local castIcon = cast:CreateTexture(nil, "BORDER")
    castIcon:SetPoint("RIGHT", cast, "LEFT", -SPACING, 0)
    castIcon:SetWidth(SECONDARY_HEIGHT+4)
    castIcon:SetHeight(SECONDARY_HEIGHT+4)
    cast.Icon = castIcon

    local castSZ = cast:CreateTexture(nil, "BORDER")
    castSZ:SetPoint("TOPRIGHT")
    castSZ:SetPoint("BOTTOMRIGHT")
    castSZ:SetTexture(Q.STATUS_BAR)
    castSZ:SetVertexColor(.3, 0, 0)
    cast.SafeZone = castSZ

    -- background    
    local castBD = CreateFrame("Frame")
    castBD:SetParent(cast)
    castBD:SetPoint("CENTER", cast, "CENTER", -(SECONDARY_HEIGHT-2), 0)
    castBD:SetWidth((width*0.61803399) + (SECONDARY_HEIGHT+4) + (SPACING*4))
    castBD:SetHeight(SECONDARY_HEIGHT+(SPACING*3))
    castBD:SetFrameStrata("MEDIUM")
    castBD:SetBackdrop({
     bgFile   = [[Interface\Tooltips\UI-Tooltip-Background]],
     edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
     tile     = true, tileSize = 16, edgeSize = 16,
     insets   = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    castBD:SetBackdropColor(0.1, 0.1, 0.1, 1)
    castBD:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    -- self.PostCastStart = Q.Units.PostCastStart

    self.Castbar = cast
  end

  -- Auras
  self.Auras = CreateFrame("Frame", nil, self)
  self.Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", SPACING, SPACING/2)
  self.Auras:SetWidth(width-(SPACING*2))
  self.Auras:SetHeight(16)
  self.Auras.size    = 16
  self.Auras.spacing = SPACING/2
  self.Auras.gap     = true

  self.PostCreateAuraIcon = Q.Units.PostCreateAuraIcon
end

Q.Units.Party = function(settings, self, unit)
  self.unit = unit
  self.menu = Q.Units.Menu
end

Q.Units.Menu = function(self)
  local unit = self.unit:sub(1, -2)
  local cunit = self.unit:gsub("(.)", string.upper, 1)

  if(unit == "party" or unit == "partypet") then
    ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
  elseif(_G[cunit.."FrameDropDown"]) then
    ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
  end
end

Q.Units.PostUpdateHealth = function(self, event, unit, bar, min, max)
  local color = not UnitIsDeadOrGhost(unit) and (not UnitIsTapped(unit) and not (unit == "player") or UnitIsTappedByPlayer(unit)) and Q.Units.ReactionColor[UnitReaction(unit, 'player')] or {r = .3, g = .3, b = .3}
  self:SetBackdropBorderColor(color.r, color.g, color.b)
end

Q.Units.PostCreateAuraIcon = function(self, button, icons, index, debuff)
  icons.showDebuffType = true
  button.cd:SetReverse()
  -- Remove buff on right click
  button:SetScript("OnMouseUp", function(self, mouseButton)
    if (mouseButton == "RightButton") then
      CancelUnitBuff("player", index)
    end
  end)
end

-- --- Color cast bar based on spell school, once I can figure out how
-- Q.Units.PostCastStart = function(self, event, unit, spell, spellrank)
--   self.Castbar:SetStatusBarColor(0,0,0) 
-- end

-- Slightly darker than the default colors.
Q.Units.ReactionColor = {
  { r = 0.6, g = 0.0, b = 0.0 }, -- Exceptionally Hostile
  { r = 0.6, g = 0.0, b = 0.0 }, -- Very Hostile
  { r = 0.6, g = 0.0, b = 0.0 }, -- Hostile
  { r = 0.8, g = 0.8, b = 0.0 }, -- Neutral
  { r = 0.0, g = 0.3, b = 0.0 }, -- Friendly
  { r = 0.0, g = 0.3, b = 0.0 }, -- Very Friendly
  { r = 0.0, g = 0.3, b = 0.0 }, -- Exceptionally Friendly
  { r = 0.0, g = 0.3, b = 0.0 }, -- Exalted
}

oUF:RegisterStyle("Q - Primary", setmetatable({
  ["initial-width"] = PRIMARY_WIDTH,
  ["initial-height"] = (SECONDARY_HEIGHT * 2) + (SPACING * 2) + 14, -- 2 Bars, + Font height and padding
}, {__call = Q.Units.PlayerFrames}))

oUF:RegisterStyle("Q - Secondary", setmetatable({
  ["initial-width"] = SECONDARY_WIDTH,
  ["initial-height"] = (SECONDARY_HEIGHT * 2) + (SPACING * 2) + 14,
}, {__call = Q.Units.PlayerFrames}))

oUF:SetActiveStyle("Q - Primary")

local player = oUF:Spawn("player", "oUF_Player")
player:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOM", 0, SPACING/2)

local target = oUF:Spawn("target", "oUF_Target")
target:SetPoint("BOTTOMLEFT", WorldFrame, "BOTTOM", 0, SPACING/2)

oUF:SetActiveStyle("Q - Secondary")

local targettarget = oUF:Spawn("targettarget", "oUF_TargetTarget")
targettarget:SetPoint("TOPLEFT", target, "TOPRIGHT", 0, 0)

local focus = oUF:Spawn("focus", "oUF_Focus")
focus:SetPoint("TOPRIGHT", player, "TOPLEFT", 0, 0)