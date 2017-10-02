#define MENU_TEXT_COLOR_TRUE [0.18,0.545,0.341,1]

createDialog "menu_startGame";
A3AS_menu_escEH = (findDisplay 100) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then {[true] execVM 'UI\startGame.sqf'; true} else {if ((_this select 1) == 28) then {[] execVM 'UI\startGame.sqf'; true}}"];
((findDisplay 100) displayCtrl 2503) ctrlShow false;

{
	((findDisplay 100) displayCtrl _x) ctrlEnable false;
} forEach [1301, 1302, 1303, 1304];

if !(enableRestart) then {
	((findDisplay 100) displayCtrl 2502) ctrlEnable false;
};

if (activeACE) then {
	((findDisplay 100) displayCtrl 1301) ctrlSetTextColor MENU_TEXT_COLOR_TRUE;
	((findDisplay 100) displayCtrl 1301) ctrlAddEventHandler ["MouseEnter", "['STR_UI_SM_ACE_TT'] call AS_fnc_UI_setTText;"];
	((findDisplay 100) displayCtrl 1301) ctrlEnable true;
};
if (activeTFAR) then {
	((findDisplay 100) displayCtrl 1302) ctrlSetTextColor MENU_TEXT_COLOR_TRUE;
	((findDisplay 100) displayCtrl 1302) ctrlAddEventHandler ["MouseEnter", "['STR_UI_SM_TFAR_TT'] call AS_fnc_UI_setTText;"];
	((findDisplay 100) displayCtrl 1302) ctrlEnable true;
};
if (activeAFRF) then {
	((findDisplay 100) displayCtrl 1303) ctrlSetTextColor MENU_TEXT_COLOR_TRUE;
	((findDisplay 100) displayCtrl 1303) ctrlAddEventHandler ["MouseEnter", "['STR_UI_SM_AFRF_TT'] call AS_fnc_UI_setTText;"];
	((findDisplay 100) displayCtrl 1303) ctrlEnable true;
};
if (activeUSAF) then {
	((findDisplay 100) displayCtrl 1304) ctrlSetTextColor MENU_TEXT_COLOR_TRUE;
	((findDisplay 100) displayCtrl 1304) ctrlAddEventHandler ["MouseEnter", "['STR_UI_SM_USAF_TT'] call AS_fnc_UI_setTText;"];
	((findDisplay 100) displayCtrl 1304) ctrlEnable true;
};
if (replaceFIA) then {
	((findDisplay 100) displayCtrl 1303) ctrlSetTextColor MENU_TEXT_COLOR_TRUE;
	((findDisplay 100) displayCtrl 1303) ctrlSetText "RHS Complete";
	((findDisplay 100) displayCtrl 1303) ctrlAddEventHandler ["MouseEnter", "['STR_UI_SM_RHS_TT'] call AS_fnc_UI_setTText;"];
	((findDisplay 100) displayCtrl 1303) ctrlEnable true;
	((findDisplay 100) displayCtrl 1304) ctrlShow false;
};
