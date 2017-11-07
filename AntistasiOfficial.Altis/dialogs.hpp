
class HQ_menu
{
	idd=100;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_8);
	AS_FRAME_D(FRAME_H_8, "FIA HQ Options - Commander Only");
	BTN_BACK(A_CLOSE);

	#define STR_HQ_FIA "if (activeBE) then {[] remoteExec [""fnc_BE_buyUpgrade"", 2]} else {closeDialog 0; [] call FIAskillAdd;}"

	BTN_L1(-1, "Grab 100 € from Pool", "", "if (isMultiPlayer) then {nul=call stavrosSteal} else {hint ""This function is MP only""};");
	BTN_L2(-1, "Manage Garrisons", "", "closeDialog 0; nul=CreateDialog ""garrison_menu"";");
	BTN_L3(-1, "Move HQ to another Zone", "", "closeDialog 0; [] spawn moveHQ;");

	BTN_R1(-1, "Ingame Member's List", "", "if (isMultiplayer) then {[] execVM ""OrgPlayers\membersList.sqf""} else {hint ""This function is MP only""};");
	BTN_R2(109, "Train FIA", "", STR_HQ_FIA);
	BTN_R3(-1, "Rebuild Assets", "Cost: 5.000 €", "closeDialog 0; [] execVM ""rebuildAssets.sqf"";");
	};
};

class unit_recruit
{
	idd= 100;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, "Recruitment Options");
	BTN_BACK(A_CLOSE);

	BTN_L1(104, "Recruit Militiaman", "", "[guer_sol_RFL] spawn reinfPlayer");
	BTN_L2(105, "Recruit Autorifleman", "", "[guer_sol_AR] spawn reinfPlayer");
	BTN_L3(106, "Recruit Medic", "", "[guer_sol_MED] spawn reinfPlayer");
	BTN_L4(110, "Recruit Marksman", "", "[guer_sol_MRK] spawn reinfPlayer");

	BTN_R1(107, "Recruit Engineer", "", "[guer_sol_ENG] spawn reinfPlayer");
	BTN_R2(109, "Recruit Grenadier", "", "[guer_sol_GL] spawn reinfPlayer");
	BTN_R3(108, "Recruit Bomb Specialist", "", "[guer_sol_EXP] spawn reinfPlayer");
	BTN_R4(111, "Recruit AT", "", "[guer_sol_LAT] spawn reinfPlayer");

	BTN_M(BTN_Y_5, 112, "Recruit AA", "", "[""Soldier_AA""] spawn reinfPlayer");

		};
};

class squad_recruit
{
	idd=100;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, "Squad Recruitment Options");
	BTN_BACK("closeDialog 0; createDialog ""radio_comm_commander"";");

	BTN_L1(104, "Recruit Inf. Squad", "", "closeDialog 0; [guer_grp_squad] spawn addFIAsquadHC");
	BTN_L2(105, "Recruit Inf. Team", "", "closeDialog 0; [guer_grp_team] spawn addFIAsquadHC");
	BTN_L3(106, "Recruit AT Squad", "", "closeDialog 0; [guer_grp_AT] spawn addFIAsquadHC");
	BTN_L4(110, "Recruit AA Truck", "", "closeDialog 0; [guer_stat_AA] spawn addFIAsquadHC");

	BTN_R1(107, "Recruit Sniper Team", "", "closeDialog 0; [guer_grp_sniper] spawn addFIAsquadHC");
	BTN_R2(109, "Recruit AT Truck", "", "closeDialog 0; [guer_stat_AT] spawn addFIAsquadHC");
	BTN_R3(108, "Recruit Sentry", "", "closeDialog 0; [guer_grp_sentry] spawn addFIAsquadHC");
	BTN_R4(111, "Recruit Mortar Team", "", "closeDialog 0; [guer_stat_mortar] spawn addFIAsquadHC");

	BTN_M(BTN_Y_5, 112, "Recruit Engineers", "", "closeDialog 0; [""delete""] spawn mineDialog;");

	};
};

class buy_vehicle
{
	idd=100;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, "Purchase Military Vehicle");
	BTN_BACK("closeDialog 0; createDialog ""vehicle_option"";");

	BTN_L1(104, "Buy Quadbike", "", "closedialog 0; [vfs select 3] call addFIAveh");
	BTN_L2(105, "Buy Offroad/UAZ", "", "closedialog 0; [vfs select 4] call addFIAveh");
	BTN_L3(106, "Buy Truck", "", "closedialog 0; [vfs select 5] call addFIAveh");
	BTN_L4(110, "Buy Static AT", "", "closedialog 0; [vfs select 9] call addFIAveh");

	BTN_R1(107, "Buy Armed Offroad", "", "closedialog 0; [vfs select 6] call addFIAveh");
	BTN_R2(109, "Buy Mortar", "", "closedialog 0; [vfs select 8] call addFIAveh");
	BTN_R3(108, "Buy MG", "", "closedialog 0; [vfs select 7] call addFIAveh");
	BTN_R4(111, "Buy Static AA", "", "closedialog 0; [vfs select 10] call addFIAveh");

	BTN_M(BTN_Y_5, 112, "Buy APC", "", "if (activeAFRF) then {if (player == Slowhand) then {closeDialog 0; [vfs select 11] call addFIAveh;} else {hint ""Only Player Commander has access to this function""};}else {hint ""RHS exclusive for now""};");

	};
};

class first_load
{
	idd=-1;
	movingenable=false;

	class controls
	{

		AS_BOX_D(BOX_H_2);
		AS_FRAME_D(FRAME_H_2, "Load previous session?");

		#define STR_LOAD_YES "closeDialog 0; if ((player == Slowhand) and (isNil ""placementDone"")) then {[] remoteExec [""AS_fnc_loadGame"",2];placementDone = true; publicVariable 'placementDone';};"

		BTN_L1(-1,"YES", "", STR_LOAD_YES);
		BTN_R1(-1,"NO", "", A_CLOSE);

	};
};

