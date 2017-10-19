if (!isServer and hasInterface) exitWith{};

private ["_veh","_text","_mrkfin","_pos","_side","_tipo","_newPos","_road","_amigos"];

_veh = _this select 0;
_text = _this select 1;
_enemigo = true;
_convoy = false;

waitUntil {sleep 1; (not(isNull driver _veh))};

_side = side (driver _veh);
_tipo = "hd_destroy";
if ((_side == side_blue) or (_side == civilian)) then {_enemigo = false};

if (_side == side_green) then {
	if ((typeOf _veh) in CIV_vehicles) then {_tipo = "n_unknown"}
	else {
		if (((typeOf _veh) in vehPatrol) or ((typeOf _veh) in vehTrucks)) then {_tipo = "n_motor_inf"}
		else {
			if (((typeOf _veh) in vehAPC) or ((typeOf _veh) in vehIFV)) then {_tipo = "n_mech_inf"}
			else {
				if ((typeOf _veh) in vehTank) then {_tipo = "n_armor"}
				else {
					if (_veh isKindOf "Plane_Base_F") then {_tipo = "n_plane"}
					else {
						if (_veh isKindOf "UAV_02_base_F") then {_tipo = "n_uav"}
						else {
							if (_veh isKindOf "Helicopter") then {_tipo = "n_air"}
							else {
								if (_veh isKindOf "Boat_F") then {_tipo = "n_naval"}
							};
						};
					};
				};
			};
		};
	};
};

if (_side == side_red) then {
	_tipo = "o_air";
};

if ((_side == side_blue) or (_side == civilian)) then
	{
	if ((typeOf _veh == guer_veh_truck) or (typeOf _veh == AS_misVehicleBox)) then {_tipo = "b_motor_inf"}
	else
		{
		if (typeOf _veh in bluMBT) then {_tipo = "b_armor"}
		else
			{
			if (typeOf _veh in bluCASFW) then {_tipo = "b_plane"}
			else
				{
				if ((typeOf _veh) in planesNATO) then {_tipo = "b_air"}
				else {_tipo = "b_unknown"};
				};
			};
		};
	};
if ((_text == "AAF Convoy Objective") or (_text == "Mission Vehicle") or (debug)) then {_convoy = true;};

if (!_convoy) exitWith {};

if (debug) then {revelar = true};

waitUntil {sleep 1;(not alive _veh) or ({(_x knowsAbout _veh > 1.4) and (side _x == side_blue)} count allUnits >0) or (!_enemigo) or (revelar)};

if (!alive _veh) exitWith {};

if (_enemigo) then {[["TaskSucceeded", ["", format ["%1 Spotted",_text]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;};
_mrkfin = createMarker [format ["%2%1", random 100,_text], position _veh];
_mrkfin setMarkerShape "ICON";
_mrkfin setMarkerType _tipo;
if (_tipo == "hd_destroy") then
	{
	if (_enemigo) then {_mrkfin setMarkerColor OPFOR_marker_colour} else {_mrkfin setMarkerColor BLUFOR_marker_colour};
	};
_mrkfin setMarkerText _text;
while {(alive _veh) and ((side (driver _veh) == _side) or _convoy)} do
	{
	_pos = getPos _veh;
	_mrkfin setMarkerPos _pos;
	sleep 60;
	_newPos = getPos _veh;
	if (_newPos distance _pos < 5) then
		{
		if (_veh isKindOf "Air") then
			{
			if (isTouchingGround _veh) then
				{
				{
				unAssignVehicle _x;
	   			moveOut _x;
	   			sleep 1.5;
				} forEach assignedCargo _veh;
				};
			}
		else
			{
			if ({_x distance _newPos < 500} count (allPlayers - hcArray) == 0) then
				{
				_road = [_newPos,100] call BIS_fnc_nearestRoad;
				if (!isNull _road) then
					{
					_veh setPos getPos _road;
					};
				};
			};
		};
	};
deleteMarker _mrkfin;
