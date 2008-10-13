-- Originally based on Tekkub Stoutwrithe's teklayout:
--   http://github.com/tekkub/teklayout/tree
local VSIZE, GAP = 120, 5
local HSIZE = (UIParent:GetWidth()/4)

local Chat = {}

Chat.groups = {
  [ChatFrame1] = {"SYSTEM", "SYSTEM_NOMENU", "ERRORS", "ACHIEVEMENT", "CHANNEL"},
  [ChatFrame3] = {"GUILD", "GUILD_OFFICER", "GUILD_ACHIEVEMENT"},
  [ChatFrame4] = { "AFK", "DND", "EMOTE", "IGNORED", "SAY", "WHISPER",
    "BATTLEGROUND", "BATTLEGROUND_LEADER", "BG_ALLIANCE", "BG_HORDE", "BG_NEUTRAL",
    "MONSTER_EMOTE", "MONSTER_SAY", "MONSTER_WHISPER", "MONSTER_YELL", "MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER",
    "PARTY", "RAID", "RAID_LEADER", "RAID_WARNING" },
  [ChatFrame5] = {"COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "MONEY", "COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_MISC_INFO"},
}

Chat.frame = CreateFrame("Frame")
Chat.frame:RegisterEvent("PLAYER_LOGIN")
Chat.frame:SetScript("OnEvent", function()
  Chat.frame:UnregisterAllEvents()
  Chat.frame:SetScript("OnEvent", nil)

  -- Make edit box stick to channel chat
  ChatTypeInfo["CHANNEL"] = { sticky = 1 };

  local barSize = UIParent:GetWidth()/(NUM_ACTIONBAR_BUTTONS*4)

  Chat:setupFrame(ChatFrame1, VSIZE-barSize, HSIZE-GAP, 51, 51, 51, 107, "BOTTOMLEFT",  MultiBarBottomLeft, "TOPLEFT",     0,   barSize+GAP)
  Chat:setupFrame(ChatFrame3, VSIZE/2 - GAP, HSIZE-GAP, 5,  70, 6,  91,  "TOPLEFT",     ChatFrame1,         "TOPRIGHT",    GAP, 0)
  Chat:setupFrame(ChatFrame4, VSIZE/2 - GAP, HSIZE-GAP, 81, 14, 68, 119, "TOPLEFT",     ChatFrame3,         "BOTTOMLEFT",  0,   -GAP*2)
  Chat:setupFrame(ChatFrame5, VSIZE,         HSIZE-GAP, 39, 65, 68, 112, "BOTTOMRIGHT", MultiBarRight,      "TOPRIGHT",    -GAP,GAP)
  SetCVar("chatLocked", 0)

  ChatFrame1.SetPoint = function() end -- Wrath build 8820 started resetting ChatFrame1's position.  This ensures it doesn't fuck with my layout.
  -- Seems Wrath likes to undo scale from time to time
  SetCVar("useUiScale", 1)
  SetCVar("UISCALE", 1)

  for i=1,7 do
    -- Hide buttons
    Chat:hideFrame("ChatFrame"..i.."UpButton")
    Chat:hideFrame("ChatFrame"..i.."DownButton")
    Chat:hideFrame("ChatFrame"..i.."BottomButton")

    -- Enable mouse wheel scrolling
    c = _G["ChatFrame"..i]
    c:EnableMouseWheel(1)
    c:SetScript("OnMouseWheel", function() Chat:OnMouseWheel(arg1) end)
  end

  -- Hide the tabs and lock the all the chat frames, except General and Combat
  for i=3,7 do
    Chat:hideFrame("ChatFrame"..i.."Tab")
    c = _G["ChatFrame"..i]
    c.isLocked = 1;
    SetChatWindowLocked(c:GetID(), 1);
  end

  ChatFrameEditBox:ClearAllPoints()
  ChatFrameEditBox:SetPoint("TOPLEFT",  "ChatFrame4", "BOTTOMLEFT",  -5, 0)
  ChatFrameEditBox:SetPoint("TOPRIGHT", "ChatFrame4", "BOTTOMRIGHT", 5, 0)

  WorldFrame:ClearAllPoints()
  WorldFrame:SetUserPlaced()
  WorldFrame:SetPoint("TOPRIGHT", UIParent)
  WorldFrame:SetPoint("LEFT", UIParent)
  WorldFrame:SetPoint("BOTTOM", ChatFrame1, "TOP", 0, GAP/2)
end)

function Chat:setupFrame(frame, h, w, r, g, b, a, ...)
  local id = frame:GetID()

  if frame ~= ChatFrame1 then
    SetChatWindowDocked(id, nil)
    for i,v in pairs(DOCKED_CHAT_FRAMES) do if v == frame then table.remove(DOCKED_CHAT_FRAMES, i) end end
    frame.isDocked = nil

    frame.isLocked = nil
    SetChatWindowLocked(id, nil)
  end

  frame:ClearAllPoints()
  frame:SetPoint(...)
  frame:SetHeight(h)
  frame:SetWidth(w)
  frame:Show()

  FCF_SetWindowColor(frame, r/255, g/255, b/255)
  FCF_SetWindowAlpha(frame, a/255)

  local font, _, flags = frame:GetFont()
  frame:SetFont(font, 11, flags)
  SetChatWindowSize(id, 11)

  -- ChatFrame_RemoveAllChannels(frame)
  ChatFrame_RemoveAllMessageGroups(frame)
  for i,v in pairs(self.groups[frame]) do ChatFrame_AddMessageGroup(frame, v) end
end

function Chat:OnMouseWheel(direction)
  if direction > 0 then
    if IsShiftKeyDown() then this:ScrollToTop() else this:ScrollUp() end
  elseif direction < 0 then
    if IsShiftKeyDown() then this:ScrollToBottom() else this:ScrollDown() end
  end
end

function Chat:hideFrame(frameName)
  local frame = _G[frameName]
  frame:Hide()
  frame.Show = function() end
end