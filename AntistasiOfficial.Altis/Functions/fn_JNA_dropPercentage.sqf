/*
 	Description:
		Drop a percentage of each items from the arsenal

	Parameters:
		0: INTEGER - Percentage to be dropped

 	Returns:
		None

 	Example:
		[50] call AS_fnc_JNA_dropPercentage;
*/

if !(isServer) exitWith {};

params [["_percentage",50,[0]]];;
private ["_category","_data"];

{
	_category = _x;
	{
		_data =+ _x;
		if ((_data select 1) != -1) then {
			_x set [1, round ((_data select 1) / 2) max 0];
		};
	} forEach _category;
} forEach jna_dataList;