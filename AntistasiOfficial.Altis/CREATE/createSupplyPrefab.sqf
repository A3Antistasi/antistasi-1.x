if (!isServer and hasInterface) exitWith {};

params [["_marker", nil], ["_type", ""], ["_create", false]];
diag_log format ["SUP_CitySupply, _type = %1, now creating",_type];
private ["_duration","_endTime", "_spawnPosition","_crate", "_house","_groupType","_group"];

if(_create) then
{
	_posHQ = getMarkerPos guer_respawn;

	_houseType = "Land_i_Shed_Ind_F";
	_crateType = "Land_PaperBox_01_open_boxes_F";
	if(_type == "WATER") then
	{
		_crateType = "Land_PaperBox_01_open_water_F";
	};
	if(_type == "FUEL") then
	{
		_crateType = "CargoNet_01_barrels_F";
	};
	_allSheds = nearestObjects [_posHQ, [_houseType], 4000, true];
	sleep 1;

	if (count _allSheds == 0) exitWith
	{
		diag_log format ["Supply mission not created, could not find %1", _houseType];
	};

	_selectedShed = selectRandom _allSheds;
	_spawnPosition = position _selectedShed;
	//Marker will do the following much easier
	while {
		count (
			nearestObjects [_spawnPosition, ["Land_PaperBox_01_open_boxes_F", "Land_PaperBox_01_open_water_F", "CargoNet_01_barrels_F"], 300, true]
		) != 0
	} do
	{
		_allSheds = _allSheds - [_selectedShed];
		if((count _allSheds)  == 0) exitWith {_spawnPosition = nil};
		_spawnPosition = position _selectedShed;
	};

	if(_spawnPosition == nil) then {diag_log "ANTISTASI - DynamicSupplies: No suitable position found around HQ for a supply crate";};

	// Create Marker and add it to the supply list
	_marker = createMarker [format ["SUP%1", random 100], _spawnPosition];
	_marker setMarkerShape "ICON";
	_marker setMarkerAlpha 0;
	//spawner setVariable [_marker, 4, true]; //Activate when merged with new spawn system
	spawner setVariable [_marker, false, true];
	mrkSupplyCrates = mrkSupplyCrates pushBackUnique _marker;
	publicVariable "mrkSupplyCrates";

	[_spawnPosition, _crateType, _marker] remoteExec ["createSupplyBox", AS_fnc_getNextWorker];
};
if(!_create) then {_spawnPosition = getMarkerPos marker;};


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
waitUntil {sleep 1; !(spawner getVariable _marker) OR !(_marker in mrkSupplyCrates)};

if((_marker in mrkSupplyCrates) AND (count (nearestObjects [_spawnPosition, ["Land_PaperBox_01_open_boxes_F", "Land_PaperBox_01_open_water_F", "CargoNet_01_barrels_F"], 300, true])  != 0)) then
{
	//FIA has taken the Supply Box, not in range any more
	spawner setVariable [_marker, nil, true];
	mrkSupplyCrates = mrkSupplyCrates - [_marker];
	publicVariable "mrkSupplyCrates";
};

{deleteVehicle _x} forEach _allSoldiers;
{deleteGroup _x} forEach _allGroups;