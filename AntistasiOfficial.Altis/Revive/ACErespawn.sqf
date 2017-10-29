params ["_player"];
_old = {
	sleep 5;
	player setVariable ["ACE_isUnconscious",false,true];
	player setDamage 0.9;
	player setVariable ["ASunconscious",false,true];
	[player] spawn medUnconscious;
};

sleep 15;
if !(_player getVariable ["ASunconscious", false]) then {
	_player setVariable ["ASunconscious",true,true];
	[] call _old;
};