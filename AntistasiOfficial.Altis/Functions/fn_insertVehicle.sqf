/*
 	Description:
		- Insert a vehicle by helicopter.

	Parameters:
		0: Class of the helicopter (default: heli_transport as defined in the template)
		1: Class of the vehicle to be inserted
		2: Position to spawn in
		3: Destination

 	Returns:
		Nothing

 	Example:
		["B_Heli_Transport_03_F", "B_MRAP_01_hmg_F", getMarkerPos "spawnNATO", position player] spawn AS_fnc_insertVehicle
*/

params [["_helicopterClass", heli_transport], "_vehicleClass", "_spawnPosition", "_dropPosition"];
private ["_vehicleSpawnPos", "_vehicle", "_heliData", "_helicopter", "_heliGroup", "_wpIn"];

_vehicleSpawnPos = [_spawnPosition, [8577.8,25293.5,6.86646e-005]] select (worldName == "Altis");

_heliData = [_spawnPosition, [_spawnPosition, _dropPosition] call BIS_fnc_dirTo, _helicopterClass, side_blue] call bis_fnc_spawnvehicle;
_helicopter = _heliData select 0;
_heliGroup = _heliData select 2;
_helicopter setPosATL [getPosATL _helicopter select 0, getPosATL _helicopter select 1, 300];

sleep 1;
_vehicle = _vehicleClass createVehicle _vehicleSpawnPos;
_helicopter setSlingLoad _vehicle;
sleep 1;

_helicopter disableAI "TARGET";
_helicopter disableAI "AUTOTARGET";
Slowhand hcSetGroup [_heliGroup];
_heliGroup setVariable ["isHCgroup", true, true];

waitUntil {sleep 2; (_helicopter distance2d _dropPosition < 100) || !(canMove _helicopter)};
Slowhand hcRemoveGroup _heliGroup;
_wpIn = _heliGroup addWaypoint [_dropPosition, 10];
_heliGroup setCurrentWaypoint _wpIn;

sleep 2;
_helicopter flyInHeight 5;
waitUntil {sleep 0.5; (((getPosATL _helicopter) select 2) < 15)};
_vehicle allowDamage false;
_helicopter setSlingLoad objNull;
_helicopter flyInHeight 50;
_heliGroup move _spawnPosition;
sleep 3;
_vehicle allowDamage true;

waitUntil {sleep 1; ({alive _x} count units _heliGroup == 0) || ({_x distance2D _spawnPosition > 200} count units _heliGroup == 0)};
{deleteVehicle _x} forEach units _heliGroup + [vehicle leader _heliGroup]; deleteGroup _heliGroup;