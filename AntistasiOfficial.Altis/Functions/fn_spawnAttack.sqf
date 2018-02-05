private ["_objectives","_possibleTargets", "_difficulty", "_includeCSAT","_scoreLand","_scoreAir","_scoreNeededLandBase","_scoreNeededAirBase","_objective","_easyTarget","_data","_prestigeBLUFOR","_prestigeOPFOR","_base","_airport","_position", "_scoreNeededLand", "_scoreNeededAir", "_nearbyThreat", "_size", "_statics", "_priority"];

_objectives = [];
_possibleTargets = [];
_difficulty = 0;

_possibleTargets = mrkFIA - destroyedCities - controles - colinas - puestosFIA - ["FIA_HQ"];
_includeCSAT = true;
cuentaCA = cuentaCA + 600; //experimental

diag_log format ["fn_spawnAttack.sqf: initial possible targets %1", _possibleTargets];

if ((random 100 > (server getVariable "prestigeCSAT")) or ({_x in bases} count mrkFIA == 0) || (server getVariable "blockCSAT")) then {
	diag_log format ["fn_spawnAttack.sqf:  removing cities from objectives."];
	_possibleTargets = _possibleTargets - ciudades;
	_includeCSAT = false;
};

if (_possibleTargets isEqualTo []) exitWith {diag_log format ["fn_spawnAttack.sqf:  no possible targets found."];};

_scoreLand = APCAAFcurrent + (5*tanksAAFcurrent);
_scoreAir = helisAAFcurrent + (5*planesAAFcurrent);
if (_includeCSAT) then {_scoreLand = _scoreLand + 15; _scoreAir = _scoreAir + 15};

_scoreNeededLandBase = [0, 3] select (count (unlockedWeapons arrayIntersect genATLaunchers) > 0);
_scoreNeededAirBase = [0, 5] select (count (unlockedWeapons arrayIntersect genAALaunchers) > 0);

