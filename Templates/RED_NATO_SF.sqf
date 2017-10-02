// (un-)armed transport helicopters
opHeliTrans = 		["B_Heli_Transport_01_F","B_Heli_Transport_03_F"];

// helicopter that dismounts troops
opHeliDismount = 	"B_Heli_Transport_03_F"; // Mi-290 Taru (Bench)

// helicopter that fastropes troops in
opHeliFR = 			"B_Heli_Transport_01_F"; // PO-30 Orca (Unarmed)

// small armed helicopter
opHeliSD = 			"B_Heli_Transport_01_F"; // PO-30 Orca (Armed)

// gunship
opGunship = 		"B_Heli_Attack_01_F"; // Mi-48 Kajman

// CAS, fixed-wing
opCASFW = 			["B_Plane_CAS_01_F"]; // To-199 Neophron (CAS)

// small UAV (Darter, etc)
opUAVsmall = 		"O_UAV_01_F"; // Tayran AR-2

// air force
opAir = 			["B_Heli_Transport_01_F","B_Heli_Transport_03_F","B_Heli_Attack_01_F","B_Plane_CAS_01_F","B_Heli_Transport_01_F"];

// self-propelled anti air
opSPAA = 			"B_APC_Tracked_01_AA_F";

opTruck = 			"B_Truck_01_covered_F";

opMRAPu = 			"B_MRAP_01_F";

opIFV = 			["B_APC_Tracked_01_rcws_F"];

opArtillery = 		"B_MBT_01_arty_F";
opArtilleryAmmoHE = "32Rnd_155mm_Mo_shells";

// infantry classes, to allow for class-specific skill adjustments and pricing
opI_OFF = 	"B_officer_F"; // officer/official
opI_PIL = 	"B_helipilot_F"; // pilot
opI_OFF2 = 	"B_officer_F"; // officer/traitor
opI_SL = 	"B_recon_TL_F"; // squad leader, urban camo
opI_RFL1 = 	"B_recon_F"; // rifleman, urban camo
opI_CREW = 	"B_crew_F"; // crew
opI_MK = 	"B_sniper_F";
opI_MED =	"B_recon_medic_F";
opI_RFL2 = 	"B_recon_F";
opI_AR = 	"B_Soldier_AR_F";
opI_AR2 = 	"";
opI_MK2 = 	"B_recon_M_F";
opI_AAR = 	"";
opI_SP = 	"B_spotter_F";
opI_GL =	"B_recon_JTAC_F";
opI_LAT = 	"B_recon_LAT_F";

// config path for infantry groups
opCfgInf = 			(configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry");

// standard group arrays, used for spawning groups
opGroup_Sniper = 		(configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_SniperTeam"); // sniper team
opGroup_SpecOps = 		(configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_ReconTeam"); // spec opcs
opGroup_Squad = 		(configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_ReconSquad"); // squad
opGroup_Recon_Team = 	(configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_ReconPatrol");
opGroup_Security = 		[opI_SL, opI_RFL1];

// the affiliation
side_red = 			west;

opFlag = 			"flag_NATO_F";

opIR = "acc_pointer_IR";

opCrate = "Box_East_WpsLaunch_F";

// Colour of this faction's markers
OPFOR_marker_colour = "ColorWEST";

// Type of this faction's markers
OPFOR_marker_type = "flag_NATO";

// Name of the faction
A3_Str_RED = localize "STR_GENIDENT_SF";