disableSerialization;

params [["_restart", false]];

_display = findDisplay 100;
_display displayRemoveEventHandler ["KeyDown", A3AS_menu_escEH];

if (_restart) exitWith {
	switchCom = false; publicVariable 'switchCom';
	{miembros pushBack (getPlayerUID _x)} forEach playableUnits; publicVariable 'miembros';
	closedialog 100;

	if ((isNil 'statsLoaded') && (isNil 'placementDone')) then {
		[] spawn placementSelection;
	};
};

call {
	if (ctrlChecked (_display displayCtrl 2500)) then {
		switchCom = true; publicVariable 'switchCom';
	};
	if !(ctrlChecked (_display displayCtrl 2501)) then {
		{miembros pushBack (getPlayerUID _x)} forEach playableUnits;
		publicVariable 'miembros';
	};
	if !(ctrlChecked (_display displayCtrl 2502)) exitWith {
		//disableUserInput true;
		(_display displayCtrl 1600) ctrlEnable false;
		['STR_UI_SM_TEXTF_LOADING'] call AS_fnc_UI_setTText;
		[] remoteExec ["AS_fnc_loadGame",2];
		//placementDone = true; publicVariable 'placementDone';
		waitUntil {sleep 0.5; !(isNil "ASA3_saveLoaded")};
		ASA3_saveLoaded = nil;
		['STR_UI_SM_TEXTF_LOADED'] call AS_fnc_UI_setTText;
		sleep 2;
		//disableUserInput false;
	};
	if (ctrlChecked (_display displayCtrl 2503)) then {
		[[], 'boost.sqf'] remoteExec ['execVM', 2];
	};
};

closedialog 100;

if ((isNil 'statsLoaded') && (isNil 'placementDone')) then {
	[] spawn placementSelection;
};