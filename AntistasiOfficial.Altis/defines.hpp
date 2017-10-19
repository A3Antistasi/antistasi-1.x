// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C
#define ST_GROUP_BOX       96
#define ST_GROUP_BOX2      112
#define ST_ROUNDED_CORNER  ST_GROUP_BOX + ST_CENTER
#define ST_ROUNDED_CORNER2 ST_GROUP_BOX2 + ST_CENTER

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4


////////////////
//Base Classes//
////////////////

class RscText
{
    access = 0;
    idc = -1;
    type = CT_STATIC;
    style = ST_MULTI;
    linespacing = 1;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,.5};
    text = "";
    shadow = 2;
    font = "PuristaMedium";
    SizeEx = 0.02300;
    fixedWidth = 0;
    x = 0;
    y = 0;
    h = 0;
    w = 0;

};

class RscStructuredText {
  idc = -1;
  type = CT_STRUCTURED_TEXT;  // defined constant
  style = ST_CENTER;            // defined constant
  colorBackground[] = { 1, 1, 1, 1 };
  x = 0.1;
  y = 0.1;
  w = 0.3;
  h = 0.1;
  size = 0.035;
  text = "";
  class Attributes {
    font = "TahomaB";
    color = "#FF0000";
    align = "center";
    valign = "middle";
    shadow = false;
    shadowColor = "#ff0000";
    size = "1";
  };
};

class RscPicture
{
    access = 0;
    idc = -1;
    type = CT_STATIC;
    style = ST_PICTURE;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    font = "PuristaMedium";
    sizeEx = 0;
    lineSpacing = 0;
    text = "";
    fixedWidth = 0;
    shadow = 0;
    x = 0;
    y = 0;
    w = 0.2;
    h = 0.15;
};
class RscButton
{

   access = 0;
    type = CT_BUTTON;
    text = "";
    colorText[] = {0,0.871,0.769,1};
    colorDisabled[] = {0.4,0.4,0.4,0};
    colorBackground[] =  {0.247,0.243,0.243,1};
    colorBackgroundDisabled[] = {0,0.0,0};
    colorBackgroundActive[] = {0.247,0.243,0.243,1};
    colorFocused[] = {0.247,0.243,0.243,1};
    colorShadow[] = {0.023529,0,0.0313725,1};
    colorBorder[] = {0.023529,0,0.0313725,1};
    soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
    soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
    soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
    soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
    style = 2;
    x = 0;
    y = 0;
    w = 0.055589;
    h = 0.039216;
    shadow = 2;
    font = "PuristaMedium";
    sizeEx = 0.05;
    offsetX = 0.003;
    offsetY = 0.003;
    offsetPressedX = 0.002;
    offsetPressedY = 0.002;
    borderSize = 0;
    onMouseEnter = "(_this select 0) ctrlSetTextColor [1,0.969,0,1]";
    onMouseExit = "(_this select 0) ctrlSetTextColor [0,0.871,0.769,1]";
};

class RscFrame
{
    type = CT_STATIC;
    idc = -1;
    style = ST_FRAME;
    shadow = 2;
    colorBackground[] = {0.118,0.114,0.114,1};
    colorText[] = {1,0.969,0,1};
    font = "PuristaMedium";
    sizeEx = 0.03;
    text = "";
};
class BOX
{
   type = CT_STATIC;
    idc = -1;
    style = ST_CENTER;
    shadow = 2;
    colorText[] = {1,1,1,1};
    font = "PuristaMedium";
    sizeEx = 0.02;
    colorBackground[] = { 0.2,0.2,0.2, 0.9 };
    text = "";
};

class RscListBox
{
     access = 0;
     type = 5;
     style = 0;
     w = 0.4;
     h = 0.4;
     font = "TahomaB";
     sizeEx = 0.04;
     rowHeight = 0;
     colorText[] = {1,1,1,1};
     colorScrollbar[] = {1,1,1,1};
     colorSelect[] = {0,0,0,1};
     colorSelect2[] = {1,0.5,0,1};
     colorSelectBackground[] = {0.6,0.6,0.6,1};
     colorSelectBackground2[] = {0.2,0.2,0.2,1};
     colorBackground[] = {0.2,0.2,0.2,0.9};
     maxHistoryDelay = 1.0;
     soundSelect[] = {"",0.1,1};
     period = 1;
     autoScrollSpeed = -1;
     autoScrollDelay = 5;
     autoScrollRewind = 0;
     arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
     arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
     shadow = 0;
     class ListScrollBar// : ScrollBar //ListScrollBar is class name required for Arma 3
     {
          color[] = {1,1,1,0.6};
          colorActive[] = {1,1,1,1};
          colorDisabled[] = {1,1,1,0.3};
          thumb = "#(argb,8,8,3)color(1,1,1,1)";
          arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
          arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
          border = "#(argb,8,8,3)color(1,1,1,1)";
          shadow = 0;
     };
};

