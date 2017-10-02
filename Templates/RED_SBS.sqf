
// (un-)armed transport helicopters
opHeliTrans = 		["UK3CB_BAF_Merlin_HC3_18_GPMG_DPMT","UK3CB_BAF_Merlin_HC3_18_GPMG_DPMT"];

// helicopter that dismounts troops
opHeliDismount = 	"CUP_B_CH47F_GB"; // Mi-290 Taru (Bench)

// helicopter that fastropes troops in
opHeliFR = 			"UK3CB_BAF_Wildcat_AH1_TRN_8A_DPMT_RM"; // PO-30 Orca (Unarmed)

// small armed helicopter
opHeliSD = 			"UK3CB_BAF_Wildcat_HMA2_TRN_8A_DPMT"; // PO-30 Orca (Armed)

// gunship
opGunship = 		"UK3CB_BAF_Apache_AH1_JS_DPMT"; // Mi-48 Kajman

// CAS, fixed-wing
opCASFW = 			["CUP_B_GR9_AGM_GB"]; // To-199 Neophron (CAS)


// small UAV (Darter, etc)
opUAVsmall = 		"B_UAV_01_F"; // Tayran AR-2

// air force
opAir = 			["UK3CB_BAF_Merlin_HC3_18_GPMG_DPMT","UK3CB_BAF_Wildcat_AH1_TRN_8A_DPMT_RM","UK3CB_BAF_Apache_AH1_JS_DPMT","CUP_B_CH47F_GB","UK3CB_BAF_Wildcat_HMA2_TRN_8A_DPMT","CUP_B_GR9_AGM_GB"];

// self-propelled anti air
opSPAA = 			"B_APC_Tracked_01_AA_F";

opTruck = 			"UK3CB_BAF_LandRover_Soft_FFR_Green_B_Tropical_RM";

opMRAPu = 			"UK3CB_BAF_LandRover_Hard_FFR_Green_B_Tropical_RM";

opIFV = 			["CUP_B_MCV80_GB_W_SLATCUP_B_MCV80_GB_W_SLAT","CUP_B_MCV80_GB_W_SLAT"];

opArtillery = 		"B_MBT_01_arty_F";
opArtilleryAmmoHE = "32Rnd_155mm_Mo_shells";

// infantry classes, to allow for class-specific skill adjustments and pricing
opI_OFF = 	"UK3CB_BAF_Officer_Tropical_RM"; // officer/official
opI_PIL = 	"UK3CB_BAF_HeliPilot_RN_Tropical"; // pilot
opI_OFF2 = 	"B_G_Soldier_unarmed_F"; // officer/traitor
opI_CREW = 	"UK3CB_BAF_Crewman_Tropical_RM"; // crew
opI_MK = 	"UK3CB_BAF_Marksman_Tropical_BPT_RM";
opI_MED =	"UK3CB_BAF_Medic_Tropical_BPT_RM";
opI_RFL1 = 	"UK3CB_BAF_Explosive_Tropical_BPT_RM";
opI_RFL2 = 	"UK3CB_BAF_Pointman_Tropical_BPT_RM";
opI_AR = 	"UK3CB_BAF_MGLMG_Tropical_BPT_RM";
opI_AR2 = 	"UK3CB_BAF_MGGPMG_Tropical_RM";
opI_SL = 	"UK3CB_BAF_SC_Tropical_BPT_RM";
opI_MK2 = 	"UK3CB_BAF_Sniper_Tropical_Ghillie_L135_RM";
opI_AAR = 	"UK3CB_BAF_Rifleman_762_Tropical_RM";
opI_SP = 	"UK3CB_BAF_Sniper_Tropical_Ghillie_L115_RM";
opI_GL =	"UK3CB_BAF_FAC_Tropical_BPT_RM";
opI_LAT = 	"UK3CB_BAF_MAT_Tropical_RM";

// config path for infantry groups (not used)
opCfgInf = 			(configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_recon_wd_infantry");

// standard group arrays, used for spawning groups
opGroup_Sniper = 		[opI_MK, opI_MK2]; // sniper team
opGroup_SpecOps = 		[opI_SL, opI_MK, opI_MED, opI_RFL1, opI_RFL2, opI_GL, opI_LAT]; // spec opcs
opGroup_Squad = 		[opI_SL, opI_AR, opI_AAR, opI_MK, opI_SP, opI_MED, opI_GL, opI_LAT]; // squad
opGroup_Recon_Team = 	[opI_SL, opI_MK, opI_LAT, opI_MED];
opGroup_Security = 		[opI_SL, opI_AR2, opI_RFL2, opI_MED]; // security detail

// the affiliation
side_red = 			west;

opFlag = 			"Flag_UK_F";

opIR = "UK3CB_BAF_LLM_IR_Black";

opCrate = "Box_NATO_WpsLaunch_F";

// Colour of this faction's markers
OPFOR_marker_colour = "ColorWEST";

// Type of this faction's markers
OPFOR_marker_type = "flag_UK";

// Name of the faction
A3_Str_RED = localize "STR_GENIDENT_SBS";