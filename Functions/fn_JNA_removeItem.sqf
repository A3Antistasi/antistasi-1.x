/*
 	Description:
		Reduce quantity of a specific item, exception being items in unlimited quantity

	Parameters:
		0: STRING - Class name of item
		1: STRING - Item category with regards to the arsenal's item classification scheme
		2: INTEGER - Number of items to be removed

 	Returns:
		None

 	Example:
		["arifle_TRG21_F","primary",4] call AS_fnc_JNA_removeItem;
*/

if !(isServer) exitWith {};

params ["_item",["_itemCategory","",jna_categories],["_itemCount",1,[0]]];
private ["_index","_data"];

_itemCount = _itemCount max 1;

_index = missionNamespace getVariable [format ["jna_index_%1",_itemCategory],-1];
if (_index < 0) exitWith {format ["Error in JNA_removeItem: cannot find category index. Parameters: %1", _itemCategory]};

if (count (jna_dataList select _index) > 0) then {
	{
		if ((_x select 0) isEqualTo _item) exitWith {
			_data =+ _x;
			if ((_data select 1) != -1) then {
				_x set [1, ((_data select 1) - _itemCount) max 0];
			};
		};
	} forEach (jna_dataList select _index);
};