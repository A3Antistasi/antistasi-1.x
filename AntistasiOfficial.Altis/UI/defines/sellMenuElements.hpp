class Default_RscShortcutButton {
  idc = -1;
  style   = ST_KEEP_ASPECT_RATIO;
  type  = CT_SHORTCUTBUTTON;
  x = 0.1;
  y = 0.1;
  w = 0.183825;
  h = "((((safezoneW / safezoneH) min 1.2) / 1.2) / 20)";
  default = 0;
  shadow = 1;
  deletable = 0;
  fade = 0;
  periodFocus = 1.2;
  periodOver = 0.8;
  period = 0.4;
  font = "PuristaMedium";
  size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
  sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
  text = "";
  textSecondary = "";
  action = "";

  class HitZone {
    left = 0;
    top = 0;
    right = 0;
    bottom = 0;
  };
  class ShortcutPos {
    left = 0;
    top = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 20) - (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2";
    w = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1) * (3/4)";
    h = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
  };
  class TextPos {
    left = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1) * (3/4)";
    top = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 20) - (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2";
    right = 0.005;
    bottom = 0;
  };
  shortcuts[] = {
  };
  textureNoShortcut = "#(argb,8,8,3)color(0,0,0,0)";
  color[] = {1,1,1,1};
  colorFocused[] = {1,1,1,1};
  color2[] = {0.95,0.95,0.95,1};
  colorDisabled[] = {1,1,1,0.25};
  colorBackground[] = {
    "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77])",
    "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51])",
    "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08])",
    1
  };
  colorBackgroundFocused[] = {
    "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77])",
    "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51])",
    "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08])",
    1
  };
  colorBackground2[] = {1,1,1,1};
  soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter", 0.09,1};
  soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
  soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
  soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
  class Attributes {
    font = "PuristaMedium";
    color = "#E5E5E5";
    align = "left";
    shadow = "true";
  };
  colorSecondary[] = {1,1,1,1};
  colorFocusedSecondary[] ={1,1,1,1};
  color2Secondary[] = {0.95,0.95,0.95,1};
  colorDisabledSecondary[] = {1,1,1,0.25};
  sizeExSecondary = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
  fontSecondary = "PuristaMedium";
  animTextureDefault = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
  animTextureNormal = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
  animTextureDisabled = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\normal_ca.paa";
  animTextureOver = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\over_ca.paa";
  animTextureFocused = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\focus_ca.paa";
  animTexturePressed = "\A3\ui_f\data\GUI\RscCommon\RscShortcutButton\down_ca.paa";

  class AttributesImage {
    font = MyTag_FONT_NORMAL;
    color = "#E5E5E5";
    align = "left";
  };
};

class Default_RscCombo {
  deletable = 0;
  fade = 0;
  access = 0;
  type  = CT_COMBO;
  style = "0x10 + 0x200";
  colorActive[] = {1,0,0,1};
  colorBackground[] = {0,0,0,1};
  colorDisabled[] = {1,1,1,0.25};
  colorPicture[] = {1,1,1,1};
  colorPictureDisabled[] = {1,1,1,0.25};
  colorPictureRight[] = {1,1,1,1};
  colorPictureRightDisabled[] = {1,1,1,0.25};
  colorPictureRightSelected[] = {1,1,1,1};
  colorPictureSelected[] = {1,1,1,1};
  colorScrollbar[] = {1,0,0,1};
  colorSelect2Right[] = {0,0,0,1};
  colorSelect[] = {0,0,0,1};
  colorSelectBackground[] = {1,1,1,0.7};
  colorSelectRight[] = {0,0,0,1};
  colorText[] = {1,1,1,1};
  colorTextRight[] = {1,1,1,1};
  soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1};
  soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1};
  soundCollapse[]={"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1};
  tooltipColorBox[] = {1,1,1,1};
  tooltipColorShade[] = {0,0,0,0.65};
  tooltipColorText[] = {1,1,1,1};
  maxHistoryDelay = 1;
  class ComboScrollBar {
    arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
    arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
    autoScrollDelay = 5;
    autoScrollEnabled = 0;
    autoScrollRewind = 0;
    autoScrollSpeed = -1;
    border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
    color[] = {1,1,1,1};
    colorActive[] = {1,1,1,1};
    colorDisabled[] = {1,1,1,0.3};
    height = 0;
    scrollSpeed = 0.06;
    shadow = 0;
    thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
    width = 0;
  };

  font = "PuristaMedium";
  sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
  shadow = 0;
  x = 0;
  y = 0;
  w = 0.12;
  h = 0.025;
  arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
  arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
  wholeHeight = 0.45;
};

