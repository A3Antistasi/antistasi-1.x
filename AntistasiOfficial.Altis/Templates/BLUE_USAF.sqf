bluHeliTrans = 		["RHS_MELB_MH6M","RHS_UH60M","RHS_CH_47F_light"];
bluHeliTS = 		["RHS_MELB_MH6M"];
bluHeliDis = 		["RHS_UH60M"];
bluHeliRope = 		["RHS_CH_47F_light"];
bluHeliArmed = 		["RHS_MELB_AH6M_H","RHS_MELB_AH6M_M"];
bluHeliGunship = 	["RHS_AH64D_AA","RHS_AH64D_GS","RHS_AH64D"];
bluCASFW = 			["RHS_A10"];

bluAS = 			["rhsusf_f22"];
bluC130 = 			["RHS_C130J"];

bluUAV = 			["B_UAV_02_F"];

planesNATO = bluHeliTrans + bluHeliArmed + bluHeliGunship + bluCASFW;
planesNATOTrans = bluHeliTrans;


bluMBT = 		["rhsusf_m1a2sep1wd_usarmy","rhsusf_m1a2sep1tuskiwd_usarmy"];
bluAPC = 		["RHS_M2A3_wd","RHS_M2A3_BUSKI_wd"];
bluIFV = 		["rhsusf_m113_usarmy_M240","rhsusf_m113_usarmy_supply"];
bluIFVAA = 		["RHS_M6_wd"];
bluArty = 		["RHS_M119_W"]; bluArtyAmmoHE = "RHS_mag_m1_he_12"; bluArtyAmmoLaser = nil; bluArtyAmmoSmoke = "rhs_mag_m60a2_smoke_4";
bluMLRS = 		["B_MBT_01_mlrs_F"];
bluMRAP = 		["rhsusf_m1025_W","rhsusf_m998_w_4dr_halftop","rhsusf_m998_w_4dr_fulltop"];
bluMRAPHMG = 	["rhsusf_m1025_W_m2","rhsusf_rg33_m2_W"];
bluTruckTP = 	["rhsusf_M1083A1P2_B_M2_wd_fmtv_usarmy"];
bluTruckMed = 	["rhsusf_M1083A1P2_B_M2_d_Medical_fmtv_usarmy"];
bluTruckFuel = 	["rhsusf_M978A4_BKIT_usarmy_wd"];

vehNATO = bluMBT + bluAPC + bluIFV + bluIFVAA + bluArty + bluMLRS + bluMRAP + bluMRAPHMG + bluTruckTP + bluTruckMed + bluTruckFuel;


bluStatAA = 	["RHS_Stinger_AA_pod_WD"];
bluStatAT = 	["RHS_TOW_TriPod_WD"];
bluStatHMG = 	["RHS_M2StaticMG_WD"];
bluStatMortar = ["RHS_M252_WD"];


bluPilot = 	"rhsusf_army_ocp_helipilot";
bluCrew = 	"rhsusf_usmc_marpat_wd_combatcrewman";
bluGunner = "rhsusf_usmc_marpat_wd_rifleman_light";

bluMRAPHMGgroup = 	["rhsusf_usmc_fr_marpat_wd_riflemanat","rhsusf_usmc_fr_marpat_wd_rifleman","rhsusf_usmc_fr_marpat_wd_autorifleman_m249"];
bluMRAPgroup = 		["rhsusf_usmc_fr_marpat_wd_teamleader","rhsusf_usmc_fr_marpat_wd_marksman","rhsusf_usmc_fr_marpat_wd_autorifleman"];


bluAirCav = 	["rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_marksman","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_riflemanat","rhsusf_usmc_marpat_wd_rifleman","rhsusf_usmc_marpat_wd_autorifleman_m249"];

bluSquad = 			["rhs_group_nato_usmc_wd_infantry_squad"]; // 12
bluSquadWeapons = 	["rhs_group_nato_usmc_wd_infantry_weaponsquad"]; // 7
bluTeam = 			["rhs_group_nato_usmc_wd_infantry_team"]; // 4
bluATTeam = 		["rhs_group_nato_usmc_wd_infantry_team_heavy_AT"]; // 4

