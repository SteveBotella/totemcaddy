--[==[
Copyright ©2020 Porthias of Myzrael or Porthios of Myzrael

The contents of this addon, excluding third-party resources, are
copyrighted to Porthios with all rights reserved.
This addon is free to use and the authors hereby grants you the following rights:
1. You may make modifications to this addon for private use only, you
   may not publicize any portion of this addon.
2. Do not modify the name of this addon, including the addon folders.
3. This copyright notice shall be included in all copies or substantial
  portions of the Software.
All rights not explicitly addressed in this license are reserved by
the copyright holders.
]==]--

TOCA.Global = {
  title  = "|cff006aa6Totem Caddy|r",
  author = "Porthias of Myzrael",
  version= 2.40,
  command= "toca",
  width  = 150,
  height = 85,
  font   = "Fonts/FRIZQT__.TTF",
  dir    = "Interface/Addons/TotemCaddy/",
  prefix = "TotemCaddy",
}

TOCA.DEBUG = false

TOCA.Prefix = {
  version = "0xEFVe",
}

TCCMD = "/"..TOCA.Global.command

TOCA.Backdrop={}
TOCA.Backdrop.General = { --also used for gray out
  bgFile  = "Interface/ToolTips/CHATBUBBLE-BACKGROUND",
  edgeFile= "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize= 12,
  insets  = {left=2, right=2, top=2, bottom=2},
}

TOCA.Backdrop.Main = { --also used for gray out
  bgFile  = "Interface/ToolTips/CHATBUBBLE-BACKGROUND",
  edgeFile= "Interface/TUTORIALFRAME/TUTORIALFRAMEBORDER",
  edgeSize= 20,
  insets  = {left=2, right=2, top=2, bottom=2},
}

TOCA.Backdrop.empty= { --also used for gray out
  bgFile  = "",
  edgeFile= "",
  edgeSize= 12,
  insets  = {left=2, right=2, top=2, bottom=2},
}

TOCA.Backdrop.highlight = {
  bgFile  = "Interface/Buttons/ButtonHilight-Square",
  edgeFile= "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize= 12,
  insets  = {left=2, right=2, top=2, bottom=2},
}

TOCA.Backdrop.Button = {
  bgFile  = "Interface/Buttons/GoldGradiant",
  edgeFile= "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize= 12,
  insets  = {left=2, right=2, top=2, bottom=2},
}

TOCA.Backdrop.RGB = {
  bgFile  = "Interface/Tooltips/UI-Tooltip-Background",
  edgeFile= "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize= 12,
  insets  = {left=2, right=2, top=2, bottom=2},
}

TOCA.Backdrop.BorderOnly= { --also used for gray out
  bgFile  = "",
  edgeFile= "Interface/ToolTips/UI-Tooltip-Border",
  edgeSize= 12,
  insets  = {left=2, right=2, top=2, bottom=2},
}

TOCA.version_alerted = 0
TOCA.Button={}
TOCA.Checkbox={}
TOCA.Slider={}
TOCA.Prompt={}
TOCA.Dropdown = {}
TOCA.Dropdown.Menu = {"Default"}
TOCA.Tooltip = {}
TOCA.MenuIsOpenMain = 0
TOCA.MenuIsOpenSets = 0
TOCA.ReincTimer = 0
TOCA.globalTimerInMinutes = true --default
TOCA.Tab={}
TOCA.TabWidth={}
TOCA.isInCombat = false

TOCA.Framelevel = {
  Background=0,
  Foreground=1,
  Menu      =2,
  Buttons   =3,
  Cover     =4,
}

TOCA.Slot_w=35
TOCA.Slot_h=35
TOCA.Slot_x=-TOCA.Slot_w/2

--defaults
TOCASlotOne  = TOCA.totems.AIR[1][1]
TOCASlotTwo  = TOCA.totems.EARTH[1][1]
TOCASlotThree= TOCA.totems.FIRE[1][1]
TOCASlotFour = TOCA.totems.WATER[1][1]

function TOCA.Notification(msg, debug)
  if ((debug) and (TOCA.DEBUG)) then
    print(TOCA.Global.title .. " DEBUG: " .. msg)
  end
  if (not debug) then
    print(TOCA.Global.title .. " " .. msg)
  end
end

function TOCA.BuildKeyBindsInit()
  BINDING_HEADER_TOTEMCADDY = TOCA.Global.title
  TOCA.KeyBindNames = {
    TOTEM_RECALL= "Totem Recall",
    TOTEM_AIR   = "Totem Slot: Air",
    TOTEM_EARTH = "Totem Slot: Earth",
    TOTEM_FIRE  = "Totem Slot: Fire",
    TOTEM_WATER = "Totem Slot: Water",
  }
  for KeyBK,KeyBV in pairsByKeys(TOCA.KeyBindNames) do
    _G["BINDING_NAME_"..KeyBK] = KeyBV
  end
  TOCA.Notification("TOCA.BuildKeyBindsInit()", true)
end

function TOCA.GetKeyBindings() --call after INIT all
  for KeyBK,KeyBV in pairsByKeys(TOCA.KeyBindNames) do
    local key1, key2 = GetBindingKey(KeyBK)
    if (key1) then
      TOCA.Notification(key1, true)
    end
  end
end

TOCA.KeyBindButton = CreateFrame("Button", nil, UIParent, "BackdropTemplate")
TOCA.KeyBindButton:SetSize(4, 4)
TOCA.KeyBindButton:SetPoint("TOPLEFT", -100, 0)

TOCA.BuildKeyBindsInit()

function TOCA.SetKeyBindReset(KeyBK, spell)
  local key1, key2 = GetBindingKey(KeyBK)
  if (key1) then
    SetOverrideBindingSpell(TOCA.KeyBindButton, true, key1, spell)
    TOCA.Notification("TOCA.SetKeyBindReset("..key1..", "..spell..")", true)
  end
  if (key2) then
    SetOverrideBindingSpell(TOCA.KeyBindButton, true, key2, spell)
    TOCA.Notification("TOCA.SetKeyBindReset("..key2..", "..spell..")", true)
  end
end

