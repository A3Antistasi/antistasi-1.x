private ["_veh", "_owner", "_exit", "_vehType", "_cost"];
_veh = cursortarget;

if (isNull _veh) exitWith {hint "You are not looking at any vehicle"};
if (_veh distance getMarkerPos guer_respawn > 50) exitWith {hint "Vehicle must be within 50m of the flag"};
if ({isPlayer _x} count crew _veh > 0) exitWith {hint "In order to sell, vehicle must be empty."};

_owner = _veh getVariable "duenyo";
_exit = false;

if !(isNil "_owner") then {
	if (_owner isEqualType "") then {
		if (getPlayerUID player != _owner) then {_exit = true};
	};
};

if (_exit) exitWith {hint "You are not owner of this vehicle and you cannot sell it"};

_vehType = typeOf _veh;
_cost = 0;

call {
	if (_vehType in vehNATO) exitWith {hint format ["You cannot sell %1 vehicles", A3_Str_BLUE]};
	if (_vehType in guer_vehicleArray) exitWith {_cost = round (([_vehType] call vehiclePrice)/2)};
	if (_vehType == "C_Van_01_fuel_F") exitWith {_cost = 50};
	if (_vehType in CIV_vehicles) exitWith {_cost = 25};
	if (_vehType in (vehTrucks + vehPatrol + vehSupply)) exitWith {_cost = 300};
	if (_vehType in vehTank) exitWith {
		[_veh] call AS_fnc_AAFassets;
		_cost = 5000;
	};
	if (_vehType in vehIFV) exitWith {
		[_veh] call AS_fnc_AAFassets;
		_cost = 2000;
	};
	if (_vehType in vehAPC) exitWith {
		[_veh] call AS_fnc_AAFassets;
		_cost = 1000;
	};
	if (_vehType in heli_unarmed) exitWith {
		[_veh] call AS_fnc_AAFassets;
		_cost = 1000;
	};
	if (_vehType in heli_armed) exitWith {
		[_veh] call AS_fnc_AAFassets;
		_cost = 5000;
	};
	if (_vehType in planes) exitWith {
		[_veh] call AS_fnc_AAFassets;
		_cost = 10000;
	};
};

if (_cost == 0) exitWith {hint "The vehicle you are looking at is currently not in demand in our marketplace."};

_cost = _cost * (1-damage _veh);

[0,_cost] remoteExec ["resourcesFIA",2];

if (_veh in staticsToSave) then {staticsToSave = staticsToSave - [_veh]; publicVariable "staticsToSave"};
if (_veh in reportedVehs) then {reportedVehs = reportedVehs - [_veh]; publicVariable "reportedVehs"};

[_veh,true] call vaciar;

if (_veh isKindOf "StaticWeapon") then {deleteVehicle _veh};

hint "Vehicle Sold";