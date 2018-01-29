params ["_marker", ["_min", 2000],["_max", 2500]];
private ["_position", "_cities"];

_position = getMarkerPos _marker;
_cities = [];

for "_i" from 0 to (count ciudades - 1) do {
    private _dest = (getMarkerPos (ciudades select _i));
	if ((_dest distance _position > _min) AND (_dest distance _position < _max)) then {_cities set [count _cities,ciudades select _i]};
};

_cities = _cities - [_marker];
_cities