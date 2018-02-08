if (!isServer and hasInterface) exitWith {};

_tskTitle = "STR_TSK_TD_DesHeli";
_tskDesc = "STR_TSK_TD_DESC_DesHeli";

private ["_poscrash","_marcador","_posicion","_mrkfin","_tipoveh","_efecto","_heli","_vehiculos","_soldados","_grupos","_unit","_roads","_road","_vehicle","_veh","_tipogrupo","_tsk","_humo","_emitterArray"];

_marcador = _this select 0;
_source = _this select 1;

if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val + 1, true];
};

_posicion = getMarkerPos _marcador;

_posHQ = getMarkerPos guer_respawn;

_tiempolim = 120;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

while {true} do
	{
	sleep 0.1;
	_poscrash = [_posicion,5000,random 360] call BIS_fnc_relPos;
	if ((!surfaceIsWater _poscrash) and (_poscrash distance _posHQ < 4000)) exitWith {};
	};

_tipoVeh = indAirForce call BIS_fnc_selectRandom;

_posCrashMrk = [_poscrash,random 500,random 360] call BIS_fnc_relPos;
_posCrash = _posCrash findEmptyPosition [0,100,_tipoVeh];
_mrkfin = createMarker [format ["DES%1", random 100], _posCrashMrk];
_mrkfin setMarkerShape "ICON";

_nombrebase = [_marcador] call AS_fnc_localizar;

