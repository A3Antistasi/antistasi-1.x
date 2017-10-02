params ["_marker", "_on"];
private ["_damage","_lamps","_position","_size"];

_position = getMarkerPos _marker;
_damage = [0.95, 0] select _on;

_size = (markerSize _marker) select 0;

for "_i" from 0 to ((count lamptypes) -1) do {
	_lamps = _position nearObjects [lamptypes select _i, _size];
	{sleep 0.3; _x setDamage _damage} forEach _lamps;
};