if (!isServer and hasInterface) exitWith {};

private ["_prestigio","_marcador","_posicion","_tiempolim","_fechalim","_fechalimnum","_nombredest","_tsk","_soldados","_vehiculos","_grupo","_tipoVeh","_cuenta","_size"];

_prestigio = server getVariable "prestigeNATO";

_marcador = _this select 0;
_posicion = getMarkerPos _marcador;

[-10,0] remoteExec ["prestige",2];

_tiempolim = _prestigio;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombredest = [_marcador] call AS_fnc_localizar;

_tsk = ["NATOArty",[west,civilian],[format ["We have %4 Artillery support from %1. They will be under our command until %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, A3_Str_BLUE],format ["%1 Artillery", A3_Str_BLUE],_marcador],_posicion,"CREATED",5,true,true,"target"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

_size = [_marcador] call sizeMarker;
_soldados = [];
_vehiculos = [];
_grupo = createGroup side_blue;
_tipoVeh = selectRandom bluStatMortar;
_grupo setVariable ["esNATO",true,true];
_cuenta = 1;
_spread = 0;
if (_prestigio < 33) then
	{
	_cuenta = 4;
	_spread = 15;
	}
else
	{
	if (_prestigio < 66) then {_tipoVeh = selectRandom bluArty} else {_cuenta = 2; _spread = 20; _tipoVeh = selectRandom bluMLRS};
	};
for "_i" from 1 to _cuenta do
	{
	_unit = ([_posicion, 0, bluGunner, _grupo] call bis_fnc_spawnvehicle) select 0;
	[_unit] spawn NATOinitCA;
	sleep 1;
	_pos = [_marcador, "base_4", true] call AS_fnc_findSpawnSpots;
	_veh = createVehicle [_tipoVeh, _pos, [], _spread, "NONE"];
	[_veh] spawn NATOvehInit;
	sleep 1;
	_unit moveInGunner _veh;
	_soldados pushBack _unit;
	_vehiculos pushBack _veh;
	sleep 2;
	};
_grupo setGroupOwner (owner Slowhand);
_grupo setGroupId ["N.Arty"];
Slowhand hcSetGroup [_grupo];
_grupo setVariable ["isHCgroup", true, true];
//{[_x] spawn unlimitedAmmo} forEach _vehiculos;

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or ({alive _x} count _vehiculos == 0)};

if ({alive _x} count _vehiculos == 0) then
	{
	[-5,0] remoteExec ["prestige",2];

	_tsk = ["NATOArty",[west,civilian],[format ["We have %4 Artillery support from %1. They will be under our command until %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4, A3_Str_BLUE],format ["%1 Artillery", A3_Str_BLUE],_marcador],_posicion,"FAILED",5,true,true,"target"] call BIS_fnc_setTask;
	};

//[_tsk,true] call BIS_fnc_deleteTask;
[0,_tsk] spawn borrarTask;

{deleteVehicle _x} forEach _soldados;
{deleteVehicle _x} forEach _vehiculos;
deleteGroup _grupo;