class init_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Enable Switch Commander?");

	BTN_L1(-1,"YES", "", "switchCom = true; publicVariable ""switchCom""; hint ""Switch Commander Enabled\n\nGame will auto assign Commander position to the highest ranked player"";");
	BTN_R1(-1,"NO", "", "switchCom = false; publicVariable ""switchCom""; hint ""Switch Commander Disabled\n\nGame will only assign Commander position upon Commander disconnection"";");

	BTN_M(BTN_Y_2, -1, "Done", "", "if (!isNil ""switchCom"") then {closedialog 0; [] execVM ""Dialogs\membersMenu.sqf"";} else {hint ""Select an option first""};");
	};
};

class build_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, "Building Options");
	BTN_BACK("closeDialog 0; if (player == Slowhand) then {createDialog ""radio_comm_commander""} else {createDialog ""radio_comm_player""};");

	BTN_L1(-1,"O.Post - Roadblock", "", "closeDialog 0; [""create""] spawn puestoDialog");
	BTN_L2(-1,"Build Minefield", "", "closeDialog 0; createDialog ""minebuild_menu"";");

	BTN_R1(-1,"O.Post-Roadblock Delete", "", "closeDialog 0; [""delete""] spawn puestoDialog");
	BTN_R2(-1,"Manage Camps", "Establish/Abandon Camps", "closeDialog 0; createDialog ""camp_dialog"";");

	BTN_M(BTN_Y_3, -1, "HQ Fortifications", "", "closeDialog 0; createDialog ""HQ_fort_dialog"";");
	};
};

class mission_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_8);
	AS_FRAME_D(FRAME_H_8, "Available Missions");
	BTN_BACK(A_CLOSE);

	#define STR_MIS_MIL "closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""FND_M""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};"
	#define STR_MIS_CIV "closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""FND_C""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};"
	#define STR_MIS_EXP "closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""FND_E""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};"
	#define STR_MIS_LOG	"closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""LOG""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};"
	#define STR_MIS_DES	"closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""DES""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};"
	#define STR_MIS_RES "closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""RES""],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};"
	#define STR_MIS_PRO "closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""PR"",false,true],""missionrequest""] call BIS_fnc_MP} else {hint ""Only Player Commander has access to this function""};"

	BTN_L1(-1,"Military Contact", "", STR_MIS_MIL);
	BTN_L2(-1,"Civilian Contact", "", STR_MIS_CIV);
	BTN_L3(-1,"Sketchy Irishman", "", STR_MIS_EXP);

	BTN_R1(-1,"Logistics Mission", "", STR_MIS_LOG);
	BTN_R2(-1,"Destroy Mission", "", STR_MIS_DES);
	BTN_R3(-1,"Rescue Mission", "", STR_MIS_RES);

	BTN_M(BTN_Y_4, -1, "Propaganda", "", STR_MIS_PRO);
	};
};

class NATO_Options
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, "Ask NATO for");
	BTN_BACK("closeDialog 0; createDialog ""radio_comm_commander"";");

	BTN_L1(-1,"Attack Mission", "Cost: 20 points", "closeDialog 0; [""NATOCA""] execVM ""NatoDialog.sqf"";");
	BTN_L2(-1,"Armored Column", "Cost: 20 points", "closeDialog 0; [""NATOArmor""] execVM ""NatoDialog.sqf"";");
	BTN_L3(-1,"Artillery", "Cost: 10 points", "closeDialog 0; [""NATOArty""] execVM ""NatoDialog.sqf"";");
	BTN_L4(-1,"Roadblock", "Cost: 10 points", "closeDialog 0; [""NATORoadblock""] execVM ""NatoDialog.sqf"";");
	BTN_L5(-1, "NATO QRF", "Cost: 10 points", "closeDialog 0; [""NATOQRF""] execVM ""NatoDialog.sqf"";");  //Stef 30-08

	BTN_R1(-1,"NATO UAV", "Cost: 10 points", "closeDialog 0; [""NATOUAV""] execVM ""NatoDialog.sqf"";");
	BTN_R2(-1,"Ammodrop", "Cost: 5 points", "closeDialog 0; [""NATOAmmo""] execVM ""NatoDialog.sqf"";");
	BTN_R3(-1,"CAS Support", "Cost: 10 points", "closeDialog 0; [""NATOCAS""] execVM ""NatoDialog.sqf"";");
	BTN_R4(-1,"Bomb Run", "Cost: 10 points", "closeDialog 0; createDialog ""carpet_bombing"";");
	BTN_R5(-1,"Weaken OPFOR", "Cost: 100 points", "closeDialog 0; [""NATORED""] execVM ""NatoDialog.sqf"";");

	//BTN_M(BTN_Y_5, -1, "NATO QRF", "Cost: 10 points", "closeDialog 0; [""NATOQRF""] execVM ""NatoDialog.sqf"";");   removed to make it even left and right



	};
};

class garrison_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Garrison Menu");
	BTN_BACK("closeDialog 0; createDialog ""HQ_menu"";");

	BTN_L1(-1,"Recruit Garrison", "", "closeDialog 0; [""add""] spawn garrisonDialog");
	BTN_R1(-1,"Remove Garrison", "", "closeDialog 0; [""rem""] spawn garrisonDialog");

	};
};

class garrison_recruit
{
	idd=100;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_8);
	AS_FRAME_D(FRAME_H_8, "Garrison Recruitment Options");
	BTN_BACK("closeDialog 0; createDialog ""garrison_menu"";");

	BTN_L1(104, "Recruit Militiaman", "", "[guer_sol_RFL] call garrisonAdd");
	BTN_L2(105, "Recruit Autorifleman", "", "[guer_sol_AR] call garrisonAdd");
	BTN_L3(106, "Recruit Medic", "", "[guer_sol_MED] call garrisonAdd");
	BTN_L4(110, "Recruit Marksman", "", "[guer_sol_MRK] call garrisonAdd");

	BTN_R1(107, "Recruit Squad Leader", "", "[guer_sol_SL] call garrisonAdd");
	BTN_R2(109, "Recruit Grenadier", "", "[guer_sol_GL] call garrisonAdd");
	BTN_R3(108, "Recruit Mortar", "", "[guer_sol_UN] call garrisonAdd");
	BTN_R4(111, "Recruit AT", "", "[guer_sol_LAT] call garrisonAdd");

	};
};

