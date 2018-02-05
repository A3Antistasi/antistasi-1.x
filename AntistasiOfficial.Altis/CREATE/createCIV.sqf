if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_allGroups","_allCivilians","_allVehicles","_markerPos","_size","_data","_countCiv","_countVehicles","_roads","_group","_counter","_patrolCities","_patrolCounter","_civType","_vehicleType","_orientation","_counter","_spawnPos","_unit","_road","_p1","_p2","_connectedRoads","_vehicle","_wp_civ_1","_wp_civ_2"];

_allGroups = [];
_allCivilians = [];
_allVehicles = [];

_orientation = 0;

_markerPos = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;
_roads = carreteras getVariable _marker;
_roads = _roads call BIS_fnc_arrayShuffle;

_data = server getVariable _marker;
_countCiv = _data select 0;
_countVehicles = _data select 1;


if (_marker in destroyedCities) then {
	_countCiv = _countCiv / 10;
	_countVehicles = _countVehicles / 10;
};

_counter = 0;
_countVehicles = (round (_countVehicles * civPerc)) max 1;
_countCiv = round (_countCiv * civPerc);
if ((daytime < 8) OR (daytime > 21)) then {
	_countCiv = round (_countCiv/4);
	_countVehicles = round (_countVehicles * 1.5);
};
if (_countCiv < 1) then {_countCiv = 1};

_group = createGroup civilian;
_allGroups pushBack _group;

while {(spawner getVariable _marker) AND (_counter < _countCiv)} do {
	if (diag_fps > minimoFPS) then {
		_spawnPos = [];
		while {true} do {
			_spawnPos = [_markerPos, round (random _size), random 360] call BIS_Fnc_relPos;
			if (!surfaceIsWater _spawnPos) exitWith {};
		};
		_civType = selectRandom CIV_units;
		_unit = _group createUnit [_civType, _spawnPos, [],0, "NONE"];
		[_unit] spawn CIVinit;
		_allCivilians pushBack _unit;

		if (_counter < _countVehicles) then {
			_p1 = selectRandom _roads;
			_road = (_p1 nearRoads 5) select 0;
			if !(isNil "_road") then {
				_connectedRoads = roadsConnectedto (_road);
				_p2 = getPos (_connectedRoads select 0);
				_orientation = [_p1,_p2] call BIS_fnc_DirTo;
				_spawnPos = [_p1, 3, _orientation + 90] call BIS_Fnc_relPos;
				_vehicleType = selectRandom CIV_vehicles;
				if (count (_spawnPos findEmptyPosition [0,5,_vehicleType]) > 0) then {
					_vehicle = _vehicleType createVehicle _spawnPos;
					[_vehicle] spawn AS_fnc_protectVehicle;
					_vehicle setDir _orientation;
					_allVehicles pushBack _vehicle;
					[_vehicle] spawn civVEHinit;
				};
			};
		};
		sleep 0.5;
	};

	_counter = _counter + 1;
};

if ((random 100 < ((server getVariable ["prestigeNATO",0]) + (server getVariable ["prestigeCSAT",0]))) AND (spawner getVariable _marker)) then {
	while {true} do {
		_spawnPos = [_markerPos, round (random _size), random 360] call BIS_Fnc_relPos;
		if !(surfaceIsWater _spawnPos) exitWith {};
	};
	_unit = _group createUnit [selectRandom CIV_journalists, _spawnPos, [],0, "NONE"];
	[_unit] spawn CIVinit;
	_allCivilians pushBack _unit;
};

[_group, _marker, "SAFE", "SPAWNED","NOFOLLOW", "NOVEH2","NOSHARE","DoRelax"] execVM "scripts\UPSMON.sqf";

_patrolCities = [_marker] call AS_fnc_getNearbyCities;

_counter = 0;
_patrolCounter = (round (_countCiv / 30)) max 1;
for "_i" from 1 to _patrolCounter do {
	while {(spawner getVariable _marker) AND (_counter < (count _patrolCities - 1))} do {
		_p1 = selectRandom _roads;
		_road = (_p1 nearRoads 5) select 0;
		if !(isNil "_road") then {
			_connectedRoads = roadsConnectedto _road;
			_p2 = getPos (_connectedRoads select 0);
			_orientation = [_p1,_p2] call BIS_fnc_DirTo;

			_group = createGroup civilian;
			_allGroups pushBack _group;

			_vehicleType = selectRandom CIV_vehicles;
			_vehicle = _vehicleType createVehicle _p1;
			[_vehicle, "", []] call bis_fnc_initVehicle;
			_vehicle setDir _orientation;
			if(activeACE) then {[_vehicle, 300] call ace_refuel_fnc_setFuel;} else {_vehicle setfuelcargo 0.1;};
			_vehicle setfuel ((random 45)+5)/100; //Random 5-50% fuel
			_vehicle addEventHandler ["HandleDamage",{if (((_this select 1) find "wheel" != -1) and (_this select 4=="") and (!isPlayer driver (_this select 0))) then {0;} else {(_this select 2);};}];
			_vehicle addEventHandler ["HandleDamage",           //STEF 01-09 civilian disembark on hit, thanks Barbolani
					{
					_vehicle = _this select 0;
					if (side(_this select 3) == WEST) then
						{
						_condu = driver _vehicle;
						if (side _condu == civilian) then {_condu leaveVehicle _vehicle};
						};
					}
					];
			_allVehicles pushBack _vehicle;
			[_vehicle] spawn AS_fnc_protectVehicle;
			_civType = selectRandom CIV_units;
			_unit = _group createUnit [_civType, _p1, [],0, "NONE"];
			[_unit] spawn CIVinit;
			_allCivilians pushBack _unit;
			_unit moveInDriver _vehicle;
			_unit limitspeed 30;
			_group addVehicle _vehicle;
			_group setBehaviour "CARELESS";

			_wp_civ_1 = _group addWaypoint [getMarkerPos (_patrolCities select _counter),0];
			_wp_civ_1 setWaypointType "MOVE";
			_wp_civ_1 setWaypointSpeed "LIMITED";
			_wp_civ_1 setWaypointTimeout [5, 7, 10];
			_wp_civ_1 = _group addWaypoint [_markerPos,1];
			_wp_civ_1 setWaypointType "MOVE";
			_wp_civ_1 setWaypointSpeed "LIMITED";
			_wp_civ_1 setWaypointTimeout [5, 7, 10];
			_wp_civ_2 = _group addWaypoint [_markerPos,0];
			_wp_civ_2 setWaypointType "CYCLE";
			_wp_civ_2 setWaypointSpeed "LIMITED";
			_wp_civ_2 synchronizeWaypoint [_wp_civ_1];
		};
		_counter = _counter + 1;
		sleep 5;
	};
};

waitUntil {sleep 1; !(spawner getVariable _marker)};
[_allGroups, _allCivilians] call AS_fnc_despawnUnitsNow;
[[],[],_allVehicles] call AS_fnc_despawnUnits;
