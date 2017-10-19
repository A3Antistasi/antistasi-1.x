#define MENU_BTN_Y1 (UI_BASE_Y + 0.370) * safezoneH + safezoneY
#define MENU_BTN_Y2 (UI_BASE_Y + 0.405) * safezoneH + safezoneY
#define MENU_BTN_Y3 (UI_BASE_Y + 0.440) * safezoneH + safezoneY
#define MENU_BTN_Y4 (UI_BASE_Y + 0.475) * safezoneH + safezoneY
#define MENU_BTN_Y5 (UI_BASE_Y + 0.510) * safezoneH + safezoneY
#define MENU_BTN_Y6 (UI_BASE_Y + 0.545) * safezoneH + safezoneY

#define MENU_LINE_Y1 (UI_BASE_Y + 0.3815) * safezoneH + safezoneY
#define MENU_LINE_Y2 (UI_BASE_Y + 0.4175) * safezoneH + safezoneY
#define MENU_LINE_Y3 (UI_BASE_Y + 0.4525) * safezoneH + safezoneY
#define MENU_LINE_Y4 (UI_BASE_Y + 0.4875) * safezoneH + safezoneY
#define MENU_LINE_Y5 (UI_BASE_Y + 0.5225) * safezoneH + safezoneY
#define MENU_LINE_Y6 (UI_BASE_Y + 0.5575) * safezoneH + safezoneY

#define BMENU_BTN_Y1 (UI_BASE_Y + 0.37000) * safezoneH + safezoneY
#define BMENU_BTN_Y2 (UI_BASE_Y + 0.42375) * safezoneH + safezoneY
#define BMENU_BTN_Y3 (UI_BASE_Y + 0.47775) * safezoneH + safezoneY
#define BMENU_BTN_Y4 (UI_BASE_Y + 0.53125) * safezoneH + safezoneY

class menu_startGame {
	idd=100;
	movingenable=true;

	class controls {
		#define	STR_START_MISSION "[] execVM 'UI\startGame.sqf';"


		#define STR_START_SC_ACTION "if ((_this select 2) isEqualTo 1) then {['STR_UI_SM_COM_1'] call AS_fnc_UI_setTText; switchCom = true; publicVariable 'switchCom';} \
			else {['STR_UI_SM_COM_0'] call AS_fnc_UI_setTText; switchCom = false; publicVariable 'switchCom';}" \

		#define STR_START_SC_NO "switchCom = false; publicVariable 'switchCom';"

		#define STR_START_MEM_ACTION "if ((_this select 2) isEqualTo 1) then {['STR_UI_SM_MEM_1'] call AS_fnc_UI_setTText;} else {['STR_UI_SM_MEM_0'] call AS_fnc_UI_setTText;}"

		#define STR_START_CAM_ACTION "if ((_this select 2) isEqualTo 1) then {['STR_UI_SM_LOAD_0'] call AS_fnc_UI_setTText; ((findDisplay 100) displayCtrl 2503) ctrlShow true;} \
			else {['STR_UI_SM_LOAD_0'] call AS_fnc_UI_setTText; ((findDisplay 100) displayCtrl 2503) ctrlShow false;}" \

		#define STR_START_EAS_ACTION "if ((_this select 2) isEqualTo 1) then {['STR_UI_SM_EAS_0'] call AS_fnc_UI_setTText;} else {['STR_UI_SM_EAS_1'] call AS_fnc_UI_setTText;}"

		#define STR_LOAD_YES "[] remoteExec [""AS_fnc_loadGame"",2];"

		MENU_BG();
		MENU_IMG(1001, MENU_IMG_DAY);
		SMENU_TFIELD(1100);
		MENU_BTN_S(1600, STR_START_MISSION);