bluIR = 	"rhsusf_acc_anpeq15";

bluFlag = 	"Flag_NATO_F";

bluCfgInf = (configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry");


bluRifle = 	[
	"rhs_weap_m16a4_carryhandle",
	"rhs_weap_m4a1_carryhandle",
	"rhs_weap_m4a1_grip"
];

bluGL = [
	"rhs_weap_m16a4_carryhandle_M203",
	"rhs_weap_m4a1_carryhandle_m203S",
	"rhs_weap_m4a1_m203s"
];

bluSNPR = 	[
	"rhs_weap_m107_leu",
	"rhs_weap_m40_wd_usmc",
	"rhs_weap_sr25"
];

bluLMG = 	[
	"rhs_weap_m240G",
	"rhs_weap_m249_pip_L_para",
	"rhs_weap_m249_pip_S_vfg"
];

bluSmallWpn = 	[
	"rhs_weap_M590_5RD",
	"rhsusf_weap_m1911a1"
];

bluRifleAmmo = [
	"rhs_mag_30Rnd_556x45_Mk318_Stanag",
	"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red"
];

bluSNPRAmmo = [
	"rhsusf_mag_10Rnd_STD_50BMG_M33",
	"rhsusf_mag_10Rnd_STD_50BMG_mk211",
	"rhsusf_10Rnd_762x51_m118_special_Mag",
	"rhsusf_20Rnd_762x51_m118_special_Mag",
	"20Rnd_762x51_Mag"
];

bluLMGAmmo = [
	"rhsusf_50Rnd_762x51",
	"rhsusf_100Rnd_762x51_m62_tracer",
	"rhs_200rnd_556x45_M_SAW"
];

bluSmallAmmo = [
	"rhsusf_5Rnd_00Buck",
	"rhsusf_5Rnd_FRAG",
	"rhsusf_mag_7x45acp_MHP"
];

bluAmmo = [
	"rhsusf_mag_10Rnd_STD_50BMG_M33",
	"rhsusf_mag_10Rnd_STD_50BMG_mk211",
	"rhs_mag_30Rnd_556x45_Mk318_Ball",
	"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",
	"rhsusf_20Rnd_762x51_m118_special_Mag",
	"rhsusf_10Rnd_762x51_m118_special_Mag",
	"rhs_200rnd_556x45_M_SAW",
	"rhsusf_5Rnd_00Buck",
	"rhs_mag_smaw_SR",
	"20Rnd_762x51_Mag",
	"rhsusf_100Rnd_762x51_m61_ap",
	"rhsusf_100Rnd_762x51_m62_tracer",
	"rhsusf_mag_7x45acp_MHP"
];

blu40mm = [
	"rhs_mag_M433_HEDP",
	"1Rnd_HE_Grenade_shell",
	"SmokeShell",
	"SmokeShellGreen",
	"rhs_mag_m576"
];

bluGrenade = [
	"HandGrenade",
	"MiniGrenade"
];

bluAT = [
	"rhs_weap_smaw_optic",
	"rhs_weap_M136_hedp"
];

bluAA = [
	"rhs_weap_fim92"
];

bluVest = [
	"rhsusf_spc_rifleman",
	"rhsusf_spc_crewman"
];

bluScopes = [
	"rhsusf_acc_LEUPOLDMK4",
	"rhsusf_acc_ACOG3_USMC",
	"rhsusf_acc_compm4"
];

bluAttachments = [
	"rhsusf_acc_harris_bipod",
	"rhsusf_acc_sr25S",
	"rhsusf_acc_anpeq15A",
	"rhsusf_acc_nt4_black"
];

bluATMissile = [
	"rhs_mag_smaw_HEAA"
];

bluAAMissile = [
	"rhs_fim92_mag"
];

bluItems = bluVest + bluScopes + bluAttachments;

genGL = genGL + bluGL;
genATLaunchers = genATLaunchers + bluAT;
genAALaunchers = genAALaunchers + bluAA;

// Colour of this faction's markers
BLUFOR_marker_colour = "ColorWEST";

// Type of this faction's markers
BLUFOR_marker_type = "flag_USA";

// Name of the faction
A3_Str_BLUE = localize "STR_GENIDENT_USMC";
