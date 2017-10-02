params ["_type"];
[0,0] params ["_cost","_hr"];

private ["_position","_markerPos","_onRoad","_permission","_text","_groupType","_groupComp","_nearestZone"];

if ("PuestosFIA" in misiones) exitWith {hint localize "STR_TSK_BEMP_RESTR"};
if !([player] call hasRadio) exitWith {hint localize "STR_TSK_BEMP_RADIO"};
if ((_type == "delete") AND (count puestosFIA < 1)) exitWith {hint localize "STR_TSK_BEMP_DEL_NR"};

openMap true;
posicionTel = [];
hint localize (["STR_TSK_BEMP_BLD_INFO","STR_TSK_BEMP_DEL_INFO"] select (_type == "delete"));

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) OR !visiblemap};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_position = posicionTel;

if ((_type == "delete") AND ({(alive _x) AND (!captive _x) AND ((side _x == side_green) OR (side _x == side_red)) AND (_x distance _position < safeDistance_fasttravel)} count allUnits > 0)) exitWith {hint localize "STR_TSK_BEMP_DEL_ENEMY"};

_onRoad = isOnRoad _position;

if (_type != "delete") then {
	// BE module
	_permission = true;
	_text = "Error in permission system, module rb/wp.";
	if (activeBE) then {
		if (_onRoad) then {
			_permission = ["RB"] call fnc_BE_permission;
			_text = "We cannot maintain any additional roadblocks.";
		} else {
			_permission = ["WP"] call fnc_BE_permission;
			_text = "We cannot maintain any additional watchposts.";
		};
	};

	if !(_permission) exitWith {hint _text; openMap false;};
	// BE module

	_groupType = [guer_grp_sniper,guer_grp_AT] select _onRoad;

	if (_onRoad) then {
		_cost = _cost + ([guer_veh_technical] call vehiclePrice) + (server getVariable [guer_sol_RFL,150]);
		_hr = _hr + 1;
	};

	_groupComp = ([_groupType, "guer"] call AS_fnc_pickGroup);
	if (typeName _groupType != "ARRAY") then {
		_groupType = [_groupComp] call groupComposition;
	};
	{
		_cost = _cost + (server getVariable [_x,150]);
		_hr = _hr + 1;
	} forEach _groupType;
} else {
	_nearestZone = [puestosFIA,_position] call BIS_fnc_nearestPosition;
	_markerPos = getMarkerPos _nearestZone;
	if (_position distance _markerPos > 10) exitWith {hint localize "STR_TSK_BEMP_DEL_NONE"};
};

_resourcesFIA = server getVariable ["resourcesFIA",0];
_hrFIA = server getVariable ["hr",0];

if (((_resourcesFIA < _cost) OR (_hrFIA < _hr)) AND (_type != "delete")) exitWith {hint format [localize "STR_TSK_BEMP_BLD_COST",_hr,_cost]};

if (_type != "delete") then {
	[-_hr,-_cost] remoteExec ["resourcesFIA",2];
};

[_type,_position] remoteExec ["crearPuestosFIA",2];