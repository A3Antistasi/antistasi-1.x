if (player != Slowhand) exitWith {hint "Only Commander Slowhand has access to this function"};
if (!allowPlayerRecruit) exitWith {hint "Server is very loaded. \nWait one minute or change FPS settings in order to fulfill this request"};
if (markerAlpha guer_respawn == 0) exitWith {hint "You cant recruit a new squad while you are moving your HQ"};
if !([player] call hasRadio) exitWith {hint "You need a radio in your inventory to be able to give orders to other squads"};

params ["_groupCategory"];
private ["_hr","_resourcesFIA","_spawnData","_roadPos","_direction","_spawnPos","_group","_vehicleData","_vehicle","_static","_unit","_attachPos","_groupType"];

[false,false,0,0,guer_veh_offroad,"Tm-"] params ["_check","_isInfantry","_cost","_costHR","_vehicleType","_groupID"];

{
	if (((side _x == side_red) OR (side _x == side_green)) AND (_x distance petros < safeDistance_recruit)) exitWith {_check = true};
} forEach allUnits;

if (_check) exitWith {Hint "You cannot Recruit Squads with enemies near your HQ"};

_hr = server getVariable ["hr",0];
_resourcesFIA = server getVariable ["resourcesFIA",0];

if (_groupCategory in [guer_stat_AT,guer_stat_AA,guer_stat_mortar]) then {
	_cost = _cost + (2*(server getVariable guer_sol_R_L));
	_costHR = 2;
	_cost = _cost + ([_groupCategory] call vehiclePrice) + ([guer_veh_truck] call vehiclePrice);

	if ((activeAFRF) AND (_groupCategory == guer_stat_AA)) then {
		_cost = 3*(server getVariable guer_sol_R_L);
		_costHR = 3;
		_cost = _cost + ([vehTruckAA] call vehiclePrice);
	};
} else {
	_groupType = ([_groupCategory, "guer"] call AS_fnc_pickGroup);
	if !(typeName _groupType == "ARRAY") then {
		_groupType = [_groupType] call groupComposition;
	};
	{_cost = _cost + (server getVariable [_x,0]); _costHR = _costHR + 1} forEach _groupType;
	_isInfantry = true;
};

if (_hr < _costHR) exitWith {hint format ["You do not have enough HR for this request (%1 required)",_costHR]};
if (_resourcesFIA < _cost) exitWith {hint format ["You do not have enough money for this request (%1 € required)",_cost]};

[-_costHR, -_cost] remoteExec ["resourcesFIA",2];

_spawnData = [(getMarkerPos guer_respawn), [ciudades, (getMarkerPos guer_respawn)] call BIS_fnc_nearestPosition] call AS_fnc_findRoadspot;
_roadPos = _spawnData select 0;
_direction = _spawnData select 1;


