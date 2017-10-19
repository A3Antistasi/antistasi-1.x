params ["_origin","_destination",["_maxRadius",250]];
private ["_roadA","_roadB","_roadC","_targetRoad","_spawnPos"];

[[],false,20] params ["_roadArray","_roadsFound","_radius"];

if (typeName _origin == "STRING") then {
	_origin = getMarkerPos _origin
};

if (typeName _destination == "STRING") then {
	_destination = getMarkerPos _destination
};

while {_radius < _maxRadius} do {
	_roadArray = _origin nearRoads _radius;
	if (count _roadArray > 2) exitWith {
		_roadsFound = true;
	};
	_radius = _radius + 20;
};

if !(_roadsFound) exitWith {[]};

_roadA = _roadArray select 0;
_roadB = _roadArray select 1;
_roadC = _roadArray select 2;

_spawnPos = position _roadA;
_targetRoad = _roadB;

if (((position _roadA) distance _destination) < ((position _roadB) distance _destination)) then {
	_spawnPos = position _roadB;
	_targetRoad = _roadA;
};

if (((position _roadC) distance _destination) < ((position _targetRoad) distance _destination)) then {
	_spawnPos = position _targetRoad;
	_targetRoad = _roadC;
};

[_spawnPos, [_spawnPos, _targetRoad] call BIS_fnc_DirTo]