params ["_unit"];
private ["_unitType"];

_unit setVariable ["OPFORSpawn",true,true];
_unit addEventHandler ["HandleDamage",handleDamageAAF];
_unit addEventHandler ["killed",AAFKilledEH];

if (sunOrMoon < 1) then {
	if (opIR in primaryWeaponItems _unit) then {_unit action ["IRLaserOn", _unit]};
};

_unitType = typeOf _unit;
if ((activeAFRF) AND !(replaceFIA)) then {
	switch _unitType do {
		case opI_AAR: {[_unit, _unitType] call AS_fnc_gear_loadoutCSAT};
		case opI_AR2: {};
		case opI_AR: {[_unit, _unitType] call AS_fnc_gear_loadoutCSAT};
		case opI_CREW: {[_unit, _unitType] call AS_fnc_gear_loadoutCSAT};
		case opI_GL: {[_unit, _unitType] call AS_fnc_gear_loadoutCSAT};
		case opI_LAT: {[_unit, _unitType] call AS_fnc_gear_loadoutCSAT};
		case opI_MED: {[_unit, _unitType] call AS_fnc_gear_loadoutCSAT};
		case opI_MK2: {};
		case opI_MK: {[_unit, _unitType] call AS_fnc_gear_loadoutCSAT};
		case opI_OFF2: {};
		case opI_OFF: {};
		case opI_PIL: {};
		case opI_RFL1: {};
		case opI_RFL2: {};
		case opI_SL: {[_unit, _unitType] call AS_fnc_gear_loadoutCSAT};
		case opI_SP: {[_unit, _unitType] call AS_fnc_gear_loadoutCSAT};
	};
};