		SMENU_FRAME(1201, (UI_BASE_X + 0.115) * safezoneW + safezoneX, (UI_BASE_Y + 0.343) * safezoneH + safezoneY, $STR_UI_SM_FRAMEL_TEXT);
		SMENU_FRAME(1202, (UI_BASE_X + 0.245) * safezoneW + safezoneX, (UI_BASE_Y + 0.343) * safezoneH + safezoneY, $STR_UI_SM_FRAMER_TEXT);

		MENU_TEXT(1301, (UI_BASE_Y + 0.376) * safezoneH + safezoneY, "ACE");
		MENU_TEXT(1302, (UI_BASE_Y + 0.409) * safezoneH + safezoneY, "TFAR");
		MENU_TEXT(1303, (UI_BASE_Y + 0.442) * safezoneH + safezoneY, "RHS AFRF");
		MENU_TEXT(1304, (UI_BASE_Y + 0.475) * safezoneH + safezoneY, "RHS USAF");

		SMENU_TCBOX(2500, (UI_BASE_Y + 0.376) * safezoneH + safezoneY, {$STR_UI_SM_COM_0}, {$STR_UI_SM_COM_1}, "['STR_UI_SM_COM_TT'] call AS_fnc_UI_setTText;", STR_START_SC_ACTION);
		SMENU_TCBOX(2501, (UI_BASE_Y + 0.409) * safezoneH + safezoneY, {$STR_UI_SM_MEM_0}, {$STR_UI_SM_MEM_1}, "['STR_UI_SM_MEM_TT'] call AS_fnc_UI_setTText;", STR_START_MEM_ACTION);
		SMENU_TCBOX(2502, (UI_BASE_Y + 0.442) * safezoneH + safezoneY, {$STR_UI_SM_LOAD_0}, {$STR_UI_SM_LOAD_1}, "['STR_UI_SM_LOAD_TT'] call AS_fnc_UI_setTText;", STR_START_CAM_ACTION);
		SMENU_TCBOX(2503, (UI_BASE_Y + 0.475) * safezoneH + safezoneY, {$STR_UI_SM_EAS_0}, {$STR_UI_SM_EAS_1}, "['STR_UI_SM_EAS_TT'] call AS_fnc_UI_setTText;", STR_START_EAS_ACTION);
	};
};

class menu_default {
	idd=100;
	movingenable=true;

	class controls {

		MENU_CBTN(1401, (UI_BASE_X + 0.078) * safezoneH + safezoneY, "['nav'] call AS_fnc_UI_createMenu;", "['STR_UI_MENU_PLAYER_TT'] call AS_fnc_UI_setTText;");
		MENU_CBTN(1402, (UI_BASE_X + 0.156) * safezoneH + safezoneY, "if (player == Slowhand) then {['navCom'] call AS_fnc_UI_createMenu;};", "['STR_UI_MENU_COM_TT'] call AS_fnc_UI_setTText;");
		MENU_CBTN(1403, (UI_BASE_X + 0.235) * safezoneH + safezoneY, "if (isServer || (serverCommandAvailable '#logout')) then {['admin'] call AS_fnc_UI_createMenu;}", "['STR_UI_MENU_ADMIN_TT'] call AS_fnc_UI_setTText;");

		MENU_BG();
		MENU_IMG(1001, MENU_IMG_DAY);
		MENU_TFIELD(1100);

		MENU_FRAME_L(1201, 0.065 * safezoneW, 0.230 * safezoneH, $STR_UI_BM_FRAMEL_TEXT);
		MENU_FRAME_R(1202, 0.155 * safezoneW, 0.230 * safezoneH, $STR_UI_BM_FRAMER_TEXT);

		MENU_LINE_H(1211, MENU_LINE_Y1);
		MENU_LINE_H(1212, MENU_LINE_Y2);
		MENU_LINE_H(1213, MENU_LINE_Y3);
		MENU_LINE_H(1214, MENU_LINE_Y4);
		MENU_LINE_H(1215, MENU_LINE_Y5);
		MENU_LINE_H(1216, MENU_LINE_Y6);