function TOCA.SetKeyBindOnLoad()
  if (TOCA.isInCombat) then
    TOCA.Notification("TOCA.SetKeyBindOnLoad() In combat, do nothing!", true)
  else
    TOCA.SetKeyBindReset("TOTEM_RECALL", "Totemic Call")
    if (TOCASlotOne) then
      TOCA.SetKeyBindReset("TOTEM_AIR", TOCASlotOne)
    end
    if (TOCASlotTwo) then
      TOCA.SetKeyBindReset("TOTEM_EARTH", TOCASlotTwo)
    end
    if (TOCASlotThree) then
      TOCA.SetKeyBindReset("TOTEM_FIRE", TOCASlotThree)
    end
    if (TOCASlotFour) then
      TOCA.SetKeyBindReset("TOTEM_WATER", TOCASlotFour)
    end
    TOCA.Notification("TOCA.SetKeyBindOnLoad()", true)
  end
end

function TOCA.Round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function TOCA.UpdateTotemSet()
  local totemIconKey = multiKeyFromValue(TOCA.totems.AIR, TOCASlotOne, 1)
  local totemIcon = {
    bgFile  = "interface/icons/" .. TOCA.totems.AIR[totemIconKey][2],
    edgeFile= "Interface/ToolTips/UI-Tooltip-Border",
    edgeSize= 12,
    insets  = {left=2, right=2, top=2, bottom=2},
  }
  TOCA.Slot["AIR"]:SetBackdrop(totemIcon)
  TOCA.FrameSetsSlot["AIR"]:SetBackdrop(totemIcon)

  local totemIconKey = multiKeyFromValue(TOCA.totems.EARTH, TOCASlotTwo, 1)
  local totemIcon = {
    bgFile  = "interface/icons/" .. TOCA.totems.EARTH[totemIconKey][2],
    edgeFile= "Interface/ToolTips/UI-Tooltip-Border",
    edgeSize= 12,
    insets  = {left=2, right=2, top=2, bottom=2},
  }
  TOCA.Slot["EARTH"]:SetBackdrop(totemIcon)
  TOCA.FrameSetsSlot["EARTH"]:SetBackdrop(totemIcon)

  local totemIconKey = multiKeyFromValue(TOCA.totems.FIRE, TOCASlotThree, 1)
  local totemIcon = {
    bgFile  = "interface/icons/" .. TOCA.totems.FIRE[totemIconKey][2],
    edgeFile= "Interface/ToolTips/UI-Tooltip-Border",
    edgeSize= 12,
    insets  = {left=2, right=2, top=2, bottom=2},
  }
  TOCA.Slot["FIRE"]:SetBackdrop(totemIcon)
  TOCA.FrameSetsSlot["FIRE"]:SetBackdrop(totemIcon)

  local totemIconKey = multiKeyFromValue(TOCA.totems.WATER, TOCASlotFour, 1)
  local totemIcon = {
    bgFile  = "interface/icons/" .. TOCA.totems.WATER[totemIconKey][2],
    edgeFile= "Interface/ToolTips/UI-Tooltip-Border",
    edgeSize= 12,
    insets  = {left=2, right=2, top=2, bottom=2},
  }
  TOCA.Slot["WATER"]:SetBackdrop(totemIcon)
  TOCA.FrameSetsSlot["WATER"]:SetBackdrop(totemIcon)
end

TOCA.SlotSelectTotemDisabled={}
TOCA.FrameSetsSlotDisabled={}
TOCA.SlotGrid={}
TOCA.SlotGrid.VerticalTotemButton={}
TOCA.SlotGrid.HorizontalTotemButton={}
for totemCat,v in pairsByKeys(TOCA.totems) do
  TOCA.SlotSelectTotemDisabled[totemCat]={}
  TOCA.FrameSetsSlotDisabled[totemCat]={}
  TOCA.SlotGrid.VerticalTotemButton[totemCat]={}
  TOCA.SlotGrid.HorizontalTotemButton[totemCat]={}
end

function TOCA.EnableKnownTotems()
  if (TOCA.isInCombat) then
    TOCA.Notification("In Combat, do nothing!", true)
  else
    for totemCat,v in pairsByKeys(TOCA.totems) do
      for i,totemSpell in pairs(TOCA.totems[totemCat]) do
        TOCA.SlotSelectTotemDisabled[totemCat][i]:Show()
        TOCA.FrameSetsSlotDisabled[totemCat][i]:Show()
        TOCA.SlotGrid.VerticalTotemButton[totemCat][i]:Hide()
        TOCA.SlotGrid.HorizontalTotemButton[totemCat][i]:Hide()
        local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(totemSpell[1])
        if (name) then
          TOCA.SlotSelectTotemDisabled[totemCat][i]:Hide()
          TOCA.FrameSetsSlotDisabled[totemCat][i]:Hide()
          TOCA.SlotGrid.VerticalTotemButton[totemCat][i]:Show()
          TOCA.SlotGrid.HorizontalTotemButton[totemCat][i]:Show()
        end
      end
    end
    TOCA.Notification("TOCA.EnableKnownTotems()", true)
  end
end

function TOCA.FrameStyleDefault()
  TOCA.FrameMain:SetHeight(TOCA.Global.height)
  TOCA.FrameMain:SetWidth(TOCA.Global.width)
  TOCA.FrameMain.Background:SetWidth(TOCA.Global.width)
  TOCA.FrameMain.Background:SetHeight(TOCA.Global.height)
  TOCA.Button.TotemicCall:SetPoint("CENTER", 0, 40)