_tsk = ["DES",[side_blue,civilian],[[_tskDesc,_nombrebase],_tskTitle,_mrkfin],_posCrashMrk,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";
_vehiculos = [];
_soldados = [];
_grupos = [];

_efecto = createVehicle ["CraterLong", _poscrash, [], 0, "CAN_COLLIDE"];
_heli = createVehicle [_tipoVeh, _poscrash, [], 0, "CAN_COLLIDE"];
_heli attachTo [_efecto,[0,0,1.5]];
_humo = "test_EmptyObjectForSmoke" createVehicle _poscrash; _humo attachTo[_heli,[0,1.5,-1]];
_heli setDamage 0.9;
_heli lock 2;
_vehiculos = _vehiculos + [_heli,_efecto];

_grpcrash = createGroup side_green;
_grupos = _grupos + [_grpcrash];

_unit = ([_poscrash, 0, infPilot, _grpcrash] call bis_fnc_spawnvehicle) select 0;
_unit setDamage 1;
_unit moveInDriver _heli;
_soldados = _soldados + [_unit];

_tam = 100;

while {true} do
	{
	_roads = _posicion nearRoads _tam;
	if (count _roads > 0) exitWith {};
	_tam = _tam + 50;
	};

_road = _roads select 0;

_vehicle=[position _road, 0,selectRandom standardMRAP, side_green] call bis_fnc_spawnvehicle;
_veh = _vehicle select 0;
[_veh] spawn genVEHinit;
[_veh,"AAF Escort"] spawn inmuneConvoy;
_vehCrew = _vehicle select 1;
{[_x] spawn genInit} forEach _vehCrew;
_grupoVeh = _vehicle select 2;
_soldados = _soldados + _vehCrew;
_grupos = _grupos + [_grupoVeh];
_vehiculos = _vehiculos + [_veh];

sleep 1;

_tipoGrupo = [infPatrol, side_green] call AS_fnc_pickGroup;
_grupo = [_posicion, side_green, _tipogrupo] call BIS_Fnc_spawnGroup;

{_x assignAsCargo _veh; _x moveInCargo _veh; _soldados = _soldados + [_x]; [_x] join _grupoveh; [_x] spawn genInit} forEach units _grupo;
deleteGroup _grupo;
//[_veh] spawn smokeCover;

_Vwp0 = _grupoVeh addWaypoint [_poscrash, 0];
_Vwp0 setWaypointType "TR UNLOAD";
_Vwp0 setWaypointBehaviour "SAFE";
_Gwp0 = _grupo addWaypoint [_poscrash, 0];
_Gwp0 setWaypointType "GETOUT";
_Vwp0 synchronizeWaypoint [_Gwp0];

sleep 15;

_vehicleT=[position _road, 0, selectRandom vehTruckBox, side_green] call bis_fnc_spawnvehicle;
_vehT = _vehicleT select 0;
[_vehT] spawn genVEHinit;
[_vehT,"AAF Recover Truck"] spawn inmuneConvoy;
_vehCrewT = _vehicle select 1;
{[_x] spawn genInit} forEach _vehCrewT;
_grupoVehT = _vehicleT select 2;
_soldados = _soldados + _vehCrewT;
_grupos = _grupos + [_grupoVehT];
_vehiculos = _vehiculos + [_vehT];

_Vwp0 = _grupoVehT addWaypoint [_poscrash, 0];
_Vwp0 setWaypointType "MOVE";
_Vwp0 setWaypointBehaviour "SAFE";
waitUntil {sleep 1; (not alive _heli) or (_vehT distance _heli < 50) or (dateToNumber date > _fechalimnum)};

if (_vehT distance _heli < 50) then
	{
	_vehT doMove position _heli;
	sleep 60;
	if (alive _heli) then
		{
		_heli attachTo [_vehT,[0,-3,2]];
		_emitterArray = _humo getVariable "effects";
		{deleteVehicle _x} forEach _emitterArray;
		deleteVehicle _humo;
		};

	_Vwp0 = _grupoVehT addWaypoint [_posicion, 1];
	_Vwp0 setWaypointType "MOVE";
	_Vwp0 setWaypointBehaviour "SAFE";

	_Vwp0 = _grupoVeh addWaypoint [_poscrash, 0];
	_Vwp0 setWaypointType "LOAD";
	_Vwp0 setWaypointBehaviour "SAFE";
	_Gwp0 = _grupo addWaypoint [_poscrash, 0];
	_Gwp0 setWaypointType "GETIN";
	_Vwp0 synchronizeWaypoint [_Gwp0];

	_Vwp0 = _grupoVeh addWaypoint [_posicion, 2];
	_Vwp0 setWaypointType "MOVE";
	_Vwp0 setWaypointBehaviour "SAFE";

	};

waitUntil {sleep 1; (not alive _heli) or (_vehT distance _posicion < 100) or (dateToNumber date > _fechalimnum)};

if (not alive _heli) then
	{
	_tsk = ["DES",[side_blue,civilian],[[_tskDesc,_nombrebase],_tskTitle,_mrkfin],_posCrashMrk,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	[0,300] remoteExec ["resourcesFIA",2];
	[0,0] remoteExec ["prestige",2];
	//[-3,3,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
	[1200] remoteExec ["AS_fnc_increaseAttackTimer",2];
	{if (_x distance _heli < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - (entities "HeadlessClient_F"));
	[5,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
	};

if ((dateToNumber date > _fechalimnum) or (_vehT distance _posicion < 100)) then
	{
	_tsk = ["DES",[side_blue,civilian],[[_tskDesc,_nombrebase],_tskTitle,_mrkfin],_posCrashMrk,"FAILED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	//[3,0,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
	[-600] remoteExec ["AS_fnc_increaseAttackTimer",2];
	[-10,Slowhand] call playerScoreAdd;
	};

if (!isNull _humo) then
	{
	_emitterArray = _humo getVariable "effects";
	{deleteVehicle _x} forEach _emitterArray;
	deleteVehicle _humo;
	};

if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val - 1, true];
};

[1200,_tsk] spawn borrarTask;
deleteMarker _mrkfin;
{
waitUntil {sleep 1;(!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits))};
deleteVehicle _x} forEach _vehiculos;
{deleteVehicle _x} forEach _soldados;
{deleteGroup _x} forEach _grupos;

//sleep (600 + random 1200);

//[_tsk,true] call BIS_fnc_deleteTask;




