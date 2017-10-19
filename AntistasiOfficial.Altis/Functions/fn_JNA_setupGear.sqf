/*
 	Description:
		Add items in unlimited quantity to the JNA, primarily to be used to convert the regular arrays

	Parameters:
		0: ARRAY - Items to be added to the JNA

 	Returns:
		None

 	Example:
		[unlockedWeapons] call AS_fnc_JNA_setupGear;
		["U_BG_Guerilla2_1","U_BG_Guerilla2_2","U_BG_Guerilla2_3"] call AS_fnc_JNA_setupGear;
*/

params [["_array",[],[[]]]];
private ["_className","_category","_index","_added"];

if (count _array == 0) exitWith {diag_log "Error in JNA_setupGear: empty input array"};

{
	_className = _x;
	_category = [_className] call AS_fnc_JNA_classifyItem;
	_index = missionNamespace getVariable [format ["jna_index_%1",_category],-1];

	_added = false;
	{
		if ((_x select 0) isEqualTo _className) exitWith {
			_x set [1,-1];
			_added = true;
		};
	} forEach (jna_dataList select _index);

	if !(_added) then {
		(jna_dataList select _index) pushBack [_className,-1];
	};
} forEach _array;

publicVariable "jna_dataList";