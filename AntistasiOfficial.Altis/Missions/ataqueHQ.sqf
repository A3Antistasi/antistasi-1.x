if (!isServer and hasInterface) exitWith {};

_tskTitle = "STR_TSK_TD_HQATTACK";
_tskDesc = "STR_TSK_TD_DESC_HQATTACK";

_posicion = getMarkerPos guer_respawn;

_pilotos = [];
_vehiculos = [];
_grupos = [];
_soldados = [];

if (server getVariable "blockCSAT") exitWith {};

if ({(_x distance _posicion < 500) and ((typeOf _x == guer_stat_AA) or (typeOf _x == statAA))} count staticsToSave > 4) exitWith {};

_tsk = ["DEF_HQ",[side_blue,civilian],[_tskDesc,_tskTitle,guer_respawn],_posicion,"CREATED",5,true,true,"Defend"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

_pos = [_posicion, distanciaSPWN * 3, random 360] call BIS_Fnc_relPos;
_vehicle=[_pos, 0, opGunship, side_red] call bis_fnc_spawnvehicle;
_heli = _vehicle select 0;
_heliCrew = _vehicle select 1;
_grupoheli = _vehicle select 2;
_pilotos = _pilotos + _heliCrew;
_grupos = _grupos + [_grupoheli];
_vehiculos = _vehiculos + [_heli];
[_heli] spawn CSATVEHinit;
{[_x] spawn CSATinit} forEach _heliCrew;
_wp1 = _grupoheli addWaypoint [_posicion, 0];
_wp1 setWaypointType "SAD";
[_heli,"CSAT Air Attack"] spawn inmuneConvoy;
sleep 30;

for "_i" from 0 to (round random 2) do
	{
	_pos = [_posicion, distanciaSPWN * 3, random 360] call BIS_Fnc_relPos;
	_vehicle=[_pos, 0, opHeliFR, side_red] call bis_fnc_spawnvehicle;
	_heli = _vehicle select 0;
	_heliCrew = _vehicle select 1;
	_grupoheli = _vehicle select 2;
	_pilotos = _pilotos + _heliCrew;
	_grupos = _grupos + [_grupoheli];
	_vehiculos = _vehiculos + [_heli];

	{_x setBehaviour "CARELESS";} forEach units _grupoheli;
	_tipoGrupo = [opGroup_SpecOps, side_red] call AS_fnc_pickGroup;
	_grupo = [_pos, side_red, _tipoGrupo] call BIS_Fnc_spawnGroup;
	{_x assignAsCargo _heli; _x moveInCargo _heli; _soldados = _soldados + [_x]; [_x] spawn CSATinit} forEach units _grupo;
	_grupos = _grupos + [_grupo];
	[_heli,"CSAT Air Transport"] spawn inmuneConvoy;
	[_heli,_grupo,_posicion,_pos,_grupoheli] spawn fastropeCSAT;
	sleep 10;
	};

waitUntil {sleep 1;({not (captive _x)} count _soldados < {captive _x} count _soldados) or ({alive _x} count _soldados < {fleeing _x} count _soldados) or ({alive _x} count _soldados == 0) or (_posicion distance getMarkerPos guer_respawn > 999) or !(alive petros)};

call {
	if !(alive petros) exitWith {
		_tsk = ["DEF_HQ",[side_blue,civilian],[_tskDesc,_tskTitle,guer_respawn],_posicion,"FAILED",5,true,true,"Defend"] call BIS_fnc_setTask;
	};

	if (_posicion distance getMarkerPos guer_respawn > 999) exitWith {
		_tsk = ["DEF_HQ",[side_blue,civilian],[_tskDesc,_tskTitle,guer_respawn],_posicion,"SUCCEEDED",5,true,true,"Defend"] call BIS_fnc_setTask;
	};

	_tsk = ["DEF_HQ",[side_blue,civilian],[_tskDesc,_tskTitle,guer_respawn],_posicion,"SUCCEEDED",5,true,true,"Defend"] call BIS_fnc_setTask;
	[0,0] remoteExec ["prestige",2];
	[0,300] remoteExec ["resourcesFIA",2];
	{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"BLUFORSpawn"] call distanceUnits);
};


[1200,_tsk] spawn borrarTask;
{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)};
deleteVehicle _x;
} forEach _soldados;
{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)};
deleteVehicle _x;
} forEach _pilotos;
{
if (!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)) then {deleteVehicle _x};
} forEach _vehiculos;
{deleteGroup _x} forEach _grupos;