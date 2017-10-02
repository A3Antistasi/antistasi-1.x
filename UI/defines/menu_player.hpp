#define SHORTCUT_EH "call { \
		if (((_this select 1) == 21) || ((_this select 1) == 1)) exitWith {closeDialog 0; true}; \
		if ((_this select 1) == 33) exitWith {closeDialog 0; if (server getVariable 'enableFTold') then {createDialog 'fasttravel_dialog'} else {[] spawn AS_fnc_fastTravel}; true}; \
		if ((_this select 1) == 34) exitWith {closeDialog 0; [false] call AS_fnc_garageVehicle; true}; \
		if ((_this select 1) == 22) exitWith {closeDialog 0; [] spawn undercover; true}; \
	};  \
	true" \

// NAV PLAYER
#define NAV_ACT_FASTTRAVEL "closeDialog 0; if (server getVariable 'enableFTold') then {createDialog 'fasttravel_dialog'} else {[] spawn AS_fnc_fastTravel};"
#define NAV_ACT_UNDERCOVER "closeDialog 0; [] spawn undercover;"
#define NAV_ACT_VEHMGMT "['veh_mgmt', (_this select 0)] spawn AS_fnc_UI_createMenu"
#define NAV_ACT_AIMGMT "['ai_mgmt', (_this select 0)] spawn AS_fnc_UI_createMenu"
#define NAV_ACT_MONEY "['money', (_this select 0)] spawn AS_fnc_UI_createMenu"
#define NAV_ACT_RESIGN "closedialog 0; if (isMultiplayer) then {execVM ""orgPlayers\commResign.sqf""} else {hint ""This feature is MP Only""};"

#define NAV_TEXTS ["STR_UI_BM_NAV1_TEXT", "STR_UI_BM_NAV2_TEXT", "STR_UI_BM_NAV3_TEXT", "STR_UI_BM_NAV4_TEXT", "STR_UI_BM_NAV5_TEXT", "STR_UI_BM_NAV6_TEXT"]
#define NAV_TTS ["STR_UI_BM_NAV1_TT", "STR_UI_BM_NAV2_TT", "STR_UI_BM_NAV3_TT", "STR_UI_BM_NAV4_TT", "STR_UI_BM_NAV5_TT", "STR_UI_BM_NAV6_TT"]

// AI MGMT
#define ACT_AI_TEMPCTRL "closeDialog 0; if ((count groupselectedUnits player > 0) and (count hcSelected player > 0)) exitWith {hint 'You must select from HC or Squad Bars, not both'}; \
	if (count groupselectedUnits player == 1) then {[groupselectedUnits player] execVM 'REINF\controlunit.sqf'}; \
	if (count hcSelected player == 1) then {[hcSelected player] execVM 'REINF\controlHCsquad.sqf';};"
#define ACT_AI_AUTOHEAL "if (autoHeal) then {(_this select 0) ctrlSetTextColor [1,0,0,1]; autoHeal = false; ['STR_UI_AIMGMT_AH_TT_0'] call AS_fnc_UI_setTText;} \
	else {if (player == leader group player) then {autoHeal = true; (_this select 0) ctrlSetTextColor [0.18,0.545,0.341,1]; ['STR_UI_AIMGMT_AH_TT_1'] call AS_fnc_UI_setTText;}};"
#define ACT_AI_REARM "[] call AS_fnc_UI_clearMenu;; if (count groupselectedUnits player == 0) then {(units group player) execVM 'AI\rearmCall.sqf'} else {(groupselectedUnits player) execVM 'AI\rearmCall.sqf'};"
#define ACT_AI_DISMISS "[] call AS_fnc_UI_clearMenu;; if (count groupselectedUnits player > 0) then {[groupselectedUnits player] execVM 'REINF\dismissPlayerGroup.sqf'} else { \
	if (count (hcSelected player) > 0) then {[hcSelected player] execVM 'REINF\dismissSquad.sqf'}}; \
	if ((count groupselectedUnits player == 0) and (count hcSelected player == 0)) then {hint 'No units or squads selected'}"
// #define ACT_AI_SCAVENGE "[cursorTarget] spawn AS_fnc_startScavenging;"
#define ACT_AI_SCAVENGE "hint 'Coming soon™'"
#define ACT_AI_STORE "[] spawn AS_fnc_storeAllGear;"
#define ACT_AI_RESET "[] spawn AS_fnc_resetAIStatus;"

#define AI_TEXTS_L ["STR_UI_AIMGMT_TEMP_TEXT", "STR_UI_AIMGMT_AH_TEXT", "STR_UI_AIMGMT_AR_TEXT"]
#define AI_TEXTS_R ["STR_UI_AIMGMT_SCV_TEXT", "STR_UI_AIMGMT_STG_TEXT", "STR_UI_AIMGMT_RST_TEXT"]
#define AI_TEXTS_M "STR_UI_AIMGMT_DIS_TEXT"

#define AI_TOOLTIPS_L ["STR_UI_AIMGMT_TEMP_TT", "STR_UI_AIMGMT_AH_TT", "STR_UI_AIMGMT_AR_TT", "STR_UI_AIMGMT_DIS_TT"]
#define AI_TOOLTIPS_R ["STR_UI_AIMGMT_SCV_TT", "STR_UI_AIMGMT_STG_TT", "STR_UI_AIMGMT_RST_TT"]
#define AI_TOOLTIPS_M "STR_UI_AIMGMT_DIS_TT"

// VEH MGMT
#define ACT_VEH_PGAR "closeDialog 0; [false] call AS_fnc_garageVehicle;"
#define ACT_VEH_UNLOCK "closeDialog 0; if (player != Slowhand) then {[false] spawn AS_fnc_unlockVehicle} else {[true] spawn AS_fnc_unlockVehicle};"
#define ACT_VEH_FGAR "closeDialog 0; [true] call AS_fnc_garageVehicle;"
#define ACT_VEH_SELL "[] call AS_fnc_sellVehicle"

#define VEH_TEXTS ["STR_UI_VEHMGMT_PGAR_TEXT", "STR_UI_VEHMGMT_UNL_TEXT", "STR_UI_VEHMGMT_FGAR_TEXT", "STR_UI_VEHMGMT_SELL_TEXT"]
#define VEH_TOOLTIPS ["STR_UI_VEHMGMT_PGAR_TT", "STR_UI_VEHMGMT_UNL_TT", "STR_UI_VEHMGMT_FGAR_TT", "STR_UI_VEHMGMT_SELL_TT"]

// MONEY
#define ACT_MON_PLAYER "[true] call donateMoney;"
#define ACT_MON_FIA "[] call donateMoney;"

#define MON_TEXTS ["STR_UI_MONEY_PLY_TEXT", "STR_UI_MONEY_FIA_TEXT"]
#define MON_TOOLTIPS ["STR_UI_MONEY_PLY_TT", "STR_UI_MONEY_FIA_TT"]