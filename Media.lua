local LSM3 = LibStub("LibSharedMedia-3.0", true)
local LSM2 = LibStub("LibSharedMedia-2.0", true)
local SML  = LibStub("SharedMedia-1.0", true)
local SRFC = LibStub("Surface-1.0", true)

Media = {}
Media.registry = {}

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

Media:Register("font",      "Calibri",             [[Interface\Addons\Q\Media\Calibri.ttf]])
Media:Register("font",      "Calibri Bold",        [[Interface\Addons\Q\Media\CalibriBold.ttf]])
Media:Register("font",      "Calibri Bold Italic", [[Interface\Addons\Q\Media\CalibriBoldItalic.ttf]])
Media:Register("font",      "Calibri Italic",      [[Interface\Addons\Q\Media\CalibriItalic.ttf]])
Media:Register("statusbar", "Minimalist",          [[Interface\Addons\Q\Media\Minimalist]])
