params ["_unit"];
private ["_skill","_skillFIA","_aiming","_spotD","_spotT","_cour","_comm","_aimingSh","_aimingSp","_reload","_unitType","_skillSet"];

[_unit] call initRevive;
_unit setVariable ["BLUFORSpawn",true,true];

_skillFIA = server getVariable ["skillFIA", 1];

_unit allowFleeing 0;
_skill = 0.2 + (_skillFIA * 0.04);
if ((!isMultiplayer) and (leader _unit == Slowhand)) then {_skill = _skill + 0.2};
_unit setSkill _skill;

_aiming = _skill;
_spotD = _skill;
_spotT = _skill;
_cour = _skill;
_comm = _skill;
_aimingSh = _skill;
_aimingSp = _skill;
_reload = _skill;

_unitType = typeOf _unit;
_skillSet = 0;

if !("ItemRadio" in unlockedItems) then {
	if ((_unit != leader _unit) AND (_unitType != guer_sol_UN)) then {_unit unlinkItem "ItemRadio"};
};

call {
	if (activeAFRF) then {
		removeVest _unit;
		_unit addVest "V_Chestrig_oli";
		_unit addItem "FirstAidKit";
		_unit addItem "FirstAidKit";
		_unit addMagazine "rhs_mag_rdg2_white";
		_unit addMagazine "rhs_mag_rgd5";
	};

	if (_unitType == guer_sol_LAT) exitWith {
		[_unit,true,true,true,false] call randomRifle;
		if (guer_gear_AT in unlockedWeapons) then {
			{if (_x in (server getVariable [format ["%1_mags", secondaryWeapon _unit],secondaryWeaponMagazine _unit])) then {_unit removeMagazine _x}} forEach magazines _unit;
			_unit removeWeaponGlobal (secondaryWeapon _unit);
			[_unit, guer_gear_AT, 4, 0] call BIS_fnc_addWeapon;
		} else {
			if ((guer_gear_LAT in unlockedWeapons) OR (activeAFRF)) then {
				{if (_x in (server getVariable [format ["%1_mags", secondaryWeapon _unit],secondaryWeaponMagazine _unit])) then {_unit removeMagazine _x}} forEach magazines _unit;
				_unit removeWeaponGlobal (secondaryWeapon _unit);
				[_unit, guer_gear_LAT, 4, 0] call BIS_fnc_addWeapon;
			};
		};
	};

	if (_unitType == guer_sol_RFL) exitWith {
		[_unit,true,true,true,true] call randomRifle;
		if (loadAbs _unit < 340) then {
			if ((random 25 < _skillFIA) && (guer_gear_AA in unlockedWeapons)) then {
				removeBackpackGlobal _unit;
				_unit addBackpackGlobal guer_gear_BP_AT;
				[_unit, guer_gear_AA, 2, 0] call BIS_fnc_addWeapon;
			} else {
				if ((random 25 < _skillFIA) && (guer_gear_LAT in unlockedWeapons)) then {
					removeBackpackGlobal _unit;
					_unit addBackpackGlobal guer_gear_BP;
					[_unit, guer_gear_LAT, 2, 0] call BIS_fnc_addWeapon;
				};
			};
		};
	};

	if (_unitType == guer_sol_GL) exitWith {
		[_unit,false,true,true,false] call randomRifle;
		_unit removeMagazines (currentMagazine _unit);
		_unit removeWeaponGlobal (primaryWeapon _unit);
		removeBackpackGlobal _unit;
		_unit addBackpackGlobal guer_gear_BP;
		[_unit, guer_gear_GL, 5, 0] call BIS_fnc_addWeapon;
		_unit addMagazine [guer_gear_GL_gren, 4];
	};

	if (_unitType == guer_sol_R_L) exitWith {
		[_unit,true,true,true,true] call randomRifle;
		_skillSet = 1;
	};

	if (_unitType == guer_sol_UN) exitWith {
		{
			_unit removeWeaponGlobal _x;
		} forEach (weapons _unit);
		_skillSet = 1;
	};

	if (_unitType == guer_sol_SL) exitWith {
		[_unit,false,true,true,false] call randomRifle;
		_unit removeMagazines (currentMagazine _unit);
		_unit removeWeaponGlobal (primaryWeapon _unit);
		[_unit, guer_gear_GL, 5, 0] call BIS_fnc_addWeapon;
		_unit addMagazine [guer_gear_GL_gren, 4];
		_unit addPrimaryWeaponItem guer_gear_defOptic;
		_skillSet = 2;
	};

	if (_unitType == guer_sol_TL) exitWith {
		[_unit,false,true,true,false] call randomRifle;
		_unit removeMagazines (currentMagazine _unit);
		_unit removeWeaponGlobal (primaryWeapon _unit);
		[_unit, guer_gear_GL, 5, 0] call BIS_fnc_addWeapon;
		_unit addMagazine [guer_gear_GL_gren, 4];
		_unit addPrimaryWeaponItem guer_gear_defOptic;
		_skillSet = 3;
	};

	if (_unitType == guer_sol_AR) exitWith {
		[_unit,false,true,true,false] call randomRifle;
		[_unit,false,true,true,false] call randomRifle;
		_unit removeMagazines (currentMagazine _unit);
		_unit removeWeaponGlobal (primaryWeapon _unit);
		removeBackpackGlobal _unit;
		_unit addBackpackGlobal guer_gear_BP;
		[_unit, guer_gear_LMG, 3, 0] call BIS_fnc_addWeapon;
		_skillSet = 4;
	};

	if (_unitType == guer_sol_MED) exitWith {
		if (activeAFRF) then {
			removeVest _unit;
			_unit addVest guer_gear_vestMedic;
			removeAllItemsWithMagazines _unit;
			_unit removeWeaponGlobal (primaryWeapon _unit);
			[_unit,false,true,true,false] call randomRifle;
			removeBackpackGlobal _unit;
			_unit addBackpack guer_gear_BP_Medic;
			_unit addMagazine guer_gear_grenSmoke;
			_unit addMagazine guer_gear_grenSmoke;
			_unit addItemToBackpack "Medikit";
			[_unit, guer_gear_Carbine, 4, 0] call BIS_fnc_addWeapon;
		} else {
			[_unit,true,true,true,false] call randomRifle;
		};
		_skillSet = 5;
	};

	if (_unitType == guer_sol_ENG) exitWith {
		if (activeAFRF) then {
			removeVest _unit;
			_unit addVest guer_gear_vestEngineer;
			removeAllItemsWithMagazines _unit;
			_unit removeWeaponGlobal (primaryWeapon _unit);
			[_unit,false,true,true,false] call randomRifle;
			removeBackpackGlobal _unit;
			_unit addBackpackGlobal guer_gear_BP_Engineer;
			[_unit, guer_gear_Carbine, 4, 0] call BIS_fnc_addWeapon;
		} else {
			[_unit,true,true,true,false] call randomRifle;
		};
		_skillSet = 5;
	};

	if (_unitType == guer_sol_EXP) exitWith {
		[_unit,true,true,true,false] call randomRifle;
		_unit addmagazine atMine;
		_skillSet = 5;
	};

	if (_unitType == guer_sol_AM) exitWith {
		[_unit,true,true,true,false] call randomRifle;
		_skillSet = 5;
	};

	if (_unitType == guer_sol_MRK) exitWith {
		if (activeAFRF) then {
			_unit removeMagazines (currentMagazine _unit);
			_unit removeWeaponGlobal (primaryWeapon _unit);
			[_unit, guer_gear_SNPR, 6, 0] call BIS_fnc_addWeapon;
		};
		if (count (gear_sniperRifles arrayIntersect unlockedWeapons) > 0) then {
			_unit removeMagazines (currentMagazine _unit);
			_unit removeWeaponGlobal (primaryWeapon _unit);
			[_unit, selectRandom (gear_sniperRifles arrayIntersect unlockedWeapons), 6, 0] call BIS_fnc_addWeapon;
		};
		_skillSet = 6;
	};

	if (_unitType == guer_sol_SN) exitWith {
		if (activeAFRF) then {
			_unit removeMagazines (currentMagazine _unit);
			_unit removeWeaponGlobal (primaryWeapon _unit);
			[_unit, guer_gear_SNPR_camo, 6, 0] call BIS_fnc_addWeapon;
		};
		_skillSet = 6;
	};
};

