private ["_destino","_origen","_tam","_dif","_roads","_road","_dist","_result","_threat"];

_destino = _this select 0;
_origen = _this select 1;
_threat = _this select 2;
_tam = 400 + (10*_threat);
_dif = (_destino select 2) - (_origen select 2);

if (_dif > 0) then
	{
	_tam = _tam + (_dif * 2);
	};

while {true} do
	{
	_roads = _destino nearRoads _tam;
	if (count _roads == 0) then {_tam = _tam + 50};
	if (count _roads > 0) exitWith {};
	};

_road = _roads select 0;
_dist = _origen distance (position _road);
{
if ((_origen distance (position _x)) < _dist) then
	{
	_dist = _origen distance (position _x);
	_road = _x;
	};
} forEach _roads - [_road];

_result = position _road;

_result