		MENU_NAV_BTN(1501, MENU_BTN_Y1, $STR_UI_BM_NAV1_TEXT);
		MENU_NAV_BTN(1502, MENU_BTN_Y2, $STR_UI_BM_NAV2_TEXT);
		MENU_NAV_BTN(1503, MENU_BTN_Y3, $STR_UI_BM_NAV3_TEXT);
		MENU_NAV_BTN(1504, MENU_BTN_Y4, $STR_UI_BM_NAV4_TEXT);
		MENU_NAV_BTN(1505, MENU_BTN_Y5, $STR_UI_BM_NAV5_TEXT);
		MENU_NAV_BTN(1506, MENU_BTN_Y6, $STR_UI_BM_NAV6_TEXT);

		MENU_ACT_BTN_L(1511, MENU_BTN_Y1);
		MENU_ACT_BTN_L(1512, MENU_BTN_Y2);
		MENU_ACT_BTN_L(1513, MENU_BTN_Y3);
		MENU_ACT_BTN_L(1514, MENU_BTN_Y4);
		MENU_ACT_BTN_L(1515, MENU_BTN_Y5);
		MENU_ACT_BTN_L(1516, MENU_BTN_Y6);

		MENU_ACT_BTN_R(1521, MENU_BTN_Y1);
		MENU_ACT_BTN_R(1522, MENU_BTN_Y2);
		MENU_ACT_BTN_R(1523, MENU_BTN_Y3);
		MENU_ACT_BTN_R(1524, MENU_BTN_Y4);
		MENU_ACT_BTN_R(1525, MENU_BTN_Y5);
		MENU_ACT_BTN_R(1526, MENU_BTN_Y6);

		MENU_ACT_BTN_M(1531, MENU_BTN_Y1);
		MENU_ACT_BTN_M(1532, MENU_BTN_Y2);
		MENU_ACT_BTN_M(1533, MENU_BTN_Y3);
		MENU_ACT_BTN_M(1534, MENU_BTN_Y4);
		MENU_ACT_BTN_M(1535, MENU_BTN_Y5);
		MENU_ACT_BTN_M(1536, MENU_BTN_Y6);

		BMENU_ACT_BTN(1541, BMENU_BTN_Y1);
		BMENU_ACT_BTN(1542, BMENU_BTN_Y2);
		BMENU_ACT_BTN(1543, BMENU_BTN_Y3);
		BMENU_ACT_BTN(1544, BMENU_BTN_Y4);
	};
};

class menu_sell {
	idd=100;
	movingenable=true;

	class controls {

		MENU_BG();
		MENU_IMG(1001, MENU_IMG_DAY);

		MENU_FRAME_L(1201, 0.065 * safezoneW, 0.230 * safezoneH, $STR_UI_SELL_FRAME);
		MENU_FRAME_R(1202, 0.155 * safezoneW, 0.230 * safezoneH, $STR_UI_SELL_WEAPONS);

		SELL_NAV_BTN(1501, MENU_BTN_Y1, $STR_UI_SELL_WEAPONS);
		SELL_NAV_BTN(1502, MENU_BTN_Y2, $STR_UI_SELL_AMMO);
		SELL_NAV_BTN(1503, MENU_BTN_Y3, $STR_UI_SELL_ITEMS);
		SELL_NAV_BTN(1504, MENU_BTN_Y4, $STR_UI_SELL_BACKPACKS);
		SELL_NAV_BTN(1505, MENU_BTN_Y6, $STR_UI_SELL_FRAME);

		MULTICOMBO(ItemOne, 2100, MENU_BTN_Y1);
		MULTICOMBO_INVIS(ItemTwo, 2110, MENU_BTN_Y2);
		MULTICOMBO_INVIS(ItemThree, 2120, MENU_BTN_Y3);
		MULTICOMBO_INVIS(ItemFour, 2130, MENU_BTN_Y4);
	};
};