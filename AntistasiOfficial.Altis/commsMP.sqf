if (!hasInterface) exitWith {};

params ["_unit","_tipo","_texto"];

if (_tipo == "sideChat") exitWith
	{
	_unit sideChat format ["%1", localize _texto];
	};
if (_tipo == "hint") exitWith {hint format ["%1", localize _texto]};
if (_tipo == "hintCS") exitWith {hintC format ["%1", localize _texto]};
if (_tipo == "globalChat") exitWith
	{
	_unit globalChat format ["%1", localize _texto];
	};

if (_tipo == "income") exitWith
	{
	waitUntil {sleep 0.2; !incomeRep};
	incomeRep = true;
	//playSound3D ["a3\sounds_f\sfx\beep_target.wss", player];
	playSound "3DEN_notificationDefault";
	//[_texto,0.8,0.5,5,0,0,2] spawn bis_fnc_dynamicText;
	[localize _texto, [safeZoneX + (0.8 * safeZoneW), (0.2 * safeZoneW)], 0.5, 5, 0, 0, 2] spawn bis_fnc_dynamicText;
	incomeRep = false;
	};

if (_tipo == "countdown") exitWith
	{
	_texto = format ["Time Remaining: %1 secs",_texto];
	hint format ["%1",_texto];
	};

if (_tipo == "taxRep") exitWith
	{
	incomeRep = true;
	playSound "3DEN_notificationDefault";
	//playSound3D ["a3\sounds_f\sfx\beep_target.wss", player];
	//[_texto,0.8,0.5,5,0,0,2] spawn bis_fnc_dynamicText;
	[localize _texto, [safeZoneX + (0.8 * safeZoneW), (0.2 * safeZoneW)], 0.5, 5, 0, 0, 2] spawn bis_fnc_dynamicText;
	sleep 10;
	incomeRep = false;
	};

if (_tipo == "BE") exitWith {
	sleep 0.5;
	"AXP Details" hintC (localize _texto);
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		0 = _this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};

if (_tipo == "status") exitWith {
	sleep 0.5;
	"FIA Details" hintC (localize _texto);
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		0 = _this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};

if (_tipo == "save") exitWith {
	sleep 0.5;
	(localize "STR_HINTS_SAVE_COM_TITLE") hintC (localize _texto);
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		0 = _this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};