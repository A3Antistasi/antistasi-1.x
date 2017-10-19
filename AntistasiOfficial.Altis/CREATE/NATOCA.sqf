if (!isServer and hasInterface) exitWith{};

private ["_origen"];

_marcador = _this select 0;

//forcedSpawn = forcedSpawn + [_marcador]; publicVariable "forcedSpawn";

_posicion = getMarkerPos (_marcador);

_aeropuertos = aeropuertos - mrkAAF + ["spawnNATO"];

_threatEval = [_marcador] call AAthreatEval;

_origen = [_aeropuertos,_posicion] call BIS_fnc_nearestPosition;
_orig = getMarkerPos _origen;

_nombredest = [_marcador] call AS_fnc_localizar;
_nombreorig = "the NATO Carrier";
if (_origen!= "spawnNATO") then {_nombreorig = [_origen] call AS_fnc_localizar};
_tsk = ["NATOCA",[side_blue,civilian],[format ["Our Commander asked %3 for an attack on %1. Help them in order to have success in this operation. Their attack will depart from %2",_nombredest,_nombreorig, A3_Str_BLUE],format ["%1 Attack", A3_Str_BLUE],_marcador],_posicion,"CREATED",5,true,true,"Attack"] call BIS_fnc_setTask;
misiones pushBackUnique _tsk; publicVariable "misiones";
_soldados = [];
_vehiculos = [];
_grupos = [];
_tipoveh = "";
_cuenta = server getVariable "prestigeNATO";
_cuenta = round (_cuenta / 10);

[-20,0] remoteExec ["prestige",2];

if ((_marcador in bases) or (_marcador in aeropuertos)) then
	{
	/*
	for "_i" from 1 to _cuenta do
		{
		[_marcador,"B_Plane_CAS_01_F"] spawn airstrike;
		sleep 30;
		};
	*/
	[_marcador] spawn artilleriaNATO;
	};

