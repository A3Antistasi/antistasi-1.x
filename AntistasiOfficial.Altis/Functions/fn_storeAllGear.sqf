/*
    Description:
        - Commands selected units to deposit all their gear into the targeted container

    Parameters:
        None

    Returns:
        Nothing

    Example:
        [] call AS_fnc_storeAllGear
*/

private ["_units", "_container"];

_units = groupSelectedUnits player;
_container = ["", cursorTarget] select ((cursorTarget isKindOf "Car") || (cursorTarget isKindOf "Tank") || (cursorTarget isKindOf "ReammoBox_F"));

if !(count _units > 0) exitWith {hintSilent "Please select the units who should store their gear."};
if (typeName _container == "STRING") exitWith {hintSilent "Please point at a target container."};

{
	if !(vehicle _x == _x) then {
		doGetOut _x;
	};
	[_x, _container] spawn AS_fnc_storeGear;

} forEach _units;