class RscProgress
{
    type = 8;
    style = 0;
    colorFrame[] = {1,1,1,1};
    colorBar[] = {0.3,0.3,0.5,1};
    texture = "#(argb,8,8,3)color(1,1,1,1)";
    w = 1;
    h = 0.03;
};

class ProgressBarGeneric
{
    idd = -1;
    onLoad = "((_this select 0) displayCtrl -1) progressSetPosition 0.0";
    class Controls
    {
        class Progress: RscProgress
        {
            idc = -1;
            x = 0;
            y = 0.3;
        };
    };
};

class MenuText {
    idc = -1;
    colorText[] = {1,1,1,1};
    colorBackground[] = {0,0,0,0};
    size = 1;
    access = 0;
    type = CT_STATIC;
    style = ST_CENTER;
    font = "TahomaB";
    sizeEx = 0.02;
    fixedWidth = 0;
    shadow = 0;
    linespacing = 1;
};

class RscEdit {
  access = 0;
  type = CT_EDIT;
  style = ST_LEFT+ST_FRAME;
  x = 0;
  y = 0;
  w = 0.055589;
  h = 0.039216;
  colorBackground[] = {0.75,0.75,0.75,0.8};
  colorText[] = {1,1,1,.9};
  colorSelection[] = {1,1,1,0.25};
  colorDisabled[] = {0.4,0.4,0.4,0};
  font = "PuristaMedium";
  sizeEx = 0.03;
  autocomplete = "";
  text = "";
  size = 0.2;
  shadow = 2;
};


#define A_CLOSE "closeDialog 0"

#define BOX_W (0.445038 * safezoneW)
#define BOX_H_2 (0.20 * safezoneH)
#define BOX_H_4 (0.30 * safezoneH)
#define BOX_H_6 (0.40 * safezoneH)
#define BOX_H_8 (0.50 * safezoneH)
#define BOX_H_10 (0.60 * safezoneH)

#define FRAME_W (0.425038 * safezoneW)
#define FRAME_H_2 (0.18 * safezoneH)
#define FRAME_H_4 (0.28 * safezoneH)
#define FRAME_H_6 (0.37 * safezoneH)
#define FRAME_H_8 (0.462103 * safezoneH)
#define FRAME_H_10 (0.560125 * safezoneH)


#define BTN_X_L (0.272481 * safezoneW + safezoneX)
#define BTN_X_R (0.482498 * safezoneW + safezoneX)
#define BTN_X_M (0.37749 * safezoneW + safezoneX)

#define BTN_W (0.175015 * safezoneW)
#define BTN_H (0.0560125 * safezoneH)

#define BTN_Y_1 (0.317959 * safezoneH + safezoneY)
#define BTN_Y_2 (0.415981 * safezoneH + safezoneY)
#define BTN_Y_3 (0.514003 * safezoneH + safezoneY)
#define BTN_Y_4 (0.612025 * safezoneH + safezoneY)
#define BTN_Y_5 (0.710047 * safezoneH + safezoneY)


class AS_box: BOX
{
  idc = -1;
  text = ""; //--- ToDo: Localize;
  x = 0.244979 * safezoneW + safezoneX;
  y = 0.223941 * safezoneH + safezoneY;
  w = BOX_W;
  h = BOX_H_2;
};

#define AS_BOX_D(BOX_SIZE) \
class NAME##BOX : AS_box { \
  h = BOX_SIZE; \
};\


class AS_frame: RscFrame
{
  idc = -1;
  text = "";
  x = 0.254979 * safezoneW + safezoneX;
  y = 0.233941 * safezoneH + safezoneY;
  w = FRAME_W;
  h = FRAME_H_2;
};

#define AS_FRAME_D(FRAME_SIZE,F_TEXT) \
class NAME##FRAME : AS_frame { \
  h = FRAME_SIZE; \
  text= F_TEXT; \
};\

