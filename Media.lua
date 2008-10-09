local LSM3 = LibStub("LibSharedMedia-3.0", true)
local LSM2 = LibStub("LibSharedMedia-2.0", true)
local SML  = LibStub("SharedMedia-1.0", true)
local SRFC = LibStub("Surface-1.0", true)

Media = {}
Media.registry = { ["statusbar"] = {} }

function Media:Register(mediatype, key, data, langmask)
  if LSM3 then
    LSM3:Register(mediatype, key, data, langmask)
  end
  if LSM2 then
    LSM2:Register(mediatype, key, data)
  end
  if SML then
    SML:Register(mediatype, key, data)
  end
  if Surface and mediatype == "statusbar" then
    Surface:Register(key, data)
  end
  if not Media.registry[mediatype] then
    Media.registry[mediatype] = {}
  end
  table.insert(Media.registry[mediatype], { key, data, langmask})
end

function Media.OnEvent(this, event, ...)
  if not LSM3 then
    LSM3 = LibStub("LibMedia-3.0", true)
    if LSM3 then
      for m,t in pairs(Media.registry) do
        for _,v in ipairs(t) do
          LSM3:Register(m, v[1], v[2], v[3])
        end
      end
    end
  end
  if not LSM2 then
    LSM2 = LibStub("LibMedia-2.0", true)
    if LSM2 then
      for m,t in pairs(Media.registry) do
        for _,v in ipairs(t) do
          LSM2:Register(m, v[1], v[2])
        end
      end
    end
  end
  if not SML then
    SML = LibStub("Media-1.0", true)
    if SML then
      for m,t in pairs(Media.registry) do
        for _,v in ipairs(t) do
          SML:Register(m, v[1], v[2])
        end
      end
    end
  end
  if not Surface then
    Surface = LibStub("Surface-1.0", true)
    if Surface then
      for k,v in ipairs(Media.registry.statusbar) do
        Surface:Register(v[1], v[2])
      end
    end
  end
end

Media.frame = CreateFrame("Frame")
Media.frame:SetScript("OnEvent", Media.OnEvent)
Media.frame:RegisterEvent("ADDON_LOADED")

Media:Register("font",      "Calibri",             [[Interface\Addons\Q\Media\Calibri.ttf]])
Media:Register("font",      "Calibri Bold",        [[Interface\Addons\Q\Media\CalibriBold.ttf]])
Media:Register("font",      "Calibri Bold Italic", [[Interface\Addons\Q\Media\CalibriBoldItalic.ttf]])
Media:Register("font",      "Calibri Italic",      [[Interface\Addons\Q\Media\CalibriItalic.ttf]])
Media:Register("statusbar", "Minimalist",          [[Interface\Addons\Q\Media\Minimalist]])