class fps_limiter
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "FPS Limiter");
	BTN_BACK("closeDialog 0; createDialog ""game_options_commander"";");

	#define STR_FPS_PLUS "[[1],""AS_fnc_fpsChange""] call BIS_fnc_MP;"
	#define STR_FPS_MINUS "[[-1],""AS_fnc_fpsChange""] call BIS_fnc_MP;"

	BTN_L1(-1, "+1 FPS Limit", "", STR_FPS_PLUS);
	BTN_R1(-1, "-1 FPS Limit", "", STR_FPS_MINUS);

	};
};
class spawn_config
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Spawn Distance Config");
	BTN_BACK("closeDialog 0; createDialog ""game_options_commander"";");

	#define STR_DIST_PLUS "if (distanciaSPWN < 2500) then {distanciaSPWN = (distanciaSPWN + 100) min 2500; publicVariable ""distanciaSPWN""; hint format [""Spawn Distance Set to %1 meters. Be careful, this may affect game performance"",distanciaSPWN];};"
	#define STR_DIST_MINUS "if (distanciaSPWN > 1000) then {distanciaSPWN = (distanciaSPWN - 100) max 100; publicVariable ""distanciaSPWN""; hint format [""Spawn Distance Set to %1 meters. Be careful, this may affect game performance"",distanciaSPWN];};"

	BTN_L1(-1, "+100 Spawn Dist.", "", STR_DIST_PLUS);
	BTN_R1(-1, "-100 Spawn Dist.", "", STR_DIST_MINUS);

	};
};
class civ_config
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Civ Presence Config");
	BTN_BACK("closeDialog 0; createDialog ""game_options_commander"";");

	#define STR_CIV_PLUS "if (civPerc < 1) then {civPerc = (civPerc + 0.01) min 1; publicVariable ""civPerc""; hint format [""Civilian Percentage Set to %1 percent"",civPerc * 100];};"
	#define STR_CIV_MINUS "if (civPerc > 0) then {civPerc = (civPerc - 0.01) max 0; publicVariable ""civPerc""; hint format [""Civilian Percentage Set to %1 percent"",civPerc * 100];};"

	BTN_L1(-1, "+1% Civ Spawn.", "", STR_CIV_PLUS);
	BTN_R1(-1, "-1% Civ Spawn.", "", STR_CIV_MINUS);

	};
};

class squad_manager
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "HC Squad Options");
	BTN_BACK("closeDialog 0; createDialog ""radio_comm_commander"";");

	BTN_L1(-1, "Squad Add Vehicle", "", "closeDialog 0; [] execVM ""REINF\addSquadVeh.sqf"";");
	BTN_L2(-1, "Squad Vehicle Stats", "", "[""stats""] execVM ""REINF\vehStats.sqf"";");

	BTN_R1(-1, "Mount / Dismount", "", "[""mount""] execVM ""REINF\vehStats.sqf""");
	BTN_R2(-1, "Static Autotarget", "", "closeDialog 0; [] execVM ""AI\staticAutoT.sqf"";");

	};
};
class veh_query
{
	idd=100;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Add Vehicle to Squad?");
	BTN_BACK("closeDialog 0; vehQuery = nil; [] execVM ""Dialogs\squad_recruit.sqf"";");

	BTN_L1(104, "YES", "", "closeDialog 0; vehQuery = true");
	BTN_R1(105, "NO", "", "closeDialog 0; vehQuery = nil");

	};
};
class player_money
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Player and Money Interaction");
	BTN_BACK("closeDialog 0; if (player == Slowhand) then {createDialog ""radio_comm_commander""} else {createDialog ""radio_comm_player""};");

	BTN_L1(-1, "Add Server Member", "", "if (isMultiplayer) then {closeDialog 0; [""add""] call memberAdd;} else {hint ""This function is MP only""};");
	BTN_L2(-1, "Remove Server Member", "", "if (isMultiplayer) then {closeDialog 0; [""remove""] call memberAdd;} else {hint ""This function is MP only""};");

	BTN_R1(-1, "Donate 100 € to player", "", "[true] call donateMoney;");
	BTN_R2(-1, "Donate 100 € to FIA", "", "[] call donateMoney;");

	};
};
class members_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Enable Server Membership?");

	BTN_L1(-1, "YES", "", "membersPool = []; {membersPool pushBack (getPlayerUID _x)} forEach playableUnits; publicVariable ""membersPool""; hint ""Server Membership Enabled.\n\nAll the present players have been added to the Member's List.\n\nNon-members cannot use the HQ Ammobox and cannot be commanders, even with Switch Commander enabled.\n\nIf you load a session with this feature disabled, it will change to disabled.\n\nUse this option for Open Server Environments"";");
	BTN_R1(-1, "NO", "", "membersPool = []; publicVariable ""membersPool""; hint ""Server Membership Disabled.\n\nAnyone can use the HQ Ammobox and become Commander (if Switch Commander is enabled).\n\nIf you load a session with this feature enabled, it will become enabled.\n\nUse this option for Private Server environments."";");

	BTN_M(BTN_Y_2, -1, "Done", "", "if (!isNil ""membersPool"") then {closedialog 0; [] execVM ""Dialogs\firstLoad.sqf"";} else {hint ""Select an option first""};");

	};
};
class vehicle_manager
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Vehicle Manager");
	BTN_BACK("closeDialog 0; if (player == Slowhand) then {createDialog ""radio_comm_commander""} else {createDialog ""radio_comm_player""};");

	BTN_L1(-1, "Garage\Sell Vehicle", "", "closeDialog 0; createDialog ""garage_sell"";");
	BTN_R1(-1, "Vehicles and Squads", "", "closeDialog 0; if (player == Slowhand) then {createDialog ""squad_manager""} else {hint ""Only Player Commander has access to this function""};");

	BTN_M(BTN_Y_2, -1, "Unlock Vehicle", "", "closeDialog 0; if !(isMultiplayer) then {hint ""It's unlocked already.""} else {if (player != Slowhand) then {[false] call AS_fnc_unlockVehicle} else {[true] call AS_fnc_unlockVehicle};};");

	};
};