call {
	if (_skillSet == 0) exitWith {
		_aiming = _aiming -0.2;
		_aimingSh = _aimingSh - 0.2;
		_aimingSp = _aimingSp - 0.2;
		_reload = _reload - 0.2;
	};

	if (_skillSet == 1) exitWith {
		_aiming = _aiming -0.1;
		_spotD = _spotD - 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp + 0.2;
		_reload = _reload + 0.1;
	};

	if (_skillSet == 2) exitWith {
		_aiming = _aiming - 0.1;
		_spotD = _spotD + 0.2;
		_spotT = _spotT + 0.2;
		_cour = _cour + 0.1;
		_comm = _comm + 0.2;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.2;
	};

	if (_skillSet == 3) exitWith {
		_aiming = _aiming + 0.1;
		_spotD = _spotD + 0.1;
		_spotT = _spotT + 0.1;
		_cour = _cour + 0.1;
		_comm = _comm + 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
	};

	if (_skillSet == 4) exitWith {
		_aiming = _aiming - 0.1;
		_aimingSh = _aimingSh + 0.2;
		_aimingSp = _aimingSp - 0.2;
		_reload = _reload - 0.2;
	};

	if (_skillSet == 5) exitWith {
		_aiming = _aiming - 0.1;
		_spotD = _spotD - 0.1;
		_spotT = _spotT - 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
	};

	if (_skillSet == 6) exitWith {
		_aiming = _aiming + 0.2;
		_spotD = _spotD + 0.4;
		_spotT = _spotT + 0.2;
		_cour = _cour - 0.1;
		_comm = _comm - 0.1;
		_aimingSh = _aimingSh + 0.1;
		_aimingSp = _aimingSp + 0.1;
		_reload = _reload - 0.4;
	};
};

