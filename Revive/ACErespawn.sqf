params ["_player"];
_old = {
	sleep 5;
	player setVariable ["ACE_isUnconscious",false,true];
	player setDamage 0.9;
	player setVariable ["inconsciente",false,true];
	[player] spawn inconsciente;
};

sleep 15;
if !(_player getVariable ["inconsciente", false]) then {
	_player setVariable ["inconsciente",true,true];
	[] call _old;
};