class garage_sell
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Sell or Garage Vehicle");
	BTN_BACK("closeDialog 0; createDialog ""vehicle_manager"";");

	BTN_L1(-1, "Garage Vehicle", "", "closeDialog 0; if (player != Slowhand) then {[false] call AS_fnc_garageVehicle} else {if (isMultiplayer) then {createDialog ""garage_check""} else {[true] call AS_fnc_garageVehicle}};");
	BTN_R1(-1, "Sell Vehicle", "", "closeDialog 0; if (player == Slowhand) then {[] call AS_fnc_sellVehicle} else {hint ""Only the Commander can sell vehicles""};");

	};
};
class garage_check
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Personal or FIA Garage?");
	BTN_BACK("closeDialog 0; createDialog ""garage_sell"";");

	BTN_L1(-1, "Personal Garage", "", "closeDialog 0; [false] call AS_fnc_garageVehicle;");
	BTN_R1(-1, "FIA Garage", "", "closeDialog 0; [true] call AS_fnc_garageVehicle;");

	};
};
class vehicle_option
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Buy Vehicle");
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, "Civilian Vehicle", "", "closeDialog 0; nul=[] execVM ""Dialogs\buy_vehicle_civ.sqf"";");
	BTN_R1(-1, "Military Vehicle", "", "closeDialog 0; nul=[] execVM ""Dialogs\buy_vehicle.sqf"";");

	};
};
class civ_vehicle
{
	idd=100;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Buy Civilian Vehicle");
	BTN_BACK("closeDialog 0; createDialog ""vehicle_option"";");

	BTN_L1(104, "Offroad", "", "closeDialog 0; [vfs select 0] call addFIAveh;");
	BTN_R1(105, "Truck", "", "closeDialog 0; [vfs select 1] call addFIAveh;");

	BTN_M(BTN_Y_2, 106, "Helicopter", "", "closeDialog 0; [vfs select 2] call addFIAveh;");

	};
};
class carpet_bombing
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Carpet Bombing Strike");
	BTN_BACK("closeDialog 0; createDialog ""NATO_Options"";");

	BTN_L1(-1, "HE Bombs", "Cost: 10 points", "closeDialog 0; [""HE""] execVM ""REINF\NATObomb.sqf"";");
	BTN_R1(-1, "Carpet Bombing", "Cost: 10 points", "closeDialog 0; [""CARPET""] execVM ""REINF\NATObomb.sqf"";");

	BTN_M(BTN_Y_2, -1, "NAPALM Bomb", "Cost: 10 points", "closeDialog 0; [""NAPALM""] execVM ""REINF\NATObomb.sqf"";");

	};
};

class AI_management
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "AI Management");
	BTN_BACK("closeDialog 0; if (player == Slowhand) then {createDialog ""radio_comm_commander""} else {createDialog ""radio_comm_player""};");

	BTN_L1(-1, "Temp. AI Control", "", "closeDialog 0; if ((count groupselectedUnits player > 0) and (count hcSelected player > 0)) exitWith {hint ""You must select from HC or Squad Bars, not both""}; if (count groupselectedUnits player == 1) then {[groupselectedUnits player] execVM ""REINF\controlunit.sqf""}; if (count hcSelected player == 1) then {[hcSelected player] execVM ""REINF\controlHCsquad.sqf"";};");
	BTN_L2(-1, "Auto Heal", "", "if (autoHeal) then {autoHeal = false; hint ""Auto Healing disabled"";} else {autoHeal = true; hint ""Auto Heal enabled""; [] execVM ""AI\autoHealFnc.sqf""}");

	BTN_R1(-1, "Auto Rearm", "", "closeDialog 0; if (count groupselectedUnits player == 0) then {(units group player) execVM ""AI\rearmCall.sqf""} else {(groupselectedUnits player) execVM ""AI\rearmCall.sqf""};");
	BTN_R2(-1, "Dismiss Units/Squads", "", "closeDialog 0; if (count groupselectedUnits player > 0) then {[groupselectedUnits player] execVM ""REINF\dismissPlayerGroup.sqf""} else {if (count (hcSelected player) > 0) then {[hcSelected player] execVM ""REINF\dismissSquad.sqf""}}; if ((count groupselectedUnits player == 0) and (count hcSelected player == 0)) then {hint ""No units or squads selected""}");

	};
};

class rounds_number
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_8);
	AS_FRAME_D(FRAME_H_8, "Select No. Rounds to be fired");
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, "1", "", "closeDialog 0; rondas = 1;");
	BTN_L2(-1, "2", "", "closeDialog 0; rondas = 2;");
	BTN_L3(-1, "3", "", "closeDialog 0; rondas = 3;");
	BTN_L4(-1, "4", "", "closeDialog 0; rondas = 4;");

	BTN_R1(-1, "5", "", "closeDialog 0; rondas = 5;");
	BTN_R2(-1, "6", "", "closeDialog 0; rondas = 6;");
	BTN_R3(-1, "7", "", "closeDialog 0; rondas = 7;");
	BTN_R4(-1, "8", "", "closeDialog 0; rondas = 8;");

	};
};

class strike_type
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Select type of strike");
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, "Single Point Strike", "", "closeDialog 0; tipoArty = ""NORMAL"";");
	BTN_R1(-1, "Barrage Strike", "", "closeDialog 0; tipoArty = ""BARRAGE"";");

	};
};

class mbt_type
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Select type ammo for the strike");
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, "HE", "", "closeDialog 0; tipoMuni = bluArtyAmmoHE;");
	BTN_R1(-1, "Laser Guided", "", "closeDialog 0; tipoMuni = bluArtyAmmoLaser;");

	BTN_M(BTN_Y_2, -1, "Smoke", "", "closeDialog 0; tipoMuni = bluArtyAmmoSmoke;");

	};
};
class mortar_type
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Select Mortar Ammo");
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, "HE", "", "closeDialog 0; if (activeAFRF) then {tipoMuni = ""rhs_mag_3vo18_10""} else {tipoMuni = ""8Rnd_82mm_Mo_shells""};");
	BTN_R1(-1, "Smoke", "", "closeDialog 0; if (activeAFRF) then {tipoMuni = ""rhs_mag_3vs25m_10""} else {tipoMuni = ""8Rnd_82mm_Mo_Smoke_white""};");

	};
};

