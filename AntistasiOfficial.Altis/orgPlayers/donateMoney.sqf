params [["_toPlayer",false]];
private ["_resourcesPlayer","_score","_target","_money"];

_resourcesPlayer = player getVariable ["dinero", 0];
if (_resourcesPlayer < 100) exitWith {hint localize "STR_HINTS_GEN_DONATE_FAIL"};

if !(_toPlayer) exitWith {
	[-100] call resourcesPlayer;
	[0,100] remoteExec ["resourcesFIA",2];
	_score = (player getVariable ["score",0]) + 1;
	player setVariable ["score",_score,true];
	hint localize "STR_HINTS_GEN_DONATE_FIA";
};

_target = cursortarget;
if (!isPlayer _target) exitWith {hint localize "STR_HINTS_GEN_DONATE_PLAYER_FAIL"};

[-100] call resourcesPlayer;
_money = player getVariable ["dinero",0];
_dinero = _target getVariable ["dinero",0];
_target setVariable ["dinero",_dinero + 100, true];
hint format [localize "STR_HINTS_GEN_DONATE_PLAYER", name _target];
