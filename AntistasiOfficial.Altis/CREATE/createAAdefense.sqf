if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_posMarker","_size","_cmpInfo","_posCmp","_cmp","_objs","_allGroups","_allSoldiers","_allVehicles","_statics","_SPAA","_hasSPAA","_truck","_crate","_unit","_groupCrew","_groupGunners","_markerPatrol","_UAV","_groupUAV","_groupType","_groupPatrol","_garrisonSize","_mrk"];

_posMarker = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;

_allGroups = [];
_allSoldiers = [];
_allVehicles = [];

_groupType = [infAAdef, side_green] call AS_fnc_pickGroup;
_groupAA = [_posMarker, side_green, _groupType] call BIS_Fnc_spawnGroup;
sleep 0.1;
[_groupAA, _marker, "COMBAT","SPAWNED","NOFOLLOW","NOVEH2"] execVM "scripts\UPSMON.sqf";
{[_x] spawn genInitBASES; _allSoldiers pushBack _x} forEach units _groupAA;
_allGroups pushBack _groupAA;

_garrisonSize = count _allSoldiers;

waitUntil {sleep 1; (spawner getVariable _marker == 4)};

[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;