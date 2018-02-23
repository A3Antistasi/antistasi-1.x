if (!isServer and hasInterface) exitWith{};

private ["_origen"];

_marcador = _this select 0;

_posicion = getMarkerPos (_marcador);

_aeropuertos = aeropuertos - mrkAAF + ["spawnNATO"];

_threatEval = 7; //Stef i forced it to 7 untill i manage to check if vehDef and static guns are operative or not.

_origen = [_aeropuertos,_posicion] call BIS_fnc_nearestPosition;
_orig = getMarkerPos _origen;

_nombredest = [_marcador] call AS_fnc_localizar;
_nombreorig = "the NATO Carrier";
if (_origen!= "spawnNATO") then {_nombreorig = [_origen] call AS_fnc_localizar};
_tsk = ["NATOCA",[side_blue,civilian],[["STR_TSK_DESC_ATTACK",_nombredest,_nombreorig, A3_Str_BLUE],["STR_TSK_ATTACK", A3_Str_BLUE],_marcador],_posicion,"CREATED",5,true,true,"Attack"] call BIS_fnc_setTask;
misiones pushBackUnique _tsk; publicVariable "misiones";
_soldados = [];
_vehiculos = [];
_grupos = [];
_tipoveh = "";
_cuenta = 3;

[-20,0] remoteExec ["prestige",2];

_spawnergroup = createGroup east;
_spawner = _spawnergroup createUnit [selectrandom CIV_journalists, getmarkerpos _marcador, [], 15,"None"];
_spawner setVariable ["BLUFORSpawn",true,true];
_spawner disableAI "ALL";
_spawner allowdamage false;
_spawner setcaptive true;
_spawner enableSimulation false;
hideObjectGlobal _spawner;

sleep 15;

