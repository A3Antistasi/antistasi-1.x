/*
parameters
0: target location (marker)
1: duration of the script's runtime (integer, minutes)
2: timing of the waves with regards to the starting time (array of integers, minutes after script call)
3: wave specifications: "QRF_air/land_mixed/destroy/transport_small/large", "CSAT" (array of strings)
4: (optional) object to add the stop action to (object)

If origin is an airport/carrier, the QRF will consist of air cavalry. Otherwise it'll be ground forces in MRAPs/trucks.

Example: 0 = ["Paros", 15, [2, 3, 10], ["QRF_air_transport_small", "QRF_land_mixed_large", "Attack"]] spawn attackWaves;
*/
_targetMarker = _this select 0;
_duration = _this select 1;
_waveIntervals = _this select 2;
_waveSpecs = _this select 3;

_targetLocation = getMarkerPos _targetMarker;

// break if timing and specs of waves don't match
if !(count _waveIntervals == count _waveSpecs) exitWith {diag_log format ["Script failure: number and type of waves do not match -- intervals: %1; types: %2", _waveIntervals, _waveSpecs]};

if (server getVariable "waves_active") exitWith {diag_log "Script failure: attack waves already active."};

_startTime = dateToNumber date;
_endTime = dateToNumber ([date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration]);

server setVariable ["waves_start", _startTime, true];
server setVariable ["waves_active", true, true];

// check if a stop action is requested
if (count _this > 4) then {
	_breakCondition = _this select 3 select 4;
	_action = _breakCondition addAction ["Stop Attack Waves", {
	server setVariable ["waves_active", false, true];
	server setVariable ["waves_duration", (dateToNumber date) - (server getVariable "waves_start")];
	},nil,0,false,true,"",""];
};

// find closest base
_basesAAF = bases - mrkFIA;
_bases = [];
_base = "";
_posBase = [];
{
	_base = _x;
	_posBase = getMarkerPos _base;
	if ((_targetLocation distance _posBase < 7500) and (_targetLocation distance _posBase > 1500) and (not (spawner getVariable _base))) then {_bases = _bases + [_base]}
} forEach _basesAAF;
if (count _bases > 0) then {_base = [_bases, _targetLocation] call BIS_fnc_nearestPosition; _posBase = getMarkerPos _base;} else {_base = ""};


// find closest airport
_airportsAAF = aeropuertos - mrkFIA;
_airports = [];
_airport = "";
_posAirport = [];
{
	_airport = _x;
	_posAirport = getMarkerPos _airport;
	if ((_targetLocation distance _posAirport < 7500) and (_targetLocation distance _posAirport > 1500) and (not (spawner getVariable _airport))) then {_airports = _airports + [_airport]}
} forEach _airportsAAF;
if (count _airports > 0) then {_airport = [_airports, _targetLocation] call BIS_fnc_nearestPosition; _posAirport = getMarkerPos _airport;} else {_airport = ""};

// create marker at target location
_mrk = createMarkerLocal [format ["Attack-%1", random 100],_targetLocation];
_mrk setMarkerShapeLocal "RECTANGLE";
_mrk setMarkerSizeLocal [150,150];
_mrk setMarkerTypeLocal "hd_warning";
_mrk setMarkerColorLocal "ColorRed";
_mrk setMarkerBrushLocal "DiagGrid";
_mrk setMarkerAlpha 0;

