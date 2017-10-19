params [["_units", groupSelectedUnits player], ["_silent", false]];

if !(count _units > 0) exitWith {
	if (_silent) then {hintSilent "You have not selected any units."};
};

{
	_x setVariable ["vehicle", nil, true];
	_x setVariable ["AS_lootingCorpses", nil, true];
	_x setVariable ["AS_storingGear", nil, true];
	_x setVariable ["AS_strippingCorpse", nil, true];
	_x setVariable ["AS_cannotComply", nil, true];
};