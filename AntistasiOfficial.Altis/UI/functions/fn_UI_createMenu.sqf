#include "..\defines\general.hpp"
#include "..\defines\menu_player.hpp"
#include "..\defines\menu_commander.hpp"
#include "..\defines\menu_admin.hpp"

disableSerialization;
params ["_menu", "_idc"];
private ["_display", "_index"];

_display = findDisplay 100;

[] call AS_fnc_UI_clearMenu;

_fnc_setup = {
	params ["_column", "_arrayEH", ["_texts", []], ["_tooltips", []]];
	private ["_z", "_ehAction"];

	for "_i" from 0 to (count _arrayEH) - 1 do {
		_z = _column select _i;
		_display displayCtrl _z ctrlEnable true;
		_display displayCtrl _z ctrlShow true;
		_display displayCtrl _z ctrlAddEventHandler ["ButtonClick", (_arrayEH select _i)];

		if (count _texts > 0) then {
			_display displayCtrl _z ctrlSetText (localize (_texts select _i));
			_ehAction = format ["['%1'] call AS_fnc_UI_setTText", (_tooltips select _i)];
			_display displayCtrl _z ctrlAddEventHandler ["MouseEnter", _ehAction];
		};
	};
};

_fnc_setupSingle = {
	params ["_btnIDC", "_EH", ["_text", ""], ["_tooltip", ""]];
	private ["_ehAction"];

	_display displayCtrl _btnIDC ctrlEnable true;
	_display displayCtrl _btnIDC ctrlShow true;
	_display displayCtrl _btnIDC ctrlAddEventHandler ["ButtonClick", _EH];
	_display displayCtrl _btnIDC ctrlSetText (localize _text);
	_ehAction = format ["['%1'] call AS_fnc_UI_setTText", _tooltip];
	_display displayCtrl _btnIDC ctrlAddEventHandler ["MouseEnter", _ehAction];
};

_fnc_setupSingleText = {
	params ["_btnIDC", "_EH", ["_text", ""], ["_tooltip", ""]];
	private ["_ehAction"];

	_display displayCtrl _btnIDC ctrlEnable true;
	_display displayCtrl _btnIDC ctrlShow true;
	_display displayCtrl _btnIDC ctrlSetText _text;
	_display displayCtrl _btnIDC ctrlRemoveAllEventHandlers "MouseEnter";
	_display displayCtrl _btnIDC ctrlAddEventHandler ["MouseEnter", format ["findDisplay 100 displayCtrl 1100 ctrlSetStructuredText parseText '%1';", _tooltip]];
};

