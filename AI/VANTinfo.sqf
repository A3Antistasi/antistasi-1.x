private ["_veh","_marcador","_posicion","_grupos","_conocidos","_grupo","_lider"];

_veh = _this select 0;
_marcador = _this select 1;

_posicion = getMarkerPos _marcador;

while {alive _veh} do
	{
	_conocidos = [];
	_grupos = [];
	_enemigos = [distanciaSPWN,0,_posicion,"OPFORSpawn"] call distanceUnits;
	sleep 60;
	{
	_lider = leader _x;
	if ((_lider in _enemigos) and (vehicle _lider != _lider)) then {_grupos pushBack _x};
	} forEach allGroups;
	{
	if ((side _x == side_blue) and (alive _x) and (_x distance _posicion < 500)) then
		{
		_conocidos pushBack _x;
		};
	} forEach allUnits;
	{
	_grupo = _x;
		{
		_grupo reveal [_x,4];
		} forEach _conocidos;
	} forEach _grupos;

	};