if (!isServer and hasInterface) exitWith {false};

params ["_marker","_base"];
private ["_basePos","_markerPos","_targetDir","_direction","_counter","_distance","_position","_nearestZone","_size","_road","_mine"];

if (spawner getVariable _base) exitWith {false};

_basePos = getMarkerPos _base;
_markerPos = getMarkerPos _marker;
_targetDir = [_basePos,_markerPos] call BIS_fnc_dirTo;
_targetDir = _targetDir - 45;
_direction = _targetDir + random 90;
_counter = 1;
_distance = 500;

_areaFound = true;
while {_counter < 37} do {
	_position = [_basePos, _distance, _direction] call BIS_Fnc_relPos;
	if (!surfaceIsWater _position) then {
		_nearestZone = [markers,_position] call BIS_fnc_nearestPosition;
		if !(spawner getVariable _nearestZone) then {
			_size = [_nearestZone] call sizeMarker;
			if ((_position distance (getMarkerPos _nearestZone)) > (_size + 100)) then {
				_road = [_position,101] call BIS_fnc_nearestRoad;
				if (isNull _road) then {
					if ({_x distance _position < 100} count allMines == 0) then {
						_areaFound = false;
					};
				};
			};
		};
	};

	if !(_areaFound) exitWith {};
	_counter = _counter + 1;
	_direction = _direction - 10;
};

if (_areaFound) exitWith {false};

for "_i" from 1 to 60 do {
	_mine = createMine [apMine_placed,_position,[],100];
	side_green revealMine _mine;
};

true