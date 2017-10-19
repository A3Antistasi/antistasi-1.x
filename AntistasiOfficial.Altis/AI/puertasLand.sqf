private ["_veh","_puertas"];
_veh = _this select 0;

if (!alive _veh) exitWith {};
_puertas = [];

_tipo = typeOf _veh;
_helis = heli_unarmed;
_helis set [(count heli_unarmed - 1), nil];
call {
	if (_tipo in standardMRAP) exitWith {_puertas = ["Door_LF","Door_RF"]};
	if (_tipo in _helis) exitWith {_puertas = ["CargoRamp_Open","Door_Back_L","Door_Back_R"]};
	if (_tipo in bluHeliTS) exitWith {_puertas = ["DoorL_Front_Open","DoorR_Front_Open","DoorL_Back_Open","DoorR_Back_Open"]};
	if (_tipo in bluHeliDis) exitWith {_puertas = ["Door_L","Door_R"]};
	if (_tipo in bluHeliRope) exitWith {_puertas = ["Door_rear_source"]};
};

if (count _puertas == 0) exitWith {};

if (count _this > 1) then
	{
	sleep 30;
	waitUntil {sleep 1; (!alive _veh) or (speed _veh < 5)};
	};


{
waitUntil {(!alive _veh) or (_veh doorPhase _x == 0) or (_veh doorPhase _x == 1)}
} forEach _puertas;

if (!alive _veh) exitWith {};

_fase = _veh doorPhase (_puertas select 0);

if (_fase == 0) then {_fase = 1} else {_fase = 0};

{
_veh animateDoor [_x,_fase,false];
} forEach _puertas;

{
waitUntil {(!alive _veh) or (_veh doorPhase _x == 0) or (_veh doorPhase _x == 1)}
} forEach _puertas;

if (count _this > 1) then
	{
	waitUntil {sleep 1; (!alive _veh) or (speed _veh > 5)};
	if (alive _veh) then
		{
		{
		waitUntil {(!alive _veh) or (_veh doorPhase _x == 0) or (_veh doorPhase _x == 1)}
		} forEach _puertas;

		if (!alive _veh) exitWith {};

		_fase = _veh doorPhase (_puertas select 0);

		if (_fase == 0) then {_fase = 1} else {_fase = 0};

		{
		_veh animateDoor [_x,_fase,false];
		} forEach _puertas;
		};
	};