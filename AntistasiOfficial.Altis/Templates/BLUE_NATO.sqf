//Aircrafts				//Class id									//.sqf presence and selection

	bluHeliTrans = 		["B_Heli_Transport_03_F"];					// None
	bluHeliTS = 		["B_Heli_Light_01_F"];						// \Create\NATOCA.sqf landing helo. - \AI\puertasLand.sqf
	bluHeliDis = 		["B_Heli_Transport_01_camo_F"];				// \Create\NATOCA.sqf land or fastrope or paradrop -  \AI\puertasLand.sqf -  \Missions\NATOAmmo.sqf drop the resupply
	bluHeliRope = 		["B_Heli_Transport_03_F"];					// \Create\NATOCA.sqf land or fastrope - \AI\puertasLand.sqf
	bluHeliArmed = 		["B_Heli_Light_01_armed_F"];				// \CREATE\NATOQRF.sqf - \REINF\NATOCAS.sqf
	bluHeliGunship = 	["B_Heli_Attack_01_F"];						// \REINF\NATOCAS.sqf selectrandom
	bluCASFW = 			["B_Plane_CAS_01_F"];						// \AI\airstrike.sqf selectrandom

	bluUAV = 			["B_UAV_02_F"];								// \REINF\NATOUAV.sqf

	//Categories
	planesNATOTrans = bluHeliTrans;									// \Create\NATOCA.sqf selectrandom
	planesNATO = bluHeliTrans + bluHeliArmed + bluHeliGunship + bluCASFW + bluHeliTS + bluHeliDis, bluHeliRope;	//All Air Assets

//Groundvehicles		//Class id									//.sqf presence
	bluMBT = 			["B_MBT_01_cannon_F","B_MBT_01_TUSK_F"];	// \CREATE\NATOArmor.sqf selectrandom
	bluAPC = 			["B_APC_Wheeled_01_cannon_F"];				// \REINF\NATORoadblock.sqf select 0 (APC to move to RB point) - \Compositions\cmpNATO_RB.sqf select 0 (APC stationary at RB)
	bluIFV = 			["B_APC_Tracked_01_rcws_F"];				//	None
	bluIFVAA = 			["B_APC_Tracked_01_AA_F"];					//	None

	bluArty = 			["B_MBT_01_arty_F"]; 						// \REINF\NATOArty.sqf selectrandom
	bluMLRS = 			["B_MBT_01_mlrs_F"];						// \REINF\NATOArty.sqf selectrandom
		bluArtyAmmoHE = "32Rnd_155mm_Mo_shells";
		bluArtyAmmoLaser = "2Rnd_155mm_Mo_LG";
		bluArtyAmmoSmoke = "2Rnd_155mm_Mo_LG";

	bluMRAP =			["B_MRAP_01_F"];							// \CREATE\NATOQRF.sqf one is select 0, two is selectrandom
	bluMRAPHMG =		["B_MRAP_01_hmg_F"];						// \CREATE\NATOQRF.sqf select 0
	bluTruckTP = 		["B_Truck_01_covered_F"];					// none
	bluTruckMed = 		["B_Truck_01_medical_F"];					// none
	bluTruckFuel = 		["B_Truck_01_fuel_F"];						// none

	//Category
	vehNATO = bluMBT + bluAPC + bluIFV + bluIFVAA + bluArty + bluMLRS + bluMRAP + bluMRAPHMG + bluTruckTP + bluTruckMed + bluTruckFuel;

	bluStatAA = 	["B_static_AA_F"];								// \CREATE\createNATOpuesto.sqf selectrandom
	bluStatAT = 	["B_static_AT_F"];								// none
	bluStatHMG = 	["B_HMG_01_high_F"];							// \CREATE\createNATOpuesto.sqf selectrandom
	bluStatMortar = ["B_G_Mortar_01_F"];							// \REINF\NATOArty.sqf selectrandom