for "_i" from 1 to _cuenta do {
	//Create and initialise aircraft
		_tipoveh = planesNATOTrans call BIS_fnc_selectRandom;
		_vehicle=[_orig, 0, _tipoveh, side_blue] call bis_fnc_spawnvehicle;
		_heli = _vehicle select 0;
		_heliCrew = _vehicle select 1;
		_grupoheli = _vehicle select 2;
		_gunners = _heliCrew - [driver _heli];
		_gunnersgroup = createGroup west;
		_gunners join _gunnersgroup;
		_gunnersgroup setbehaviour "COMBAT";
		{_x setskill 1} foreach units _gunnersgroup;
		{[_x] call NATOinitCA} forEach _heliCrew;
		[_heli] call NATOVEHinit;
		_soldados = _soldados + _heliCrew;
		_grupos = _grupos + [_grupoheli];
		_vehiculos = _vehiculos + [_heli];
		_heli lock 3;
		{_x setBehaviour "CARELESS";} forEach units _grupoheli;
		[_heli,"NATO Air Transport"] call inmuneConvoy;
	//Depending on kind of heli
		if (_tipoveh in bluHeliDis) then {		//Apache transport, can land, fastrope or paradrop
			//Add troops and init them
			_tipoGrupo = [bluSquadWeapons, side_blue] call AS_fnc_pickGroup;
			_grupo = [_orig, side_blue, _tipoGrupo] call BIS_Fnc_spawnGroup;
			{_x assignAsCargo _heli; _x moveInCargo _heli; _soldados = _soldados + [_x]; [_x] spawn NATOinitCA} forEach units _grupo;
			_grupos = _grupos + [_grupo];
			//Decide for aidrop or fastrope/land
			if ((_marcador in puestos) or (random 10 < _threatEval)) then {
				{removebackpack _x; _x addBackpack "B_Parachute"} forEach units _grupo;
				[_heli,_grupo,_marcador,_threatEval] spawn airdrop;
				diag_log format ["NATOCA HeliDIS airdropping: %1, %2, %3 ",_heli,_grupo,_marcador];
			} else {
				if ((_marcador in bases) or (_marcador in puestos)) then {
					[_heli,_grupo,_posicion,_orig,_grupoheli] spawn fastropeNATO;
				};
				if ((_marcador in recursos) or (_marcador in power) or (_marcador in fabricas)) then {
					{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _grupoheli;
					_landpos = [];
					_landpos = [_posicion, 0, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
					_landPos set [2, 0];
					_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
					_vehiculos = _vehiculos + [_pad];
					_wp0 = _grupoheli addWaypoint [_landpos, 0];
					_wp0 setWaypointType "TR UNLOAD";
					_wp0 setWaypointSpeed "FULL";
					_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';"];
					[_grupoheli,0] setWaypointBehaviour "CARELESS";
					_wp3 = _grupo addWaypoint [_landpos, 0];
					_wp3 setWaypointType "GETOUT";
					_wp0 synchronizeWaypoint [_wp3];
					_wp4 = _grupo addWaypoint [_posicion, 1];
					_wp4 setWaypointType "SAD";
					_wp2 = _grupoheli addWaypoint [_orig, 1];
					_wp2 setWaypointType "MOVE";
					_wp2 setWaypointSpeed "FULL";
					_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
					[_grupoheli,1] setWaypointBehaviour "AWARE";
					[_heli,true] spawn puertasLand;
				};
			};
		};
		if (_tipoveh in bluHeliTS) then {  		//Littlebird will land only
			{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _grupoheli;
			//Add troops and init them
			_tipoGrupo = [bluTeam, side_blue] call AS_fnc_pickGroup;
			_grupo = [_orig, side_blue, _tipoGrupo] call BIS_Fnc_spawnGroup;
			{_x assignAsCargo _heli; _x moveInCargo _heli; _soldados = _soldados + [_x]; [_x] call NATOinitCA} forEach units _grupo;
			_grupos = _grupos + [_grupo];
			_landpos = [];
			_landpos = [_posicion, 0, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
			_landPos set [2, 0];
			_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
			_vehiculos = _vehiculos + [_pad];
			//WP assignement
			_wp0 = _grupoheli addWaypoint [_landpos, 0];
			_wp0 setWaypointType "TR UNLOAD";
			_wp0 setWaypointSpeed "FULL";
			_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';"];
			[_grupoheli,0] setWaypointBehaviour "CARELESS";
			_wp3 = _grupo addWaypoint [_landpos, 0];
			_wp3 setWaypointType "GETOUT";
			_wp0 synchronizeWaypoint [_wp3];
			_wp4 = _grupo addWaypoint [_posicion, 1];
			_wp4 setWaypointType "SAD";
			_wp2 = _grupoheli addWaypoint [_orig, 1];
			_wp2 setWaypointSpeed "FULL";
			_wp2 setWaypointType "MOVE";
			_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
			[_grupoheli,1] setWaypointBehaviour "AWARE";
			[_heli,true] spawn puertasLand;
			diag_log format ["NATOCA HeliTS airdropping: %1, %2, %3 ",_heli,_grupo,_marcador];
		};
		if (_tipoveh in bluHeliRope) then {			//Chinhook	can aidrop or land
			{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _grupoheli;
			//Add troops and init them
			_tipoGrupo = [bluSquad, side_blue] call AS_fnc_pickGroup;
			_grupo = [_orig, side_blue, _tipoGrupo] call BIS_Fnc_spawnGroup;
			{_x assignAsCargo _heli; _x moveInCargo _heli; _soldados = _soldados + [_x]; [_x] call NATOinitCA} forEach units _grupo;
			_grupos = _grupos + [_grupo];

			//Decide airdrop or land
			if (!(_marcador in puestos) or (_marcador in bases) or (random 10 < _threatEval)) then {
				{removebackpack _x; _x addBackpack "B_Parachute"} forEach units _grupo;
				[_heli,_grupo,_marcador,_threatEval] spawn airdrop;
				diag_log format ["NATOCA HeliRope: %1, %2, %3,",_heli,_grupo,_marcador];
			} else {
				_landpos = [];
				_landpos = [_posicion, 0, 300, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
				_landPos set [2, 0];
				_pad = createVehicle ["Land_HelipadEmpty_F", _landpos, [], 0, "NONE"];
				_vehiculos = _vehiculos + [_pad];
				_wp0 = _grupoheli addWaypoint [_landpos, 0];
				_wp0 setWaypointType "TR UNLOAD";
				_wp0 setWaypointSpeed "FULL";
				_wp0 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';"];
				[_grupoheli,0] setWaypointBehaviour "CARELESS";
				_wp3 = _grupo addWaypoint [_landpos, 0];
				_wp3 setWaypointType "GETOUT";
				_wp0 synchronizeWaypoint [_wp3];
				_wp4 = _grupo addWaypoint [_posicion, 1];
				_wp4 setWaypointType "SAD";
				_wp2 = _grupoheli addWaypoint [_orig, 1];
				_wp2 setWaypointType "MOVE";
				_wp2 setWaypointSpeed "FULL";
				_wp2 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
				[_grupoheli,1] setWaypointBehaviour "AWARE";
				[_heli,true] spawn puertasLand;
				};
		};
		sleep 25;
	};


_solMax = count _soldados;
_solMax = round (_solMax / 4);

sleep 20;
//Taking out enemy mortar to balance the fight
	if ((_marcador in bases) and ((player distance _posicion)>300)) then {
		[_marcador] spawn artilleriaNATO;
	};
	if ((_marcador in aeropuertos) and ((player distance _posicion)>300)) then {
		[_marcador] spawn artilleriaNATO;
	};

waitUntil {sleep 1; (_marcador in mrkFIA) or ({alive _x} count _soldados < _solMax)};

if ({alive _x} count _soldados < _solMax) then {
	_tsk = ["NATOCA",[side_blue,civilian],[["STR_TSK_DESC_ATTACK",_nombredest,_nombreorig, A3_Str_BLUE],["STR_TSK_ATTACK", A3_Str_BLUE],_marcador],_posicion,"FAILED",5,true,true,"Attack"] call BIS_fnc_setTask;
	[-10,0] remoteExec ["prestige",2];
};


//[_tsk,true] call BIS_fnc_deleteTask;
[0,_tsk] spawn borrarTask;

{
	_soldado = _x;
	waitUntil {sleep 1; {_x distance _soldado < distanciaSPWN} count (allPlayers - (entities "HeadlessClient_F")) == 0};
	deleteVehicle _soldado;
} forEach _soldados;

{deleteGroup _x} forEach _grupos;

{
	_vehiculo = _x;
	waitUntil {sleep 1; {_x distance _vehiculo < distanciaSPWN/2} count (allPlayers - (entities "HeadlessClient_F")) == 0};
	deleteVehicle _x
} forEach _vehiculos;

deletevehicle _spawner;
deleteGroup _spawnergroup;