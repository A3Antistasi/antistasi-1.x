params ["_vehicle"];
private ["_isListed","_vehiclePos","_city","_data","_unit"];

_isListed = _vehicle getVariable ["inDespawner",false];
if (_isListed) exitWith {};
if (dynamicSimulationEnabled _vehicle) exitWith {};

_vehicle setVariable ["inDespawner",true,true];

if ((typeOf _vehicle in CIV_vehicles) AND ({_x getVariable ["BLUFORSpawn",false]} count crew _vehicle > 0) AND (_vehicle distance getMarkerPos guer_respawn > 50)) then {
	_vehiclePos = position _vehicle;
	[0,-1,_vehiclePos] remoteExec ["AS_fnc_changeCitySupport",2];
	_city = [ciudades, _vehiclePos] call BIS_fnc_nearestPosition;
	_data = server getVariable _city;
	_prestigeOPFOR = _data select 2;
	sleep 5;
	if (random 100 < _prestigeOPFOR) then {
		{
			_unit = _x;
			if ((captive _unit) AND (isPlayer _unit)) then {
				[_unit,false] remoteExec ["setCaptive",_unit];
			};
			{
				if ((side _x == side_green) AND (_x distance _vehiclePos < distanciaSPWN)) then {_x reveal [_unit,4]};
			} forEach allUnits;
		} forEach crew _vehicle;
	};
};

while {alive _vehicle} do {
	if (!([distanciaSPWN,1,_vehicle,"BLUFORSpawn"] call distanceUnits) AND !([distanciaSPWN,1,_vehicle,"OPFORSpawn"] call distanceUnits) AND !(_vehicle in staticsToSave) AND (_vehicle distance getMarkerPos guer_respawn > 100)) then {
		if (_vehicle in reportedVehs) then {reportedVehs = reportedVehs - [_vehicle]; publicVariable "reportedVehs"};
		deleteVehicle _vehicle;
	};
	sleep 60;
};