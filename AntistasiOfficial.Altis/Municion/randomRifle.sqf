params ["_unit","_changeRifle","_changeHelmet","_changeUniform","_changeVest"];
private ["_newRifle","_compatibleOptics","_options","_radio","_items"];

_skillFIA = server getVariable ["skillFIA", 1];

if (_changeVest) then {
	if (random 25 < _skillFIA) then {
		removeVest _unit;
		_unit addVest guer_gear_vestAdv;
		_unit addItemToVest "FirstAidKit";
	};
};

if (_changeHelmet) then {
	if (random 20 < _skillFIA) then {
		_items = [itemcargo caja arrayIntersect genHelmets,["helmet"] call AS_fnc_JNA_getLists] select activeJNA;
		if (count _items > 0) then {_unit addHeadgear (selectRandom _items)}
	} else {
		if (_changeUniform) then {
			// BE module
			if (activeBE) then {
				_result = ["outfit"] call fnc_BE_getCurrentValue;
				if (random 100 > _result) then {
					_unit forceAddUniform (selectRandom civUniforms);
					_unit addItemToUniform "FirstAidKit";
					_unit addMagazine [guer_gear_grenHE, 1];
					_unit addMagazine [guer_gear_grenSmoke, 1];
				};
			}
			// BE module
			else {
				if (random 10 > _skillFIA) then {
					_unit forceAddUniform (selectRandom civUniforms);
					_unit addItemToUniform "FirstAidKit";
					_unit addMagazine [guer_gear_grenHE, 1];
					_unit addMagazine [guer_gear_grenSmoke, 1];
				};
			};
		};
	};
};

if (_changeRifle) then {
	if (count unlockedRifles > 0) then {
		_unit removeMagazines (currentMagazine _unit);
		_unit removeWeaponGlobal (primaryWeapon _unit);
		_newRifle = selectRandom unlockedRifles;
		if (_newRifle in genGL) then {
			_unit addMagazine [guer_gear_GL_gren, 4];
		};
		[_unit, _newRifle, 5, 0] call BIS_fnc_addWeapon;
	};

	_items = [unlockedOptics,["optic"] call AS_fnc_JNA_getLists] select activeJNA;
	if (count _items > 0) then {
		_compatibleOptics = [primaryWeapon _unit] call BIS_fnc_compatibleItems;
		_options = [];
		{
			if (_x in _compatibleOptics) then {_options pushBack _x};
		} forEach _items;
		_unit addPrimaryWeaponItem (selectRandom _options);
	};
};

if (activeTFAR) then {
	_unit addItem guer_radio_TFAR;
	_unit assignItem guer_radio_TFAR;
};