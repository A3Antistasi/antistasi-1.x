private ["_unit"];
//esto habrá que meterlo en onplayerrespawn también
_unit = _this select 0;
_unit setVariable ["ASunconscious",false,true];

_unit setVariable ["ASrespawning",false];
_unit addEventHandler ["HandleDamage", handleDamage];