//Units					//Class id											//.sqf presence
	bluCfgInf = (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry");

	bluPilot = 			"B_Pilot_F";										//
	bluCrew = 			"B_crew_F";											// \CREATE\createNATOpuesto.sqf
	bluGunner = 		"B_support_MG_F";									// \REINF\NATOArty.sqf

	bluMRAPHMGgroup = 	["B_recon_LAT_F","B_Recon_Sharpshooter_F"];			// \CREATE\NATOQRF.sqf foreach
	bluMRAPgroup = 		["B_recon_medic_F","B_recon_F","B_recon_JTAC_F"];	// \CREATE\NATOQRF.sqf foreach
	//Category
	bluAirCav = 		["B_recon_TL_F","B_recon_LAT_F","B_Recon_Sharpshooter_F","B_recon_medic_F","B_recon_F","B_recon_JTAC_F"]; // \CREATE\NATOQRF.sqf foreach


	bluSquad = 			["BUS_InfSquad"]; 				// 8 men			\CREATE\NATOCA.sqf call AS_fnc_pickGroup
	bluSquadWeapons = 	["BUS_InfSquad_Weapons"];		// 8 men			\CREATE\NATOCA.sqf call AS_fnc_pickGroup
	bluTeam = 			["BUS_InfTeam"];				// 4 men			\CREATE\NATOCA.sqf call AS_fnc_pickGroup
	bluATTeam = 		["BUS_InfTeam_AT"]; 			// 4 men			\CREATE\createNATOpuesto.sqf call AS_fnc_pickGroup

	bluIR = 			"acc_pointer_IR";

//Vehicles to buy
	blubuyTruck =			"B_Truck_01_covered_F";
	blubuyAPC = 			"B_APC_Tracked_01_rcws_F";
	blubuyMRAP = 			"B_MRAP_01_hmg_F";

//Airfield vehicle (max1)
	blubuyHeli = 			"B_Heli_Light_01_F";
//Seaport vehicle
	blubuyBoat = 			"B_Boat_Armed_01_minigun_F";
//Special vehicle to buy (max 1)

	blubuylist = [blubuyBoat,blubuyHeli,blubuyMRAP,blubuyAPC,blubuyTruck];

//bluEquipment
	bluSmallWpn = 	[					// select reference
		"hgun_Pistol_heavy_01_F",      	// 0 Pistol
		"SMG_02_F"     					// 1 SecondarySMG or Shotgun short
	];

	bluSmallAmmo = [					// select reference
		"11Rnd_45ACP_Mag",  			// 0 Pistol ammo
		"30Rnd_9x21_Mag_SMG_02"			// 1 SecondarySMG ammo
	];

	bluRifle = 	[ 						// select random
		"arifle_MXC_Black_F",			// 0 Rifle
		"arifle_MX_GL_Black_F"			// 0 GL rifle
	];

	bluRifleAmmo = [						// select random (this might require a tweak if blurifle have rifle with different ammo, try to keep the same)
		"30Rnd_65x39_caseless_mag",
		"30Rnd_65x39_caseless_mag_Tracer"
	];

	bluGL = [
		"arifle_MX_GL_Black_F"
	];

	bluGLsmoke = [								// foreach
		"UGL_FlareGreen_F",
		"UGL_FlareRed_F",
		"1Rnd_SmokeRed_Grenade_shell",
		"1Rnd_SmokeGreen_Grenade_shell"
	];

	bluSNPR = 	[
		"srifle_EBR_F",			//7.62mm
		"srifle_LRR_F"			//big gun, only for higher tier
	];

	bluSNPRAmmo = [
		"20Rnd_762x51_Mag",
		"7Rnd_408_Mag"
	];

	bluLMG = 	[
		"arifle_MX_SW_F",				//Tier 1
		"LMG_Zafir_F"					//Tier 2
	];

	bluLMGAmmo = [
		"100Rnd_65x39_caseless_mag",	//Tier 1
		"150Rnd_762x54_Box"				//Tier 2
	];

	bluGrenade = [
		"HandGrenade",		//
		"MiniGrenade"
	];

	bluAT = [
		"launch_NLAW_F",			//Tier 1
		"launch_NLAW_F",			//Tier 2
		"launch_B_Titan_short_F"	//Tier 3
	];

	bluATMissile = [
		"NLAW_F",			// Tier 1 single use
		"NLAW_F",			// Tier 2
		"Titan_AT"			// Tier 3
	];

	bluAA = [
		"launch_B_Titan_F"		//Higher tier
	];

	bluAAMissile = [
		"Titan_AA"			//Higher tier
	];

	bluVest = [				//Need to check stats
		"rhsusf_spc_light",		//0 - Tier 1
		"rhsusf_spc_crewman"	//1 - Tier 2
	];							//2 - Tier 3

	bluScopes = [					// Preferibly only PIP compatible = more realisitc
		"optic_Hamr",				// 0 Normal
		"optic_MRCO",				// 1 LMG
		"optic_DMS"					// 2 Sniper
	];

	bluAttachments = [
		"acc_flashlight", 			//anpeq with laser + flashlight
		"bipod_01_F_snd",			//Bipod
		"muzzle_snds_L",			//Higer tier only
		"acc_flashlight_pistol",	//pistol flashlight
		"optic_MRD"					//pistol optic
	];

	bluSuppressor = [
	"muzzle_snds_acp",
	"muzzle_snds_L"
	];

	blunvg = [
	"NVGoggles"

	];

	bluHelmet = [
	"H_HelmetB_light_black",		// Tier 1
	"H_HelmetB_black",				// Tier 2
	"H_HelmetSpecB_blk"				// Tier 3
	];


genGL = genGL + bluGL;
genATLaunchers = genATLaunchers + bluAT;
genAALaunchers = genAALaunchers + bluAA;

// Flag
bluFlag = 	"Flag_NATO_F";

// Colour of this faction's markers
BLUFOR_marker_colour = "ColorWEST";

// Type of this faction's markers
BLUFOR_marker_type = "flag_NATO";

// Name of the faction
A3_Str_BLUE = localize "STR_GENIDENT_NATO";