end
function TOCA.FrameStyleSet(style)
  if (style == TOCA.Dropdown.FrameStyles[1]) then --classic
    TOCA.FrameStyleDefault()
    TOCA.FrameMain.ReincFrame:SetPoint("TOPLEFT", TOCA.Global.width-4, -14)
    for totemCat,v in pairsByKeys(TOCA.totems) do
      TOCA.Slot[totemCat]:Show()
      TOCA.Button.DropdownMain:Show()
      TOCA.FrameMainGridVertical:Hide()
      TOCA.FrameMainGridHorizontal:Hide()
    end
  elseif (style == TOCA.Dropdown.FrameStyles[2]) then --vert
    TOCA.FrameStyleDefault()
    TOCA.FrameMain.ReincFrame:SetPoint("TOPLEFT", TOCA.Global.width-4, -14)
    TOCA.FrameMain:SetHeight(TOCA.Global.height+240)
    TOCA.FrameMain.Background:SetHeight(TOCA.Global.height+240)
    TOCA.Button.TotemicCall:SetPoint("CENTER", 0, 160)
    for totemCat,v in pairsByKeys(TOCA.totems) do
      TOCA.Slot[totemCat]:Hide()
      TOCA.Button.DropdownMain:Hide()
      TOCA.FrameMainGridVertical:Show()
      TOCA.FrameMainGridHorizontal:Hide()
    end
  elseif (style == TOCA.Dropdown.FrameStyles[3]) then --horz
    TOCA.FrameStyleDefault()
    TOCA.FrameMain.ReincFrame:SetPoint("TOPLEFT", TOCA.Global.width+171, -22)
    TOCA.FrameMain:SetHeight(TOCA.Global.height+84)
    TOCA.FrameMain.Background:SetHeight(TOCA.Global.height+84)
    TOCA.FrameMain:SetWidth(TOCA.Global.height+240)
    TOCA.FrameMain.Background:SetWidth(TOCA.Global.height+240)
    TOCA.Button.TotemicCall:SetPoint("CENTER", 0, 84)
    for totemCat,v in pairsByKeys(TOCA.totems) do
      TOCA.Slot[totemCat]:Hide()
      TOCA.Button.DropdownMain:Hide()
      TOCA.FrameMainGridVertical:Hide()
      TOCA.FrameMainGridHorizontal:Show()
    end
  end
  TOCA.Notification("Frame Style: " .. style, true)
end

function TOCA.Init()
  local lC, eC, cI = UnitClass("player")
  TOCA.FrameMain:Hide()
  if (eC == "SHAMAN") then
    TOCA.FrameMain:Show()
  else
    TOCA.FrameHelp:Hide()
  end
  if (TOCADB == nil) then
    TOCADB = {}
  end

  if (TOCADB[TOCA.player.combine] == nil) then
    TOCADB[TOCA.player.combine] = {}
    if (TOCADB[TOCA.player.combine]["CONFIG"] == nil) then
      TOCADB[TOCA.player.combine]["CONFIG"] = {}
    end
    if (TOCADB[TOCA.player.combine]["PROFILES"] == nil) then
      TOCADB[TOCA.player.combine]["PROFILES"] = {}
    end
    if (TOCADB[TOCA.player.combine]["LASTSAVED"] == nil) then
      TOCADB[TOCA.player.combine]["LASTSAVED"] = TOCA.Dropdown.Menu[1]
    end
    if (TOCADB[TOCA.player.combine]["DISABLED"] == nil) then
      TOCADB[TOCA.player.combine]["DISABLED"] = "NO"
    end
    if (TOCADB[TOCA.player.combine]["HELP"] == nil) then
      TOCADB[TOCA.player.combine]["HELP"] = "YES"
    end
    TOCA.Notification("Building Profile: " .. TOCA.player.combine)
    TOCADB[TOCA.player.combine]["PROFILES"][TOCA.Dropdown.Menu[1]] = {TOCA_AIR=TOCASlotOne, TOCA_EARTH=TOCASlotTwo, TOCA_FIRE=TOCASlotThree, TOCA_WATER=TOCASlotFour}
    TOCA.UpdateTotemSet()
  else
    TOCA.Notification("Loading Profile: " .. TOCA.player.combine)
    if (TOCADB[TOCA.player.combine]["DISABLED"] == "YES") then
      TOCA.FrameMain:Hide()
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["SCALE"]) then
      TOCA.Slider.Scale:SetValue(TOCADB[TOCA.player.combine]["CONFIG"]["SCALE"])
      TOCA.Slider.Scale.Val:SetText(TOCADB[TOCA.player.combine]["CONFIG"]["SCALE"])
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["MAINMENU"] == "OFF") then
      TOCA.FrameMain.Background:SetBackdrop(TOCA.Backdrop.General)
      TOCA.Button.CloseMain:Hide()
      TOCA.Button.Options:Hide()
      TOCA.Checkbox.MainMenu:SetChecked(nil)
      TOCA.FrameMain.Background:SetPoint("CENTER", 0, 0)
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["ENDCAPS"] == "OFF") then
      TOCA.Button.TotemicCall.ECL:Hide()
      TOCA.Button.TotemicCall.ECR:Hide()
      TOCA.Checkbox.EndCaps:SetChecked(nil)
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["TIMERS"] == "OFF") then
      for i=1, 4 do
        TOCA.Slot.Timer[i]:Hide()
        TOCA.SlotGrid.VerticalTimer[i]:Hide()
        TOCA.SlotGrid.HorizontalTimer[i]:Hide()
      end
      TOCA.Checkbox.Timers:SetChecked(nil)
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["TIMERSMINUTES"] == "OFF") then
      TOCA.globalTimerInMinutes = false
      TOCA.Checkbox.TimersInMinutes:SetChecked(nil)
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["REINC"] == "OFF") then
      TOCA.FrameMain.ReincFrame:Hide()
      TOCA.Checkbox.Reinc:SetChecked(nil)
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["TOTEMORDER"]) then
      TOCA.SetTotemOrderDropdown()
      TOCA.SetTotemOrder()
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["OPACITY"]) then
      TOCA.Slider.Opacity:SetValue(TOCADB[TOCA.player.combine]["CONFIG"]["OPACITY"])
      TOCA.Slider.Opacity.Val:SetText(TOCADB[TOCA.player.combine]["CONFIG"]["OPACITY"])
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["FRAMESTYLE"]) then
      TOCA.FrameStyleSet(TOCADB[TOCA.player.combine]["CONFIG"]["FRAMESTYLE"])
      TOCA.Dropdown.FrameStyle.text:SetText(TOCADB[TOCA.player.combine]["CONFIG"]["FRAMESTYLE"])
    else
      TOCA.FrameStyleSet(TOCA.Dropdown.FrameStyles[1])
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["FRAMELEVEL"]) then
      TOCA.FrameMain:SetFrameStrata(TOCADB[TOCA.player.combine]["CONFIG"]["FRAMELEVEL"])
      TOCA.Dropdown.FrameStrat.text:SetText(TOCADB[TOCA.player.combine]["CONFIG"]["FRAMELEVEL"])
    end
    if (TOCADB[TOCA.player.combine]["LASTSAVED"]) then
      TOCA.SetDDMenu(TOCA.Dropdown.Main, TOCADB[TOCA.player.combine]["LASTSAVED"])
      TOCA.FrameSetsProfile:SetText(TOCADB[TOCA.player.combine]["LASTSAVED"])
    end
    if (TOCADB[TOCA.player.combine]["HELP"] == TOCA.Global.version) then
      TOCA.FrameHelp:Hide()
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["MAINPOS"]) then
      local TOCAFrameMainPos = {}
      TOCAFrameMainPos = split(TOCADB[TOCA.player.combine]["CONFIG"]["MAINPOS"], ",")
      TOCA.FrameMain:ClearAllPoints()
      TOCA.FrameMain:SetPoint(TOCAFrameMainPos[1], tonumber(TOCAFrameMainPos[2]), tonumber(TOCAFrameMainPos[3]))
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["EXPLODEPOS"]) then
      local TOCAFrameExplodePos = {}
      TOCAFrameExplodePos = split(TOCADB[TOCA.player.combine]["CONFIG"]["EXPLODEPOS"], ",")
      TOCA.FrameExplode:ClearAllPoints()
      TOCA.FrameExplode:SetPoint(TOCAFrameExplodePos[1], tonumber(TOCAFrameExplodePos[2]), tonumber(TOCAFrameExplodePos[3]))
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["TOOLON"] == "OFF") then
      TOCA.Checkbox.Tooltip:SetChecked(nil)
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["COMBATLOCK"] == "OFF") then
      TOCA.Checkbox.MainLock:SetChecked(nil)
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["ENDCAPSTYLE"] == "Lions") then
      TOCA.Dropdown.FrameGryphons.text:SetText(TOCADB[TOCA.player.combine]["CONFIG"]["ENDCAPSTYLE"])
      TOCA.Button.TotemicCall.ECL:SetTexture("Interface/MainMenuBar/UI-MainMenuBar-EndCap-Human")
      TOCA.Button.TotemicCall.ECR:SetTexture("Interface/MainMenuBar/UI-MainMenuBar-EndCap-Human")
    end
    if (TOCADB[TOCA.player.combine]["CONFIG"]["TOOLPOS"]) then
      local TOCAFrameToolPos = {}
      TOCAFrameToolPos = split(TOCADB[TOCA.player.combine]["CONFIG"]["TOOLPOS"], ",")
      TOCA.Tooltip:ClearAllPoints()
      TOCA.Tooltip:SetPoint(TOCAFrameToolPos[1], tonumber(TOCAFrameToolPos[2]), tonumber(TOCAFrameToolPos[3]))
    end
    TOCA.UpdateTotemSet()
    TOCA.UpdateDDMenu(TOCA.Dropdown.Main)
    TOCA.UpdateDDMenu(TOCA.Dropdown.Sets)
  end

  TOCA.FrameOptionsMain.name = TOCA.Global.title
  InterfaceOptions_AddCategory(TOCA.FrameOptionsMain)
  TOCA.Notification("TOCA.Init()", true)
