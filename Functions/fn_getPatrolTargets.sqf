params ["_markers"];
private ["_array","_position","_marker"];

_array = _markers - colinas - controles - ["puesto_13"];

{
	if ((getMarkerPos guer_respawn) distance (getMarkerPos _x) > 3000) then {
		_array = _array - [_x];
	};
} forEach _markers;

_array