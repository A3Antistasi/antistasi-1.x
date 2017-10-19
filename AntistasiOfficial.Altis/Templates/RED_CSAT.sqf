// (un-)armed transport helicopters
opHeliTrans = 		["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];

// helicopter that dismounts troops
opHeliDismount = 	"O_Heli_Transport_04_bench_F"; // Mi-290 Taru (Bench)

// helicopter that fastropes troops in
opHeliFR = 			"O_Heli_Light_02_unarmed_F"; // PO-30 Orca (Unarmed)

// small armed helicopter
opHeliSD = 			"O_Heli_Light_02_F"; // PO-30 Orca (Armed)

// gunship
opGunship = 		"O_Heli_Attack_02_F"; // Mi-48 Kajman

// CAS, fixed-wing
opCASFW = 			["O_Plane_CAS_02_F"]; // To-199 Neophron (CAS)

// small UAV (Darter, etc)
opUAVsmall = 		"O_UAV_01_F"; // Tayran AR-2

// air force
opAir = 			["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F","O_Heli_Attack_02_F","O_Plane_CAS_02_F","O_Heli_Light_02_F"];

// self-propelled anti air
opSPAA = 			"O_APC_Tracked_02_AA_F";

opTruck = 			"O_Truck_02_transport_F";

opMRAPu = 			"O_MRAP_02_F";

opIFV = 			["O_APC_Tracked_02_cannon_F","O_MRAP_02_gmg_F"];

opArtillery = 		"O_MBT_02_arty_F";
opArtilleryAmmoHE = "32Rnd_155mm_Mo_shells";

// infantry classes, to allow for class-specific skill adjustments and pricing
opI_OFF = 	"O_officer_F"; // officer/official
opI_PIL = 	"O_helipilot_F"; // pilot
opI_OFF2 = 	"O_G_officer_F"; // officer/traitor
opI_SL = 	"O_SoldierU_SL_F"; // squad leader, urban camo
opI_RFL1 = 	"O_soldierU_F"; // rifleman, urban camo
opI_CREW = 	"O_crew_F"; // crew
opI_MK = 	"O_sniper_F";
opI_MED =	"O_recon_medic_F";
opI_RFL2 = 	"O_recon_F";
opI_AR = 	"O_Soldier_AR_F";
opI_AR2 = 	"";
opI_MK2 = 	"O_recon_M_F";
opI_AAR = 	"";
opI_SP = 	"O_spotter_F";
opI_GL =	"O_Soldier_GL_F";
opI_LAT = 	"O_Soldier_LAT_F";

// config path for infantry groups
opCfgInf = 			(configfile >> "CfgGroups" >> "east" >> "OPF_F" >> "Infantry");

// standard group arrays, used for spawning groups
opGroup_Sniper = 		(configfile >> "CfgGroups" >> "east" >> "OPF_F" >> "Infantry" >> "OI_SniperTeam"); // sniper team
opGroup_SpecOps = 		(configfile >> "CfgGroups" >> "east" >> "OPF_F" >> "Infantry" >> "OI_reconTeam"); // spec opcs
opGroup_Squad = 		(configfile >> "CfgGroups" >> "east" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"); // squad
opGroup_Recon_Team = 	(configfile >> "CfgGroups" >> "east" >> "OPF_F" >> "Infantry" >> "OI_reconPatrol");
opGroup_Security = 		[opI_GL, opI_AR, opI_RFL2, opI_MED];

// the affiliation
side_red = 			east;

opFlag = 			"Flag_CSAT_F";

opIR = "acc_pointer_IR";

opCrate = "Box_East_WpsLaunch_F";

// Colour of this faction's markers
OPFOR_marker_colour = "colorOPFOR";

// Type of this faction's markers
OPFOR_marker_type = "flag_CSAT";

// Name of the faction
A3_Str_RED = localize "STR_GENIDENT_CSAT";