class minebuild_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Build Minefield");
	BTN_BACK("closeDialog 0; createDialog ""build_menu"";");

	BTN_L1(-1, "APERS Mines", "", "closeDialog 0; [""APERSMine""] spawn mineDialog");
	BTN_R1(-1, "AT Mines", "", "closeDialog 0; [""ATMine""] spawn mineDialog");

	};
};

class fasttravel_dialog // 340
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Fast Travel");
	BTN_BACK("closeDialog 0; if (player == Slowhand) then {createDialog ""radio_comm_commander""} else {createDialog ""radio_comm_player""};");

	BTN_L1(-1, "Fast Travel (old)", "Targets: all FIA-controlled zones", "closeDialog 0; [] execVM ""fastTravelRadio.sqf"";");
	BTN_R1(-1, "Fast Travel (new)", "Only FIA camps and HQ", "closeDialog 0; [] spawn AS_fnc_fastTravel;");

	};
};

class camp_dialog // 350
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Camp Management");
	BTN_BACK("closeDialog 0; createDialog ""build_menu"";");

	BTN_L1(-1, "Establish Camp", "Price: 800 Euros", "closeDialog 0; [""create""] spawn ftravelDialog");
	BTN_R1(-1, "Delete Camp", "", "closeDialog 0; [""delete""] spawn ftravelDialog");

	BTN_M(BTN_Y_2, -1, "Rename Camp", "", "closeDialog 0; [""rename""] spawn ftravelDialog");

	};
};

class boost_menu // 390
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Is the start too hard for you?");

	#define STR_BST_YES "closeDialog 0; if (player == Slowhand) then {[[], ""boost.sqf""] remoteExec [""execVM"", 2];};if ((player == Slowhand) and (isNil ""placementDone"")) then {[] spawn placementselection};"
	#define STR_BST_NO "closeDialog 0; [false] remoteExec [""AS_fnc_MAINT_arsenal"", 2]; if (activeBE) then {[] call fnc_BE_refresh}; if ((player == Slowhand) and (isNil ""placementDone"")) then {[] spawn placementselection};"

	BTN_L1(-1, "YES", "You'll get some resources, and basic gear will be unlocked", STR_BST_YES);
	BTN_R1(-1, "NO", "Pea shooters, iron sights and plain clothes it is", STR_BST_NO);
	};
};

class misCiv_menu // 400
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Available Missions");
	BTN_BACK(A_CLOSE);

	#define STR_CIV_ASS "closeDialog 0; if (((getPlayerUID player) in membersPool) || (player == Slowhand)) then {[[""ASS""],""misReqCiv""] call BIS_fnc_MP} else {hint ""Stranger does not trust you.""};"
	#define STR_CIV_CVY "closeDialog 0; if (((getPlayerUID player) in membersPool) || (player == Slowhand)) then {[[""CONVOY""],""misReqCiv""] call BIS_fnc_MP} else {hint ""Stranger does not trust you.""};"
	#define STR_CIV_CON "closeDialog 0; if (((getPlayerUID player) in membersPool) || (player == Slowhand)) then {[[""CON""],""misReqCiv""] call BIS_fnc_MP} else {hint ""Stranger does not trust you.""};"

	BTN_L1(-1, "Assassination Mission", "", STR_CIV_ASS);
	BTN_R1(-1, "Convoy Ambush", "", STR_CIV_CVY);

	BTN_M(BTN_Y_2, -1, "Conquest Missions", "", STR_CIV_CON);

	};
};

class misMil_menu // 410
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Available Missions");
	BTN_BACK(A_CLOSE);

	#define STR_MIL_ASS "closeDialog 0; if (((getPlayerUID player) in membersPool) || (player == Slowhand)) then {[[""AS""],""misReqMil""] call BIS_fnc_MP} else {hint ""Nomad does not trust you.""};"
	#define STR_MIL_CVY "closeDialog 0; if (((getPlayerUID player) in membersPool) || (player == Slowhand)) then {[[""CONVOY""],""misReqMil""] call BIS_fnc_MP} else {hint ""Nomad does not trust you.""};"
	#define STR_MIL_CON "closeDialog 0; if (((getPlayerUID player) in membersPool) || (player == Slowhand)) then {[[""CON""],""misReqMil""] call BIS_fnc_MP} else {hint ""Nomad does not trust you.""};"
	#define STR_MIL_DES "closeDialog 0; if (((getPlayerUID player) in membersPool) || (player == Slowhand)) then {[[""DES""],""misReqMil""] call BIS_fnc_MP} else {hint ""Nomad does not trust you.""};"

	BTN_L1(-1, "Assassination Mission", "", STR_MIL_ASS);
	BTN_L2(-1, "Convoy Ambush", "", STR_MIL_CVY);

	BTN_R1(-1, "Conquest Missions", "", STR_MIL_CON);
	BTN_R2(-1, "Destroy Missions", "", STR_MIL_DES);

	};
};

class rCamp_Dialog // 420
{
    idd = 1;
    movingEnable = 1;
    enableSimulation = 1;
    enableDisplay = 1;
    onLoad = "uiNamespace setVariable ['rCamp', _this select 0];";
    duration = 25;
    fadein = 0;
    fadeout = 0;

    class controlsBackground {
        class RscPicture_1200: RscPicture
        {
            idc = 1200;
            text = "";
            x = 0.425 * safezoneW + safezoneX;
            y = 0.46 * safezoneH + safezoneY;
            w = 0.15 * safezoneW;
            h = 0.08 * safezoneH;
        };
    };

