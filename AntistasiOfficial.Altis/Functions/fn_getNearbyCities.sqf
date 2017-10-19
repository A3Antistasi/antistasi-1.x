params ["_marker"];
private ["_position", "_cities"];

_position = getMarkerPos _marker;
_cities = [];

for "_i" from 0 to (count ciudades - 1) do {
	if ((getMarkerPos (ciudades select _i)) distance _position < 3000) then {_cities set [count _cities,ciudades select _i]};
};

_cities = _cities - [_marker];
_cities