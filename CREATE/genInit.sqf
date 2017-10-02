params ["_unit"];
private ["_skill","_aiming","_spotD","_spotT","_cour","_comm","_aimingSh","_aimingSp","_reload","_skillSet","_unitType","_resourcesAAF"];

_unit setVariable ["OPFORSpawn",true,true];

_skill = (0.2 + (skillAAF * 0.025));
_unit setSkill (_skill + 0.1);
_aiming = _skill + 0.1;
_spotD = _skill + 0.1;
_spotT = _skill + 0.1;
_cour = _skill + 0.1;
_comm = _skill + 0.1;
_aimingSh = _skill + 0.1;
_aimingSp = _skill + 0.1;
_reload = _skill + 0.1;

_skillSet = 0;

_unitType = typeOf _unit;
switch _unitType do {
	case sol_A_AA: {_skillSet = 0;}; // assistant AA
	case sol_A_AR: {_skillSet = 3;}; // assistant autorifle
	case sol_A_AT: {_skillSet = 0;}; // assistant AT
	case sol_AA: {_skillSet = 0;}; // AA
	case sol_AR: {_skillSet = 3;}; // autorifle
	case sol_AT: {_skillSet = 0; if (activeACE AND replaceFIA) then {[_unit, _unitType] call AS_fnc_gear_loadoutAAF}}; // AT
	/*case sol_AMMO: {}; // ammo bearer*/
	/*case sol_GL: {}; // grenade launcher*/
	/*case sol_GL2: {}; // grenade launcher*/
	/*case sol_LAT: {}; // light AT*/
	/*case sol_LAT2: {}; // light AT*/
	case sol_MG: {_skillSet = 3;}; // MG
	case sol_MK: {_skillSet = 2;}; // marksman
	case sol_SL: {_skillSet = 1;}; // squad leader
	case sol_TL: {_skillSet = 1;}; // team leader
	case sol_TL2: {_skillSet = 1;}; // team leader
	case sol_EXP: {_skillSet = 0;}; // explosives
	/*case sol_R_L: {}; // rifleman, light*/
	case sol_REP: {_skillSet = 0;}; // repair
	/*case sol_UN: {}; // unarmed*/
	/*case sol_RFL: {}; // rifleman*/
	case sol_SN: {_skillSet = 2;}; // sniper
	case sol_SP: {_skillSet = 2;}; // spotter
	case sol_MED: {_skillSet = 0;}; // medic
	case sol_ENG: {_skillSet = 0;}; // engineer
	case sol_OFF: {_skillSet = 1;}; // officer
	case sol_OFF2: {_skillSet = 1;}; // officer

	/*case sol_CREW: {}; // crew*/
	/*case sol_CREW2: {}; // crew*/
	/*case sol_CREW3: {}; // crew*/
	/*case sol_CREW4: {}; // crew*/
	/*case sol_DRV: {}; // driver*/
	/*case sol_DRV2: {}; // driver*/
	/*case sol_HCREW: {}; // helicopter crew*/
	case sol_HPIL: {_skillSet = 1;};  // helicopter pilot (unarmed)
	case sol_HPIL2: {_skillSet = 1;}; // helicopter pilot (armed)
	case sol_PIL: {_skillSet = 1;}; // pilot
	/*case sol_UAV: {}; // UAV controller*/

	/*case sol_SUP_AMG: {}; // assistant HMG*/
	/*case sol_SUP_AMTR: {}; // assistant mortar*/
	case sol_SUP_GMG: {_skillSet = 3;}; // GMG gunner
	case sol_SUP_MG: {_skillSet = 3;}; // HMG gunner
	/*case sol_SUP_MTR: {}; // mortar gunner*/
};


switch _skillSet do {
	case 0: { // AT, AA, ENG, MED
		_aiming = _aiming - 0.1;
		if (_aiming > 0.35) then {_aiming = 0.35};
		_spotD = _spotD - 0.1;
		_spotT = _spotT - 0.1;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
	};
	case 1: { // officers, NCOs, pilots
		_aiming = _aiming - 0.1;
		if (_aiming > 0.35) then {_aiming = 0.35};
		_spotD = _spotD + 0.1;
		_spotT = _spotT + 0.2;
		_cour = _cour + 0.1;
		_comm = _comm + 0.2;
		_aimingSh = _aimingSh - 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.1;
	};
	case 2: { // sniper/marksman
		_aiming = _aiming + 0.2;
		_spotD = _spotD + 0.2;
		_spotT = _spotT + 0.2;
		_cour = _cour - 0.1;
		_comm = _comm - 0.1;
		_aimingSh = _aimingSh + 0.1;
		_aimingSp = _aimingSp - 0.1;
		_reload = _reload - 0.4;
	};
	case 3: { // machinegunner, autorifleman
		_aiming = _aiming - 0.1;
		if (_aiming > 0.35) then {_aiming = 0.35};
		_aimingSh = _aimingSh + 0.2;
		_aimingSp = _aimingSp - 0.2;
		_reload = _reload - 0.2;
	};
};

_resourcesAAF = server getVariable ["resourcesAAF",0];

if (round random 13 > skillAAF) then {
	_unit unassignItem indNVG;
	_unit removeItem indNVG;

	_unit unassignItem indLaser;
	_unit removePrimaryWeaponItem indLaser;
	_unit addPrimaryWeaponItem indFL;

	if (sunOrMoon < 1) then {
		_unit enableGunLights "forceOn";
		_spotD = ((_spotD - 0.2) max 0.2);
		_spotT = ((_spotT - 0.2) max 0.2);
	};
} else {
	if (sunOrMoon < 1) then {
		if (indLaser in primaryWeaponItems _unit) then {
			if (random 1 > 0.6) then {
				_unit enableIRLasers true;
			} else {
				_unit enableIRLasers false;
			};
		};
	};
};

_unit setskill ["aimingAccuracy",_aiming];
_unit setskill ["spotDistance",_spotD];
_unit setskill ["spotTime",_spotT];
_unit setskill ["courage",_cour];
_unit setskill ["commanding",_comm];
_unit setskill ["aimingShake",_aimingSh];
_unit setskill ["aimingSpeed",_aimingSp];
_unit setskill ["reloadSpeed",_reload];

_unit addEventHandler ["HandleDamage",handleDamageAAF];
_unit addEventHandler ["killed", AAFKilledEH];