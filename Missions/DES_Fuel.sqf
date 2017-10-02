if (!isServer and hasInterface) exitWith {};

_tskTitle = localize "STR_TSK_DESfuel";
_tskDesc  = localize "STR_TSKDESC_DESfuel";

private ["_posbase", "_mrkfin", "_mrkTarget", "_tipoveh", "_range", "_vehiculos", "_soldados", "_grupos", "_returntime", "_roads", "_road", "_vehicle", "_veh", "_TypeOfGroup", "_tsk", "_humo", "_emitterArray", "_poschurch", "_grupo", "_fuelstop", "_posfuelstop", "_fuelstops"];


_InitialMarker = _this select 0;
_InitialPos    = getMarkerPos _InitialMarker;

_posHQ = getMarkerPos guer_respawn;

_MissionDuration = 60;
_MissionEndTime	 = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _MissionDuration];
_TimeLeft	 = dateToNumber _MissionEndTime;

_fMarkers = mrkFIA + campsFIA;
_hMarkers = bases + aeropuertos + puestos - mrkFIA;

_basesAAF = bases - mrkFIA;
_bases	  = [];
_base	  = "";
{
	_base	 = _x;
	_posbase = getMarkerPos _base;
	if ((_InitialPos distance _posbase < 7500)and (_InitialPos distance _posbase > 1500) and (not (spawner getVariable _base))) then {_bases = _bases + [_base]}
		} forEach _basesAAF;
	if (count _bases > 0) then {_base = [_bases, _InitialPos] call BIS_fnc_nearestPosition;
		} else                                                                                 {_base = ""};

	_posbase = getMarkerPos _base;

	_nombreOrig = [_base] call AS_fnc_localizar;

	// finding location and making markers


	_range = 2000;
	while {true} do {
		sleep 0.1;
		while {true} do {
			sleep 0.1;
			_range	   = _range + 500;
			_fuelstops = nearestTerrainObjects [_InitialPos, ["FUELSTATION"], _range];
			if (count _fuelstops > 0) exitwith {};
		};
		_fuelstop    = selectRandom _fuelstops;
		_posfuelstop = getPos _fuelstop;
		_nfMarker    = [_fMarkers, _posfuelstop] call BIS_fnc_nearestPosition;
		_nhMarker    = [_hMarkers, _posfuelstop] call BIS_fnc_nearestPosition;
		if ((_posfuelstop distance _posHQ > 400) && (getMarkerPos _nfMarker distance _posfuelstop > 200)) exitWith {};
	};

	_spawnpositionData = [_posbase, _posfuelstop] call AS_fnc_findSpawnSpots;
	_spawnPosition = _spawnpositionData select 0;
	_direction = _spawnpositionData select 1;

	_mrkfuelstop  = createMarker [format ["Fuel%1", random 100], _posfuelstop];
	_mrkfuelstop setMarkerSize [150, 150];

	_mrkfin = createMarker [format ["DES%1", random 100], _posfuelstop];

	_mrkfin setMarkerShape "ICON";

	// setting the mission

	_nearestbase = [_base] call AS_fnc_localizar;
	_tsk	     = ["DES", [side_blue, civilian], [format [_tskDesc, _nearestbase, numberToDate [2035, _TimeLeft] select 3, numberToDate [2035, _TimeLeft] select 4, A3_Str_INDEP], _tskTitle, _mrkfin], _fuelstop, "CREATED", 5, true, true, "Destroy"] call BIS_fnc_setTask;
	misiones pushBack _tsk;
	publicVariable "misiones";

	// adding groups and vehicle

	_vehiculos = [];
	_soldados  = [];
	_grupos	   = [];


	[_mrkfuelstop] remoteExec ["patrolCA", HCattack];
	sleep 10;


	private _grupo = createGroup side_green;

	_fueltruck = selectRandom vehFuel;
	_veh	   = _fueltruck createVehicle _spawnPosition;
	sleep 1;
	if (not alive _veh) then {_veh = "I_Truck_02_fuel_F" createVehicle _spawnPosition}; // Fallback default fuel truck in case it's not in a template.
	_veh setDir _direction;
	// _vehiculos = _vehiculos + [_veh];
	[_veh] spawn genVEHinit;

	_unit = ( [_posbase, 0, sol_RFL, _grupo] call bis_fnc_spawnvehicle)select 0;
	_unit moveInDriver _veh;
	_unit disableAI "AUTOTARGET";
	_unit disableAI "TARGET";
	_unit disableAI "AUTOCOMBAT";
	_unit setBehaviour "CARELESS";
	_unit allowFleeing 0;
	_grupos = _grupos + [_grupo];

	{ [_x] spawn genInit;
	  _soldados = _soldados + [_x]} forEach units _grupo;


	_wp0 = _grupo addWaypoint [_posfuelstop, 0];
	_wp0 setWaypointType "MOVE";
	_wp0 setWaypointBehaviour "SAFE";
	_wp0 setWaypointSpeed "NORMAL";
	_wp0 setWaypointFormation "COLUMN";


	waitUntil {sleep 3;
		   (not alive _veh)or (dateToNumber date > _TimeLeft) or (_veh distance _posfuelstop < 40)};
	if (dateToNumber date > _TimeLeft) then {_tsk = ["DES", [side_blue, civilian], [format [_tskDesc, _nearestbase, numberToDate [2035, _TimeLeft] select 3, numberToDate [2035, _TimeLeft] select 4, A3_Str_INDEP], _tskTitle, _mrkfin], _fuelstop, "FAILED", 5, true, true, "Destroy"] call BIS_fnc_setTask;
		};

	if (not alive _veh) then
		{_tsk = ["DES", [side_blue, civilian], [format [_tskDesc, _nearestbase, numberToDate [2035, _TimeLeft] select 3, numberToDate [2035, _TimeLeft] select 4, A3_Str_INDEP], _tskTitle, _mrkfin], _fuelstop, "SUCCEEDED", 5, true, true, "Destroy"] call BIS_fnc_setTask;
		};

	if (_veh distance _posfuelstop < 40) then
		{
			_tsk = ["DES", [side_blue, civilian], [format [_tskDesc, _nearestbase, numberToDate [2035, _TimeLeft] select 3, numberToDate [2035, _TimeLeft] select 4, A3_Str_INDEP], _tskTitle, _mrkfin], _veh, "CREATED", 5, true, true, "Destroy"] call BIS_fnc_setTask;
			hint "The fuel truck has arrived at the station.";
			_returntime = (time + (1800 + (random 600)));

			waitUntil {sleep 5;
				   (not alive _veh)or (dateToNumber date > _TimeLeft) or (time > _returntime)};
			if (dateToNumber date > _TimeLeft) exitWith {_tsk = ["DES", [side_blue, civilian], [format [_tskDesc, _nearestbase, numberToDate [2035, _TimeLeft] select 3, numberToDate [2035, _TimeLeft] select 4, A3_Str_INDEP], _tskTitle, _mrkfin], _fuelstop, "FAILED", 5, true, true, "Destroy"] call BIS_fnc_setTask;
				};

			if (not alive _veh) then
				{
					_tsk = ["DES", [side_blue, civilian], [format [_tskDesc, _nearestbase, numberToDate [2035, _TimeLeft] select 3, numberToDate [2035, _TimeLeft] select 4, A3_Str_INDEP], _tskTitle, _mrkfin], _fuelstop, "SUCCEEDED", 5, true, true, "Destroy"] call BIS_fnc_setTask;
					[-10, 10, _InitialMarker] remoteExec ["AS_fnc_changeCitySupport", 2];
					[5, 0] remoteExec ["prestige", 2];
					{if (_x distance _veh < 1500) then { [10, _x] call playerScoreAdd}} forEach (allPlayers - hcArray);
					 [5, Slowhand] call playerScoreAdd;
						// BE module
					 if (activeBE) then { ["mis"] remoteExec ["fnc_BE_XP", 2]};
					};

					if (time >= _returntime) then
						{
							_wp1 = _grupo addWaypoint [_posbase, 0];
							_wp1 setWaypointType "MOVE";
							_wp1 setWaypointBehaviour "SAFE";
							_wp1 setWaypointSpeed "NORMAL";
							_wp1 setWaypointFormation "COLUMN";
							hint "The fuel truck is RTB";
						};

					waitUntil {sleep 5;
						   ((_veh distance _posbase) < 75)or (not alive _veh) or (dateToNumber date > _TimeLeft)};
					if (dateToNumber date > _TimeLeft) then {_tsk = ["DES", [side_blue, civilian], [format [_tskDesc, _nearestbase, numberToDate [2035, _TimeLeft] select 3, numberToDate [2035, _TimeLeft] select 4, A3_Str_INDEP], _tskTitle, _mrkfin], _fuelstop, "FAILED", 5, true, true, "Destroy"] call BIS_fnc_setTask;
						};

					if (not alive _veh) then
						{
							_tsk = ["DES", [side_blue, civilian], [format [_tskDesc, _nearestbase, numberToDate [2035, _TimeLeft] select 3, numberToDate [2035, _TimeLeft] select 4, A3_Str_INDEP], _tskTitle, _mrkfin], _fuelstop, "SUCCEEDED", 5, true, true, "Destroy"] call BIS_fnc_setTask;
							[-10, 10, _InitialMarker] remoteExec ["AS_fnc_changeCitySupport", 2];
							{if (_x distance _veh < 1500) then { [10, _x] call playerScoreAdd}} forEach (allPlayers - hcArray);
							 [5, Slowhand] call playerScoreAdd;
								// BE module
							 if (activeBE) then { ["mis"] remoteExec ["fnc_BE_XP", 2]};
							};
							if (_veh distance _posbase < 75) then
								{
									_tsk = ["DES", [side_blue, civilian], [format [_tskDesc, _nearestbase, numberToDate [2035, _TimeLeft] select 3, numberToDate [2035, _TimeLeft] select 4, A3_Str_INDEP], _tskTitle, _mrkfin], _fuelstop, "FAILED", 5, true, true, "Destroy"] call BIS_fnc_setTask;
									deleteVehicle _veh;
									deleteGroup _grupo;
								};
						};

					[800, _tsk] spawn borrarTask;
					deleteMarker _mrkfin;
					deleteMarker _mrkfuelstop;