class AS_FullCombo : Default_RscCombo {
  x = (UI_BASE_X + 0.2) * safezoneW + safezoneX;
  y = (UI_BASE_Y + 0.370) * safezoneH + safezoneY;
  w = 0.09 * safezoneW;
  h = 0.025 * safezoneH;
  maxHistoryDelay = 1000;
  autoScrollSpeed = 1000;
  onLBSelChanged = "_this spawn AS_fnc_UI_itemSelected";
  sizeEx = 0.03;
  colorBackground[] = {.3, .3, .3, 1};
  style = ST_MULTI + ST_SHADOW + ST_KEEP_ASPECT_RATIO + ST_FRAME;
};

class AS_MinusButton : Default_RscShortcutButton {
  x = (UI_BASE_X + 0.295) * safezoneW + safezoneX;
  y = (UI_BASE_Y + 0.370) * safezoneH + safezoneY;
  w = 0.015 * safezoneW;
  h = 0.025 * safezoneH;
  textureNoShortcut =  "textures\minus_ca.paa";
  onButtonClick = "_this spawn AS_fnc_UI_PressMinus; false";
  sizeEx = 0.03;
  type = CT_SHORTCUTBUTTON;
  style = ST_KEEP_ASPECT_RATIO;
  class ShortcutPos {
    left = 0.003;
    top = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 20) - (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2";
    w = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1) * (3/4)";
    h = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
  };
  color2[]={0,0,0,1};
  color[]={0,1,1,1};
  colorFocused[]={0,1,1,1};
};

class AS_PlusButton : AS_MinusButton {
  x = (UI_BASE_X + 0.325) * safezoneW + safezoneX;
  textureNoShortcut =  "textures\plus_ca.paa";
  onButtonClick = "_this spawn AS_fnc_UI_PressPlus; false";
};

class AS_FieldLabel : RscText {
  colorText[] = {0.961,0.478,0,1};
  style = ST_CENTER;
  x = (UI_BASE_X + 0.31) * safezoneW + safezoneX;
  y = (UI_BASE_Y + 0.370) * safezoneH + safezoneY;
  w = 0.015 * safezoneW;
  h = 0.025 * safezoneH;
  sizeEx = 0.03;
  text = "0";
};


#define SINGLECOMBO(NAME,FIRSTIDC,YPOS) \
class NAME##SINGLECOMBO : AS_FullCombo { \
  idc= FIRSTIDC;\
  y = YPOS; \
}; \

#define MULTICOMBO(NAME,FIRSTIDC,YPOS) \
class NAME##MULTICOMBO : AS_FullCombo { \
  idc= FIRSTIDC; \
  y = YPOS; }; \
class NAME##Minus : AS_MinusButton { \
  idc= FIRSTIDC+1; \
  y = YPOS; };\
class NAME##Count : AS_FieldLabel { \
  idc= FIRSTIDC+2; \
  y = YPOS; };\
class NAME##Plus : AS_PlusButton { \
  idc= FIRSTIDC+3; \
  y = YPOS; }; \

#define MULTICOMBO_INVIS(NAME,FIRSTIDC,YPOS) \
class NAME##MULTICOMBO_INVIS : AS_FullCombo { \
  idc= FIRSTIDC; \
  y = YPOS; \
  enable = false; \
  show = false; \
  onLBSelChanged = ""; \
}; \
class NAME##Minus : AS_MinusButton { \
  idc= FIRSTIDC+1; \
  y = YPOS; \
  enable = false; \
  show = false; \
}; \
class NAME##Count : AS_FieldLabel { \
  idc= FIRSTIDC+2; \
  y = YPOS; \
  enable = false; \
  show = false; \
}; \
class NAME##Plus : AS_PlusButton { \
  idc= FIRSTIDC+3; \
  y = YPOS; \
  enable = false; \
  show = false; \
}; \

#define SELL_NAV_BTN(BTN_IDC, BTNY, BTN_TEXT) \
class BTN_IDC##SELL_NAV_BTN : Menu_StartButton { \
  x = (UI_BASE_X + 0.12) * safezoneW + safezoneX; \
  w = 0.055 * safezoneW; \
  h = 0.025 * safezoneH; \
  sizeEx = 0.03; \
  colorText[] = MENU_TEXT_COLOR; \
  colorBackground[] = MENU_TCB_BG_COLOR; \
  colorBackgroundActive[] = MENU_TCB_BG_COLOR; \
  idc = BTN_IDC; \
  y = BTNY; \
  text = BTN_TEXT; \
  onMouseEnter = ""; \
  onMouseExit = ""; \
}; \