if (_isInfantry) then {
	_spawnPos = [(getMarkerPos guer_respawn), 30, random 360] call BIS_Fnc_relPos;
	_group = [_spawnPos, side_blue, _groupType] call BIS_Fnc_spawnGroup;
	_group selectLeader (units _group select 0);
	call {
		if (_groupCategory isEqualTo guer_grp_squad) exitWith {_groupID = "Squd-"};
		if (_groupCategory isEqualTo guer_grp_team) exitWith {_groupID = "Tm-"};
		if (_groupCategory isEqualTo guer_grp_AT) exitWith {_groupID = "AT-"};
		if (_groupCategory isEqualTo guer_grp_sniper) exitWith {_groupID = "Snpr-"};
		if (_groupCategory isEqualTo guer_grp_sentry) exitWith {_groupID = "Stry-"};
	};
	_groupID = format ["%1%2",_groupID,{side (leader _x) == side_blue} count allGroups];
	_group setGroupId [_groupID];
} else {
	call {
		if ((activeAFRF) AND (_groupCategory isEqualTo guer_stat_AA)) exitWith {
			_spawnPos = _roadPos findEmptyPosition [1,50,vehTruckAA];
			_vehicle = vehTruckAA createVehicle _spawnPos;
			_vehicle setDir _direction;
			_group = createGroup side_blue;
			_unit = _group createUnit [guer_sol_UN, _roadPos, [],0, "NONE"];
			_unit assignAsDriver _vehicle;
			_unit moveInDriver _vehicle;
			_unit = _group createUnit [guer_sol_UN, _roadPos, [],0, "NONE"];
			_unit moveInGunner _vehicle;
			_unit assignAsGunner _vehicle;
			_unit = _group createUnit [guer_sol_UN, _roadPos, [],0, "NONE"];
			_unit moveInCommander _vehicle;
			_unit assignAsCommander _vehicle;
			_group setGroupId [format ["M.AA-%1",{side (leader _x) == side_blue} count allGroups]];
		};

		if ((activeGREF) AND (_groupCategory isEqualTo guer_stat_AT)) exitWith {
			_spawnPos = _roadPos findEmptyPosition [1,50,guer_veh_technical_AT];
			_vehicleData = [_spawnPos,_direction,guer_veh_technical_AT,side_blue] call bis_fnc_spawnvehicle;
			_vehicle = _vehicleData select 0;
			_group = _vehicleData select 2;
			_group setVariable ["staticAutoT",false,true];
			_group setGroupId [format ["M.AT-%1",{side (leader _x) == side_blue} count allGroups]];
		};

		_spawnPos = _roadPos findEmptyPosition [1,50,guer_veh_truck];
		_vehicleData = [_spawnPos,_direction,guer_veh_truck,side_blue] call bis_fnc_spawnvehicle;
		_vehicle = _vehicleData select 0;
		_group = _vehicleData select 2;
		_spawnPos = _roadPos findEmptyPosition [1,30,guer_stat_mortar];
		_attachPos = [0,-1.5,0.2];
		if ((activeAFRF) AND (_groupCategory isEqualTo guer_stat_AT)) then {
			_attachPos = [0,-2.4,-0.6];
		};
		_static = _groupCategory createVehicle _spawnPos;
		[_static] spawn VEHinit;
		_unit = _group createUnit [guer_sol_UN, _spawnPos, [],0, "NONE"];
		_group setVariable ["staticAutoT",false,true];
		if (_groupCategory isEqualTo guer_stat_mortar) then {
			_unit moveInGunner _static;
			[_unit,_vehicle,_static] spawn mortyAI;
			_group setGroupId [format ["Mort-%1",{side (leader _x) == side_blue} count allGroups]];
		} else {
			_static attachTo [_vehicle,_attachPos];
			_static setDir (getDir _vehicle + 180);
			_unit moveInGunner _static;
			if (_groupCategory isEqualTo guer_stat_AT) then {_group setGroupId [format ["M.AT-%1",{side (leader _x) == side_blue} count allGroups]]};
			if (_groupCategory isEqualTo guer_stat_AA) then {_group setGroupId [format ["M.AA-%1",{side (leader _x) == side_blue} count allGroups]]};
		};
	};

	driver _vehicle action ["engineOn", vehicle driver _vehicle];
	[_vehicle] spawn VEHinit;
};

{[_x] call AS_fnc_initialiseFIAUnit} forEach units _group;
leader _group setBehaviour "SAFE";
Slowhand hcSetGroup [_group];
_group setVariable ["isHCgroup", true, true];
petros directSay "SentGenReinforcementsArrived";
hint format ["Group %1 at your command.\n\nGroups are managed from the High Command bar (Default: CTRL+SPACE)\n\nIf the group gets stuck, use the AI Control feature to make them start moving. Mounted Static teams tend to get stuck (solving this is WiP)\n\nTo assign a vehicle for this group, look at some vehicle, and use Vehicle Squad Mngmt option in Y menu", groupID _group];

if (!_isInfantry) exitWith {};

if (_groupCategory isEqualTo guer_grp_squad) then {
	_vehicleType = guer_veh_truck;
} else {
	if ((_groupCategory isEqualTo guer_grp_sniper) OR (_groupCategory isEqualTo guer_grp_sentry)) then {
		_vehicleType = guer_veh_quad;
	} else {
		_vehicleType = guer_veh_offroad;
	};
};

_cost = [_vehicleType] call vehiclePrice;
if (_cost > server getVariable "resourcesFIA") exitWith {};

createDialog "veh_query";

sleep 1;
disableSerialization;

_display = findDisplay 100;

if (str (_display) != "no display") then
	{
	_ChildControl = _display displayCtrl 104;
	_ChildControl  ctrlSetTooltip format ["Buy a vehicle for this squad for %1 €",_cost];
	_ChildControl = _display displayCtrl 105;
	_ChildControl  ctrlSetTooltip "Barefoot Infantry";
	};

waitUntil {(!dialog) or (!isNil "vehQuery")};

if ((!dialog) and (isNil "vehQuery")) exitWith {};

vehQuery = nil;
_vehicle = _vehicleType createVehicle _roadPos;
_vehicle setDir _direction;
[_vehicle] spawn VEHinit;
_group addVehicle _vehicle;
_vehicle setVariable ["owner",_group,true];
[0, - _cost] remoteExec ["resourcesFIA",2];
leader _group assignAsDriver _vehicle;
{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _group;
hint "Vehicle Purchased";
petros directSay "SentGenBaseUnlockVehicle";