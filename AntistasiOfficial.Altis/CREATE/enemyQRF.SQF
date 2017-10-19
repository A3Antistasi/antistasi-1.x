if (!isServer and hasInterface) exitWith{};

/*
parameters
0: base/airport/carrier to start from (marker)
1: target location (position)
2: marker for dismounts to patrol (marker)
3: patrol duration (time in minutes)
4: composition: transport/destroy/mixed (string)
5: size: large/small (string)
6: source of the QRF request (optional)

If origin is an airport/carrier, the QRF will consist of air cavalry. Otherwise it'll be ground forces in MRAPs/trucks.
*/
params ["_orig", "_dest", "_mrk", "_duration", "_composition", "_size", ["_source", ""], ["_varName", ""]];

// FIA bases/airports
_bases = bases arrayIntersect mrkAAF;
_airports = aeropuertos arrayIntersect mrkAAF;

_posComp = ["transport", "destroy", "mixed"];
if !(_composition in _posComp) exitWith {};

// define type of QRF and vehicles by type of origin, plus method of troop insertion by air (rope or land)
_type = "air";
_method = "rope";
_side = side_red;
_faction = "RED";
_lead = opHeliSD;
_transport = opHeliFR;
_dismountGroup = [opGroup_Recon_Team, side_red] call AS_fnc_pickGroup;
if (_size == "large") then {
	_dismountGroup = [opGroup_Squad, side_red] call AS_fnc_pickGroup;
};
_dismountGroupEscort = [infTeam, side_green] call AS_fnc_pickGroup;
if !(_orig == "spawnCSAT") then {
	_method = "land";
	_side = side_green;
	_faction = "GREEN";
	_lead = heli_escort;
	if (_size == "small") then {
		_transport = heli_default;
		_dismountGroup = [infTeam, side_green] call AS_fnc_pickGroup;
		if (_orig in _bases) then {
			_type = "land";
			_lead = selectRandom vehLead;
			_transport = enemyMotorpoolDef;
			_dismountGroup = [infSquad, side_green] call AS_fnc_pickGroup;
		};
	} else {
		_transport = heli_transport;
		_dismountGroup = [infSquad, side_green] call AS_fnc_pickGroup;
		_method = "ROPE";
		if (_orig in _bases) then {
			_type = "land";
			_lead = selectRandom vehAPC;
			_transport = enemyMotorpoolDef;
			_dismountGroup = [infSquad, side_green] call AS_fnc_pickGroup;
		};
	};
};

private _origMarker = _orig;
if (typeName _orig == "ARRAY") then {
	_origMarker = [markers, _orig] call BIS_Fnc_nearestPosition;
};

// get the position of the target marker
if !(typeName _orig == "ARRAY") then {
	_orig = getMarkerPos _orig;
};

// create a patrol marker if none provided
if (_mrk == "none") then {
	_mrk = createMarkerLocal [format ["Patrol-%1", random 100],_dest];
	_mrk setMarkerShapeLocal "RECTANGLE";
	_mrk setMarkerSizeLocal [150,150];
	_mrk setMarkerTypeLocal "hd_warning";
	_mrk setMarkerColorLocal "ColorRed";
	_mrk setMarkerBrushLocal "DiagGrid";
    _mrk setMarkerAlpha 0;
};

_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration];
_endTime = dateToNumber _endTime;

// arrays of all spawned units/groups
_grupos = [];
_soldados = [];
_vehiculos = [];

// initialise groups, two for vehicles, three for dismounts
_grpVeh1 = createGroup _side;
_grupos pushBack _grpVeh1;

_grpVeh2 = createGroup _side;
_grupos pushBack _grpVeh2;

_grpDis1 = createGroup _side;
_grupos pushBack _grpDis1;

_grpDis2 = createGroup _side;
_grupos pushBack _grpDis2;

_grpDisEsc = createGroup _side;
_grupos pushBack _grpDisEsc;

private _dir = [_orig, _dest] call BIS_fnc_dirTo;

