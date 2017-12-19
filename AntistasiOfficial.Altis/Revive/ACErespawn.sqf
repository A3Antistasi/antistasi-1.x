params ["_player"];
_old = {
	sleep 5;
	[player, false] call AS_fnc_setUnconscious;
	[player] spawn medUnconscious;
};

sleep 15;
if !([_player] call AS_fnc_isUnconscious) then {
	[player, true] call AS_fnc_setUnconscious;
	[] call _old;
};