    class controls
    {
        class RscEdit_1400: RscEdit
        {
            idc = 1400;
            x = 0.435 * safezoneW + safezoneX;
            y = 0.47 * safezoneH + safezoneY;
            w = 0.13 * safezoneW;
            h = 0.03 * safezoneH;
            text = "";
            colorText[] =   {0,0,0,1};
            sizeEx = 0.05;
        };
        class SaveButton: RscButton
        {
            idc = 1600;
            text = "Save";
            x = 0.52 * safezoneW + safezoneX;
            y = 0.51 * safezoneH + safezoneY;
            w = 0.04 * safezoneW;
            h = 0.02 * safezoneH;
            action = "closeDialog 0; cName = ctrlText ((uiNamespace getVariable ""rCamp"") displayCtrl 1400);";
        };
    };
};

class exp_menu // 430
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, "Buy Ordnance");
	BTN_BACK(A_CLOSE);

	#define STR_EXP_SCH "closeDialog 0; if (player == Slowhand) then {[expCrate, ""expLight"", 300] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_MCH "closeDialog 0; if (player == Slowhand) then {[expCrate, ""expLight"", 800] remoteExec [""buyGear"", 2];}"

	#define STR_EXP_SWP "closeDialog 0; createDialog ""wpns_small"";"
	#define STR_EXP_MWP "closeDialog 0; createDialog ""wpns_large"";"

	#define STR_EXP_SMS "closeDialog 0; if (player == Slowhand) then {[expCrate, ""expHeavy"", 300] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_MMS "closeDialog 0; if (player == Slowhand) then {[expCrate, ""expHeavy"", 800] remoteExec [""buyGear"", 2];}"

	#define STR_EXP_SAC "closeDialog 0; if (player == Slowhand) then {[expCrate, ""aCache"", 500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_MAC "closeDialog 0; if (player == Slowhand) then {[expCrate, ""aCache"", 5000] remoteExec [""buyGear"", 2];}"


	BTN_L1(-1, "Some Charges", "Spend 300 Euros on a small bag of explosives.", STR_EXP_SCH);
	BTN_L2(-1, "Many Charges", "Spend 800 Euros on a large bag of explosives.", STR_EXP_MCH);
	BTN_L3(-1, "Some Weapons", "Spend 1000 Euros on a small cache of weapons.", STR_EXP_SWP);
	BTN_L4(-1, "Many Weapons", "Spend 2500 Euros on a large cache of weapons.", STR_EXP_MWP);

	BTN_R1(-1, "Some Mines", "Spend 300 Euros on a small bag of mines.", STR_EXP_SMS);
	BTN_R2(-1, "Many Mines", "Spend 800 Euros on a large bag of mines.", "");
	BTN_R3(-1, "Some Accessories", "Spend 500 Euros on a small cache of weapon accessories.", STR_EXP_SAC);
	BTN_R4(-1, "Many Accessories", "Spend 5000 Euros on a large cache of weapon accessories.", STR_EXP_MAC);

	BTN_M(BTN_Y_5, -1, "Some Ammo", "Currently not available", A_CLOSE);

	};
};

class wpns_small
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, "Weapon Options");
	BTN_BACK("closeDialog 0; createDialog ""exp_menu"";");

	#define STR_EXP_ASS_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""ASRifles"", 1000] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_PIS_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Pistols"", 1000] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_MGS_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Machineguns"", 1000] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_SNP_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Sniper Rifles"", 1000] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_LCH_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Launchers"", 1000] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_RND_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Random"", 1000] remoteExec [""buyGear"", 2];}"

	BTN_L1(-1, "Assault Rifles", "", STR_EXP_ASS_S);
	BTN_L2(-1, "Machineguns", "", STR_EXP_MGS_S);
	BTN_L3(-1, "Launchers", "", STR_EXP_LCH_S);

	BTN_R1(-1, "Pistols", "", STR_EXP_PIS_S);
	BTN_R2(-1, "Sniper Rifles", "", STR_EXP_SNP_S);
	BTN_R3(-1, "Random", "", STR_EXP_RND_S);

	};
};

class wpns_large
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, "Weapon Options");
	BTN_BACK("closeDialog 0; createDialog ""exp_menu"";");

	#define STR_EXP_ASS_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""ASRifles"", 2500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_PIS_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Pistols"", 2500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_MGS_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Machineguns"", 2500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_SNP_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Sniper Rifles"", 2500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_LCH_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Launchers"", 2500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_RND_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Random"", 2500] remoteExec [""buyGear"", 2];}"

	BTN_L1(-1, "Assault Rifles", "", STR_EXP_ASS_L);
	BTN_L2(-1, "Machineguns", "", STR_EXP_MGS_L);
	BTN_L3(-1, "Launchers", "", STR_EXP_LCH_L);

	BTN_R1(-1, "Pistols", "", STR_EXP_PIS_L);
	BTN_R2(-1, "Sniper Rifles", "", STR_EXP_SNP_L);
	BTN_R3(-1, "Random", "", STR_EXP_RND_L);

	};
};


class HQ_fort_dialog // 440
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, "HQ Fortifications");
	BTN_BACK("closeDialog 0; createDialog ""radio_comm_commander"";");

	#define STR_HQ_CMO "closeDialog 0; [""net""] remoteExec [""HQ_adds"",2];"
	#define STR_HQ_LAN "closeDialog 0; [""lantern""] remoteExec [""HQ_adds"",2];"
	#define STR_HQ_SND "closeDialog 0; [""sandbag""] remoteExec [""HQ_adds"",2];"
	#define STR_HQ_PAD "closeDialog 0; [""pad""] remoteExec [""HQ_adds"",2];"
	#define STR_HQ_DEL "closeDialog 0; [""delete""] remoteExec [""HQ_adds"",2];"

	BTN_L1(-1, "Camo Net", "", STR_HQ_CMO);
	BTN_L2(-1, "Lantern", "", STR_HQ_LAN);

	BTN_R1(-1, "Sandbag", "", STR_HQ_SND);
	BTN_R2(-1, "Vehicle Spawn Pad", "Create/Delete the vehicle spawn pad. Deploy at intended position.", STR_HQ_PAD);

	BTN_M(BTN_Y_3, -1, "Delete All", "", STR_HQ_DEL);
	};
};

