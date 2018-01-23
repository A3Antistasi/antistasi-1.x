if (!isServer) exitWith{};

private ["_marcador","_pos","_equis","_cuenta","_y"];

_marcador = _this select 0;
_pos = getMarkerPos _marcador;
_equis = _pos select 0;
_y = _pos select 1;
_cuenta = 0;


_shell1 = "Sh_82mm_AMOS" createVehicle [_equis,_y,200];
_shell1 setVelocity [0,0,-50];