end

function TOCA.SetDDMenu(DDFrame, value)
  if (TOCADB[TOCA.player.combine]["PROFILES"][value]) then
    for k,v in pairs(TOCADB[TOCA.player.combine]["PROFILES"][value]) do
      --TOCA.Notification("debug profile " .. k, true)
      if (k == "TOCA_AIR") then
        TOCASlotOne = v
        if (TOCA.isInCombat) then
          TOCA.Notification("In Combat, do nothing!", true)
        else
          TOCA.Totem["AIR"]:SetAttribute("spell", v)
          TOCA.SetKeyBindReset("TOTEM_AIR", v)
        end
      end
      if (k == "TOCA_EARTH") then
        TOCASlotTwo = v
        if (TOCA.isInCombat) then
          TOCA.Notification("In Combat, do nothing!", true)
        else
          TOCA.Totem["EARTH"]:SetAttribute("spell", v)
          TOCA.SetKeyBindReset("TOTEM_EARTH", v)
        end
      end
      if (k == "TOCA_FIRE") then
        TOCASlotThree = v
        if (TOCA.isInCombat) then
          TOCA.Notification("In Combat, do nothing!", true)
        else
          TOCA.Totem["FIRE"]:SetAttribute("spell", v)
          TOCA.SetKeyBindReset("TOTEM_FIRE", v)
        end
      end
      if (k == "TOCA_WATER") then
        TOCASlotFour = v
        if (TOCA.isInCombat) then
          TOCA.Notification("In Combat, do nothing!", true)
        else
          TOCA.Totem["WATER"]:SetAttribute("spell", v)
          TOCA.SetKeyBindReset("TOTEM_WATER", v)
        end
      end
    end
  end
  --just update both
  TOCA.Dropdown.Main.text:SetText(value)
  TOCA.Dropdown.Sets.text:SetText(value)
  TOCADB[TOCA.player.combine]["LASTSAVED"] = value
  TOCA.UpdateTotemSet()
  TOCA.Notification("TOCA.SetDDMenu(...)", true)
end

function TOCA.UpdateDDMenu(DDFrame, value)
  local DDArray = {TOCA.Dropdown.Menu[1]}
  for k,v in pairs(TOCADB[TOCA.player.combine]["PROFILES"]) do
    if (k ~= TOCA.Dropdown.Menu[1]) then
      table.insert(DDArray, k)
    end
  end
  DDFrame.initialize = function(self, level)
    local info = UIDropDownMenu_CreateInfo()
    local i = 0
    for k,v in pairs(DDArray) do
      info.notCheckable = 1
      info.padding = 2
      info.text = v
      info.value= v
      info.fontObject = GameFontWhite
      info.justifyH = "LEFT"
      info.disabled = false
      info.func = self.onClick
      UIDropDownMenu_AddButton(info, level)
    end
  end
  if (value) then
    TOCA.Dropdown.Main.text:SetText(value)
    TOCA.Dropdown.Sets.text:SetText(value)
  end
