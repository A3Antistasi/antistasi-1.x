if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_markerPos","_spawnPos","_objs","_camp","_fire","_group"];

_objs = [];

_markerPos = getMarkerPos _marker;

_camp = selectRandom AS_campList;
_spawnPos = _markerPos findEmptyPosition [1,50,"I_Heli_Transport_02_F"];
_objs = [_spawnPos, floor(random 361), _camp] call BIS_fnc_ObjectsMapper;

sleep 2;

{
	call {
		if (typeof _x == campCrate) exitWith {[_x] call cajaAAF; [_x,"heal_camp"] remoteExec ["AS_fnc_addActionMP"]};
		if (typeof _x == "Land_MetalBarrel_F") exitWith {[_x,"refuel"] remoteExec ["AS_fnc_addActionMP"]};
		if (typeof _x == "Land_Campfire_F") exitWith {_fire = _x;};
	};
	_x setVectorUp (surfaceNormal (position _x));
} forEach _objs;

_group = [_spawnPos, side_blue, ([guer_grp_sniper, "guer"] call AS_fnc_pickGroup)] call BIS_Fnc_spawnGroup;
_group setBehaviour "STEALTH";
_group setCombatMode "GREEN";

{[_x] spawn AS_fnc_initialiseFIAGarrisonUnit;} forEach units _group;

_shorecheck = [_spawnPos, 0, 50, 0, 0, 0, 1, [], [0]] call BIS_fnc_findSafePos;
if ((typename _shorecheck) == "ARRAY") then {[[_fire,"seaport"],"AS_fnc_addActionMP"] call BIS_fnc_MP;};

sleep 10;
_fire inflame true;

waitUntil {sleep 5; !(spawner getVariable _marker) OR ({alive _x} count units _group == 0) OR !(_marker in campsFIA)};

if ({alive _x} count units _group == 0) then {
	["TaskFailed", ["", format [localize "STR_TSK_CAMP_DESTROYED", markerText _marker]]] remoteExec ["BIS_fnc_showNotification"];
	campsFIA = campsFIA - [_marker]; publicVariable "campsFIA";
	campList = campList - [[_marker, markerText _marker]]; publicVariable "campList";
	usedCN = usedCN - [markerText _marker]; publicVariable "usedCN";
	markers = markers - [_marker]; publicVariable "markers";
	deleteMarker _marker;
};

waitUntil {sleep 5; !(spawner getVariable _marker) OR !(_marker in campsFIA)};

{deleteVehicle _x} forEach units _group;
deleteGroup _group;

_fire inflame false;
sleep 2;
{deleteVehicle _x} forEach _objs;