params ["_marker", ["_force", false]];
private ["_marker","_position","_airportsAAF","_airports","_airport","_posAirport","_radio"];

_position = _this select 0;
if (typeName _marker == typeName "") then {_position = getMarkerPos _marker};

_airportsAAF = aeropuertos - mrkFIA;
_airports = [];
_airport = "";

{
	_airport = _x;
	_busy = [true, false] select (dateToNumber date > server getVariable _airport);
	_posAirport = getMarkerPos _airport;
	if (_force) then {_radio = true} else {_radio = [_airport] call AS_fnc_radioCheck};
	if ((_position distance _posAirport < 10000) and (_position distance _posAirport > 2000) and !(spawner getVariable _airport) and !(_busy) and (_radio)) then {_airports pushBackUnique _airport};
} forEach _airportsAAF;

if (count _airports > 0) then {[_airports,_position] call BIS_fnc_nearestPosition} else {""}