class game_options_commander
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, "Game Options");
	BTN_BACK(A_CLOSE);

	#define STR_GO_GAR "closeDialog 0; [[], ""garbageCleaner.sqf""] remoteExec [""execVM"", 2];"
	#define STR_GO_PSS "closeDialog 0; [] remoteExec [""AS_fnc_saveGame"",2];"

	BTN_L1(-1, "Civ Config", "", "closeDialog 0; createDialog ""civ_config"";");
	BTN_L2(-1, "Spawn Dist. Config", "", "closeDialog 0; createDialog ""spawn_config"";");
	BTN_L3(-1, "FPS Limiter", "", "closeDialog 0; createDialog ""fps_limiter"";");

	BTN_R1(-1, "Garbage Clean", "", STR_GO_GAR);
	BTN_R2(-1, "Persistent Save", "", STR_GO_PSS);
	BTN_R3(-1, "Music ON/OFF", "", "closedialog 0; if (musicON) then {musicON = false; hint ""Music turned OFF"";} else {musicON = true; execVM ""musica.sqf""; hint ""Music turned ON""};");
	};
};

class game_options_player
{
	idd=-1;
	movingenable=false;

	class controls
	{
	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, "Game Options");
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, "Music ON/OFF", "", "closedialog 0; if (musicON) then {musicON = false; hint ""Music turned OFF"";} else {musicON = true; execVM ""musica.sqf""; hint ""Music turned ON""};");
	BTN_R1(-1, "Ingame Member's List", "", "if (isMultiplayer) then {[] execVM ""OrgPlayers\membersList.sqf""} else {hint ""This function is MP only""};");
	};
};

class HQ_reset_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "Do you want to reset HQ?");
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, "Yes", "", "closeDialog 0; [true] spawn buildHQ");
	BTN_R1(-1, "No", "", A_CLOSE);

	};
};

class maintenance_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, "Maintenance Menu");
	BTN_BACK("closeDialog 0; createDialog ""com_menu"";");

	// #define STR_MAINT_ARS "closeDialog 0; [] remoteExec [""AS_fnc_MAINT_arsenal"", 2];" Stef, removed, it caused double arsenal
	#define STR_GO_GAR ""
	#define STR_MAINT_PAN "closeDialog 0; [] remoteExec [""AS_fnc_togglePetrosAnim"", 2];"
	#define STR_MAINT_PET "closeDialog 0; [true] remoteExec [""fn_togglePetrosAnim"", 2]; [] remoteExec [""AS_fnc_MAINT_resetPetros"", 2];"
	#define STR_MAINT_MOV "closeDialog 0; [] remoteExec ['AS_fnc_addMoveObjAction',Slowhand];"
	#define STR_MAINT_AXP "if (activeBE) then {activeBE = true} else {activeBE = false}; hint format [""Current setting: %1"", [""off"", ""on""] select activeBE];"

	BTN_L1(-1, "Garbage Cleaner", "Delete corpses, destroyed vehicles, on ground items, might freeze", STR_GO_GAR);
	BTN_L2(-1, "Toggle Petros' animations", "Turn the idle animation of Petros on/off.", STR_MAINT_PAN);
	BTN_L3(-1, "Toggle Army XP System", "Turn the extended Army XP system on/off, including all restrictions.", STR_MAINT_AXP);

	BTN_R1(-1, "Reset HQ", "If you managed to lose one of your HQ items, this will reset all of them near Petros.", "closeDialog 0; createDialog ""HQ_reset_menu"";");
	BTN_R2(-1, "Reset Petros' position", "Terminate Petros' animation, move him next to the campfire at HQ.", STR_MAINT_PET);
	BTN_R3(-1, "Move statics/HQ items", "Reset your ability to move statics and HQ assets.", STR_MAINT_MOV);
	};
};

class com_options
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, "Options Menu");
	BTN_BACK("closeDialog 0; createDialog ""com_menu"";");

	#define STR_COM_OPT_FT "if (server getVariable ""enableFTold"") then {server setVariable [""enableFTold"",false,true]; [[petros,""hint"",""Fast Travel limited to camps and HQ""],""commsMP""] call BIS_fnc_MP;} else {server setVariable [""enableFTold"",true,true]; [[petros,""hint"",""Extended Fast Travel system enabled""],""commsMP""] call BIS_fnc_MP;};"
	#define STR_COM_OPT_INC "if (server getVariable ""easyMode"") then {server setVariable [""easyMode"",false,true]; [[petros,""hint"",""Easy Mode disabled.""],""commsMP""] call BIS_fnc_MP;} else {server setVariable [""easyMode"",true,true]; [[petros,""hint"",""FIA income permanently increased.""],""commsMP""] call BIS_fnc_MP;};"
	#define STR_COM_OPT_ARS "if (server getVariable ""enableMemAcc"") then {server setVariable [""enableMemAcc"",false,true]; [[petros,""hint"",""Arsenal access set to default.""],""commsMP""] call BIS_fnc_MP;} else {server setVariable [""enableMemAcc"",true,true]; [[petros,""hint"",""Members now get to keep their gear.""],""commsMP""] call BIS_fnc_MP;};"
	#define STR_COM_OPT_AXP "if (activeBE) then {activeBE = false} else {activeBE = true}; publicVariable ""activeBE""; hint format [""Current setting: %1"", [""off"", ""on""] select activeBE];"
	#define STR_COM_OPT_WPP "if (server getVariable [""enableWpnProf"",false]) then {server setVariable [""enableWpnProf"",false,true]; [] remoteExec [""AS_fnc_resetSkills"", [0,-2] select isDedicated,true]} else {server setVariable [""enableWpnProf"",true,true]}; hint format [""Current setting: %1"", [""on"", ""off""] select (server getVariable [""enableWpnProf"",false])];"

	BTN_L1(-1, "FT On/Off", "Toggle the old Fast Travel system on/off", STR_COM_OPT_FT);
	BTN_L2(-1, "Toggle Increased Income", "", STR_COM_OPT_INC);

	BTN_R1(-1, "Arsenal Access On/Off", "Simplified: members are exempt from gear-removal upon accessing the arsenal.", STR_COM_OPT_ARS);
	BTN_R2(-1, "Toggle Army XP System", "Turn the extended Army XP system on/off, including all restrictions.", STR_COM_OPT_AXP);

	BTN_M(BTN_Y_3, -1, "Weapon Proficiencies", "Turn the extended weapon proficiencies system on/off (MP exclusive)", STR_COM_OPT_WPP);
	};
};


