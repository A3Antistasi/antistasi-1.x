/*
<<<<<<< HEAD
*	REWORK of the spawn system to integrate airplanes and helis
*	The code is basically for WotP with adjustments, so all the credits go (as always) to Barbolani
*
*	Now featuring status flags of the current spawn state
*	0 = Place is fully spawned in and active
*	1 = Place has the minimal AA active, the rest is inactive
*	2 = Place is completly not active
*	3 = Place is not spawned in yet
=======
Rework of spawn system

Status flags:
0 - full alerted, AA and normal garrison spawned in
1 - alerted, normal garrison spawned in
2 - AA alert, AA group spawn in
3 - not alerted, cached in but not simulated (not used by now)
4 - not cached in

>>>>>>> 4319c42f9ca06717c1d3daa21180a141d1782ea4
*/

if !(isServer) exitWith {};

debugperf = false;

private _currentTime = time;
private _hills = colinas - colinasAA;

while {true} do {
	sleep 1;
	if (debugperf) then {hint format ["Tiempo transcurrido: %1 para %2 markers", time - _currentTime, count markers]};
	_currentTime = time;

	waitUntil {!isNil "Slowhand"};

	//Ally that can spawn in enemy
	private _allyUnits = [];

	//Airplanes that trigger AA
	private _allyPlanes = [];

	//Enemy that can spawn in friendly
	private _enemyUnits = [];

	//Airplanes that counter FIA airplanes
	private _enemyPlanes = [];
	private _planeTargets = [];

	//loop all units
	{
		_unit = _x;
		_veh = vehicle _unit;

		//check if vehicle can spawn in units
		_sideAlly = _veh getVariable "BLUFORSpawn";
		_sideEnemy = _veh getVariable "OPFORSpawn";

		//check unit if vehicle doesnt have variable
		if(isNil "_sideAlly")then{_sideAlly = _x getVariable ["BLUFORSpawn",false]};
		if(isNil "_sideEnemy")then{_sideEnemy = _x getVariable ["OPFORSpawn",false]};

		//pushback units in list
		if (_sideAlly) then
		{
			if(_veh isKindOf "Air") then {
				//Dont add pilot and crew, these would trigger the 1 km full spawn!!
				_allyPlanes pushBack _veh;
			} else {
				_allyUnits pushBack _x;
			};

		};
		if (_sideEnemy) then {
			if(_veh isKindOf "Air") then {
				_enemyPlanes pushBack _veh;
			};
			_enemyUnits pushBack _x;
		};

	} forEach allUnits;

//Nothing changed till here
	{
		_target = _x getVariable ["target", ""];
		_planeTargets pushBackUnique _target;
	} forEach _enemyPlanes;

	{
		private _marker = _x;
		private _markerPos = getMarkerPos _marker;
		private _markerAlert = spawner getVariable _marker;

		if (_marker in mrkAAF) then {
			if (_markerAlert == 4) then {
				//check if a units is near the location or place needs to be forced to spawned in
				_numberOfUnits = {_x distance2D _markerPos < distanciaSPWN} count _allyUnits;
				_numberOfPlanes = {_x distance2D _markerPos < distanciaSPWN * 4} count _allyPlanes;
				if ((_numberOfUnits > 0) OR (_numberOfPlanes > 0) OR (_marker in forcedSpawn)) then {

					if(_numberOfPlanes > 0) then{
						if(!((_marker in _hills) OR (_marker in controles) OR (_marker in ciudades))) then {
							spawner setVariable [_marker,2,true]; //Spawning AA in
							_markerAlert = 2;
							[_marker] remoteExec ["createAAdefense", call AS_fnc_getNextWorker];

						};
						if({!(_x in _planeTargets)} count _allyPlanes > 0) then { //Enemy plane currently not under attack
							_availableAirports = aeropuertos - mrkFIA;
							_startAirport = nil;

							while { (count _availableAirports) > 0} do {
								_startAirport = [_marker] call AS_fnc_findAirportForCA;
								_availableAirports = _availableAirports - [_startAirport];
								if ((spawner getVariable _startAirport) > 1) exitWith {};
								_startAirport = nil;
							};
							if(_startAirport != nil) then {
								//Not sure if this is working like it should
								_plane = { if(_x distance2D _markerPos < distanciaSPWN * 4) exitWith {_x};} forEach (_allyPlanes - _planeTargets);
								_planeTargets pushBackUnique _plane;
								//[_startAirport, _plane] remoteExec ["counterJet", call AS_fnc_getNextWorker]; Activate this once the jet counter script is finished
							};

						};
					};

					if(_numberOfUnits > 0) then{
						if(_markerAlert == 2) then
						{
							spawner setVariable [_marker,0,true]; //Spawning troops in
						}
						else
						{
							spawner setVariable [_marker,1,true]; // spawning only garrison
						};
						call {
							//Optimization possible, but perhaps not really needed due to low calls
							if (_marker in _hills) exitWith {[_marker] remoteExec ["createWatchpost", call AS_fnc_getNextWorker]};
							if (_marker in colinasAA) exitWith {[_marker] remoteExec ["createAAsite", call AS_fnc_getNextWorker]};
							if (_marker in ciudades) exitWith {[_marker] remoteExec ["createCIV", call AS_fnc_getNextWorker]; [_marker] remoteExec ["createCity", call AS_fnc_getNextWorker]};
							if (_marker in power) exitWith {[_marker] remoteExec ["createPower", call AS_fnc_getNextWorker]};
							if (_marker in bases) exitWith {[_marker] remoteExec ["createBase", call AS_fnc_getNextWorker]};
							//if (_marker in controles) exitWith {[_marker] remoteExec ["createRoadblock", call AS_fnc_getNextWorker]};
							if (_marker in controles) exitWith {[_marker] remoteExec ["createRoadblock2", call AS_fnc_getNextWorker]};
							if (_marker in aeropuertos) exitWith {[_marker] remoteExec ["createAirbase", call AS_fnc_getNextWorker]};
							if ((_marker in recursos) OR (_marker in fabricas)) exitWith {[_marker] remoteExec ["createResources", call AS_fnc_getNextWorker]};
							if ((_marker in puestos) OR (_marker in puertos)) exitWith {[_marker] remoteExec ["createOutpost", call AS_fnc_getNextWorker]};
							//if ((_marker in artyEmplacements) AND (_marker in forcedSpawn)) exitWith {[_marker] remoteExec ["createArtillery", call AS_fnc_getNextWorker]};
						};
					};
				};
			} else { //If place was spawned in already
				//Special rule for helos													 	 | The 100 has to be tested, not sure which values are ok, the higher the faster the garrision is spawning
				//										    ^						   ^     ^
				if (({((_x distance2D _markerPos - 300) max 1) * ((speed _x - 100) max 1) < 100} count _allyPlanes != 0)) then 	
				{
					_markerAlert = 0;
						call {
							//Optimization possible, but perhaps not really needed due to low calls
							if (_marker in _hills) exitWith {[_marker] remoteExec ["createWatchpost", call AS_fnc_getNextWorker]};
							if (_marker in colinasAA) exitWith {[_marker] remoteExec ["createAAsite", call AS_fnc_getNextWorker]};
							if (_marker in ciudades) exitWith {[_marker] remoteExec ["createCIV", call AS_fnc_getNextWorker]; [_marker] remoteExec ["createCity", call AS_fnc_getNextWorker]};
							if (_marker in power) exitWith {[_marker] remoteExec ["createPower", call AS_fnc_getNextWorker]};
							if (_marker in bases) exitWith {[_marker] remoteExec ["createBase", call AS_fnc_getNextWorker]};
							//if (_marker in controles) exitWith {[_marker] remoteExec ["createRoadblock", call AS_fnc_getNextWorker]};
							if (_marker in controles) exitWith {[_marker] remoteExec ["createRoadblock2", call AS_fnc_getNextWorker]};
							if (_marker in aeropuertos) exitWith {[_marker] remoteExec ["createAirbase", call AS_fnc_getNextWorker]};
							if ((_marker in recursos) OR (_marker in fabricas)) exitWith {[_marker] remoteExec ["createResources", call AS_fnc_getNextWorker]};
							if ((_marker in puestos) OR (_marker in puertos)) exitWith {[_marker] remoteExec ["createOutpost", call AS_fnc_getNextWorker]};
							//if ((_marker in artyEmplacements) AND (_marker in forcedSpawn)) exitWith {[_marker] remoteExec ["createArtillery", call AS_fnc_getNextWorker]};
						};
				}
				
				
				if (({_x distance2D _markerPos < (distanciaSPWN+50)} count _allyUnits == 0) AND !(_marker in forcedSpawn)) then {
					//No enemy infantry active
					if(_markerAlert < 2) then {
						//infantry at position active
						if(_markerAlert == 0) then {_markerAlert = 2;}; //Keep AA active}
						if(_markerAlert == 1) then {_markerAlert = 4;}; //Despawn position};
					};
				} else {
					//Enemy infantry active
					if(_markerAlert == 2 AND ({_x distance2D _markerPos < distanciaSPWN} count _allyUnits > 0)) then
					{
						_markerAlert = 0;
						call {
							//Optimization possible, but perhaps not really needed due to low calls
							if (_marker in _hills) exitWith {[_marker] remoteExec ["createWatchpost", call AS_fnc_getNextWorker]};
							if (_marker in colinasAA) exitWith {[_marker] remoteExec ["createAAsite", call AS_fnc_getNextWorker]};
							if (_marker in ciudades) exitWith {[_marker] remoteExec ["createCIV", call AS_fnc_getNextWorker]; [_marker] remoteExec ["createCity", call AS_fnc_getNextWorker]};
							if (_marker in power) exitWith {[_marker] remoteExec ["createPower", call AS_fnc_getNextWorker]};
							if (_marker in bases) exitWith {[_marker] remoteExec ["createBase", call AS_fnc_getNextWorker]};
							//if (_marker in controles) exitWith {[_marker] remoteExec ["createRoadblock", call AS_fnc_getNextWorker]};
							if (_marker in controles) exitWith {[_marker] remoteExec ["createRoadblock2", call AS_fnc_getNextWorker]};
							if (_marker in aeropuertos) exitWith {[_marker] remoteExec ["createAirbase", call AS_fnc_getNextWorker]};
							if ((_marker in recursos) OR (_marker in fabricas)) exitWith {[_marker] remoteExec ["createResources", call AS_fnc_getNextWorker]};
							if ((_marker in puestos) OR (_marker in puertos)) exitWith {[_marker] remoteExec ["createOutpost", call AS_fnc_getNextWorker]};
							//if ((_marker in artyEmplacements) AND (_marker in forcedSpawn)) exitWith {[_marker] remoteExec ["createArtillery", call AS_fnc_getNextWorker]};
						};
					};
				};
				if (({_x distance2D _markerPos < (distanciaSPWN * 4 + 50)} count _allyPlanes == 0)) then {
					//No enemy planes active
					if(_markerAlert == 2) then {_markerAlert = 4;}; //Despawn if only AA was active
					if(_markerAlert == 0) then {_markerAlert = 1;}; //Despawn only AA groups
				} else {
					//Enemy Plane active
					if (
						(_markerAlert == 1)
					) then
					{
						_markerAlert = 0;
						if(!((_marker in _hills) OR (_marker in controles) OR (_marker in ciudades))) then 
						{
							[_marker] remoteExec ["createAAdefense", call AS_fnc_getNextWorker];
						}
					};
					
				};
				spawner setVariable [_marker, _markerAlert, true];
			};
		}else{
			//if !(spawner getVariable _marker) then {    <-- Wurzel -- if not spawned in the value is 4
			if !(spawner getVariable _marker != 4) then {
				if (({_x distance _markerPos < distanciaSPWN} count _enemyUnits > 0) OR ({((_x getVariable ["owner",objNull]) == _x) AND (_x distance _markerPos < distanciaSPWN)} count _allyUnits > 0) OR (_marker in forcedSpawn)) then {
					spawner setVariable [_marker,2,true];
					if (_marker in ciudades) then {
						if (({((_x getVariable ["owner",objNull]) == _x) AND (_x distance _markerPos < distanciaSPWN)} count _allyUnits > 0) OR (_marker in forcedSpawn)) then {[_marker] remoteExec ["createCIV",call AS_fnc_getNextWorker]};
						[_marker] remoteExec ["createCity", call AS_fnc_getNextWorker]
					} else {
						call {
							if ((_marker in recursos) OR (_marker in fabricas)) exitWith {[_marker] remoteExec ["createFIAresources", call AS_fnc_getNextWorker]};
							if ((_marker in power) OR (_marker == "FIA_HQ")) exitWith {[_marker] remoteExec ["createFIApower", call AS_fnc_getNextWorker]};
							if (_marker in aeropuertos) exitWith {[_marker] remoteExec ["createNATOaerop", call AS_fnc_getNextWorker]};
							if (_marker in bases) exitWith {[_marker] remoteExec ["createNATObases", call AS_fnc_getNextWorker]};
							if (_marker in puestosFIA) exitWith {[_marker] remoteExec ["createFIAEmplacement", call AS_fnc_getNextWorker]};
							if ((_marker in puestos) OR (_marker in puertos)) exitWith {[_marker] remoteExec ["createFIAOutpost", call AS_fnc_getNextWorker]};
							if (_marker in campsFIA) exitWith {[_marker] remoteExec ["createCampFIA", call AS_fnc_getNextWorker]};
							if (_marker in puestosNATO) exitWith {[_marker] remoteExec ["createNATOpuesto", call AS_fnc_getNextWorker]};
						};
					};
				};
			} else {
				if ((({_x distance _markerPos < (distanciaSPWN+50)} count _enemyUnits == 0) AND ({((_x getVariable ["owner",objNull]) == _x) AND (_x distance _markerPos < distanciaSPWN)} count _allyUnits == 0)) AND !(_marker in forcedSpawn)) then {
					spawner setVariable [_marker,4,true];
				};
			};
		};

	} forEach markers;

};