// trigger of wave types
_triggerWave = {
    private _waveType = _this select 0;

    switch (_waveType) do {

    	// QRF, air, small
    	case "QRF_air_mixed_small": {
   			if !(_airport == "") then {
   				[_airport, _targetLocation, _targetMarker, _duration, "mixed", "small"] remoteExec ["enemyQRF",HCattack];
   			}
   			else {
   				["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "small"] remoteExec ["enemyQRF",HCattack];
   			};
    	};
    	case "QRF_air_transport_small": {
   			if !(_airport == "") then {
   				[_airport, _targetLocation, _targetMarker, _duration, "transport", "small"] remoteExec ["enemyQRF",HCattack];
   			}
   			else {
   				["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "small"] remoteExec ["enemyQRF",HCattack];
   			};
    	};
    	case "QRF_air_destroy_small": {
   			if !(_airport == "") then {
   				[_airport, _targetLocation, _targetMarker, _duration, "destroy", "small"] remoteExec ["enemyQRF",HCattack];
   			}
   			else {
   				["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "small"] remoteExec ["enemyQRF",HCattack];
   			};
    	};

      // QRF, air, large
      case "QRF_air_mixed_large": {
        if !(_airport == "") then {
          [_airport, _targetLocation, _targetMarker, _duration, "mixed", "large"] remoteExec ["enemyQRF",HCattack];
        }
        else {
          ["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "large"] remoteExec ["enemyQRF",HCattack];
        };
      };
      case "QRF_air_transport_large": {
        if !(_airport == "") then {
          [_airport, _targetLocation, _targetMarker, _duration, "transport", "large"] remoteExec ["enemyQRF",HCattack];
        }
        else {
          ["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "large"] remoteExec ["enemyQRF",HCattack];
        };
      };
      case "QRF_air_destroy_large": {
        if !(_airport == "") then {
          [_airport, _targetLocation, _targetMarker, _duration, "destroy", "large"] remoteExec ["enemyQRF",HCattack];
        }
        else {
          ["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "large"] remoteExec ["enemyQRF",HCattack];
        };
      };

    	// QRF, land, small
    	case "QRF_land_mixed_small": {
   			if !(_base == "") then {
   				[_base, _targetLocation, _targetMarker, _duration, "mixed", "small"] remoteExec ["enemyQRF",HCattack];
   			}
   			else {
   				["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "small"] remoteExec ["enemyQRF",HCattack];
   			};
    	};
    	case "QRF_land_transport_small": {
   			if !(_base == "") then {
   				[_base, _targetLocation, _targetMarker, _duration, "transport", "small"] remoteExec ["enemyQRF",HCattack];
   			}
   			else {
   				["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "small"] remoteExec ["enemyQRF",HCattack];
   			};
    	};
    	case "QRF_land_destroy_small": {
   			if !(_base == "") then {
   				[_base, _targetLocation, _targetMarker, _duration, "destroy", "small"] remoteExec ["enemyQRF",HCattack];
   			}
   			else {
   				["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "small"] remoteExec ["enemyQRF",HCattack];
   			};
    	};

      // QRF, land, large
      case "QRF_land_mixed_large": {
        if !(_base == "") then {
          [_base, _targetLocation, _targetMarker, _duration, "mixed", "large"] remoteExec ["enemyQRF",HCattack];
        }
        else {
          ["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "large"] remoteExec ["enemyQRF",HCattack];
        };
      };
      case "QRF_land_transport_large": {
        if !(_base == "") then {
          [_base, _targetLocation, _targetMarker, _duration, "transport", "large"] remoteExec ["enemyQRF",HCattack];
        }
        else {
          ["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "large"] remoteExec ["enemyQRF",HCattack];
        };
      };
      case "QRF_land_destroy_large": {
        if !(_base == "") then {
          [_base, _targetLocation, _targetMarker, _duration, "destroy", "large"] remoteExec ["enemyQRF",HCattack];
        }
        else {
          ["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "large"] remoteExec ["enemyQRF",HCattack];
        };
      };

    	// CSAT
      case "CSAT_small": {
        ["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "small"] remoteExec ["enemyQRF",HCattack];
      };
      case "CSAT_large": {
        ["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "large"] remoteExec ["enemyQRF",HCattack];
      };

      // default: CSAT, small
    	default {
        diag_log format ["Incorrect call of QRF. Details: %1; %2; %3; %4", _targetLocation, _duration, _waveIntervals, _waveSpecs];
    		["spawnCSAT", _targetLocation, _targetMarker, _duration, "transport", "small"] remoteExec ["enemyQRF",HCattack];
    	};
    };
};

// times at which the waves will be dispatched
_waveTimes = [];
for "_i" from 0 to (count _waveIntervals - 1) do {
	_waveTimes pushBack dateToNumber ([date select 0, date select 1, date select 2, date select 3, (date select 4) + (_waveIntervals select _i)]);
};

_break = false;
_nrOfWaves = count _waveTimes;
_waveIndex = 0;
_currentWave = 0;

_manualStop = false;

// while attacks are going on
while {(server getVariable "waves_active") && (dateToNumber date < _endTime) && !(_break)} do {
	_currentWave = _waveTimes select _waveIndex;

	// while the current wave is active
	while {(server getVariable "waves_active") && (dateToNumber date < _endTime)} do {
		if (_waveIndex == _nrOfWaves) exitWith {
			_break = true;
		};

		if (dateToNumber date > _currentWave) exitWith {
			_waveIndex = _waveIndex + 1;
		};

		sleep 10;
	};
	if (!(_break) && (server getVariable "waves_active")) then {
		[_waveSpecs select (_waveIndex - 1)] call _triggerWave;
		diag_log format ["Wave triggered: %1", _waveSpecs select (_waveIndex - 1)];
	};
	sleep 1;
};

if !(server getVariable "waves_active") then {
	_manualStop = true;
	// make the duration available externally
	server setVariable ["waves_duration", (dateToNumber date) - (server getVariable "waves_start")];
};

server setVariable ["waves_active", false, true];

deleteMarker _mrk;