class AS_button_back: RscButton
{
  idc = -1;
  text = "Back";
  x = 0.61 * safezoneW + safezoneX;
  y = 0.251941 * safezoneH + safezoneY;
  w = 0.06 * safezoneW;
  h = 0.05 * safezoneH;
  action = A_CLOSE;
};

#define BTN_BACK(BTN_ACTION) \
class NAME##BTN_B : AS_button_back { \
  action = BTN_ACTION; \
};\

class AS_button_L: RscButton
{
  idc = -1;
  text = "";
  x = BTN_X_L;
  y = BTN_Y_1;
  w = BTN_W;
  h = BTN_H;
  action = A_CLOSE;
};

class AS_button_R: AS_button_L
{
  x = BTN_X_R;
};

#define BTN_L1(BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_L1 : AS_button_L { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  y = BTN_Y_1; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\

#define BTN_L2(BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_L2 : AS_button_L { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  y = BTN_Y_2; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\

#define BTN_L3(BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_L3 : AS_button_L { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  y = BTN_Y_3; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\

#define BTN_L4(BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_L4 : AS_button_L { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  y = BTN_Y_4; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\

#define BTN_L5(BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_L5 : AS_button_L { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  y = BTN_Y_5; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\


#define BTN_R1(BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_R1 : AS_button_R { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  y = BTN_Y_1; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\

#define BTN_R2(BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_R2 : AS_button_R { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  y = BTN_Y_2; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\

#define BTN_R3(BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_R3 : AS_button_R { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  y = BTN_Y_3; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\

#define BTN_R4(BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_R4 : AS_button_R { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  y = BTN_Y_4; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\

#define BTN_R5(BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_R5 : AS_button_R { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  y = BTN_Y_5; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\

#define BTN_M(BTN_LINE,BTN_IDC,BTN_TEXT,BTN_TOOLTIP,BTN_ACTION) \
class NAME##BTN_R5 : AS_button_R { \
  idc = BTN_IDC; \
  text = BTN_TEXT; \
  x = BTN_X_M; \
  y = BTN_LINE; \
  toolTip = BTN_TOOLTIP; \
  action = BTN_ACTION; \
};\

class ASA3_Picture
{
  access = 0;
  type = 0;
  idc = -1;
  style = 48;
  colorBackground[] ={0,0,0,0};
  colorText[] ={1,1,1,1};
  font = "TahomaB";
  sizeEx = 0;
  lineSpacing = 0;
  text = "";
  fixedWidth = 0;
  shadow = 0;
  x = 0;
  y = 0;
  w = 0.24 * safezoneW;
  h = 0.32 * safezoneH;
};

class RscTextCheckBox
{
  idc = -1;
  type  = CT_CHECKBOXES;
  style   = ST_CENTER;
  x = "0.375 * safezoneW + safezoneX";
  y = "0.36 * safezoneH + safezoneY";
  w = "0.025 * safezoneW";
  h = "0.04 * safezoneH";
  colorText[] = {1,0,0,1};
  color[] ={0,0,0,0};
  colorBackground[] = {0,0,0,0};
  colorTextSelect[] = {0,0.8,0,1};
  colorSelectedBg[] = {0.75,0.75,0.75,0.8};
  colorSelect[] = {0,0,0,1};
  colorTextDisable[] = {0.4,0.4,0.4,1};
  colorDisable[] = {0.4,0.4,0.4,1};
  tooltipColorText[] = {1,1,1,1};
  tooltipColorBox[] = {1,1,1,1};
  tooltipColorShade[] = {0,0,0,0.65};
  font = "PuristaMedium";
  sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
  rows = 1;
  columns = 1;
  strings[] =
  {
    "UNCHECKED"
  };
  checked_strings[] =
  {
    "CHECKED"
  };
  onMouseExit = "[] call AS_fnc_UI_setTText;";
};

#include "UI\defines\general.hpp"
#include "UI\defines\menuElements.hpp"
#include "UI\defines\sellMenuElements.hpp"


class RscIconJNA: RscButton
{
	text = "";
	tooltip = "";
	colorDisabled[] = {1,1,1,1};
	colorBackground[] = {1,1,1,0};
	
	w = "1.4 * 			(			((safezoneW / safezoneH) min 1.2) / 40)";
	h = "1.4 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
	x = -1;
	y = -1;
	
	style = "0x30 + 0x800";
	
};