_unit selectWeapon (primaryWeapon _unit);

if (sunOrMoon < 1) then {
	if (indNVG in unlockedItems) then {
		_unit linkItem indNVG;
		if (indLaser in unlockedItems) then {
			_unit addPrimaryWeaponItem indLaser;
	        _unit assignItem indLaser;
	        _unit enableIRLasers true;
		};
	} else {
		if (indFL in unlockedItems) then {
			_unit unassignItem indLaser;
	        _unit removePrimaryWeaponItem indLaser;
	        _unit addPrimaryWeaponItem indFL;
	        _unit enableGunLights "forceOn";
			_spotD = ((_spotD - 0.2) max 0.2);
			_spotT = ((_spotT - 0.2) max 0.2);
	    };
	};
};

if ((_unitType != guer_sol_MRK) and (_unitType != guer_sol_SN)) then {if (_aiming > 0.35) then {_aiming = 0.35}};

_unit setskill ["aimingAccuracy",_aiming];
_unit setskill ["spotDistance",_spotD];
_unit setskill ["spotTime",_spotT];
_unit setskill ["courage",_cour];
_unit setskill ["commanding",_comm];
_unit setskill ["aimingShake",_aimingSh];
_unit setskill ["aimingSpeed",_aimingSp];
_unit setskill ["reloadSpeed",_reload];

if (player == leader _unit) then {
	_EHkilledIdx = _unit addEventHandler ["killed", {
		_muerto = _this select 0;
		[_muerto] spawn postmortem;
		if (typeOf _muerto != guer_POW) then {arrayids = arrayids + [name _muerto]};
		[0.25,0,getPos _muerto] remoteExec ["AS_fnc_changeCitySupport",2];
		_muerto setVariable ["BLUFORSpawn",nil,true];
	}];
	if (_unitType != guer_POW) then {
		_idUnit = arrayids call BIS_Fnc_selectRandom;
		arrayids = arrayids - [_idunit];
		_unit setIdentity _idUnit;
		if (captive player) then {[_unit] spawn undercoverAI};
	};
	_unit setVariable ["rearming",false];
	if !("ItemRadio" in unlockedItems) then {
		while {alive _unit} do {
			sleep 10;
			if (("ItemRadio" in assignedItems _unit) and ([player] call AS_fnc_radioCheck)) exitWith {_unit groupChat format ["This is %1, radiocheck OK",name _unit]};
			if (unitReady _unit) then {
				if ((alive _unit) and (_unit distance (getMarkerPos guer_respawn) > 50) and (_unit distance leader group _unit > 500) and ((vehicle _unit == _unit) or ((typeOf (vehicle _unit)) in CIV_vehicles))) then {
					hint format ["%1 lost communication, he will come back with you if possible", name _unit];
					[_unit] join rezagados;
					if ((vehicle _unit isKindOf "StaticWeapon") or (isNull (driver (vehicle _unit)))) then {unassignVehicle _unit; [_unit] orderGetIn false};
					_unit doMove position player;
					_tiempo = time + 900;
					waitUntil {sleep 1;(!alive _unit) or (_unit distance player < 500) or (time > _tiempo)};
					if ((_unit distance player >= 500) and (alive _unit)) then {_unit setPos (getMarkerPos guer_respawn)};
					[_unit] join group player;
				};
			};
		};
	};

	_unit addEventHandler ["GetInMan",
	{
	private ["_soldier","_veh"];
	_soldier = _this select 0;
	_veh = _this select 2;

	if (((typeOf _veh) in CIV_vehicles) || ((typeOf _veh) == civHeli)) then {
		if !(_veh in reportedVehs) then {
				[_soldier] spawn undercoverAI;
			};
	};
	}];
}
else {
	_EHkilledIdx = _unit addEventHandler ["killed", {
		_muerto = _this select 0;
		_killer = _this select 1;
		[_muerto] remoteExec ["postmortem",2];
		if (isPlayer _killer) then {
			if (!isMultiPlayer) then {
				[0,-20] remoteExec ["resourcesFIA",2];
				_killer addRating -1000;
			};
		};
		[_muerto] spawn postmortem;
		_muerto setVariable ["BLUFORSpawn",nil,true];
		[0,-0.25,getPos _muerto] remoteExec ["AS_fnc_changeCitySupport",2];
	}];
};