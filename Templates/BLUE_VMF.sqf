bluHeliTrans = 		["RHS_Mi24Vt_vvsc","rhs_ka60_grey","RHS_Mi8mt_vdv"];
bluHeliTS = 		["RHS_Mi24Vt_vvsc"];
bluHeliDis = 		["RHS_Mi8mt_vdv"];
bluHeliRope = 		["RHS_Mi24Vt_vvsc","rhs_ka60_grey"];
bluHeliArmed = 		["RHS_Mi24P_vvsc","RHS_Mi24P_CAS_vvsc"];
bluHeliGunship = 	["rhsgref_mi24g_UPK23","rhsgref_mi24g_FAB","rhs_mi28n_s13_vvsc"];
bluCASFW = 			["RHS_Su25SM_vvs"];

bluAS = 			["RHS_T50_vvs_generic"];
bluC130 = 			["RHS_C130J"];

bluUAV = 			["I_UAV_02_CAS_F"];

planesNATO = bluHeliTrans + bluHeliArmed + bluHeliGunship + bluCASFW;
planesNATOTrans = bluHeliTrans;


bluMBT = 		["rhs_t90a_tv","rhs_t80bvk"];
bluAPC = 		["rhs_btr80a_vdv","rhs_btr80_vdv"];
bluIFV = 		["rhs_brm1k_tv","rhs_bmp2k_tv", "rhs_bmp2k_tv"];
bluIFVAA = 		["rhs_zsu234_aa"];
bluArty = 		["rhs_2s3_tv"]; bluArtyAmmoHE = "rhs_mag_HE_2a33"; bluArtyAmmoLaser = "rhs_mag_LASER_2a33"; bluArtyAmmoSmoke = "rhs_mag_SMOKE_2a33";
bluMLRS = 		["RHS_BM21_VMF_01"];
bluMRAP = 		["rhs_tigr_vmf","rhs_tigr_vmf"];
bluMRAPHMG = 	["rhs_tigr_sts_3camo_vmf","rhs_tigr_sts_3camo_vmf"];
bluTruckTP = 	["RHS_Ural_Flat_VMF_01"];
bluTruckMed = 	["rhs_gaz66_ap2_vmf"];
bluTruckFuel = 	["RHS_Ural_Fuel_VMF_01"];

vehNATO = bluMBT + bluAPC + bluIFV + bluIFVAA + bluArty + bluMLRS + bluMRAP + bluMRAPHMG + bluTruckTP + bluTruckMed + bluTruckFuel;


bluStatAA = 	["rhs_Igla_AA_pod_vdv"];
bluStatAT = 	["rhs_Kornet_9M133_2_vdv"];
bluStatHMG = 	["rhs_KORD_high_VDV"];
bluStatMortar = ["rhs_2b14_82mm_vdv"];


bluPilot = 	"rhs_pilot_tan";
bluCrew = 	"rhs_vdv_armoredcrew";
bluGunner = "rhs_vdv_rifleman_lite";

bluMRAPHMGgroup = 	["rhs_vmf_recon_sergeant","rhs_vmf_recon_medic","rhs_vmf_recon_arifleman_scout"];
bluMRAPgroup = 		["rhs_vmf_recon_sergeant","rhs_vmf_recon_marksman","rhs_vmf_recon_arifleman_scout"];

bluAirCav = 	["rhs_vmf_recon_rifleman_l","rhs_vmf_recon_marksman","rhs_vmf_recon_arifleman_scout","rhs_vmf_recon_sergeant","rhs_vmf_recon_rifleman_scout","rhs_vmf_recon_medic"];

bluSquad = 			["rhs_group_rus_vdv_infantry_squad"]; // 12
bluSquadWeapons = 	["rhs_group_rus_vdv_infantry_squad_mg_sniper"]; // 7
bluTeam = 			["rhs_group_rus_vdv_infantry_MANEUVER"]; // 4
bluATTeam = 		["rhs_group_rus_vdv_infantry_section_AT"]; // 4

bluIR = 	"rhs_acc_perst1ik";

bluFlag = 	"rhs_Flag_Russia_F";

bluCfgInf = (configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry");


bluRifle = [
	"rhs_weap_ak74mr",
	"rhs_weap_m21a",
	"rhs_weap_m70ab2"
];

bluGL = [
	"rhs_weap_ak74mr_gp25",
	"rhs_weap_aks74n_gp25",
	"rhs_weap_akms_gp25"
];

bluSNPR = [
	"rhs_weap_t5000",
	"rhs_weap_m76_pso",
	"rhs_weap_vss"
];

bluLMG = [
	"rhs_weap_pkp",
	"rhs_weap_pkm",
	"rhs_weap_pkm"
];

bluSmallWpn = [
	"rhs_weap_m21s",
	"rhs_weap_savz61"
];

bluRifleAmmo = [
	"rhs_30Rnd_545x39_AK",
	"rhs_45Rnd_545x39_AK"
];

bluSNPRAmmo = [
	"rhs_5Rnd_338lapua_t5000",
	"rhs_30Rnd_762x39mm",
	"rhs_10rnd_9x39mm_SP5",
	"rhs_20rnd_9x39mm_SP6"
];

bluLMGAmmo = [
	"rhs_100Rnd_762x54mmR",
	"rhs_100Rnd_762x54mmR_green",
	"rhs_100Rnd_762x54mmR_7bz3"
];

bluSmallAmmo = [
	"rhsgref_30rnd_556x45_m21",
	"rhsgref_30rnd_556x45_m21",
	"rhsgref_20rnd_765x17_vz61"
];

bluAmmo = bluRifleAmmo + bluSNPRAmmo + bluLMGAmmo + bluSmallAmmo;

blu40mm = [
	"rhs_VOG25",
	"rhs_VOG25p"
];

bluGrenade = [
	"HandGrenade",
	"MiniGrenade"
];

bluAT = [
	"rhs_weap_rpg7",
	"rhs_weap_rpg7"
];

bluAA = [
	"rhs_weap_igla"
];

bluVest = [
	"rhs_6b23_6sh116_vog_flora",
	"rhsgref_6b23_khaki_rifleman"
];

bluScopes = [
	"rhs_acc_ekp1",
	"rhs_acc_dh520x56",
	"rhs_acc_pso1m2"
];

bluAttachments = [
	"rhs_acc_dtk4short",
	"rhs_acc_2dpZenit",
	"rhs_acc_perst1ik",
	"rhs_acc_pbs1",
	"rhs_acc_pbs4",
	"rhs_acc_tgpa"
];

bluATMissile = [
	"rhs_rpg7_PG7V_mag",
	"rhs_rpg7_PG7VL_mag",
	"rhs_rpg7_OG7V_mag",
	"rhs_rpg7_TBG7V_mag"
];

bluAAMissile = [
	"rhs_mag_9k38_rocket"
];

bluItems = bluVest + bluScopes + bluAttachments;

genGL = genGL + bluGL;
genATLaunchers = genATLaunchers + bluAT;
genAALaunchers = genAALaunchers + bluAA;

// Colour of this faction's markers
BLUFOR_marker_colour = "ColorEAST";

// Type of this faction's markers
BLUFOR_marker_type = "rhs_flag_vmf";

// Name of the faction
A3_Str_BLUE = localize "STR_GENIDENT_VMF";