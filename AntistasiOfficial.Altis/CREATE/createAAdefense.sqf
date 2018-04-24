if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_posMarker","_size","_cmpInfo","_posCmp","_cmp","_objs","_allGroups","_allSoldiers","_allVehicles","_statics","_SPAA","_hasSPAA","_truck","_crate","_unit","_groupCrew","_groupGunners","_markerPatrol","_UAV","_groupUAV","_groupType","_groupPatrol","_garrisonSize","_mrk"];

_posMarker = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;

_allGroups = [];
_allSoldiers = [];
_allVehicles = [];

_spawnSPAA = false;
if(_marker in colinasAA AND spawner getVariable _marker != 0) then {_spawnSPAA = true;};



_groupType = [infAAdef, side_green] call AS_fnc_pickGroup;
_groupAA = [_posMarker, side_green, _groupType] call BIS_Fnc_spawnGroup;
sleep 0.1;
[_groupAA, _marker, "COMBAT","SPAWNED","NOFOLLOW","NOVEH2"] execVM "scripts\UPSMON.sqf";
{[_x] spawn genInitBASES; _allSoldiers pushBack _x} forEach units _groupAA;
_allGroups pushBack _groupAA;

if(_spawnSPAA) then 
{
	_spawnPos = (getMarkerPos _marker) findEmptyPosition [0,25,opSPAA]; //How is the AA vehicle called insccript?
	_SPAA = createVehicle [opSPAA, _spawnPos, [], 0, "CAN_COLLIDE"];
	_groupCrew = createGroup side_red;
	_unit = ([_posMarker, 0, opI_CREW, _groupCrew] call bis_fnc_spawnvehicle) select 0;
	_unit moveInGunner _SPAA;
	_unit = ([_posMarker, 0, opI_CREW, _groupCrew] call bis_fnc_spawnvehicle) select 0;
	_unit moveInCommander _SPAA;
	_SPAA lock 2;
	_allGroups pushBack _groupCrew;
	{[_x] spawn CSATinit; _allSoldiers pushBack _x} forEach units _groupCrew;
};

_garrisonSize = count _allSoldiers;

while{spawner getVariable _marker != 4} do 
{
	if(_spawnSPAA) then 
	{
		waitUntil{sleep 1; ((spawner getVariable _marker == 4) OR (spawner getVariable _marker == 0))};
		if(spawner getVariable _marker == 0) then {_spawnSPAA = false; /*Despawn tigris */};
	}
	else 
	{
		waitUntil{sleep 1; ((spawner getVariable _marker == 4) OR (spawner getVariable _marker != 0))};
		if(spawner getVariable _marker != 0) then {_spawnSPAA = true; /*Despawn tigris */};
	}
	sleep 1;
	
}
[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;