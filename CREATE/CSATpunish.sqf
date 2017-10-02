if (!isServer and hasInterface) exitWith {};
private ["_posorigen","_tipogrupo","_nombreorig","_markTsk","_wp1","_soldados","_landpos","_pad","_vehiculos","_wp0","_wp3","_wp4","_wp2","_grupo","_grupos","_tipoveh","_vehicle","_heli","_heliCrew","_grupoheli","_pilotos","_rnd","_resourcesAAF","_nVeh","_tam","_roads","_Vwp1","_tanques","_road","_veh","_vehCrew","_grupoVeh","_Vwp0","_size","_Hwp0","_grupo1","_uav","_grupouav","_uwp0","_tsk","_vehiculo","_soldado","_piloto","_mrkdestino","_posdestino","_prestigeCSAT","_base","_aeropuerto","_nombredest","_tiempo","_solMax","_pos","_timeOut"];
_mrkDestino = _this select 0;

forcedSpawn = forcedSpawn + [_mrkDestino]; publicVariable "forcedSpawn";

_posdestino = getMarkerPos _mrkDestino;

_grupos = [];
_soldados = [];
_pilotos = [];
_vehiculos = [];
_civiles = [];

_nombredest = [_mrkDestino] call AS_fnc_localizar;
_tsk = ["AtaqueAAF",[side_blue,civilian],[format ["CSAT is making a punishment expedition to %1. They will kill everybody there. Defend the city at all costs",_nombredest],"CSAT Punishment",_mrkDestino],getMarkerPos _mrkDestino,"CREATED",10,true,true,"Defend"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";
//Ataque de artillería
[_mrkdestino] spawn artilleria;

_tiempo = time + 3600;

_posorigen = getMarkerPos "spawnCSAT";

for "_i" from 1 to 3 do
	{
	_tipoveh = opAir call BIS_fnc_selectRandom;
	_timeOut = 0;
	_pos = _posorigen findEmptyPosition [0,100,_tipoveh];
	while {_timeOut < 60} do
		{
		if (count _pos > 0) exitWith {};
		_timeOut = _timeOut + 1;
		_pos = _posorigen findEmptyPosition [0,100,_tipoveh];
		sleep 1;
		};
	if (count _pos == 0) then {_pos = _posorigen};
	_vehicle=[_pos, 0, _tipoveh, side_red] call bis_fnc_spawnvehicle;
	_heli = _vehicle select 0;
	_heli setVariable ["BLUFORSpawn",false];
	_heliCrew = _vehicle select 1;
	_grupoheli = _vehicle select 2;
	_pilotos = _pilotos + _heliCrew;
	_grupos = _grupos + [_grupoheli];
	_vehiculos = _vehiculos + [_heli];
	//_heli lock 3;
	if (_tipoveh != opHeliFR) then
		{
		{[_x] spawn CSATinit} forEach _heliCrew;
		_wp1 = _grupoheli addWaypoint [_posdestino, 0];
		_wp1 setWaypointType "SAD";
		[_heli,"CSAT Air Attack"] spawn inmuneConvoy;
		}
	else
		{
		{_x setBehaviour "CARELESS";} forEach units _grupoheli;
		_tipoGrupo = [opGroup_Squad, side_red] call AS_fnc_pickGroup;
		_grupo = [_posorigen, side_red, _tipoGrupo] call BIS_Fnc_spawnGroup;
		{_x assignAsCargo _heli; _x moveInCargo _heli; _soldados = _soldados + [_x]; [_x] spawn CSATinit} forEach units _grupo;
		_grupos = _grupos + [_grupo];
		[_heli,"CSAT Air Transport"] spawn inmuneConvoy;

		if (random 100 < 50) then
			{
			{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _grupoheli;
			_landpos = [];
			_landpos = [_posdestino, 300, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
			_landPos set [2, 0];
			_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
			_vehiculos = _vehiculos + [_pad];
			_wp0 = _grupoheli addWaypoint [_landpos, 0];
			_wp0 setWaypointType "TR UNLOAD";
			_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT'"];
			[_grupoheli,0] setWaypointBehaviour "CARELESS";
			_wp3 = _grupo addWaypoint [_landpos, 0];
			_wp3 setWaypointType "GETOUT";
			_wp0 synchronizeWaypoint [_wp3];
			_wp4 = _grupo addWaypoint [_posdestino, 1];
			_wp4 setWaypointType "SAD";
			_wp2 = _grupoheli addWaypoint [_posorigen, 1];
			_wp2 setWaypointType "MOVE";
			_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
			[_grupoheli,1] setWaypointBehaviour "AWARE";
			}
		else
			{[_heli,_grupo,_posdestino,_posorigen,_grupoheli] spawn fastropeCSAT;}
		};
	sleep 20;
	};

_datos = server getVariable _mrkDestino;

_numCiv = _datos select 0;
_numCiv = round ((_numCiv * civPerc)/2);

if (_numCiv < 8) then {_numCiv = 8};

_size = [_mrkDestino] call sizeMarker;
_grupoCivil = createGroup side_blue;
_grupos pushBack _grupoCivil;

for "_i" from 0 to _numCiv do
	{
	_pos = _posdestino getPos [_size,random 360];
	_civ = _grupoCivil createUnit [CIV_units call BIS_fnc_selectRandom,_pos, [],_size,"NONE"];
	_rnd = random 100;
	if (_rnd < 90) then
		{
		if (_rnd < 25) then {[_civ, "hgun_PDW2000_F", 5, 0] call BIS_fnc_addWeapon;} else {[_civ, "hgun_Pistol_heavy_02_F", 5, 0] call BIS_fnc_addWeapon;};
		};
	_civiles pushBack _civ;
	[_civ] spawn civInit;
	sleep 1;
	};

[leader _grupoCivil, _mrkDestino, "AWARE","SPAWNED","NOVEH2"] execVM "scripts\UPSMON.sqf";

_civilMax = {alive _x} count _civiles;
_solMax = count _soldados;


for "_i" from 0 to round random 2 do
	{
	[_mrkdestino, selectRandom opCASFW] spawn airstrike;
	sleep 30;
	};

{if ((surfaceIsWater position _x) and (vehicle _x == _x)) then {_x setDamage 1}} forEach _soldados;

waitUntil {sleep 5; (({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < round (_solMax / 3)) or (({(_x distance _posdestino < _size*2) and (not(vehicle _x isKindOf "Air")) and (alive _x) and (!captive _x)} count _soldados) > 4*({(alive _x) and (_x distance _posdestino < _size*2)} count _civiles)) or (time > _tiempo)};

if ((({not (captive _x)} count _soldados) < ({captive _x} count _soldados)) or ({alive _x} count _soldados < round (_solMax / 3)) or (time > _tiempo)) then
	{
	{_x doMove [0,0,0]} forEach _soldados;
	_tsk = ["AtaqueAAF",[side_blue,civilian],[format ["CSAT is making a punishment expedition to %1. They will kill everybody there. Defend the city at all costs",_nombredest],"CSAT Punishment",_mrkDestino],getMarkerPos _mrkDestino,"SUCCEEDED",10,true,true,"Defend"] call BIS_fnc_setTask;
	[-5,20,_posdestino] remoteExec ["AS_fnc_changeCitySupport",2];
	[10,0] remoteExec ["prestige",2];
	{[-5,0,_x] remoteExec ["AS_fnc_changeCitySupport",2]} forEach ciudades;
	{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posdestino,"BLUFORSpawn"] call distanceUnits);
	[10,Slowhand] call playerScoreAdd;
	}
else
	{
	_tsk = ["AtaqueAAF",[side_blue,civilian],[format ["CSAT is making a punishment expedition to %1. They will kill everybody there. Defend the city at all costs",_nombredest],"CSAT Punishment",_mrkDestino],getMarkerPos _mrkDestino,"FAILED",10,true,true,"Defend"] call BIS_fnc_setTask;
	[-5,-20,_posdestino] remoteExec ["AS_fnc_changeCitySupport",2];
	{[0,-5,_x] remoteExec ["AS_fnc_changeCitySupport",2]} forEach ciudades;
	destroyedCities = destroyedCities + [_mrkDestino];
	if (count destroyedCities > 7) then
		{
		 ["destroyedCities",false,true] remoteExec ["BIS_fnc_endMission",0];
		};
	publicVariable "destroyedCities";
	for "_i" from 1 to 60 do
		{
		_mina = createMine ["APERSMine",_posdestino,[],_size];
		};
	};

forcedSpawn = forcedSpawn - [_mrkDestino]; publicVariable "forcedSpawn";
sleep 15;

[0,_tsk] spawn borrarTask;
[7200] remoteExec ["AS_fnc_increaseAttackTimer",2];
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

waitUntil {sleep 1; not (spawner getVariable _mrkDestino)};

{deleteVehicle _x} forEach _civiles;
deleteGroup _grupoCivil;

