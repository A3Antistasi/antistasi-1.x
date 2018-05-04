if (!isServer and hasInterface) exitWith {};

params [["_marker", nil], ["_type", ""], ["_create", false]];

private ["_mapMarker", "_duration","_endTime", "_spawnPosition","_crate", "_house","_groupType","_group","_crateType"];

if(_create) then
{
	
	if(isnil "_marker") then
	{

	}
	else
	{
		diag_log format ["Marker type = %1" , typeName _marker];
		_spawnPosition = getMarkerPos _marker;
	};

	_mapMarker = createMarker [format ["SUP%1", random 100], _spawnPosition];
	_mapMarker setMarkerShape "ICON";
	_mapMarker setMarkerType "mil_warning";
	_mapMarker setMarkerAlpha 1;




	// Create Marker and add it to the supply list


	diag_log format ["ANTISTASI - SUP_CitySupply pos %1, type %2, marker %3",_spawnPosition, _crateType, _marker];
	[_spawnPosition, _crateType, _marker] remoteExec ["createSupplyBox", call AS_fnc_getNextWorker];
	waitUntil {sleep 1; (count (nearestObjects [_spawnPosition, ["Land_PaperBox_01_open_boxes_F", "Land_PaperBox_01_open_water_F", "CargoNet_01_barrels_F"], 10, true])  == 0)};
};



if(!_create) then {_spawnPosition = getMarkerPos _marker;};

diag_log format ["Supply crate at %1 spawning in troups", _marker];


_allGroups = [];
_allSoldiers = [];

_groupType = [infSquad, side_green] call AS_fnc_pickGroup;
_group = [_spawnPosition, side_green, _groupType] call BIS_Fnc_spawnGroup;
_allGroups pushBack _group;

{
	_group = _x;
	{
		[_x] spawn genInit;
		_allSoldiers pushBack _x;
	} forEach units _group;
} forEach _allGroups;

//waitUntil {sleep 1; spawner getVariable _marker > 1}; //Activate when merged with new spawn system
waitUntil {sleep 1; !(spawner getVariable _marker)};

if(count (nearestObjects [_spawnPosition, ["Land_PaperBox_01_open_boxes_F", "Land_PaperBox_01_open_water_F", "CargoNet_01_barrels_F"], 200, true])  == 0) then
{
	//FIA has taken the Supply Box, not in range any more
	spawner setVariable [_marker, nil, true];
	countSupplyCrates--;
	publicVariable "countSupplyCrates";
};

deleteMarker _mapMarker;
{deleteVehicle _x} forEach _allSoldiers;
{deleteGroup _x} forEach _allGroups;
