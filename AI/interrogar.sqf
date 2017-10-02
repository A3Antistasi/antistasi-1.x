_unit = _this select 0;
_jugador = _this select 1;

[[_unit,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
if (!alive _unit) exitWith {};

_jugador globalChat "You souvlaki! Tell me what you know!";

_chance = (server getVariable "prestigeNATO") - (server getVariable "prestigeCSAT");

_chance = _chance + 20;

if (_chance < 20) then {_chance = 20};

sleep 5;

if (round random 100 < _chance) then
	{
	_unit globalChat "Okay, I'll tell you everything I know";
	[_unit] execVM "intelFound.sqf";
	}
else
	{
	_unit globalChat "Screw you!";
	};