call {
	// PLAYER
	if (_menu isEqualTo "nav") exitWith {
		[1500, 1506] call AS_fnc_UI_clearMenu;
		[NAV_BTNS, [NAV_ACT_FASTTRAVEL, NAV_ACT_UNDERCOVER, NAV_ACT_VEHMGMT, NAV_ACT_AIMGMT, NAV_ACT_MONEY, NAV_ACT_RESIGN], NAV_TEXTS, NAV_TTS] call _fnc_setup;
		_display displayAddEventHandler ["KeyDown", SHORTCUT_EH];
	};

	// COMMANDER
	if (_menu isEqualTo "navCom") exitWith {
		[1500, 1506] call AS_fnc_UI_clearMenu;
		[NAV_BTNS, [NAVCOM_ACT_NATO, NAVCOM_ACT_SQUAD_REC, NAVCOM_ACT_SQUAD_MGMT, NAVCOM_ACT_BUILD, NAVCOM_ACT_INFO, NAVCOM_ACT_MAINT], NAVCOM_TEXTS, NAVCOM_TTS] call _fnc_setup;
		[(NAV_BTNS select 0), NAVCOM_ACT_NATO, format [localize "STR_UI_NAVCOM_NATO_TEXT", A3_Str_BLUE], format [localize "STR_UI_NAVCOM_NATO_TT", A3_Str_BLUE]] call _fnc_setupSingleText;
	};

	// ADMIN
	if (_menu isEqualTo "admin") exitWith {
		[ACT_BTNS_L6, [ADMIN_ADDMEMBER, ADMIN_REMMEMBER, ADMIN_TGLWPN, ADMIN_TGLAXP, ADMIN_FORCE1ST], ADMIN_TEXTS_L, ADMIN_TTS_L] call _fnc_setup;
		[ACT_BTNS_R6, [ADMIN_TGLFT, ADMIN_GARBAGE, ADMIN_GEARRESET, ADMIN_TGLTM, ADMIN_TGLPN], ADMIN_TEXTS_R, ADMIN_TTS_R] call _fnc_setup;

		if (server getVariable ['enableWpnProf',false]) then {_display displayCtrl (ACT_BTNS_L6 select 2) ctrlSetTextColor MENU_TEXT_COLOR_TRUE_ARRAY} else {_display displayCtrl (ACT_BTNS_L6 select 2) ctrlSetTextColor MENU_TEXT_COLOR_FALSE_ARRAY};
		if (activeBE) then {_display displayCtrl (ACT_BTNS_L6 select 3) ctrlSetTextColor MENU_TEXT_COLOR_TRUE_ARRAY} else {_display displayCtrl (ACT_BTNS_L6 select 3) ctrlSetTextColor MENU_TEXT_COLOR_FALSE_ARRAY};
		if (server getVariable ['enableFTold',false]) then {_display displayCtrl (ACT_BTNS_R6 select 0) ctrlSetTextColor MENU_TEXT_COLOR_TRUE_ARRAY} else {_display displayCtrl (ACT_BTNS_R6 select 0) ctrlSetTextColor MENU_TEXT_COLOR_FALSE_ARRAY};
		if (server getVariable ['enableMemAcc',false]) then {_display displayCtrl (ACT_BTNS_R6 select 1) ctrlSetTextColor MENU_TEXT_COLOR_TRUE_ARRAY} else {_display displayCtrl (ACT_BTNS_R6 select 1) ctrlSetTextColor MENU_TEXT_COLOR_FALSE_ARRAY};
		if (server getVariable ['testMode',false]) then {_display displayCtrl (ACT_BTNS_R6 select 3) ctrlSetTextColor MENU_TEXT_COLOR_TRUE_ARRAY} else {_display displayCtrl (ACT_BTNS_R6 select 3) ctrlSetTextColor MENU_TEXT_COLOR_FALSE_ARRAY};
		if !(server getVariable ['hardMode',false]) then {_display displayCtrl (ACT_BTNS_R6 select 4) ctrlSetTextColor MENU_TEXT_COLOR_TRUE_ARRAY} else {_display displayCtrl (ACT_BTNS_R6 select 4) ctrlSetTextColor MENU_TEXT_COLOR_FALSE_ARRAY};
		if !(isNil "AS_1PS_EH") then {_display displayCtrl (ACT_BTNS_L6 select 4) ctrlSetTextColor MENU_TEXT_COLOR_TRUE_ARRAY} else {_display displayCtrl (ACT_BTNS_L6 select 4) ctrlSetTextColor MENU_TEXT_COLOR_FALSE_ARRAY};
	};

	// GENERAL MENUS
	if (_menu isEqualTo "ai_mgmt") exitWith {
		_index = NAV_BTNS find (ctrlIDC _idc);
		_display displayCtrl (LINES select _index) ctrlShow true;
		[ACT_BTNS_L6, [ACT_AI_TEMPCTRL, ACT_AI_AUTOHEAL, ACT_AI_REARM, ACT_AI_GARR], AI_TEXTS_L, AI_TOOLTIPS_L] call _fnc_setup;
		[ACT_BTNS_R6, [ACT_AI_SCAVENGE, ACT_AI_STORE, ACT_AI_RESET, ACT_AI_DISMISS], AI_TEXTS_R, AI_TOOLTIPS_R] call _fnc_setup;
		if (autoHeal) then {_display displayCtrl (ACT_BTNS_L6 select 1) ctrlSetTextColor MENU_TEXT_COLOR_TRUE_ARRAY} else {_display displayCtrl (ACT_BTNS_L6 select 1) ctrlSetTextColor MENU_TEXT_COLOR_FALSE_ARRAY};
	};

	if (_menu isEqualTo "veh_mgmt") exitWith {
		_index = NAV_BTNS find (ctrlIDC _idc);
		_display displayCtrl (LINES select _index) ctrlShow true;
		if (player == Slowhand) then {
			[ACT_BTNS_M4, [ACT_VEH_PGAR, ACT_VEH_UNLOCK, ACT_VEH_SELL], VEH_TEXTS, VEH_TOOLTIPS] call _fnc_setup;
		} else {
			[ACT_BTNS_M4, [ACT_VEH_PGAR, ACT_VEH_UNLOCK], VEH_TEXTS, VEH_TOOLTIPS] call _fnc_setup;
		};
	};
	if (_menu isEqualTo "money") exitWith {
		_index = NAV_BTNS find (ctrlIDC _idc);
		_display displayCtrl (LINES select _index) ctrlShow true;
		[ACT_BTNS_M4, [ACT_MON_PLAYER, ACT_MON_FIA], MON_TEXTS, MON_TOOLTIPS] call _fnc_setup;
	};

	// COM MENUS

	/*if (_menu isEqualTo "com_nato") exitWith {
		_index = NAV_BTNS find (ctrlIDC _idc);
		_display displayCtrl (LINES select _index) ctrlShow true;
		[ACT_BTNS_L6, [NATO_ATT, NATO_ARM, NATO_ART, NATO_RB], NATO_TEXTS_L, NATO_TTS_L] call _fnc_setup;
		[ACT_BTNS_R6, [NATO_UAV, NATO_AMMO, NATO_CAS, NATO_BOMB], NATO_TEXTS_R, NATO_TTS_R] call _fnc_setup;
		[(ACT_BTNS_M6 select 4), NATO_QRF, NATO_TEXTS_M, NATO_TTS_M] call _fnc_setupSingle;
	};*/ //BACKUP

	if (_menu isEqualTo "com_nato") exitWith {
		_index = NAV_BTNS find (ctrlIDC _idc);
		_display displayCtrl (LINES select _index) ctrlShow true;
		[ACT_BTNS_L6, [NATO_ATT, NATO_ARM, NATO_ART, NATO_RB, NATO_QRF], NATO_TEXTS_L, NATO_TTS_L] call _fnc_setup;           // Stef 30-08 i made even columns and added the NATO Attack button.
		[ACT_BTNS_R6, [NATO_UAV, NATO_AMMO, NATO_CAS, NATO_BOMB, NATO_RED], NATO_TEXTS_R, NATO_TTS_R] call _fnc_setup;
	};


	if (_menu isEqualTo "com_squad_rec") exitWith {
		_index = NAV_BTNS find (ctrlIDC _idc);
		_display displayCtrl (LINES select _index) ctrlShow true;
		[ACT_BTNS_L6, [SR_INFSQUAD, SR_INFTEAM, SR_ATSQUAD, SR_AATRUCK], SR_TEXTS_L, SR_TTS_L] call _fnc_setup;
		[ACT_BTNS_R6, [SR_SNPRTEAM, SR_ATTRUCK, SR_SENTRY, SR_MORTAR], SR_TEXTS_R, SR_TTS_R] call _fnc_setup;
		[(ACT_BTNS_M6 select 4), SR_ENG, SR_TEXTS_M, SR_TTS_M] call _fnc_setupSingle;
	};

	if (_menu isEqualTo "com_squad_mgmt") exitWith {
		_index = NAV_BTNS find (ctrlIDC _idc);
		_display displayCtrl (LINES select _index) ctrlShow true;
		[ACT_BTNS_M4, [SM_ADDVEH, SM_VEHSTATS, SM_MOUNT, SM_AUTOT], SM_TEXTS, SM_TTS] call _fnc_setup;
	};

	if (_menu isEqualTo "com_build") exitWith {
		_index = NAV_BTNS find (ctrlIDC _idc);
		_display displayCtrl (LINES select _index) ctrlShow true;
		[ACT_BTNS_L6, [EMP_BLDRB, EMP_DELRB, EMP_MNAPERS, EMP_MNAT], EMP_TEXTS_L, EMP_TTS_L] call _fnc_setup;
		[ACT_BTNS_R6, [EMP_CMPEST, EMP_CMPDEL, EMP_CMPREN, EMP_HQFORT], EMP_TEXTS_R, EMP_TTS_R] call _fnc_setup;
	};

	if (_menu isEqualTo "com_info") exitWith {
		_index = NAV_BTNS find (ctrlIDC _idc);
		_display displayCtrl (LINES select _index) ctrlShow true;
		[ACT_BTNS_M4, [INFO_AXP_RES, INFO_MRESTR, INFO_ACEMEDIC], INFO_TEXTS, INFO_TTS] call _fnc_setup;
	};

	if (_menu isEqualTo "com_maint") exitWith {
		_index = NAV_BTNS find (ctrlIDC _idc);
		_display displayCtrl (LINES select _index) ctrlShow true;
		[ACT_BTNS_M4, [STR_GO_GAR, MAINT_PET, MAINT_MOV, MAINT_RES], MAINT_TEXTS, MAINT_TTS] call _fnc_setup;
	};
};

