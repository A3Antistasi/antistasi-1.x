#define UI_BASE_X (0.6) // default: 0.6
#define UI_BASE_Y (0.3) // default: 0.3

class StartMenu_TextCheckbox: RscTextCheckbox
{
  idc = -1;
  x = (UI_BASE_X + 0.12) * safezoneW + safezoneX;
  y = (UI_BASE_Y + 0.354) * safezoneH + safezoneY;
  w = 0.09 * safezoneW;
  h = 0.025 * safezoneH;
  colorText[] = MENU_TEXT_COLOR;
  colorSelectedBg[] = MENU_TCB_BG_COLOR;
  onMouseExit = "['STR_UI_SM_TEXTF_DEF'] call AS_fnc_UI_setTText;";
};

class Menu_Background : BOX {
  colorBackground[] = MENU_BG_COLOR;
  x = (UI_BASE_X + 0.1) * safezoneW + safezoneX;
  y = (UI_BASE_Y + 0.33) * safezoneH + safezoneY;
  w = 0.26 * safezoneW;
  h = 0.3 * safezoneH;
};

class Menu_Picture : ASA3_Picture {
  idc = -1;
  x = UI_BASE_X * safezoneW + safezoneX;
  y = UI_BASE_Y * safezoneH + safezoneY;
  w = 0.48 * safezoneW;
  h = 0.96 * safezoneH;

  text = MENU_IMG_DAY;
  moving = 1;
};

class Menu_TextField : RscStructuredText {
  idc = -1;
  x = (UI_BASE_X + 0.108) * safezoneW + safezoneX;
  y = (UI_BASE_Y + 0.563) * safezoneH + safezoneY;
  w = 0.246 * safezoneW;
  h = 0.055 * safezoneH;
  text = "";
  colorBackground[] = MENU_TCB_BG_COLOR;
};

class Menu_StartButton : RscButton {
  idc = -1;
  text = "Start Mission";
  x = (UI_BASE_X + 0.19) * safezoneW + safezoneX;
  y = (UI_BASE_Y + 0.519) * safezoneH + safezoneY;
  w = 0.08 * safezoneW;
  h = 0.03 * safezoneH;
  colorText[] = MENU_TEXT_COLOR;
  colorBackground[] = MENU_TCB_BG_COLOR;
  colorFocused[] = MENU_TCB_BG_COLOR;
  colorBackgroundActive[] = MENU_TCB_BG_COLOR;
  onMouseEnter = "(_this select 0) ctrlSetTextColor [1,0,0,1]";
  onMouseExit = "(_this select 0) ctrlSetTextColor [0.961,0.478,0,1]";
};

class Menu_StartText: RscText
{
  idc = -1;
  text = "Current Settings:"; //--- ToDo: Localize;
  x = (UI_BASE_X + 0.12) * safezoneW + safezoneX;
  y = (UI_BASE_Y + 0.343) * safezoneH + safezoneY;
  w = 0.09 * safezoneW;
  h = 0.025 * safezoneH;
  colorText[] = MENU_TEXT_COLOR_FALSE;
  sizeEx = 0.01925 / (getResolution select 5);
  class Attributes {
    align = "left";
    valign = "middle";
  };
  onMouseExit = "['STR_UI_SM_TEXTF_DEF'] call AS_fnc_UI_setTText;";
};

class Menu_Frame: RscFrame
{
  idc = -1;
  text = "";
  x = (UI_BASE_X + 0.15) * safezoneW + safezoneX;
  y = (UI_BASE_Y + 0.343) * safezoneH + safezoneY;
  w = 0.1 * safezoneW;
  h = 0.165 * safezoneH;
  colorBackground[] = MENU_BG_COLOR;
  colorText[] = MENU_TEXT_COLOR;
  font = "PuristaMedium";
  sizeEx = 0.01925 / (getResolution select 5);
};

class Menu_ControlButton : RscButton {
  idc = -1;
  text = "";
  x = (UI_BASE_X + 0.3755) * safezoneW + safezoneX;
  y = (UI_BASE_Y + 0.378) * safezoneH + safezoneY;
  w = 0.024 * safezoneW;
  h = 0.045 * safezoneH;
  colorDisabled[] = {0,0,0,0};
  colorBackground[] = {0,0,0,0};
  colorBackgroundDisabled[] = {0,0,0,0};
  colorBackgroundActive[] = {0,0,0,0};
  colorFocused[] = {0,0,0,0};
  colorShadow[] = {0,0,0,0};
  colorBorder[] = {0,0,0,0};
};

class Menu_ActionButton : Menu_StartButton { \
  x = (UI_BASE_X + 0.2) * safezoneW + safezoneX;
  w = 0.07 * safezoneW;
  h = 0.025 * safezoneH;
  sizeEx = 0.0165 / (getResolution select 5);
  colorText[] = MENU_TEXT_COLOR;
  colorBackground[] = MENU_TCB_BG_COLOR;
  colorBackgroundActive[] = MENU_TCB_BG_COLOR;
  idc = BTN_IDC;
  y = BTNY;
  show = false;
  enable = false;
  onMouseEnter = "";
  onMouseExit = "['STR_UI_BM_TEXT_DEFAULT'] call AS_fnc_UI_setTText;";
};

#define MENU_BG() class DEF_MENU_BG : Menu_Background {};

#define SMENU_TFIELD(TFIELD_IDC) \
class TFIELD_IDC##SMENU_TFIELD : Menu_TextField { \
  idc = TFIELD_IDC; \
  text = "Please setup the campaign parameters.<br />Press 'Start Mission' to continue."; \
}; \

#define MENU_IMG(IMG_IDC, IMG) \
class IMG_IDC##MENU_IMG : Menu_Picture { \
  idc = IMG_IDC; \
  text = IMG; \
}; \