// initialisation of vehicles
_initVehs = {
	params ["_specs"];
	_specs = _specs + [_dir, _side, _vehiculos, _grupos, _soldados, true];
	_specs call AS_fnc_initialiseVehicle;
};

// air cav
if (_type == "air") then {

	if ((_composition == "destroy") || (_composition == "mixed")) then {
		// attack chopper/armed escort

		private _vehData = [[_orig, _lead]] call _initVehs;
		_vehiculos = _vehData select 0;
		_grupos = _vehData select 1;
		_soldados = _vehData select 2;

		_heli1 = (_vehData select 3) select 0;
		_grpVeh1 = (_vehData select 3) select 1;

		_heli1 lock 3;

		// spawn loiter script for armed escort
		diag_log format ["Escort dispatched to %1", _dest];
		[_grpVeh1, _orig, _dest, _duration*60] spawn AS_fnc_QRF_gunship;
	};

	// small delay to prevent crashes when both helicopters are spawned
	if (_composition == "mixed") then {
		sleep 5;
	};

	if ((_composition == "transport") || (_composition == "mixed")) then {
		// landing pad, to allow for dismounts
		_landpos1 = [];
		if (_source == "campQRF") then {
			_landpos1 = [_dest, 300, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
		}
		else {
			_landpos1 = [_dest, 50, 300, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
		};
		_landpos1 set [2, 0];
		_pad1 = createVehicle ["Land_HelipadEmpty_F", _landpos1, [], 0, "NONE"];
		_vehiculos = _vehiculos + [_pad1];

		// shift the spawn position of second chopper to avoid crash
		_pos2 = _orig;
		_zshift2 = (_orig select 2) + 50;
		_pos2 set [2, _zshift2];

		// troop transport chopper
		private _vehData = [[_pos2, _transport]] call _initVehs;
		_vehiculos = _vehData select 0;
		_grupos = _vehData select 1;
		_soldados = _vehData select 2;

		_heli2 = (_vehData select 3) select 0;
		_grpVeh2 = (_vehData select 3) select 1;

		_heli2 lock 3;

		// spawn dismounts
		_grpDis2 = [_orig, _side, _dismountGroup] call BIS_Fnc_spawnGroup;
		[_grpDis2, _side, true, "none"] call AS_fnc_initialiseUnits;
		{
			_soldados pushBack _x;
			_x assignAsCargo _heli2;
			_x moveInCargo _heli2;
		} forEach units _grpDis2;
		_grpDis2 selectLeader (units _grpDis2 select 0);

		// spawn dismount script
		diag_log format ["Transport dispatched to %1", _dest];
		if ((_size == "large") && !(_faction isEqualTo "RED")) then {
			_grpDis1 = [_orig, _side, _dismountGroup] call BIS_Fnc_spawnGroup;
			[_grpDis1, _side, true, "none"] call AS_fnc_initialiseUnits;
			{
				_soldados pushBack _x;
				_x assignAsCargo _heli2;
				_x moveInCargo _heli2;
			} forEach units _grpDis1;
			_grpDis1 selectLeader (units _grpDis1 select 0);

			[_grpVeh2, _pos2, _landpos1, _mrk, [_grpDis1,_grpDis2], _duration*60, _method] call AS_fnc_QRF_airCavalry;
		}
		else {
			[_grpVeh2, _pos2, _landpos1, _mrk, _grpDis2, _duration*60, _method] spawn AS_fnc_QRF_airCavalry;
		};

		// if the QRF is dispatched to an FIA camp, provide the group
		if (_source == "campQRF") then {
			if (_size == "large") then {
				[format ["DefCamp -- QRF -- group 1: %1; group 2: %2", _grpDis1, _grpDis2, server getVariable ["campQRF", "none"]]] remoteExec ["AS_fnc_logOutput", 2];
			}
			else {
				[format ["DefCamp -- QRF -- group 1: %1", _grpDis2, server getVariable ["campQRF", "none"]]] remoteExec ["AS_fnc_logOutput", 2];
			};
		};
	};
}

// ground QRF
else {
	// find spawn positions on a road
	_posData = [_orig, _dest] call AS_fnc_findSpawnSpots;
	_posRoad = _posData select 0;
	_dir = _posData select 1;

	if ((_composition == "destroy") || (_composition == "mixed")) then {
		// first MRAP, escort
		private _vehData = [[_posRoad, _lead]] call _initVehs;
		_vehiculos = _vehData select 0;
		_grupos = _vehData select 1;
		_soldados = _vehData select 2;

		_veh1 = (_vehData select 3) select 0;
		_grpVeh1 = (_vehData select 3) select 1;
		_grpDisEsc = [];

		if (_size == "large") then {
			_grpDisEsc = [_orig, _side, _dismountGroupEscort] call BIS_Fnc_spawnGroup;
			[_grpDisEsc, _side, true, "none"] call AS_fnc_initialiseUnits;
			{
				_soldados pushBack _x;
				_x assignAsCargo _veh1;
				_x moveInCargo _veh1;
			} forEach units _grpDisEsc;
			_grpDisEsc selectLeader (units _grpDisEsc select 0);
		};

		// add waypoints
		[_grpVeh1, _orig, _dest, _mrk, _grpDisEsc, _duration*60] spawn AS_fnc_QRF_leadVehicle;
		diag_log format ["Escort dispatched to %1", _dest];
	};

	// small delay to allow for AI pathfinding shenanigans
	if (_composition == "mixed") then {
		sleep 15;
	};

	if ((_composition == "transport") || (_composition == "mixed")) then {
		// dismount position
		_dist = 200 min ([_mrk] call sizeMarker);
		_dist = -1 * ((400 - _dist) / 10);
		_dist = _dist max (-35);
		_landpos1 = [_dest, _posRoad, _dist] call findSafeRoadToUnload;

		// second vehicle
		private _vehData = [[_posRoad, _transport]] call _initVehs;
		_vehiculos = _vehData select 0;
		_grupos = _vehData select 1;
		_soldados = _vehData select 2;

		_veh2 = (_vehData select 3) select 0;
		_grpVeh2 = (_vehData select 3) select 1;

		// add dismounts
		_grpDis2 = [_orig, _side, _dismountGroup] call BIS_Fnc_spawnGroup;
		[_grpDis2, _side, true, "none"] call AS_fnc_initialiseUnits;
		{
			_soldados pushBack _x;
			_x assignAsCargo _veh2;
			_x moveInCargo _veh2;
		} forEach units _grpDis2;
		_grpDis2 selectLeader (units _grpDis2 select 0);

		if (_size == "large") then {
			_grpDis1 = [_orig, _side, _dismountGroup] call BIS_Fnc_spawnGroup;
			[_grpDis1, _side, true, "none"] call AS_fnc_initialiseUnits;
			{
				_soldados pushBack _x;
				_x assignAsCargo _veh2;
				_x moveInCargo _veh2;
			} forEach units _grpDis1;
			_grpDis1 selectLeader (units _grpDis1 select 0);
		};

		// spawn dismount script
		diag_log format ["Transport dispatched to %1", _dest];
		[_grpVeh2, _orig, _landpos1, _mrk, [_grpDis1, _grpDis2], _duration*60] spawn AS_fnc_QRF_truck;
	};
};

{_x allowDamage true} forEach _vehiculos;

waitUntil {sleep 10; (dateToNumber date > _endTime) or ({alive _x AND !captive _x} count _soldados == 0)};

if !(_varName isEqualTo "") then {
	server setVariable [_varName,true,true];
};

// remove the remains
{
	_soldado = _x;
	waitUntil {sleep 1; {_x distance _soldado < distanciaSPWN} count (allPlayers - hcArray) == 0};
	deleteVehicle _soldado;
} forEach _soldados;

{deleteGroup _x} forEach _grupos;

{
	_vehiculo = _x;
	waitUntil {sleep 1; {_x distance _vehiculo < distanciaSPWN/2} count (allPlayers - hcArray) == 0};
	deleteVehicle _x
} forEach _vehiculos;

_data = [_soldados, _grupos, _vehiculos] //Added this because it's required in INT_Reinforcements.sqf