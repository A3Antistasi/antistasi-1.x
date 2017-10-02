params ["_position"];
private ["_position","_counter","_probe","_intersec","_zi","_zf","_vel"];

_position = _position findEmptyPosition [1,30,"I_G_Mortar_01_F"];
if (count _position == 0) then {_position = _this select 0};

_probe = statMortar createVehicleLocal _position;
_probe setpos [_position select 0,_position select 1,(_position select 2) + 60];
_counter = 300;
while {_counter > 0} do {
	_intersec = false;
	_zi = _position select 2;
	_probe setVelocity [0, 0 , -60];
	waitUntil {_vel = (velocity _probe) select 2; (_vel < 1) and (_vel > -1)};
    _zf = getposATL _probe select 2;
    if (_zf - _zi > 1) then {_intersec = true};
	if (not _intersec) exitWith {};
	_position = _position getPos [31,random 360];
	_probe setpos [_position select 0,_position select 1,(_position select 2) + 60];
	_counter = _counter - 1;
};
if (_counter == 0) then {_position = (_this select 0) findEmptyPosition [1,30,"I_G_Mortar_01_F"]};
deleteVehicle _probe;
if (count _position == 0) then {_position = [0,0,0]};
_position