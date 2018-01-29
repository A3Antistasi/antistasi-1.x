params ["_vehicleType","_groupType",["_groupCounter",1],"_originPosition","_targetMarker",["_forceThreatVal",1,[1]]];
private ["_isArmed","_targetPosition","_spawnpositionData","_spawnPosition","_direction","_allVehicles","_allGroups","_allSoldiers","_vehicle","_vehicleGroup","_dismountPosition","_threatEvaluationLand","_group","_wpV1_1","_wpV1_2","_wpInf1_1","_wpInf2_1","_wpInf1_2","_wpInf2_2","_infGroupOne","_infGroupTwo","_tempInfo"];

_targetPosition = _targetMarker;
if (typeName _targetMarker == "STRING") then {
	_targetPosition = getMarkerPos _targetMarker;
};
_isArmed = !(_vehicleType in vehTrucks);

_spawnpositionData = [_originPosition, _targetPosition] call AS_fnc_findSpawnSpots;
_spawnPosition = _spawnpositionData select 0;
private _spawnPosition_s = [_spawnPosition, 5, 20, 5, 0, 6, 0, [], _spawnPosition select [0, 2]] call BIS_fnc_findSafePos; //Sparker: otherwise vehicles spawn inside each other
_spawnPosition = +_spawnPosition_s;
_spawnPosition pushback 0.1; //Because findsafepos returns [x, y]
_direction = _spawnpositionData select 1;

_initData = [_spawnPosition, _vehicleType,_direction, side_green, [], [], [], true] call AS_fnc_initialiseVehicle;
_allVehicles = _initData select 0;
_allGroups = _initData select 1;
_allSoldiers = _initData select 2;
_vehicle = (_initData select 3) select 0;
_vehicleGroup = (_initData select 3) select 1;

_vehicle allowDamage true;

_threatEvaluationLand = 1;
if (_forceThreatVal != 1) then {
	_threatEvaluationLand = _forceThreatVal;
} else {
	if (typeName _targetMarker == "STRING") then {
		_threatEvaluationLand = [_targetMarker] call landThreatEval;
	};
};

_dismountPosition = [_targetPosition, _spawnPosition, _threatEvaluationLand] call findSafeRoadToUnload;

for "_i" from 1 to _groupCounter do {
	_group = [_originPosition, side_green, _groupType] call BIS_Fnc_spawnGroup;
	{_x assignAsCargo _vehicle;_x moveInCargo _vehicle} forEach units _group;
	_allGroups pushBack _group;
};

_infGroupOne = _allGroups select 1;
_infGroupTwo = ["", _allGroups select 2] select (_groupCounter > 1);

if !(_isArmed) then {
	_tempInfo = [_vehicle, _infGroupOne, [], _originPosition] call AS_fnc_fillCargo;
	_allSoldiers = _allSoldiers + (_tempInfo select 2);

	[_vehicle,"Inf Truck."] spawn inmuneConvoy;
};

_wpV1_1 = _vehicleGroup addWaypoint [_dismountPosition, 0];
_wpV1_1 setWaypointBehaviour "CARELESS";
_wpV1_1 setWaypointSpeed "FULL";
_wpV1_1 setWaypointType "TR UNLOAD";
_wpV1_1 setWaypointStatements ["true", "(vehicle this) land 'GET OUT';"];

if (_isArmed) then {
	_wpV1_2 = _vehicleGroup addWaypoint [_targetPosition, 1];
	_wpV1_2 setWaypointType "SAD";
	_wpV1_2 setWaypointBehaviour "COMBAT";

	//[_vehicle] spawn smokeCover;
	_vehicle allowCrewInImmobile true;
	[_vehicle,"APC"] spawn inmuneConvoy;
};

_wpInf1_1 = _infGroupOne addWaypoint [_dismountPosition, 0];
_wpInf1_1 setWaypointType "GETOUT";
_wpInf1_1 synchronizeWaypoint [_wpV1_1];
if (_groupCounter > 1) then {
	_wpInf2_1 = _infGroupTwo addWaypoint [_dismountPosition, 0];
	_wpInf2_1 setWaypointType "GETOUT";
	_wpInf2_1 synchronizeWaypoint [_wpV1_1];
};

_wpInf1_2 = _infGroupOne addWaypoint [_targetPosition, 0];
_wpInf1_2 setWaypointType "SAD";
_wpInf1_2 setWaypointBehaviour "AWARE";

if (_groupCounter > 1) then {
	_wpInf2_2 = _infGroupTwo addWaypoint [_targetPosition, 0];
	_wpInf2_2 setWaypointFormation "LINE";
	_wpInf2_2 setWaypointType "SAD";
	_wpInf2_2 setWaypointBehaviour "AWARE";
};

if !(_isArmed) then {
	[_vehicleGroup, _infGroupOne, _targetPosition, _originPosition, _vehicle] spawn {
		params ["_vg","_ig","_tp","_op","_veh"];
		waitUntil {sleep 5; (((units _ig select 0) distance _veh > 50) AND ((assignedCargo _veh)isEqualTo [])) OR ({alive _x} count units _vg == 0)};
		[_vg, _op] spawn AS_fnc_QRF_RTB;
	};
};

[_allVehicles, _allGroups, _allSoldiers]
