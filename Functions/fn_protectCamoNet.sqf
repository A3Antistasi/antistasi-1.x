params ["_camoNet"];
private ["_cEH", "_currentPos"];

if (_camoNet getVariable ["AS_protected", false]) exitWith {diag_log format ["protectCamoNet -- net already protected: %1", _camoNet]};

_camoNet setVariable ["AS_protected", true, true];
_cEH = _camoNet addEventHandler ["HandleDamage", {diag_log format ["net: %1; cause: %2", _this select 0, _this select 3]; if !(side (_this select 3) == side_blue) then {false} else {true}}];
[_camoNet] spawn AS_fnc_protectVehicle;
_currentPos = position _camoNet;
sleep 10;
_camoNet setPos [_currentPos select 0, _currentPos select 1, 0];

waitUntil {!(_camoNet getVariable ["AS_protected", false]) or (isNull _camoNet)};

if !(isNull _camoNet) then {_camoNet removeEventHandler ["HandleDamage", _cEH]};