end

function TOCA.CloseAllMenus()
  for k,v in pairs(TOCA.totems) do
    TOCA.SlotSelectMenu[k]:Hide()
    TOCA.FrameSetsSlotSelectMenu[k]:Hide()
  end
  TOCA.Tooltip:Hide()
end

local TooltipMaxHeight = 82
TOCA.Tooltip = CreateFrame("frame", "TOCA.Tooltip", UIParent, "BackdropTemplate")
TOCA.Tooltip:SetWidth(250)
TOCA.Tooltip:SetHeight(TooltipMaxHeight)
TOCA.Tooltip:SetFrameStrata("TOOLTIP")
TOCA.Tooltip:SetBackdrop(TOCA.Backdrop.General)
TOCA.Tooltip:SetBackdropColor(0, 0, 1, 1)
TOCA.Tooltip:SetBackdropBorderColor(1, 1, 1, 1)
TOCA.Tooltip:SetPoint("BOTTOMRIGHT", -160, 150)
TOCA.Tooltip:SetMovable(true)
TOCA.Tooltip:EnableMouse(true)
TOCA.Tooltip:RegisterForDrag("LeftButton")
TOCA.Tooltip:SetScript("OnDragStart", function()
  TOCA.Tooltip:StartMoving()
end)
TOCA.Tooltip:SetScript("OnDragStop", function()
  TOCA.Tooltip:StopMovingOrSizing()
  local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.Tooltip:GetPoint()
  TOCADB[TOCA.player.combine]["CONFIG"]["TOOLPOS"] = point .. "," .. xOfs .. "," .. yOfs
end)
TOCA.Tooltip.title = TOCA.Tooltip:CreateFontString(nil, "ARTWORK")
TOCA.Tooltip.title:SetFont(TOCA.Global.font, 14)
TOCA.Tooltip.title:SetPoint("TOPLEFT", 10, -10)
TOCA.Tooltip.title:SetText("")
TOCA.Tooltip.cost = TOCA.Tooltip:CreateFontString(nil, "ARTWORK")
TOCA.Tooltip.cost:SetFont(TOCA.Global.font, 12)
TOCA.Tooltip.cost:SetPoint("TOPLEFT", 10, -30)
TOCA.Tooltip.cost:SetText("")
TOCA.Tooltip.tools = TOCA.Tooltip:CreateFontString(nil, "ARTWORK")
TOCA.Tooltip.tools:SetFont(TOCA.Global.font, 12)
TOCA.Tooltip.tools:SetPoint("TOPLEFT", 12, -45)
TOCA.Tooltip.tools:SetText("")
TOCA.Tooltip.text = TOCA.Tooltip:CreateFontString(nil, "ARTWORK")
TOCA.Tooltip.text:SetFont(TOCA.Global.font, 12)
TOCA.Tooltip.text:SetNonSpaceWrap(1)
TOCA.Tooltip.text:SetPoint("TOPLEFT", 12, -60)
TOCA.Tooltip.text:SetText("")
TOCA.Tooltip.text:SetTextColor(1, 1, 0.2, 1)
TOCA.Tooltip:Hide()

