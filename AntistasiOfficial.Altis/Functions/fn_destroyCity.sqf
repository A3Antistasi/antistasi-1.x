params ["_marker"];
private ["_position","_size","_buildings"];

_position = getMarkerPos _marker;
_size = [_marker] call sizeMarker;
_buildings = _position nearobjects ["house", _size];

{
	if (random 100 < 70) then {
		for "_i" from 1 to 7 do {
			_x sethit [format ["dam%1",_i],1];
			_x sethit [format ["dam %1",_i],1];
		};
	} else {
		_x setDamage [1, false];
	};
} forEach _buildings;