for "_i" from 1 to _cuenta do
	{
	_tipoveh = planesNATOTrans call BIS_fnc_selectRandom;
	_vehicle=[_orig, 0, _tipoveh, side_blue] call bis_fnc_spawnvehicle;
	_heli = _vehicle select 0;
	_heliCrew = _vehicle select 1;
	_grupoheli = _vehicle select 2;
	{[_x] spawn NATOinitCA} forEach _heliCrew;
	[_heli] spawn NATOVEHinit;
	_soldados = _soldados + _heliCrew;
	_grupos = _grupos + [_grupoheli];
	_vehiculos = _vehiculos + [_heli];
	_heli lock 3;
	/*
	if ((_tipoveh != "B_Heli_Light_01_F") and (_tipoveh != "B_Heli_Transport_01_camo_F")) then
		{
		_wp1 = _grupoheli addWaypoint [_posicion, 0];
		_wp1 setWaypointType "SAD";
		[_heli,"NATO Air Attack"] spawn inmuneConvoy;
		}
	else
		{
		{_x setBehaviour "CARELESS";} forEach units _grupoheli;
		[_heli,"NATO Air Transport"] spawn inmuneConvoy;
		};
	*/
	{_x setBehaviour "CARELESS";} forEach units _grupoheli;
	[_heli,"NATO Air Transport"] spawn inmuneConvoy;
	if (_tipoveh in bluHeliDis) then
		{
		_tipoGrupo = [bluSquadWeapons, side_blue] call AS_fnc_pickGroup;
		_grupo = [_orig, side_blue, _tipoGrupo] call BIS_Fnc_spawnGroup;
		{_x assignAsCargo _heli; _x moveInCargo _heli; _soldados = _soldados + [_x]; [_x] spawn NATOinitCA} forEach units _grupo;
		_grupos = _grupos + [_grupo];
		if ((_marcador in aeropuertos) or (random 10 < _threatEval)) then
			{
			[_heli,_grupo,_marcador,_threatEval] spawn airdrop
			}
		else
			{
			if ((_marcador in bases) or (_marcador in puestos)) then {[_heli,_grupo,_posicion,_orig,_grupoheli] spawn fastropeNATO;};
			if ((_marcador in recursos) or (_marcador in power) or (_marcador in fabricas)) then
				{
				{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _grupoheli;
				_landpos = [];
				_landpos = [_posicion, 0, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
				_landPos set [2, 0];
				_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
				_vehiculos = _vehiculos + [_pad];
				_wp0 = _grupoheli addWaypoint [_landpos, 0];
				_wp0 setWaypointType "TR UNLOAD";
				_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT'; [vehicle this] call smokeCoverAuto"];
				[_grupoheli,0] setWaypointBehaviour "CARELESS";
				_wp3 = _grupo addWaypoint [_landpos, 0];
				_wp3 setWaypointType "GETOUT";
				_wp0 synchronizeWaypoint [_wp3];
				_wp4 = _grupo addWaypoint [_posicion, 1];
				_wp4 setWaypointType "SAD";
				_wp2 = _grupoheli addWaypoint [_orig, 1];
				_wp2 setWaypointType "MOVE";
				_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
				[_grupoheli,1] setWaypointBehaviour "AWARE";
				[_heli,true] spawn puertasLand;
				};
			};
		};
	if (_tipoveh in bluHeliTS) then
		{
		{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _grupoheli;
		_tipoGrupo = [bluTeam, side_blue] call AS_fnc_pickGroup;
		_grupo = [_orig, side_blue, _tipoGrupo] call BIS_Fnc_spawnGroup;
		{_x assignAsCargo _heli; _x moveInCargo _heli; _soldados = _soldados + [_x]; [_x] spawn NATOinitCA} forEach units _grupo;
		_grupos = _grupos + [_grupo];
		_landpos = [];
		_landpos = [_posicion, 0, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
		_landPos set [2, 0];
		_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
		_vehiculos = _vehiculos + [_pad];
		_wp0 = _grupoheli addWaypoint [_landpos, 0];
		_wp0 setWaypointType "TR UNLOAD";
		_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT'; [vehicle this] call smokeCoverAuto"];
		[_grupoheli,0] setWaypointBehaviour "CARELESS";
		_wp3 = _grupo addWaypoint [_landpos, 0];
		_wp3 setWaypointType "GETOUT";
		_wp0 synchronizeWaypoint [_wp3];
		_wp4 = _grupo addWaypoint [_posicion, 1];
		_wp4 setWaypointType "SAD";
		_wp2 = _grupoheli addWaypoint [_orig, 1];
		_wp2 setWaypointType "MOVE";
		_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
		[_grupoheli,1] setWaypointBehaviour "AWARE";
		[_heli,true] spawn puertasLand;
		};
	if (_tipoveh in bluHeliRope) then
		{
		{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _grupoheli;
		_tipoGrupo = [bluSquad, side_blue] call AS_fnc_pickGroup;
		_grupo = [_orig, side_blue, _tipoGrupo] call BIS_Fnc_spawnGroup;
		{_x assignAsCargo _heli; _x moveInCargo _heli; _soldados = _soldados + [_x]; [_x] spawn NATOinitCA} forEach units _grupo;
		_grupos = _grupos + [_grupo];
		if ((_marcador in aeropuertos) or (_marcador in bases) or (_marcador in puestos) or (random 10 < _threatEval)) then
			{
			[_heli,_grupo,_marcador,_threatEval] spawn airdrop
			}
		else
			{
			_landpos = [];
			_landpos = [_posicion, 0, 300, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
			_landPos set [2, 0];
			_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
			_vehiculos = _vehiculos + [_pad];
			_wp0 = _grupoheli addWaypoint [_landpos, 0];
			_wp0 setWaypointType "TR UNLOAD";
			_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT'; [vehicle this] call smokeCoverAuto"];
			[_grupoheli,0] setWaypointBehaviour "CARELESS";
			_wp3 = _grupo addWaypoint [_landpos, 0];
			_wp3 setWaypointType "GETOUT";
			_wp0 synchronizeWaypoint [_wp3];
			_wp4 = _grupo addWaypoint [_posicion, 1];
			_wp4 setWaypointType "SAD";
			_wp2 = _grupoheli addWaypoint [_orig, 1];
			_wp2 setWaypointType "MOVE";
			_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
			[_grupoheli,1] setWaypointBehaviour "AWARE";
			[_heli,true] spawn puertasLand;
			};
		};
	sleep 35;
	};

_solMax = count _soldados;
_solMax = round (_solMax / 4);

waitUntil {sleep 1; (_marcador in mrkFIA) or ({alive _x} count _soldados < _solMax)};

if ({alive _x} count _soldados < _solMax) then
	{
	_tsk = ["NATOCA",[side_blue,civilian],[format ["Our Commander asked %3 for an attack on %1. Help them in order to have success in this operation. Their attack will depart from %2",_nombredest,_nombreorig, A3_Str_BLUE],format ["%1 Attack", A3_Str_BLUE],_marcador],_posicion,"FAILED",5,true,true,"Attack"] call BIS_fnc_setTask;
	[-10,0] remoteExec ["prestige",2];
	};

//forcedSpawn = forcedSpawn - [_marcador]; publicVariable "forcedSpawn";
sleep 15;

//[_tsk,true] call BIS_fnc_deleteTask;
[0,_tsk] spawn borrarTask;
{
_soldado = _x;
waitUntil {sleep 1; {_x distance _soldado < distanciaSPWN} count (allPlayers - hcArray) == 0};
deleteVehicle _soldado;
} forEach _soldados;
{deleteGroup _x} forEach _grupos;
{
_vehiculo = _x;
waitUntil {sleep 1; {_x distance _vehiculo < distanciaSPWN/2} count (allPlayers - hcArray) == 0};
deleteVehicle _x} forEach _vehiculos;

