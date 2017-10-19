params ["_vehGroup", "_origin", "_dest", "_mrk", "_infGroups", "_duration", "_type"];

if (_type == "rope") then {
	[_vehGroup, _origin, _dest, _mrk, _infGroups, _duration] call AS_fnc_QRF_fastrope;
};
if (_type == "land") then {
	 [_vehGroup, _origin, _dest, _mrk, _infGroups, _duration, "air"] call AS_fnc_QRF_dismountTroops;
};