class tfar_menu
{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, "TFAR Menu");
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, "Save Radio Settings", "Save TFAR radio settings.", "closeDialog 0; [player] spawn AS_fnc_saveTFARsettings");

	BTN_R1(-1, "Load Radio Settings", "Load previously saved TFAR radio settings.", "closeDialog 0; [player] spawn AS_fnc_loadTFARsettings");
	};
};

class RscTitles {

	class Default {
       idd = -1;
       fadein = 0;
       fadeout = 0;
       duration = 0;
	};
    class H8erHUD {
        idd = 745;
        movingEnable =  0;
        enableSimulation = 1;
        enableDisplay = 1;
        duration     =  10e10;
        fadein       =  0;
        fadeout      =  0;
        name = "H8erHUD";
		onLoad = "with uiNameSpace do { H8erHUD = _this select 0 }";
		class controls {
		    class structuredText {
                access = 0;
                type = 13;
                idc = 1001;
                style = 0x00;
                lineSpacing = 1;
				x = 0.103165 * safezoneW + safezoneX;
				y = 0.007996 * safezoneH + safezoneY;//0.757996
				w = 0.778208 * safezoneW;
				h = 0.0660106 * safezoneH;
                size = 0.055;//0.020
                colorBackground[] = {0,0,0,0};
                colorText[] = {0.34,0.33,0.33,0};//{1,1,1,1}
                text = "";
                font = "PuristaSemiBold";
				class Attributes {
					font = "PuristaSemiBold";
					color = "#C1C0BB";//"#FFFFFF";
					align = "CENTER";
					valign = "top";
					shadow = true;
					shadowColor = "#000000";
					underline = false;
					size = "4";//4
				};
            };
		};
	};
};


class ROLECHANGE {
	idd=-1;
	movingenable=false;
    class controls {

	//////////////////////STEF ROLECHANGE DIALOG /////////////////////////
	class ROLECHANGE_BOX: BOX
	{
		idc = 101;
		text = ""; //--- ToDo: Localize;
		x = 0.244979 * safezoneW + safezoneX;
		y = 0.223941 * safezoneH + safezoneY;
		w = 0.445038 * safezoneW;
		h = 0.492103 * safezoneH;
	};
	class HQ_frame: RscFrame
	{
		idc = 102;
		text = "Role Change"; //--- ToDo: Localize;
		x = 0.254979 * safezoneW + safezoneX;
		y = 0.233941 * safezoneH + safezoneY;
		w = 0.425038 * safezoneW;
		h = 0.462103 * safezoneH;
	};
	class HQ_button_back: RscButton
	{
		idc = 103;
		text = "Back"; //--- ToDo: Localize;
		x = 0.61 * safezoneW + safezoneX;
		y = 0.251941 * safezoneH + safezoneY;
		w = 0.06 * safezoneW;//0.175015
		h = 0.05 * safezoneH;
		action = "closeDialog 0";
	};
	class ROLECHANGE_SOLDIER: RscButton
	{
		idc = 104;
		text = "Officer"; //--- ToDo: Localize;
		x = 0.272481 * safezoneW + safezoneX;
		y = 0.317959 * safezoneH + safezoneY;
		w = 0.175015 * safezoneW;
		h = 0.0560125 * safezoneH;
		action = "[""officer""] call as_fnc_changerolestef; closeDialog 0;";
	};

	class ROLECHANGE_AUTORIFLEMAN: RscButton
	{
		idc = 105;
		text = "Autorifleman"; //--- ToDo: Localize;
		x = 0.272481 * safezoneW + safezoneX;
		y = 0.415981 * safezoneH + safezoneY;
		w = 0.175015 * safezoneW;
		h = 0.0560125 * safezoneH;
		action = "[""autorifleman""] call as_fnc_changerolestef; closeDialog 0;";
	};
	class ROLECHANGE_MEDIC: RscButton
	{
		idc = 126;
		text = "Medic"; //--- ToDo: Localize;
		x = 0.272481 * safezoneW + safezoneX;
		y = 0.514003 * safezoneH + safezoneY;
		w = 0.175015 * safezoneW;
		h = 0.0560125 * safezoneH;
		action = "[""medic""] call as_fnc_changerolestef; closeDialog 0;";
	};
	class ROLECHANGE_ENGINEER: RscButton
	{
		idc = 107;
		text = "Engineer"; //--- ToDo: Localize;
		x = 0.482498 * safezoneW + safezoneX;
		y = 0.317959 * safezoneH + safezoneY;
		w = 0.175015 * safezoneW;
		h = 0.0560125 * safezoneH;
		action = "[""engineer""] call as_fnc_changerolestef; closeDialog 0;";
	};
	class ROLECHANGE_AMMOBEARER: RscButton
	{
		idc = 108;
		text = "Ammobearer"; //--- ToDo: Localize;
		x = 0.482498 * safezoneW + safezoneX;
		y = 0.514003 * safezoneH + safezoneY;
		w = 0.175015 * safezoneW;
		h = 0.0560125 * safezoneH;
		action = "[""ammobearer""] call as_fnc_changerolestef; closeDialog 0;";
	};
	class ROLECHANGE_MARKSMAN: RscButton
	{
		idc = 109;
		text = "Marksman"; //--- ToDo: Localize;
		x = 0.482498 * safezoneW + safezoneX;
		y = 0.415981 * safezoneH + safezoneY;
		w = 0.175015 * safezoneW;
		h = 0.0560125 * safezoneH;
		action = "[""marksman""] call as_fnc_changerolestef; closeDialog 0;";
	};
	/////////////////////STEF ROLECHANGE DIALOG /////////////
}};

#include "UI\menu.hpp"