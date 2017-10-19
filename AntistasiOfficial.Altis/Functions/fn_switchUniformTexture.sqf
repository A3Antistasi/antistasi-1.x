[["U_BG_Guerilla1_1","U_BG_Guerilla3_1","U_C_WorkerOveralls"],[]] params ["_uniforms","_uniformNames"];

{
	_uniformNames pushBackUnique (gettext (configfile >> "CfgWeapons" >> _x >> "displayName"));
} forEach _uniforms;

call {
	if ((uniform player) isEqualTo "U_BG_Guerilla1_1") exitWith {
		player setObjectTextureGlobal [0, selectRandom ["\a3\characters_f_gamma\Civil\Data\c_cloth1_black.paa","A3\Characters_F\Civil\Data\c_cloth1_kabeiroi_co.paa","A3\Characters_F\Civil\Data\c_cloth1_bandit_co.paa","A3\Characters_F\Civil\Data\c_cloth1_v3_co.paa","A3\Characters_F\Civil\Data\c_cloth1_v2_co.paa","A3\Characters_F\Civil\Data\c_cloth1_co.paa","\a3\characters_f_gamma\Civil\Data\c_cloth1_brown.paa","A3\Characters_F\Civil\Data\poor_co.paa","A3\Characters_F\Civil\Data\poor_v2_co.paa","A3\Characters_F\Civil\Data\poor_v3_co.paa"]];
	};

	if ((uniform player) isEqualTo "U_BG_Guerilla3_1") exitWith {
		player setObjectTextureGlobal [0, selectRandom ["A3\Characters_F\Civil\Data\hunter_bushman_co.paa"]];
	};

	if ((uniform player) isEqualTo "U_C_WorkerOveralls") exitWith {
		player setObjectTextureGlobal [0, selectRandom ["\A3\characters_f\common\data\coveralls_bandit_co.paa","\A3\characters_f\common\data\coveralls_grey_co.paa","\A3\characters_f\common\data\coveralls_black_co.paa","\A3\characters_f\common\data\coveralls_urbancamo_co.paa"]];
	};

	if ((uniform player) isEqualTo "U_I_C_Soldier_Bandit_3_F") exitWith {
		player setObjectTextureGlobal [0, selectRandom ["\a3\characters_f_gamma\Civil\Data\c_cloth1_black.paa","A3\Characters_F\Civil\Data\c_cloth1_kabeiroi_co.paa","A3\Characters_F\Civil\Data\c_cloth1_bandit_co.paa","A3\Characters_F\Civil\Data\c_cloth1_v3_co.paa","A3\Characters_F\Civil\Data\c_cloth1_v2_co.paa","A3\Characters_F\Civil\Data\c_cloth1_co.paa","\a3\characters_f_gamma\Civil\Data\c_cloth1_brown.paa","A3\Characters_F\Civil\Data\poor_co.paa","A3\Characters_F\Civil\Data\poor_v2_co.paa","A3\Characters_F\Civil\Data\poor_v3_co.paa"]];
	};

	hint format ["List of supported clothes: \n%1",_uniformNames joinString "\n"];
};