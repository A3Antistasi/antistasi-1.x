params ["_unit", "_class"];

switch (_class) do {
	case opI_AAR: {
		removeHeadgear _unit;
		_unit addHeadgear "rhs_altyn_novisor_ess_bala";
	};
	case opI_LAT: {
		removeHeadgear _unit;
		_unit addHeadgear "rhs_altyn_novisor_ess_bala";
	};
	case opI_GL: {
		removeHeadgear _unit;
		_unit addHeadgear "rhs_altyn_novisor_ess_bala";
	};
	case opI_MED: {
		removeHeadgear _unit;
		_unit addHeadgear "rhs_altyn_novisor_ess_bala";
	};
	case opI_SL: {
		removeHeadgear _unit;
		_unit addHeadgear "rhs_altyn_novisor_ess_bala";
	};
	case opI_SP: {
		removeHeadgear _unit;
		_unit addHeadgear "rhs_altyn_novisor_ess_bala";
	};
	case opI_AR: {
		removeHeadgear _unit;
		_unit addHeadgear "rhs_altyn_bala";
	};
	case opI_CREW: {
		removeHeadgear _unit;
		_unit addHeadgear "rhs_altyn_bala";
	};
	case opI_MK: {
		removeAllWeapons _unit;
		for "_i" from 1 to 3 do {_unit addItemToUniform "rhs_5Rnd_338lapua_t5000";};
		_unit addItemToVest "rhs_mag_9x19_17";
		_unit addWeapon "rhs_weap_t5000";
		_unit addPrimaryWeaponItem "rhs_acc_dh520x56";
		_unit addPrimaryWeaponItem "rhs_acc_harris_swivel";
		_unit addWeapon "rhs_weap_pya";
		for "_i" from 1 to 10 do {_unit addItemToVest "rhs_5Rnd_338lapua_t5000";};
		_unit addHeadgear "rhs_altyn_novisor_bala";
	};
	default {
	};
};