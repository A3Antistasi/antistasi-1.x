/*
 	Description:
		- Return a list of item classes from JNA's internal item DB

	Parameters:
		0: ARRAY/STRING - Item category or array of item categories
		1: BOOLEAN - Whether or not item count restrictions should be applied

 	Returns:
		ARRAY - Array of class names of items in the provided categories

 	Example:
		_launcherList = ["secondary"] call AS_fnc_JNA_getLists;


	Additional info:
		Category list in format "name index count":
			primary 	0 	10
			secondary 	1	5
			handgun 	2	5
			uniform 	3	5
			vest 		4	10
			backpack 	5	5
			helmet 		6	5
			goggle 		7	5
			nvg 		8	5
			binos 		9	5
			map 		10	1
			gps 		11	1
			radio 		12	1
			compass 	13	1
			watch	 	14	1

			optic 		18	5
			muzzle 		19	5
			accessory 	20	5
			bipod 		21	5
			grenade 	22	10
			mine 		23	5
			misc 		24	1

			ammo 		26	10
*/

params [["_inputArray",[],[[],""]],["_restricted",false,[true,false]]];
[[],false] params ["_returnArray","_wrongDataType"];
private ["_index","_count"];

if (typeName _inputArray == "STRING") then {
	_inputArray = [_inputArray]
};

if (count _inputArray > 0) then {
	{
		if (typeName _x != "STRING") exitWith {_wrongDataType = true};
	} forEach _inputArray;
};

if (_wrongDataType) exitWith {diag_log format ["Error in JNA_getLists: wrong datatype. Parameters: %1", _inputArray]};

if (count _inputArray > 0) then {
	if (_restricted) then {
		{
			_index = missionNamespace getVariable [format ["jna_index_%1",_x], 15];
			_count = missionNamespace getVariable [format ["jna_count_%1",_x], 10];
			if (count (jna_dataList select _index) > 0) then {
				{
					if (((_x select 1) > _count) OR ((_x select 1) == -1)) then {_returnArray pushBackUnique (_x select 0)};
				} forEach (jna_dataList select _index);
			};
		} forEach _inputArray;
	} else {
		{
			_index = missionNamespace getVariable [format ["jna_index_%1",_x], 15];
			if (count (jna_dataList select _index) > 0) then {
				{
					_returnArray pushBackUnique (_x select 0);
				} forEach (jna_dataList select _index);
			};
		} forEach _inputArray;
	};

};

_returnArray