local function adjustTooltipHeight(s, x, indent)
  x = x or 79
  indent = indent or ""
  local t = {""}
  if (s) then
    local function cleanse(s) return s:gsub("@x%d%d%d",""):gsub("@r","") end
    for prefix, word, suffix, newline in s:gmatch("([ \t]*)(%S*)([ \t]*)(\n?)") do
      if (#t >= 2) then
        TOCA.Tooltip:SetHeight(TooltipMaxHeight + (10 * #t))
      end
      if #(cleanse(t[#t])) + #prefix + #cleanse(word) > x and #t > 0 then
        table.insert(t, word..suffix)
      else
        t[#t] = t[#t]..prefix..word..suffix
      end
      if #newline > 0 then
        table.insert(t, "")
      end
    end
    return indent..table.concat(t, "\n"..indent)
  end
end

function TOCA.TooltipDisplay(spell, tools, msgtooltip)
  local spellName, spellSubName, spellID = GetSpellBookItemName(spell)
  TOCA.Tooltip:SetWidth(250)
  if (spellID) then
    local spellDesc = GetSpellDescription(spellID)
    local spellPower= GetSpellPowerCost(spellID)
    local spellCost = 0
    for k,powerInfo in pairs(spellPower) do
      spellCost = powerInfo.cost
    end
    TOCA.Tooltip:SetHeight(TooltipMaxHeight)
    TOCA.Tooltip.title:SetText(spell)
    TOCA.Tooltip.cost:SetText("")
    if (spellCost) then
      TOCA.Tooltip.cost:SetText(spellCost .. " Mana")
    end
    local toolsMsg = tools.lower(tools)
    toolsMsg = firstToUpper(toolsMsg)
    TOCA.Tooltip.tools:SetText("Tools: " .. toolsMsg .. " Totem")
    if (tools == "") then
      TOCA.Tooltip.tools:SetText("")
    end
    TOCA.Tooltip.text:SetText(adjustTooltipHeight(spellDesc, 34))
  else
    TOCA.Tooltip.title:SetText(spell)
    TOCA.Tooltip.cost:SetText("")
    TOCA.Tooltip.tools:SetText("")
    if (msgtooltip) then
      TOCA.Tooltip.text:SetText(adjustTooltipHeight(msgtooltip, 34))
    else
      TOCA.Tooltip.text:SetText("Spell not learned.")
    end
  end

  if (TOCADB[TOCA.player.combine]["CONFIG"]["TOOLON"] == "OFF") then
    TOCA.Tooltip:Hide()
  else
    TOCA.Tooltip:Show()
  end
end

function TOCA.TooltipMenu(title, msgtooltip, height)
  TOCA.Tooltip:Show()
  TOCA.Tooltip.title:SetText(title)
  TOCA.Tooltip.cost:SetText("")
  TOCA.Tooltip.tools:SetText("")
  TOCA.Tooltip.text:SetText(msgtooltip)
  TOCA.Tooltip:SetWidth(360)
  TOCA.Tooltip:SetHeight(height)
end

--TOCA.HasTotemOut = 0
TOCA.TotemPresent={}
TOCA.TotemName={}
TOCA.TotemStartTime={}
TOCA.TotemDuration={}
TOCA.TotemFunc={}
TOCA.TotemTimer={}

for i=1, 4 do
  TOCA.TotemTimer[i] = 0
  TOCA.TotemDuration[i] = 0
end

function TOCA.TimerFrame(i)
  TOCA.TotemPresent[i], TOCA.TotemName[i], TOCA.TotemStartTime[i], TOCA.TotemDuration[i] = GetTotemInfo(i)
  if (TOCA.TotemPresent[i]) then
    TOCA.TotemTimer[i] = TOCA.TotemTimer[i] -1
    if (TOCA.globalTimerInMinutes) then
      TOCA.Slot.Timer[i]:SetText(TimeSecondsToMinutes(TOCA.TotemTimer[i]))
      TOCA.SlotGrid.VerticalTimer[i]:SetText(TimeSecondsToMinutes(TOCA.TotemTimer[i]))
      TOCA.SlotGrid.HorizontalTimer[i]:SetText(TimeSecondsToMinutes(TOCA.TotemTimer[i]))
    else
      TOCA.Slot.Timer[i]:SetText(TOCA.TotemTimer[i])
      TOCA.SlotGrid.VerticalTimer[i]:SetText(TOCA.TotemTimer[i])
      TOCA.SlotGrid.HorizontalTimer[i]:SetText(TOCA.TotemTimer[i])
    end
  else
    TOCA.Slot.Timer[i]:SetText("")
    TOCA.SlotGrid.VerticalTimer[i]:SetText("")
    TOCA.SlotGrid.HorizontalTimer[i]:SetText("")
  end

  if (TOCADB[TOCA.player.combine]["CONFIG"]["TIMERS"] == "OFF") then
    for i=1, 4 do --hide all
      TOCA.Slot.Timer[i]:Hide()
      TOCA.SlotGrid.VerticalTimer[i]:Hide()
      TOCA.SlotGrid.HorizontalTimer[i]:Hide()
    end
    return
  end

  if (TOCADB[TOCA.player.combine]["CONFIG"]["FRAMESTYLE"] == TOCA.Dropdown.FrameStyles[1]) then --classic
    for i=1, 4 do
      TOCA.Slot.Timer[i]:Show()
      TOCA.SlotGrid.VerticalTimer[i]:Hide()
      TOCA.SlotGrid.HorizontalTimer[i]:Hide()
    end
  end

  if (TOCADB[TOCA.player.combine]["CONFIG"]["FRAMESTYLE"] == TOCA.Dropdown.FrameStyles[2]) then --vert
    for i=1, 4 do
      TOCA.Slot.Timer[i]:Hide()
      TOCA.SlotGrid.VerticalTimer[i]:Show()
      TOCA.SlotGrid.HorizontalTimer[i]:Hide()
    end
  end

  if (TOCADB[TOCA.player.combine]["CONFIG"]["FRAMESTYLE"] == TOCA.Dropdown.FrameStyles[3]) then --horz
    for i=1, 4 do
      TOCA.Slot.Timer[i]:Hide()
      TOCA.SlotGrid.VerticalTimer[i]:Hide()
      TOCA.SlotGrid.HorizontalTimer[i]:Show()
    end
  end
end

--build timers
for i=1, 4 do
  TOCA.TotemFunc[i] = 0
  TOCA.TotemFunc[i] = C_Timer.NewTicker(0, function() TOCA.TimerFrame(i) end, 0)
  TOCA.TotemFunc[i]:Cancel()
end

function TOCA.TotemBarTimerStart()
  for i=1, 4 do
    TOCA.TotemPresent[i], TOCA.TotemName[i], TOCA.TotemStartTime[i], TOCA.TotemDuration[i] = GetTotemInfo(i)
    if (TOCA.TotemTimer[i] <= 0) then
      TOCA.TotemFunc[i] = C_Timer.NewTicker(1, function() TOCA.TimerFrame(i) end, TOCA.TotemDuration[i])
      TOCA.TotemTimer[i] = TOCA.TotemDuration[i]
    end
  end
end

function TOCA.GetReincTimer() --always checking
  local lC, eC, cI = UnitClass("player")
  if (eC == "SHAMAN") then
    local numTabs = GetNumTalentTabs()
    local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo("Reincarnation")
    if (name) then
      local start, duration, enabled = GetSpellCooldown(name)
      if (duration) then
        if (enabled == 0) then
          --DEFAULT_CHAT_FRAME:AddMessage(name.." is currently active, use it and wait " .. duration .. " seconds for the next one.")
        elseif (start > 0 and duration > 0) then
          local reincTimeLeftCalc = start + duration - GetTime()
          local reincTimeLeftRT = reincTimeLeftCalc / 60
          TOCA.ReincTimer = math.ceil(reincTimeLeftCalc / 60)
          TOCA.Notification(name.." is cooling down, wait " .. TOCA.ReincTimer, true)
          TOCA.FrameMain.ReincFrame.text:SetText(TOCA.ReincTimer.."m")
          TOCA.FrameMain.ReincFrame:Show()
        else
          TOCA.FrameMain.ReincFrame:Hide()
          --TOCA.Notification(name.." is ready.", true)
        end
      end
    end
  end
end

TOCA.SlotGrid.VerticalTimer={}
TOCA.SlotGrid.HorizontalTimer={}
function TOCA.TotemTimerReset(i)
  if (i == "all") then
    for i=1, 4 do
      TOCA.TotemFunc[i]:Cancel()
      TOCA.TotemTimer[i] = 0
      TOCA.Slot.Timer[i]:SetText("")
      TOCA.SlotGrid.VerticalTimer[i]:SetText("")
      TOCA.SlotGrid.HorizontalTimer[i]:SetText("")
    end
  else
    TOCA.TotemFunc[i]:Cancel()
    TOCA.TotemTimer[i] = 0
    TOCA.Slot.Timer[i]:SetText("")
    TOCA.SlotGrid.VerticalTimer[i]:SetText("")
    TOCA.SlotGrid.HorizontalTimer[i]:SetText("")
  end
  TOCA.Notification("TOCA.TotemTimerReset("..i..")", true)
end

function TOCA.TotemTimerResetBySpell(spellID)
  local spell = GetSpellInfo(spellID)
  local totemCatSpell={}
  if (spell) then
    totemCatSpell.fire = multiKeyFromValue(TOCA.totems.FIRE, spell, 1)
    if (totemCatSpell.fire) then
      TOCA.TotemTimerReset(1)
    end
    totemCatSpell.earth = multiKeyFromValue(TOCA.totems.EARTH, spell, 1)
    if (totemCatSpell.earth) then
      TOCA.TotemTimerReset(2)
    end
    totemCatSpell.water = multiKeyFromValue(TOCA.totems.WATER, spell, 1)
    if (totemCatSpell.water) then
      TOCA.TotemTimerReset(3)
    end
    totemCatSpell.air = multiKeyFromValue(TOCA.totems.AIR, spell, 1)
    if (totemCatSpell.air) then
      TOCA.TotemTimerReset(4)
    end
  end
end

function TOCA.TotemBarUpdate()
  --local playerPos = GetUnitSpeed("player")
  local percMana = (UnitPower("player")/UnitPowerMax("player"))*100
  local percMana = floor(percMana+0.5)
  --TOCA.Notification("mana: " .. percMana, true)
  TOCA.Button.TotemicCall.flash:Hide()
  for totemCat,v in pairsByKeys(TOCA.totems) do
    TOCA.Slot.deactive[totemCat]:Hide()
    if (percMana <= 1) then
      TOCA.Slot.deactive[totemCat]:Show()
    end
  end

  for i=1, 4 do
    TOCA.TotemPresent[i], TOCA.TotemName[i], TOCA.TotemStartTime[i], TOCA.TotemDuration[i] = GetTotemInfo(i)
    if (TOCA.TotemPresent[i]) then
      TOCA.Button.TotemicCall.flash:Show()
    end
  end

  --TOCA.EnableKnownTotems()
  TOCA.GetReincTimer()
end

function TOCA.Combat(event)
  for totemCat,v in pairsByKeys(TOCA.totems) do
    if (event == "PLAYER_REGEN_DISABLED") then
      TOCA.isInCombat = true
      TOCA.SlotSelect[totemCat]:Hide()
      TOCA.Button.DropdownMain:Hide()
      TOCA.Button.Options:Hide()
      if (TOCADB[TOCA.player.combine]["CONFIG"]["COMBATLOCK"] == "OFF") then
        TOCA.FrameMain:SetMovable(true)
        TOCA.FrameMain:EnableMouse(true)
      else
        TOCA.FrameMain:SetMovable(false)
        TOCA.FrameMain:EnableMouse(false)
      end
      TOCA.Notification("Combat Initiated", true)
    end
    if (event == "PLAYER_REGEN_ENABLED") then
      TOCA.isInCombat = false
      TOCA.SlotSelect[totemCat]:Show()
      TOCA.Button.DropdownMain:Show()
      if (TOCADB[TOCA.player.combine]["CONFIG"]["FRAMESTYLE"]) then
        TOCA.FrameStyleSet(TOCADB[TOCA.player.combine]["CONFIG"]["FRAMESTYLE"])
      end
      TOCA.FrameMain:SetMovable(true)
      TOCA.FrameMain:EnableMouse(true)
      if (TOCADB[TOCA.player.combine]["CONFIG"]["MAINMENU"] == "OFF") then
        TOCA.Button.CloseMain:Hide()
        TOCA.Button.Options:Hide()
      else
        TOCA.Button.Options:Show()
        TOCA.Button.CloseMain:Show()
      end
      TOCA.Notification("Combat Ended", true)
    end
  end
end

function TOCA.SendPacket(packet, filtered, rec)
  filteredPacket = nil
  local msg_to = "GUILD"
  if (rec) then
    msg_to = rec
  end
  if (filtered) then
    filteredPacket = packet:gsub("%s+", "") --filter spaces
  else
    filteredPacket = packet
  end
  if (IsInGuild()) then
    C_ChatInfo.SendAddonMessage(TOCA.Global.prefix, filteredPacket, msg_to)
    TOCA.Notification("sending packet " .. filteredPacket, true)
  end
end

function TOCA.ParsePacket(netpacket, code)
  if (netpacket) then
    if (string.sub(netpacket, 1, strlen(code)) == code) then
      parse = string.gsub(netpacket, code, "")
      return parse
    end
  end
end

function TOCA.GetTotemOrder()
  local buildOrder = ""
  for k, v in ipairs(TOCADB[TOCA.player.combine]["CONFIG"]["TOTEMORDER"]) do
    buildOrder = buildOrder .. v
  end
  return buildOrder
end

local totemNum = 0
local totemButtonPos_X={}
local totemButtonPos_Y={}
function TOCA.SetTotemOrder()
  local buildOrder = TOCA.GetTotemOrder()
  local totemOrder = split(buildOrder, ",")
  for k,v in ipairs(totemOrder) do
    TOCA.Slot[v]:SetPoint("TOPLEFT", -15+TOCA.SlotPosX[k], -35) --main frame
    TOCA.FrameSetsSlot[v]:SetPoint("TOPLEFT", -60+TOCA.SlotSetsPosX[k], -70) --options frame

    for totemCat,notUsed in pairsByKeys(TOCA.totems) do
      totemNum = totemNum +1
      totemButtonPos_Y[totemCat] = 0
      totemButtonPos_X[totemCat] = 0
      for i,totemSpell in pairs(TOCA.totems[totemCat]) do
        totemButtonPos_Y[totemCat] = totemButtonPos_Y[totemCat]+TOCA.Slot_h
        totemButtonPos_X[totemCat] = totemButtonPos_X[totemCat]+TOCA.Slot_w
        local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.SlotGrid.VerticalTotemButton[totemCat][i]:GetPoint()
        if (TOCA.SlotGrid.VerticalTotemButton[v][i]) then
          TOCA.SlotGrid.VerticalTotemButton[v][i]:SetPoint("TOPLEFT", -15+TOCA.SlotPosX[k], yOfs)
          if (TOCA.totems.AIR[1][1] == totemSpell[1]) then
            local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.SlotGrid.VerticalTotemButton.AIR[1]:GetPoint()
            TOCA.SlotGrid.VerticalTimer[4]:SetPoint("TOPLEFT", xOfs, -26)
          end
          if (TOCA.totems.EARTH[1][1] == totemSpell[1]) then
            local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.SlotGrid.VerticalTotemButton.EARTH[1]:GetPoint()
            TOCA.SlotGrid.VerticalTimer[2]:SetPoint("TOPLEFT", xOfs, -26)
          end
          if (TOCA.totems.FIRE[1][1] == totemSpell[1]) then
            local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.SlotGrid.VerticalTotemButton.FIRE[1]:GetPoint()
            TOCA.SlotGrid.VerticalTimer[1]:SetPoint("TOPLEFT", xOfs, -26)
          end
          if (TOCA.totems.WATER[1][1] == totemSpell[1]) then
            local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.SlotGrid.VerticalTotemButton.WATER[1]:GetPoint()
            TOCA.SlotGrid.VerticalTimer[3]:SetPoint("TOPLEFT", xOfs, -26)
          end
        end
      end
      for i,totemSpell in pairs(TOCA.totems[totemCat]) do
        totemButtonPos_Y[totemCat] = totemButtonPos_Y[totemCat]+TOCA.Slot_h
        totemButtonPos_X[totemCat] = totemButtonPos_X[totemCat]+TOCA.Slot_w
        local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.SlotGrid.HorizontalTotemButton[totemCat][i]:GetPoint()
        if (TOCA.SlotGrid.HorizontalTotemButton[v][i]) then
          TOCA.SlotGrid.HorizontalTotemButton[v][i]:SetPoint("TOPLEFT", xOfs, -TOCA.SlotPosX[k]-4)
          if (TOCA.totems.AIR[1][1] == totemSpell[1]) then
            local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.SlotGrid.HorizontalTotemButton.AIR[1]:GetPoint()
            TOCA.SlotGrid.HorizontalTimer[4]:SetPoint("TOPLEFT", 5, yOfs-12)
          end
          if (TOCA.totems.EARTH[1][1] == totemSpell[1]) then
            local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.SlotGrid.HorizontalTotemButton.EARTH[1]:GetPoint()
            TOCA.SlotGrid.HorizontalTimer[2]:SetPoint("TOPLEFT", 5, yOfs-12)
          end
          if (TOCA.totems.FIRE[1][1] == totemSpell[1]) then
            local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.SlotGrid.HorizontalTotemButton.FIRE[1]:GetPoint()
            TOCA.SlotGrid.HorizontalTimer[1]:SetPoint("TOPLEFT", 5, yOfs-12)
          end
          if (TOCA.totems.WATER[1][1] == totemSpell[1]) then
            local point, relativeTo, relativePoint, xOfs, yOfs = TOCA.SlotGrid.HorizontalTotemButton.WATER[1]:GetPoint()
            TOCA.SlotGrid.HorizontalTimer[3]:SetPoint("TOPLEFT", 5, yOfs-12)
          end
        end
      end
    end
  end
  TOCA.Notification("TOCA.SetTotemOrder()", true)
  TOCA.Notification(buildOrder, true)
end

function TOCA.SetTotemOrderDropdown() --handled on Init() ONLY
  local buildOrder = TOCA.GetTotemOrder()
  local totemOrder = split(buildOrder, ",")
  for k,v in ipairs(totemOrder) do
    TOCA.Dropdown.OrderSet[k].text:SetText(v)
  end
end

TOCA.Dropdown.OrderSetMenu={"AIR", "EARTH", "FIRE", "WATER"}
function TOCA.BuildTotemOrder()
  local buildOrder = ""
  local totemOrder = ""
  for i=1, getn(TOCA.Dropdown.OrderSetMenu) do
    totemOrder = totemOrder .. TOCA.Dropdown.OrderSet[i].text:GetText() .. ","
  end
  buildOrder = totemOrder
  buildOrder = buildOrder:sub(1, -2)
  TOCADB[TOCA.player.combine]["CONFIG"]["TOTEMORDER"] = {buildOrder}
  TOCA.SetTotemOrder()
end

SLASH_TOCA1 = TCCMD
function SlashCmdList.TOCA(cmd)
  if ((cmd == nil) or (cmd == "")) then
    TOCA.Notification("v" .. TOCA.Global.version)
    print("Commands:")
    print("|cffffff00options:|r    Open Totem Caddy Options.")
    print("|cffffff00show:|r        Display Totem Caddy (regardless of class).")
    print("|cffffff00hide:|r         Close Totem Caddy.")
    print("|cffffff00profile:|r      Display the current saved profile.")
    print("|cffffff00help:|r         Display the help introduction.")
    print("|cffffff00debug on:|r Enable Debug Mode (Very Spammy)")
    print("|cffffff00debug off:|r Disable Debug Mode (/reload)")
  elseif ((cmd == "show") or (cmd == "open")) then
    TOCA.FrameMain:Show()
    TOCADB[TOCA.player.combine]["DISABLED"] = "NO"
  elseif (cmd == "hide") then
    TOCA.FrameMain:Hide()
  elseif (cmd == "sets") then
    TOCA.FrameSets:Show()
  elseif (cmd == "profile") then
    TOCA.Notification("|r Profile: " .. TOCA.player.combine)
  elseif ((cmd == "options") or (cmd == "config")) then
    TOCA.FrameOptions:Show()
  elseif (cmd == "help") then
    TOCA.FrameHelp:Show()
  elseif (cmd == "debug on") then
    TOCA.DEBUG = true
    TOCA.Notification("DEBUG ON")
  elseif (cmd == "debug off") then
    TOCA.DEBUG = false
    TOCA.Notification("DEBUG OFF")
  end
end