{
	_objective = _x;
	_easyTarget = false;
	diag_log format ["fn_spawnAttack.sqf: analyzing objective: %1.", _objective];
	if (_objective in ciudades) then {
		diag_log "fn_spawnAttack.sqf: objective is a city.";
		_data = server getVariable _objective;
		_prestigeBLUFOR = _data select 3;
		_prestigeOPFOR = _data select 2;
		if ((_prestigeOPFOR < 35) and (_prestigeBLUFOR > 0)) then {
			_priority = floor (0.05*(server getVariable "prestigeCSAT"));
			for "_i" from 1 to _priority do {
					_objectives pushBack _objective;
			};
		};
	} else {
		_base = [_objective, true] call AS_fnc_findBaseForCA;
		_airport = [_objective, true] call AS_fnc_findAirportForCA;
		diag_log format ["fn_spawnAttack.sqf: objective is not a city. Source base: %1 source airport: %2", _base, _airport];
		if (!(_base == "") or !(_airport == "")) then {
			_position = getMarkerPos _objective;
			_scoreNeededLand = _scoreNeededLandBase;
			_scoreNeededAir = _scoreNeededAirBase;

			if !(_base == "") then {
				_scoreNeededLand = _scoreNeededLand + 2 * ({(isOnRoad getMarkerPos _x) and (getMarkerPos _x distance _position < distanciaSPWN)} count puestosFIA);
			};

			{
				if (getMarkerPos _x distance _position < distanciaSPWN) then {
					_nearbyThreat = _x;
					_garrison = garrison getVariable [_nearbyThreat, []];

					if !(_base == "") then {
						_scoreNeededLand = _scoreNeededLand + (2*({(_x == guer_sol_LAT)} count _garrison)) + (floor((count _garrison)/8));
						if ((_nearbyThreat in bases) or (_nearbyThreat in aeropuertos)) then {_scoreNeededLand = _scoreNeededLand + 3};
					};
					if !(_airport == "") then {
						_scoreNeededAir = _scoreNeededAir + (floor((count _garrison)/8));
						if ((_nearbyThreat in bases) or (_nearbyThreat in aeropuertos)) then {_scoreNeededAir = _scoreNeededAir + 3};
					};
					_size = [_nearbyThreat] call sizeMarker;
					_statics = staticsToSave select {_x distance (getMarkerPos _nearbyThreat) < _size};
					if (count _statics > 0) then {
						if !(_base == "") then {_scoreNeededLand = _scoreNeededLand + ({typeOf _x in statics_allMortars} count _statics) + (2*({typeOf _x in statics_allATs} count _statics))};
						if !(_airport == "") then {_scoreNeededAir = _scoreNeededAir + ({typeOf _x in statics_allMGs} count _statics) + (5*({typeOf _x in statics_allAAs} count _statics))}
					};
				};
			} forEach _possibleTargets;
			diag_log format ["Marcador: %1. ScoreneededLand: %2. ScoreneededAir: %3. ScoreLand: %4. ScoreAir: %5",_objective, _scoreNeededLand, _scoreNeededAir,_scoreLand,_scoreAir];

			if (_scoreNeededLand > _scoreLand) then {
				_base = "";
			} else {
				if (!(_base == "") and (_scoreNeededLand < 4)) then {
					if (((count (garrison getVariable [_objective,[]])) < 4) and (_difficulty < 4)) then {
						if (!(_objective in bases) and !(_objective in aeropuertos)) then {
							_easyTarget = true;
							if !(_objective in smallCAmrk) then {
								//if (debug) then {hint format ["%1 Es facil para bases",_objective]; sleep 5};
								_difficulty = _difficulty + 2;
								[_objective,_base] remoteExec ["patrolCA",  call AS_fnc_getNextWorker];
								sleep 15;
							};
						};
					};
				};
			};

			if (_scoreNeededAir > _scoreAir) then {
				_airport = "";
			} else {
				if (!(_airport == "") and (_base == "") and !(_easyTarget) and (_scoreNeededAir < 4)) then {
					if (((count (garrison getVariable [_objective,[]])) < 4) and (_difficulty < 4)) then {
						if (!(_objective in bases) and !(_objective in aeropuertos)) then {
							_easyTarget = true;
							if !(_objective in smallCAmrk) then {
								//if (debug) then {hint format ["%1 Es facil para aire",_objective]; sleep 5};
								_difficulty = _difficulty + 1;
								[_objective,_airport] remoteExec ["patrolCA", call AS_fnc_getNextWorker];
								sleep 15;
							};
						};
					};
				};
			};
			diag_log format ["fn_spawnAttack.sqf: Marcador: %1. ScoreNeededLand: %2. ScoreLand: %3. ScoreNeededAir: %4. ScoreAir: %5",_objective,_scoreNeededLand,_scoreLand,_scoreNeededAir,_scoreAir];

			diag_log format ["fn_spawnAttack.sqf: source base: %1 source airport: %2 easy target: %3", _base, _airport, _easyTarget];

			if ((!(_base == "") or !(_airport == "")) and !(_easyTarget)) then {
				_priority = 1;
				if ((_objective in power) or (_objective in fabricas)) then {_priority = 4};
				if ((_objective in bases) or (_objective in aeropuertos)) then {_priority = 5};
				if (_objective in recursos) then {_priority = 3};

				if !(_base == "") then {
					if !(_airport == "") then {_priority = _priority *2};
					if (_objective == [_possibleTargets,_base] call bis_fnc_nearestPosition) then {_priority = _priority *2};
				};
				diag_log format ["fn_spawnAttack.sqf: adding to _objectives. Priority: %1", _priority];
				for "_i" from 1 to _priority do {
					_objectives pushBack _objective;
				};
			};
		};
	};
} forEach _possibleTargets;
diag_log format ["ObjectiveS: %1, difficulty: %2", _objectives, _difficulty];

if ((count _objectives > 0) and (_difficulty < 3)) then {
	_objective = selectRandom _objectives;
	if !(_objective in ciudades) then
	{
		if((count allUnits) < 170) then //If there are not too many units on the map already, 17/08 Stef increased from 150 to 170
		{
			[_objective] remoteExec ["combinedCA", call AS_fnc_getNextWorker];
		}
		else
		{
			diag_log "Info: attack canceled. Too many units spawned in game.";
		};
	}
	else
	{
		[_objective] remoteExec ["CSATpunish", call AS_fnc_getNextWorker]
	};
	cuentaCA = cuentaCA - 600; //experimental
};

if !("CONVOY" in misiones) then {
	if (_objectives isEqualTo []) then {
		{
			_base = [_x] call AS_fnc_findBaseForConvoy;
			if !(_base == "") then {
				_data = server getVariable _x;
				_prestigeOPFOR = _data select 2;
				_prestigeBLUFOR = _data select 3;
				if (_prestigeOPFOR + _prestigeBLUFOR < 95) then {
					_objectives pushBack [_x,_base];
				};
			};
		} forEach (ciudades - mrkAAF);

		if !(_objectives isEqualTo []) then {
			_objective = selectRandom _objectives;
			[(_objective select 0),(_objective select 1),"civ"] remoteExec ["CONVOY", call AS_fnc_getNextWorker];
		};
	};
};
diag_log format ["ObjectivE %1", _objective];
