if (!hasInterface) exitWith {};

params ["_unit","_tipo","_texto"];

if (_tipo == "sideChat") exitWith {_unit sideChat _texto;};

if (_tipo == "locSideChat") exitWith {_unit sideChat localize _texto;};

if (_tipo == "hint") exitWith {hint _texto;};

if (_tipo == "locHint") exitWith {hint localize _texto;};

if (_tipo == "hintCS") exitWith {hintC _texto;}; //not using

if (_tipo == "globalChat") exitWith {_unit globalChat _texto;};

if (_tipo == "locGlobalChat") exitWith {_unit globalChat localize _texto;};

if (_tipo == "income") exitWith {
	waitUntil {sleep 0.2; !incomeRep};
	incomeRep = true;
	//playSound3D ["a3\sounds_f\sfx\beep_target.wss", player];
	playSound "3DEN_notificationDefault";
	//[_texto,0.8,0.5,5,0,0,2] spawn bis_fnc_dynamicText;
	[_texto, [safeZoneX + (0.8 * safeZoneW), (0.2 * safeZoneW)], 0.5, 5, 0, 0, 2] spawn bis_fnc_dynamicText;
	incomeRep = false;
};

if (_tipo == "countdown") exitWith {hint format ["Time Remaining: %1 secs",_texto];};

if (_tipo == "taxRep") exitWith {
	incomeRep = true;
	playSound "3DEN_notificationDefault";
	//playSound3D ["a3\sounds_f\sfx\beep_target.wss", player];
	//[_texto,0.8,0.5,5,0,0,2] spawn bis_fnc_dynamicText;
	[_texto, [safeZoneX + (0.8 * safeZoneW), (0.2 * safeZoneW)], 0.5, 5, 0, 0, 2] spawn bis_fnc_dynamicText;
	sleep 10;
	incomeRep = false;
};

if (_tipo == "BE") exitWith {
	sleep 0.5;
	"AXP Details" hintC _texto;
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		0 = _this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};

if (_tipo == "status") exitWith {
	sleep 0.5;
	"FIA Details" hintC _texto;
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		0 = _this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};

if (_tipo == "save") exitWith {
	sleep 0.5;
	"Progress Saved" hintC  [localize "STR_HINTS_SAVE_COM_1", localize "STR_HINTS_SAVE_COM_2",localize "STR_HINTS_SAVE_COM_3",localize "STR_HINTS_SAVE_COM_4"];
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		0 = _this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};