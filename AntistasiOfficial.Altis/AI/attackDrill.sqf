private ["_marcador","_grupo","_posicion","_size"];

_marcador = _this select 0;
_grupo = _this select 1;

_posicion = getMarkerPos _marcador;

_size = [_marcador] call sizeMarker;

waitUntil {sleep 5; (leader _grupo distance _posicion < _size) or ({alive _x} count units _grupo == 0)};

if (leader _grupo distance _posicion < _size) then
	{
	[leader _grupo, _marcador, "COMBAT","SPAWNED","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	};