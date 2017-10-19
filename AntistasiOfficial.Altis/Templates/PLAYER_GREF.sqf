side_blue = independent;
guer_respawn = "respawn_guer";
guer_marker_colour = "ColorGUER";
guer_marker_type = "rhs_flag_che";
guer_flag_texture = "rhsafrf\addons\rhs_main\data\flag_vdv_co.paa";
guer_flag = "rhs_Flag_Che_F";

guer_rem_des = "O_Static_Designator_02_F";

guer_veh_truck = "rhsgref_nat_van"; // default transport for squads
guer_veh_engineer = "B_G_Offroad_01_repair_F";
guer_veh_technical = "rhsgref_ins_g_uaz_dshkm_chdkz";
guer_veh_quad = "I_G_Quadbike_01_F"; // default transport for snipers
guer_veh_offroad = "rhsgref_ins_g_uaz"; // default transport for teams
guer_veh_technical_AT = "rhsgref_ins_g_uaz_spg9";

guer_sol_AA = "rhsgref_ins_g_specialist_aa"; // AA trooper in player groups
guer_sol_AM = "rhsgref_ins_g_rifleman_aksu"; // playable, player-only
guer_sol_AR = "rhsgref_ins_g_machinegunner"; // playable
guer_sol_ENG = "rhsgref_ins_g_engineer"; // playable
guer_sol_EXP = "rhsgref_ins_g_saboteur";
guer_sol_GL = "rhsgref_ins_g_grenadier";
guer_sol_LAT = "rhsgref_ins_g_rifleman_RPG26"; // playable
guer_sol_MED = "rhsgref_ins_g_medic"; // playable
guer_sol_MRK = "rhsgref_ins_g_sniper"; // playable
guer_sol_OFF = "rhsgref_ins_g_commander"; // playable, Petros
guer_sol_R_L = "rhsgref_ins_g_crew"; // driver/crew
guer_sol_RFL = "rhsgref_ins_g_rifleman_akm"; // playable
guer_sol_SL = "rhsgref_ins_g_squadleader";
guer_sol_SN = "rhsgref_ins_g_spotter";
guer_sol_TL = "rhsgref_ins_g_rifleman"; // playable, player-only
guer_sol_UN = "rhsgref_ins_g_pilot"; // mortar gunner

guer_POW = "rhsgref_ins_g_militiaman_mosin";

guer_stat_mortar = "rhsgref_ins_g_2b14";
guer_stat_MGH = "rhsgref_ins_g_DSHKM";
guer_stat_AT = "rhsgref_ins_g_SPG9M";
guer_stat_AA = "rhsgref_ins_g_ZU23";

statics_allMGs pushBackUnique guer_stat_MGH;
statics_allATs pushBackUnique guer_stat_AT;
statics_allAAs pushBackUnique guer_stat_AA;
statics_allMortars pushBackUnique guer_stat_mortar;

guer_cfg_inf = (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry"); // unused

guer_grp_sniper = 		[guer_sol_MRK, guer_sol_SN]; // sniper team, Sgt, Cpl
guer_grp_sentry = 		[guer_sol_GL, guer_sol_RFL]; // Cpl, Pvt
guer_grp_AT = 			[guer_sol_SL, guer_sol_LAT]; // Cpl, Pvt
guer_grp_squad = 		[guer_sol_SL, guer_sol_GL, guer_sol_LAT, guer_sol_AR]; // Sgt, Cpl, Pvt, Pvt
guer_grp_team = 		[guer_sol_SL, guer_sol_GL, guer_sol_LAT, guer_sol_AR, guer_sol_MRK, guer_sol_MED, guer_sol_RFL, guer_sol_ENG]; // Sgt, Cpl, Pvt, Pvt, cpl, pvt, pvt, pvt


/*
These are the vehicles and statics that you can buy at HQ. Currently, the array requires a strict(!) order.
0-2: civilian vehicles
3-10: military vehicles and statics
*/
vfs = [
	"C_Offroad_01_F",
	"C_Van_01_transport_F",
	"RHS_Mi8amt_civilian",
	"I_G_Quadbike_01_F",
	"rhsgref_ins_g_uaz_open",
	"rhsgref_ins_g_gaz66o",
	"rhsgref_ins_g_uaz_dshkm_chdkz",
	"rhs_DSHKM_ins",
	"rhs_2b14_82mm_msv",
	"rhs_Metis_9k115_2_vdv",
	"rhsgref_ins_g_ZU23",
	"rhsgref_ins_g_btr70",
	"rhsgref_ins_g_gaz66_r142"
];

// Name of the faction
A3_Str_PLAYER = localize "STR_GENIDENT_RES";