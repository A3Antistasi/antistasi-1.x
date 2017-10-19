if (!hasInterface) exitWith {};

params ["_unit","_tipo","_texto"];

if (_tipo == "sideChat") then
	{
	_unit sideChat format ["%1", _texto];
	};
if (_tipo == "hint") then {hint format ["%1",_texto]};
if (_tipo == "hintCS") then {hintC format ["%1",_texto]};
if (_tipo == "globalChat") then
	{
	_unit globalChat format ["%1", _texto];
	};

if (_tipo == "income") then
	{
	waitUntil {sleep 0.2; !incomeRep};
	incomeRep = true;
	//playSound3D ["a3\sounds_f\sfx\beep_target.wss", player];
	playSound "3DEN_notificationDefault";
	//[_texto,0.8,0.5,5,0,0,2] spawn bis_fnc_dynamicText;
	[_texto, [safeZoneX + (0.8 * safeZoneW), (0.2 * safeZoneW)], 0.5, 5, 0, 0, 2] spawn bis_fnc_dynamicText;
	incomeRep = false;
	};

if (_tipo == "countdown") then
	{
	_texto = format ["Time Remaining: %1 secs",_texto];
	hint format ["%1",_texto];
	};

if (_tipo == "taxRep") then
	{
	incomeRep = true;
	playSound "3DEN_notificationDefault";
	//playSound3D ["a3\sounds_f\sfx\beep_target.wss", player];
	//[_texto,0.8,0.5,5,0,0,2] spawn bis_fnc_dynamicText;
	[_texto, [safeZoneX + (0.8 * safeZoneW), (0.2 * safeZoneW)], 0.5, 5, 0, 0, 2] spawn bis_fnc_dynamicText;
	sleep 10;
	incomeRep = false;
	};

if (_tipo == "BE") then {
	sleep 0.5;
	"AXP Details" hintC (_texto);
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		0 = _this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};

if (_tipo == "status") then {
	sleep 0.5;
	"FIA Details" hintC (_texto);
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		0 = _this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};

if (_tipo == "save") then {
	sleep 0.5;
	(localize "STR_HINTS_SAVE_COM_TITLE") hintC (_texto);
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		0 = _this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};