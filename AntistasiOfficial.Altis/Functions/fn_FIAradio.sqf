private ["_chance","_position","_marker"];

_chance = 5;
{_position = getPos _x;
	_marker = [markers,_position] call BIS_fnc_nearestPosition;
	if (!(_marker in mrkAAF) and (alive _x)) then {_chance = _chance + 2.25};
} forEach antenas;

if (debug) then {_chance = 100};

if (random 100 < _chance) then {
	if (not revelar) then {
		{["TaskSucceeded", ["", "AAF Comms Intercepted"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		revelar = true; publicVariable "revelar";
		[[], "revealToPlayer.sqf"] remoteExec ["execVM", [0,-2] select isDedicated, true];
	};
} else {
	if (revelar) then {
		{["TaskFailed", ["", "AAF Comms Lost"]] call BIS_fnc_showNotification} remoteExec ["call", 0];
		revelar = false; publicVariable "revelar";
	};
};