#define MENU_BTN_S(BTN_IDC, BTN_ACTION) \
class BTN_IDC##MENU_BTN_S : Menu_StartButton { \
  idc = BTN_IDC; \
  action = BTN_ACTION; \
}; \

#define SMENU_TCBOX(TIDC, TY, TSTRINGS, TCSTRINGS, TMEH, TSEL) \
class TIDC##SMENU_TCBOX : StartMenu_TextCheckbox { \
  idc = TIDC; \
  y = TY; \
  strings[] = TSTRINGS; \
  checked_strings[] = TCSTRINGS; \
  onMouseEnter = TMEH; \
  onCheckBoxesSelChanged = TSEL; \
}; \

#define MENU_TEXT(TEXT_IDC, TEXTY, TTEXT) \
class TEXT_IDC##MENU_TEXT : Menu_StartText { \
  idc = TEXT_IDC; \
  x = (UI_BASE_X + 0.25) * safezoneW + safezoneX; \
  y = TEXTY; \
  text = TTEXT; \
}; \

#define SMENU_FRAME(FRAME_IDC, FRAMEX, FRAMEY, FTEXT) \
class FRAME_IDC##SMENU_FRAME : Menu_Frame { \
  idc = FRAME_IDC; \
  x = FRAMEX; \
  y = FRAMEY; \
  text = FTEXT; \
}; \

#define MENU_CBTN(BTN_IDC, BTNY, BTN_ACTION, EHME) \
class BTN_IDC##MENU_CBTN : Menu_ControlButton { \
  idc = BTN_IDC; \
  y = BTNY; \
  action = BTN_ACTION; \
  onMouseEnter = EHME; \
  onMouseExit = "['STR_UI_BM_TEXT_DEFAULT'] call AS_fnc_UI_setTText;"; \
}; \

// ========= MENU

#define MENU_FRAME_L(FRAME_IDC, FRAMEW, FRAMEH, FTEXT) \
class FRAME_IDC##MENU_FRAME_L : Menu_Frame { \
  idc = FRAME_IDC; \
  x = (UI_BASE_X + 0.115) * safezoneW + safezoneX; \
  y = (UI_BASE_Y + 0.345) * safezoneH + safezoneY; \
  w = FRAMEW; \
  h = FRAMEH; \
  text = FTEXT; \
}; \

#define MENU_FRAME_R(FRAME_IDC, FRAMEW, FRAMEH, FTEXT) \
class FRAME_IDC##MENU_FRAME_R : Menu_Frame { \
  idc = FRAME_IDC; \
  x = (UI_BASE_X + 0.195) * safezoneW + safezoneX; \
  y = (UI_BASE_Y + 0.345) * safezoneH + safezoneY; \
  w = FRAMEW; \
  h = FRAMEH; \
  text = FTEXT; \
}; \

#define MENU_NAV_BTN(BTN_IDC, BTNY, BTN_TEXT) \
class BTN_IDC##MENU_NAV_BTN : Menu_StartButton { \
  x = (UI_BASE_X + 0.12) * safezoneW + safezoneX; \
  w = 0.055 * safezoneW; \
  h = 0.025 * safezoneH; \
  sizeEx = 0.0165 / (getResolution select 5); \
  colorText[] = MENU_TEXT_COLOR; \
  colorBackground[] = MENU_TCB_BG_COLOR; \
  colorBackgroundActive[] = MENU_TCB_BG_COLOR; \
  idc = BTN_IDC; \
  y = BTNY; \
  text = BTN_TEXT; \
  onMouseExit = "['STR_UI_BM_TEXT_DEFAULT'] call AS_fnc_UI_setTText;"; \
}; \

#define MENU_ACT_BTN_L(BTN_IDC, BTNY) \
class BTN_IDC##MENU_ACT_BTN_L : Menu_ActionButton { \
  idc = BTN_IDC; \
  y = BTNY; \
}; \

#define MENU_ACT_BTN_R(BTN_IDC, BTNY) \
class BTN_IDC##MENU_ACT_BTN_R : Menu_ActionButton { \
  x = (UI_BASE_X + 0.275) * safezoneW + safezoneX; \
  idc = BTN_IDC; \
  y = BTNY; \
}; \

#define MENU_ACT_BTN_M(BTN_IDC, BTNY) \
class BTN_IDC##MENU_ACT_BTN_R : Menu_ActionButton { \
  x = (UI_BASE_X + 0.2375) * safezoneW + safezoneX; \
  idc = BTN_IDC; \
  y = BTNY; \
}; \

#define MENU_TFIELD(TFIELD_IDC) \
class TFIELD_IDC##MENU_TFIELD : Menu_TextField { \
  idc = TFIELD_IDC; \
  y = (UI_BASE_Y + 0.58) * safezoneH + safezoneY; \
  h = 0.038 * safezoneH; \
}; \

#define MENU_LINE_H(FRAME_IDC, FRAMEY) \
class FRAME_IDC##MENU_FRAME_R : Menu_Frame { \
  idc = FRAME_IDC; \
  x = (UI_BASE_X + 0.18) * safezoneW + safezoneX; \
  y = FRAMEY; \
  w = 0.015 * safezoneW; \
  h = 0.001 * safezoneH; \
  text = ""; \
}; \

#define BMENU_ACT_BTN(BTN_IDC, BTNY) \
class BTN_IDC##BMENU_ACT_BTN : Menu_ActionButton { \
  x = (UI_BASE_X + 0.2) * safezoneW + safezoneX; \
  w = 0.14 * safezoneW; \
  h = 0.03875 * safezoneH; \
  idc = BTN_IDC; \
  y = BTNY; \
  sizeEx = 0.02475 / (getResolution select 5); \
}; \
