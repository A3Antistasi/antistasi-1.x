//Game start
class init_menu 		{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_ENA_SW_CM);

	BTN_L1(-1,$STR_D_YES, "", "switchCom = true; publicVariable ""switchCom""; hint localize ""STR_DH_SCEGWASCPTTHRP"";");
	BTN_R1(-1,$STR_D_NO, "", "switchCom = false; publicVariable ""switchCom""; hint localize ""STR_DH_SCDGWOACPUCD"";");

	BTN_M(BTN_Y_2, -1, $STR_D_DONE, "", "if (!isNil ""switchCom"") then {closedialog 0; [] execVM ""Dialogs\membersMenu.sqf"";} else {hint localize ""STR_DH_SAOF""};");
	};
};
class first_load 		{
	idd=-1;
	movingenable=false;

	class controls {

		AS_BOX_D(BOX_H_2);
		AS_FRAME_D(FRAME_H_2, $STR_D_LOAD_PS);

		#define STR_LOAD_YES "closeDialog 0; if ((player == Slowhand) and (isNil ""placementDone"")) then {[] remoteExec [""AS_fnc_loadGame"",2];placementDone = true; publicVariable 'placementDone';};"

		BTN_L1(-1,$STR_D_YES, "", STR_LOAD_YES);
		BTN_R1(-1,$STR_D_NO, "", A_CLOSE);

	};
};
class members_menu 		{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_EN_SM);

	BTN_L1(-1, $STR_D_YES, "", "membersPool = []; {membersPool pushBack (getPlayerUID _x)} forEach playableUnits; publicVariable ""membersPool""; hint localize ""STR_DH_SMEATPP"";");
	BTN_R1(-1, $STR_D_NO, "", "membersPool = []; publicVariable ""membersPool""; hint localize ""STR_DH_EMDACUT"";");

	BTN_M(BTN_Y_2, -1, $STR_D_DONE, "", "if (!isNil ""membersPool"") then {closedialog 0; [] execVM ""Dialogs\firstLoad.sqf"";} else {hint localize ""STR_DH_SAOF""};");

	};
};
class boost_menu 		{ // 390
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_ITSTHFY);

	#define STR_BST_YES "closeDialog 0; if (player == Slowhand) then {[[], ""boost.sqf""] remoteExec [""execVM"", 2];};if ((player == Slowhand) and (isNil ""placementDone"")) then {[] spawn placementselection};"
	#define STR_BST_NO "closeDialog 0; [false] remoteExec [""AS_fnc_MAINT_arsenal"", 2]; if (activeBE) then {[] call fnc_BE_refresh}; if ((player == Slowhand) and (isNil ""placementDone"")) then {[] spawn placementselection};"

	BTN_L1(-1, $STR_D_YES, $STR_D_YGSRNBGWBU, STR_BST_YES);
	BTN_R1(-1, $STR_D_NO, $STR_D_PSISNPCII, STR_BST_NO);
	};
};

//HQ Flag
class HQ_menu 			{
	idd=100;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_8);
	AS_FRAME_D(FRAME_H_8, $STR_D_FIA_HQOCO);
	BTN_BACK(A_CLOSE);

	#define STR_HQ_FIA "if (activeBE) then {[] remoteExec [""fnc_BE_buyUpgrade"", 2]} else {closeDialog 0; [] call FIAskillAdd;}"

	BTN_L1(-1, $STR_D_GRAB_FP, "", "if (isMultiPlayer) then {nul=call stavrosSteal} else {hint localize ""STR_DH_TFIMPO""};");
	BTN_L2(-1, $STR_D_MANGE_GAR, "", "closeDialog 0; nul=CreateDialog ""garrison_menu"";");
	BTN_L3(-1, $STR_D_MOVE_HQ_TAZ, "", "closeDialog 0; [] spawn moveHQ;");

	BTN_R1(-1, $STR_D_INGAME_ML, "", "if (isMultiplayer) then {[] execVM ""OrgPlayers\membersList.sqf""} else {hint localize ""STR_DH_TFIMPO""};");
	BTN_R2(109, $STR_D_TRAIN_FIA, "", STR_HQ_FIA);
	BTN_R3(-1, $STR_D_BEBUILD_ASSE, "Cost: 5.000 €", "closeDialog 0; [] execVM ""rebuildAssets.sqf"";");
	};
};
class garrison_menu 		{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_GAR_MENU);
	BTN_BACK("closeDialog 0; createDialog ""HQ_menu"";");

	BTN_L1(-1,$STR_D_RECR_GAR, "", "closeDialog 0; [""add""] spawn garrisonDialog");
	BTN_R1(-1,$STR_D_REMO_GAR, "", "closeDialog 0; [""rem""] spawn garrisonDialog");
	};
};
class garrison_recruit 			{
	idd=100;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_8);
	AS_FRAME_D(FRAME_H_8, $STR_D_GAR_REC_OP);
	BTN_BACK("closeDialog 0; createDialog ""garrison_menu"";");

	BTN_L1(104, $STR_D_REC_MILI, "", "[guer_sol_RFL] call garrisonAdd");
	BTN_L2(105, $STR_D_REC_AUTORIL, "", "[guer_sol_AR] call garrisonAdd");
	BTN_L3(106, $STR_D_REC_MED, "", "[guer_sol_MED] call garrisonAdd");
	BTN_L4(110, $STR_D_REC_MARKMAN, "", "[guer_sol_MRK] call garrisonAdd");

	BTN_R1(107, $STR_D_REC_SQLEAD, "", "[guer_sol_SL] call garrisonAdd");
	BTN_R2(109, $STR_D_REC_GRENA, "", "[guer_sol_GL] call garrisonAdd");
	BTN_R3(108, $STR_D_REC_MORTAR, "", "[guer_sol_UN] call garrisonAdd");
	BTN_R4(111, $STR_D_REC_AT, "", "[guer_sol_LAT] call garrisonAdd");

	};
};
class unit_recruit		{
	idd= 100;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, $STR_D_RECRU_OPT);
	BTN_BACK(A_CLOSE);

	BTN_L1(104, $STR_D_RECRU_MIL, "", "[guer_sol_RFL] spawn reinfPlayer");
	BTN_L2(105, $STR_D_RECRU_AURI, "", "[guer_sol_AR] spawn reinfPlayer");
	BTN_L3(106, $STR_D_RECRU_MEDIC, "", "[guer_sol_MED] spawn reinfPlayer");
	BTN_L4(110, $STR_D_RECRU_MARSKMAN, "", "[guer_sol_MRK] spawn reinfPlayer");

	BTN_R1(107, $STR_D_RECRU_ENGI, "", "[guer_sol_ENG] spawn reinfPlayer");
	BTN_R2(109, $STR_D_RECRU_GREN, "", "[guer_sol_GL] spawn reinfPlayer");
	BTN_R3(108, $STR_D_RECRU_BOOM_S, "", "[guer_sol_EXP] spawn reinfPlayer");
	BTN_R4(111, $STR_D_RECRU_AT, "", "[guer_sol_LAT] spawn reinfPlayer");

	BTN_M(BTN_Y_5, 112, $STR_D_RECRU_AA, "", "[""Soldier_AA""] spawn reinfPlayer");

	};
};

//HQ Arsenal
class ROLECHANGE {
	idd=-1;
	movingenable=false;
    class controls {
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
			text = $STR_D_ROLE_CHANGE; //--- ToDo: Localize;
			x = 0.254979 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.425038 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class HQ_button_back: RscButton
		{
			idc = 103;
			text = $STR_D_BACK; //--- ToDo: Localize;
			x = 0.61 * safezoneW + safezoneX;
			y = 0.251941 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;//0.175015
			h = 0.05 * safezoneH;
			action = "closeDialog 0";
		};
		class ROLECHANGE_SOLDIER: RscButton
		{
			idc = 104;
			text = $STR_D_OFFICER; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "[""officer""] call as_fnc_changerolestef; closeDialog 0;";
		};

		class ROLECHANGE_AUTORIFLEMAN: RscButton
		{
			idc = 105;
			text = $STR_D_AUTORIFLEMAN; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "[""autorifleman""] call as_fnc_changerolestef; closeDialog 0;";
		};
		class ROLECHANGE_MEDIC: RscButton
		{
			idc = 126;
			text = $STR_D_MEDIC; //--- ToDo: Localize;
			x = 0.272481 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "[""medic""] call as_fnc_changerolestef; closeDialog 0;";
		};
		class ROLECHANGE_ENGINEER: RscButton
		{
			idc = 107;
			text = $STR_D_ENGINEER; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.317959 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "[""engineer""] call as_fnc_changerolestef; closeDialog 0;";
		};
		class ROLECHANGE_AMMOBEARER: RscButton
		{
			idc = 108;
			text = $STR_D_AMMOBEARER; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.514003 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "[""ammobearer""] call as_fnc_changerolestef; closeDialog 0;";
		};
		class ROLECHANGE_MARKSMAN: RscButton
		{
			idc = 109;
			text = $STR_D_MARKSMAN; //--- ToDo: Localize;
			x = 0.482498 * safezoneW + safezoneX;
			y = 0.415981 * safezoneH + safezoneY;
			w = 0.175015 * safezoneW;
			h = 0.0560125 * safezoneH;
			action = "[""marksman""] call as_fnc_changerolestef; closeDialog 0;";
		};
	}
};

//HQ Vehiclebox
class vehicle_option 	{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_BUY_VH);
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, $STR_D_CIV_VH, "", "closeDialog 0; nul=[] execVM ""Dialogs\buy_vehicle_civ.sqf"";");
	BTN_R1(-1, $STR_D_MIL_VH, "", "closeDialog 0; nul=[] execVM ""Dialogs\buy_vehicle.sqf"";");

	};
};
class buy_vehicle			{
	idd=100;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, $STR_D_PUR_MIV);
	BTN_BACK("closeDialog 0; createDialog ""vehicle_option"";");

	BTN_L1(104, $STR_D_BUY_LVEH, "", "closedialog 0; [vfs select 3] call addFIAveh");
	BTN_L2(105, $STR_D_BUY_OR_UAZ, "", "closedialog 0; [vfs select 4] call addFIAveh");
	BTN_L3(106, $STR_D_BUY_TRUCK, "", "closedialog 0; [vfs select 5] call addFIAveh");
	BTN_L4(110, $STR_D_BUY_ST_AT, "", "closedialog 0; [vfs select 9] call addFIAveh");


	BTN_R1(107, $STR_D_BUY_ARM_OR, "", "closedialog 0; [vfs select 6] call addFIAveh");
	BTN_R2(109, $STR_D_BUY_MOR, "", "closedialog 0; [vfs select 8] call addFIAveh");
	BTN_R3(108, $STR_D_BUY_MG, "", "closedialog 0; [vfs select 7] call addFIAveh");
	BTN_R4(111, $STR_D_BUY_ST_AA, "", "closedialog 0; [vfs select 10] call addFIAveh");

	};
};

class civ_vehicle 			{
	idd=100;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_BUY_CIV_VH);
	BTN_BACK("closeDialog 0; createDialog ""vehicle_option"";");

	BTN_L1(104, $STR_D_OFFR, "", "closeDialog 0; [vfs select 0] call addFIAveh;");
	BTN_R1(105, $STR_D_BUY_TRUCK, "", "closeDialog 0; [vfs select 1] call addFIAveh;");
	BTN_L2(106, $STR_D_HELI, "", "closeDialog 0; [vfs select 2] call addFIAveh;");
	BTN_R2(107, $STR_D_BUY_QUA, "", "closedialog 0; [vfs select 11] call addFIAveh");

	};
};

//NATO base and airport
class buyNATO			{
	idd=100;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, $STR_D_PUR_MIV);
	BTN_BACK("closeDialog 0;");

	BTN_L1(104, $STR_D_BUY_TRUCK, "", "closedialog 0; [blubuyTruck] call addFIAveh");
	BTN_L2(105, $STR_D_BUY_MRAP, "", "closedialog 0; [blubuyMRAP] call addFIAveh");
	BTN_L3(106, $STR_D_BUY_APC, "", "closedialog 0; [blubuyAPC] call addFIAveh");
	BTN_L4(110, $STR_D_HELI, "", "closedialog 0; [blubuyHeli] call addFIAveh");

	/*  Static guns need special initialization i can't add them yet
	BTN_R1(107, $STR_D_BUY_ST_AT, "", "closedialog 0; bluStatAT call addFIAveh");
	BTN_R2(109, $STR_D_BUY_MOR, "", "closedialog 0; bluStatMortar call addFIAveh");
	BTN_R3(108, $STR_D_BUY_MG, "", "closedialog 0; bluStatHMG call addFIAveh");
	BTN_R4(111, $STR_D_BUY_ST_AA, "", "closedialog 0; bluStatAA call addFIAveh");
	*/
	};
};

//HQ Map
class game_options_commander	{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, $STR_D_GAME_OP);
	BTN_BACK(A_CLOSE);

	#define STR_GO_GAR "closeDialog 0; [[], ""garbageCleaner.sqf""] remoteExec [""execVM"", 2];"
	#define STR_GO_PSS "closeDialog 0; [] remoteExec [""AS_fnc_saveGame"",2];"

	BTN_L1(-1, $STR_D_CIVCON, "", "closeDialog 0; createDialog ""civ_config"";");
	BTN_L2(-1, $STR_D_SDC, "", "closeDialog 0; createDialog ""spawn_config"";");
	BTN_L3(-1, $STR_D_FPSL, "", "closeDialog 0; createDialog ""fps_limiter"";");

	BTN_R1(-1, $STR_D_GARB_CLEA, "", STR_GO_GAR);
	BTN_R2(-1, $STR_D_PERSAVE, "", STR_GO_PSS);
	BTN_R3(-1, $STR_D_MUS_ON_OFF, "", "closedialog 0; if (musicON) then {musicON = false; hint localize ""STR_DH_MTOF"";} else {musicON = true; execVM ""musica.sqf""; hint localize ""STR_DH_MTO""};");
	};
};
class fps_limiter 					{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_FPSLI);
	BTN_BACK("closeDialog 0; createDialog ""game_options_commander"";");

	#define STR_FPS_PLUS "[[1],""AS_fnc_fpsChange""] call BIS_fnc_MP;"
	#define STR_FPS_MINUS "[[-1],""AS_fnc_fpsChange""] call BIS_fnc_MP;"

	BTN_L1(-1, $STR_D_FPSLI1P, "", STR_FPS_PLUS);
	BTN_R1(-1, $STR_D_FPSLI1M, "", STR_FPS_MINUS);

	};
};
class spawn_config 					{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_SPAWND);
	BTN_BACK("closeDialog 0; createDialog ""game_options_commander"";");

	#define STR_DIST_PLUS "if (distanciaSPWN < 2500) then {distanciaSPWN = (distanciaSPWN + 100) min 2500; publicVariable ""distanciaSPWN""; hint format [localize ""STR_DH_SDSTMBCTMAGP"",distanciaSPWN];};"
	#define STR_DIST_MINUS "if (distanciaSPWN > 1000) then {distanciaSPWN = (distanciaSPWN - 100) max 100; publicVariable ""distanciaSPWN""; hint format [localize ""STR_DH_SDSTMBCTMAGP"",distanciaSPWN];};"

	BTN_L1(-1, $STR_D_SPAWND100P, "", STR_DIST_PLUS);
	BTN_R1(-1, $STR_D_SPAWND100M, "", STR_DIST_MINUS);

	};
};
class civ_config 					{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_CIV_PERCON);
	BTN_BACK("closeDialog 0; createDialog ""game_options_commander"";");

	#define STR_CIV_PLUS "if (civPerc < 1) then {civPerc = (civPerc + 0.01) min 1; publicVariable ""civPerc""; hint format [localize ""STR_DH_CPSTP"",civPerc * 100];};"
	#define STR_CIV_MINUS "if (civPerc > 0) then {civPerc = (civPerc - 0.01) max 0; publicVariable ""civPerc""; hint format [localize ""STR_DH_CPSTP"",civPerc * 100];};"

	BTN_L1(-1, $STR_D_CIV1PS, "", STR_CIV_PLUS);
	BTN_R1(-1, $STR_D_CIV1MS, "", STR_CIV_MINUS);

	};
};
class game_options_player		{
	idd=-1;
	movingenable=false;

	class controls
	{
	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_GAME_OP);
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, $STR_D_MUS_ON_OFF, "", "closedialog 0; if (musicON) then {musicON = false; hint localize ""STR_DH_MTOF"";} else {musicON = true; execVM ""musica.sqf""; hint localize ""STR_DH_MTO""};");
	BTN_R1(-1, $STR_D_INGAME_ML, "", "if (isMultiplayer) then {[] execVM ""OrgPlayers\membersList.sqf""} else {hint localize ""STR_DH_TFIMPO""};");
	};
};


//HQ Petros
class mission_menu {
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_8);
	AS_FRAME_D(FRAME_H_8, $STR_D_AV_MIS);
	BTN_BACK(A_CLOSE);

	#define STR_MIS_MIL "closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""FND_M""],""missionrequest""] call BIS_fnc_MP} else {hint localize ""STR_DH_OPCHATTF""};"
	#define STR_MIS_CIV "closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""FND_C""],""missionrequest""] call BIS_fnc_MP} else {hint localize ""STR_DH_OPCHATTF""};"
	#define STR_MIS_EXP "closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""FND_E""],""missionrequest""] call BIS_fnc_MP} else {hint localize ""STR_DH_OPCHATTF""};"
	#define STR_MIS_LOG	"closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""LOG""],""missionrequest""] call BIS_fnc_MP} else {hint localize ""STR_DH_OPCHATTF""};"
	#define STR_MIS_DES	"closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""DES""],""missionrequest""] call BIS_fnc_MP} else {hint localize ""STR_DH_OPCHATTF""};"
	#define STR_MIS_RES "closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""RES""],""missionrequest""] call BIS_fnc_MP} else {hint localize ""STR_DH_OPCHATTF""};"
	#define STR_MIS_PRO "closeDialog 0; if ((player == Slowhand) or (not(isPlayer Slowhand))) then {[[""PR"",false,true],""missionrequest""] call BIS_fnc_MP} else {hint localize ""STR_DH_OPCHATTF""};"

	BTN_L1(-1,$STR_D_MI_CON, "", STR_MIS_MIL);
	BTN_L2(-1,$STR_D_CI_CON, "", STR_MIS_CIV);
	BTN_L3(-1,$STR_D_SKE_IRI, "", STR_MIS_EXP);

	BTN_R1(-1,$STR_D_LOG_MI, "", STR_MIS_LOG);
	BTN_R2(-1,$STR_D_DES_MI, "", STR_MIS_DES);
	BTN_R3(-1,$STR_D_RES_MI, "", STR_MIS_RES);

	BTN_M(BTN_Y_4, -1, $STR_D_PROPA, "", STR_MIS_PRO);
	};
};
//Civilian and Military contact
class misCiv_menu 	{ // 400
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_AV_MIS);
	BTN_BACK(A_CLOSE);

	#define STR_CIV_ASS "closeDialog 0; [[""ASS""],""misReqCiv""] call BIS_fnc_MP;"
	#define STR_CIV_CVY "closeDialog 0; [[""CONVOY""],""misReqCiv""] call BIS_fnc_MP;"
	#define STR_CIV_CON "closeDialog 0; [[""CON""],""misReqCiv""] call BIS_fnc_MP;"

	BTN_L1(-1, $STR_D_ASSMI, "", STR_CIV_ASS);
	BTN_R1(-1, $STR_D_CONAM, "", STR_CIV_CVY);

	BTN_M(BTN_Y_2, -1, $STR_D_CONQMIS, "", STR_CIV_CON);

	};
};
class misMil_menu 	{ // 410
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_AV_MIS);
	BTN_BACK(A_CLOSE);

	#define STR_MIL_ASS "closeDialog 0; [[""AS""],""misReqMil""] call BIS_fnc_MP;"
	#define STR_MIL_CVY "closeDialog 0; [[""CONVOY""],""misReqMil""] call BIS_fnc_MP;"
	#define STR_MIL_CON "closeDialog 0; [[""CON""],""misReqMil""] call BIS_fnc_MP;"
	#define STR_MIL_DES "closeDialog 0; [[""DES""],""misReqMil""] call BIS_fnc_MP;"

	BTN_L1(-1, $STR_D_ASSMI, "", STR_MIL_ASS);
	BTN_L2(-1, $STR_D_CONAM, "", STR_MIL_CVY);

	BTN_R1(-1, $STR_D_CONQMIS, "", STR_MIL_CON);
	BTN_R2(-1, $STR_D_DES_MI, "", STR_MIL_DES);

	};
};

//Y menu - submenu
class veh_query 			{
	idd=100;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_ADD_VSSQ);
	BTN_BACK("closeDialog 0; vehQuery = nil; [] execVM ""Dialogs\squad_recruit.sqf"";");

	BTN_L1(104, $STR_D_YES, "", "closeDialog 0; vehQuery = true");
	BTN_R1(105, $STR_D_NO, "", "closeDialog 0; vehQuery = nil");

	};
};
class carpet_bombing 		{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_CA_BOOM_STR);
	BTN_BACK("closeDialog 0; createDialog ""NATO_Options"";");

	BTN_L1(-1, $STR_D_HE_BOMB, "Cost: 10 points", "closeDialog 0; [""HE""] execVM ""REINF\NATObomb.sqf"";");
	BTN_R1(-1, $STR_D_CA_BOOM, "Cost: 10 points", "closeDialog 0; [""CARPET""] execVM ""REINF\NATObomb.sqf"";");

	BTN_M(BTN_Y_2, -1, $STR_D_NAPALM_BOOM, "Cost: 10 points", "closeDialog 0; [""NAPALM""] execVM ""REINF\NATObomb.sqf"";");

	};
};
class rCamp_Dialog 			{ // 420
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
class HQ_fort_dialog { // 440
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, $STR_D_HQ_FORT);
	BTN_BACK("closeDialog 0;");

	#define STR_HQ_CMO "closeDialog 0; [""net""] remoteExec [""HQ_adds"",2];"
	#define STR_HQ_LAN "closeDialog 0; [""lantern""] remoteExec [""HQ_adds"",2];"
	#define STR_HQ_SND "closeDialog 0; [""sandbag""] remoteExec [""HQ_adds"",2];"
	#define STR_HQ_PAD "closeDialog 0; [""pad""] remoteExec [""HQ_adds"",2];"
	#define STR_HQ_DEL "closeDialog 0; [""delete""] remoteExec [""HQ_adds"",2];"

	BTN_L1(-1, $STR_D_CAMO_NET, "", STR_HQ_CMO);
	BTN_L2(-1, $STR_D_LANT, "", STR_HQ_LAN);

	BTN_R1(-1, $STR_D_SAN_BAG, "", STR_HQ_SND);
	BTN_R2(-1, $STR_D_VEH_SP, $STR_D_CDVSP_DATP, STR_HQ_PAD);

	BTN_M(BTN_Y_3, -1, $STR_D_DELA, "", STR_HQ_DEL);
	};
};
class HQ_reset_menu{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_DYWTRHQ);
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, $STR_D_YES, "", "closeDialog 0; [true] spawn buildHQ");
	BTN_R1(-1, $STR_D_NO, "", A_CLOSE);

	};
};

//Devin - Irishman purchase
class exp_menu { // 430
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, $STR_D_BUY_ORD);
	BTN_BACK(A_CLOSE);

	#define STR_EXP_SCH "closeDialog 0; if (player == Slowhand) then {[expCrate, ""expLight"", 300] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_MCH "closeDialog 0; if (player == Slowhand) then {[expCrate, ""expLight"", 800] remoteExec [""buyGear"", 2];}"

	#define STR_EXP_SWP "closeDialog 0; createDialog ""wpns_small"";"
	#define STR_EXP_MWP "closeDialog 0; createDialog ""wpns_large"";"

	#define STR_EXP_SMS "closeDialog 0; if (player == Slowhand) then {[expCrate, ""expHeavy"", 300] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_MMS "closeDialog 0; if (player == Slowhand) then {[expCrate, ""expHeavy"", 800] remoteExec [""buyGear"", 2];}"

	#define STR_EXP_SAC "closeDialog 0; if (player == Slowhand) then {[expCrate, ""aCache"", 500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_MAC "closeDialog 0; if (player == Slowhand) then {[expCrate, ""aCache"", 5000] remoteExec [""buyGear"", 2];}"


	BTN_L1(-1, $STR_D_SOME_CHAR, $STR_D_SP3EOSBE, STR_EXP_SCH);
	BTN_L2(-1, $STR_D_MANY_CHAR, $STR_D_SP8EOLBE, STR_EXP_MCH);
	BTN_L3(-1, $STR_D_SOME_WEA, $STR_D_SP10EOSCW, STR_EXP_SWP);
	BTN_L4(-1, $STR_D_MANY_WEA, $STR_D_SP25EOLCW, STR_EXP_MWP);

	BTN_R1(-1, $STR_D_SOME_MIN, $STR_D_SP3EOSBM, STR_EXP_SMS);
	BTN_R2(-1, $STR_D_MANY_MIN, $STR_D_SP8EOLBM, STR_EXP_MMS);
	BTN_R3(-1, $STR_D_SOME_ACC, $STR_D_SP5EOSCWA, STR_EXP_SAC);
	BTN_R4(-1, $STR_D_MANY_ACC, $STR_D_SP50EOLCWA, STR_EXP_MAC);

	BTN_M(BTN_Y_5, -1, $STR_D_SOME_AMMO, $STR_D_CNA, A_CLOSE);

	};
};
class wpns_small{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, $STR_D_WEAP_OP);
	BTN_BACK("closeDialog 0; createDialog ""exp_menu"";");

	#define STR_EXP_ASS_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""ASRifles"", 1000] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_PIS_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Pistols"", 1000] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_MGS_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Machineguns"", 1000] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_SNP_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Sniper Rifles"", 1000] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_LCH_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Launchers"", 1000] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_RND_S "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Random"", 1000] remoteExec [""buyGear"", 2];}"

	BTN_L1(-1, $STR_D_ASRILF, "", STR_EXP_ASS_S);
	BTN_L2(-1, $STR_D_MACHGUN, "", STR_EXP_MGS_S);
	BTN_L3(-1, $STR_D_LAUN, "", STR_EXP_LCH_S);

	BTN_R1(-1, $STR_D_PIST, "", STR_EXP_PIS_S);
	BTN_R2(-1, $STR_D_SNIPRILF, "", STR_EXP_SNP_S);
	BTN_R3(-1, $STR_D_RAND, "", STR_EXP_RND_S);

	};
};
class wpns_large{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, $STR_D_WEAP_OP);
	BTN_BACK("closeDialog 0; createDialog ""exp_menu"";");

	#define STR_EXP_ASS_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""ASRifles"", 2500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_PIS_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Pistols"", 2500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_MGS_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Machineguns"", 2500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_SNP_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Sniper Rifles"", 2500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_LCH_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Launchers"", 2500] remoteExec [""buyGear"", 2];}"
	#define STR_EXP_RND_L "closeDialog 0; if (player == Slowhand) then {[expCrate, ""Random"", 2500] remoteExec [""buyGear"", 2];}"

	BTN_L1(-1, $STR_D_ASRILF, "", STR_EXP_ASS_L);
	BTN_L2(-1, $STR_D_MACHGUN, "", STR_EXP_MGS_L);
	BTN_L3(-1, $STR_D_LAUN, "", STR_EXP_LCH_L);

	BTN_R1(-1, $STR_D_PIST, "", STR_EXP_PIS_L);
	BTN_R2(-1, $STR_D_SNIPRILF, "", STR_EXP_SNP_L);
	BTN_R3(-1, $STR_D_RAND, "", STR_EXP_RND_L);

	};
};

//Mortar and Artillery
class mortar_type{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_SEMA);
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, $STR_D_HE, "", "closeDialog 0; if (activeAFRF) then {tipoMuni = ""rhs_mag_3vo18_10""} else {tipoMuni = ""8Rnd_82mm_Mo_shells""};");
	BTN_R1(-1, $STR_D_SMOKE, "", "closeDialog 0; if (activeAFRF) then {tipoMuni = ""rhs_mag_3vs25m_10""} else {tipoMuni = ""8Rnd_82mm_Mo_Smoke_white""};");

	};
};
class rounds_number{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_8);
	AS_FRAME_D(FRAME_H_8, $STR_D_SN_RTBF);
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
class strike_type{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_STOS);
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, $STR_D_SINPS, "", "closeDialog 0; tipoArty = ""NORMAL"";");
	BTN_R1(-1, $STR_D_BARRS, "", "closeDialog 0; tipoArty = ""BARRAGE"";");

	};
};
class mbt_type {
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_STAFTS);
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, $STR_D_HE, "", "closeDialog 0; tipoMuni = bluArtyAmmoHE;");
	BTN_R1(-1, $STR_D_LAS_GUI, "", "closeDialog 0; tipoMuni = bluArtyAmmoLaser;");

	BTN_M(BTN_Y_2, -1, $STR_D_SMOKE, "", "closeDialog 0; tipoMuni = bluArtyAmmoSmoke;");

	};
};

//OLD Y Menu
/*
class player_money 		{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_PNMI);
	BTN_BACK("closeDialog 0; if (player == Slowhand) then {createDialog ""radio_comm_commander""} else {createDialog ""radio_comm_player""};");

	BTN_L1(-1, $STR_D_ADD_SM, "", "if (isMultiplayer) then {closeDialog 0; [""add""] call memberAdd;} else {hint localize ""STR_DH_TFIMPO""};");
	BTN_L2(-1, $STR_D_REM_SM, "", "if (isMultiplayer) then {closeDialog 0; [""remove""] call memberAdd;} else {hint localize ""STR_DH_TFIMPO""};");

	BTN_R1(-1, $STR_D_DONP, "", "[true] call donateMoney;");
	BTN_R2(-1, $STR_D_DONFI, "", "[] call donateMoney;");

	};
};
class AI_management {
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_AI_MENEG);
	BTN_BACK("closeDialog 0; if (player == Slowhand) then {createDialog ""radio_comm_commander""} else {createDialog ""radio_comm_player""};");

	BTN_L1(-1, $STR_D_TE_AI_CON, "", "closeDialog 0; if ((count groupselectedUnits player > 0) and (count hcSelected player > 0)) exitWith {hint localize ""STR_DH_YMSFHCOSBNB""}; if (count groupselectedUnits player == 1) then {[groupselectedUnits player] execVM ""REINF\controlunit.sqf""}; if (count hcSelected player == 1) then {[hcSelected player] execVM ""REINF\controlHCsquad.sqf"";};");
	BTN_L2(-1, $STR_D_AUTO_HEAL, "", "if (autoHeal) then {autoHeal = false; hint localize ""STR_DH_AHD"";} else {autoHeal = true; hint localize ""STR_DH_AHD""; [] execVM ""AI\autoHealFnc.sqf""}");

	BTN_R1(-1, $STR_D_AUTO_REARM, "", "closeDialog 0; if (count groupselectedUnits player == 0) then {(units group player) execVM ""AI\rearmCall.sqf""} else {(groupselectedUnits player) execVM ""AI\rearmCall.sqf""};");
	BTN_R2(-1, $STR_D_DIS_UNISQ, "closeDialog 0; if (count groupselectedUnits player > 0) then {[groupselectedUnits player] execVM ""REINF\dismissPlayerGroup.sqf""} else {if (count (hcSelected player) > 0) then {[hcSelected player] execVM ""REINF\dismissSquad.sqf""}}; if ((count groupselectedUnits player == 0) and (count hcSelected player == 0)) then {hint localize ""STR_DH_NUOSS""}");

	};
};
class squad_manager 	{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_HQ_SQ_OP);
	BTN_BACK("closeDialog 0; createDialog ""radio_comm_commander"";");

	BTN_L1(-1, $STR_D_SQ_ADDV, "", "closeDialog 0; [] execVM ""REINF\addSquadVeh.sqf"";");
	BTN_L2(-1, $STR_D_SQ_VS, "", "[""stats""] execVM ""REINF\vehStats.sqf"";");

	BTN_R1(-1, $STR_D_MO_DISMO, "", "[""mount""] execVM ""REINF\vehStats.sqf""");
	BTN_R2(-1, $STR_D_ST_AUT_TAR, "", "closeDialog 0; [] execVM ""AI\staticAutoT.sqf"";");

	};
};
class vehicle_manager 	{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_VHIL_MG);
	BTN_BACK("closeDialog 0; if (player == Slowhand) then {createDialog ""radio_comm_commander""} else {createDialog ""radio_comm_player""};");

	BTN_L1(-1, $STR_D_GAR_SEll_VEH, "", "closeDialog 0; createDialog ""garage_sell"";");
	BTN_R1(-1, $STR_D_VEH_AND_SQ, "", "closeDialog 0; if (player == Slowhand) then {createDialog ""squad_manager""} else {hint localize ""STR_DH_OPCHATTF""};");

	BTN_M(BTN_Y_2, -1, $STR_D_UN_VEH, "", "closeDialog 0; if !(isMultiplayer) then {hint localize ""STR_DH_IUA""} else {if (player != Slowhand) then {[false] call AS_fnc_unlockVehicle} else {[true] call AS_fnc_unlockVehicle};};");

	};
};
class build_menu 		{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, $STR_D_BUI_OP);
	BTN_BACK("closeDialog 0; if (player == Slowhand) then {createDialog ""radio_comm_commander""} else {createDialog ""radio_comm_player""};");

	BTN_L1(-1,$STR_D_OPS_RB, "", "closeDialog 0; [""create""] spawn puestoDialog");
	BTN_L2(-1,$STR_D_BUI_MF, "", "closeDialog 0; createDialog ""minebuild_menu"";");

	BTN_R1(-1,$STR_D_OPS_RB_DEL, "", "closeDialog 0; [""delete""] spawn puestoDialog");
	BTN_R2(-1,$STR_D_MANA_CAMP, $STR_D_EAC, "closeDialog 0; createDialog ""camp_dialog"";");

	BTN_M(BTN_Y_3, -1, $STR_D_HQ_FORT, "", "closeDialog 0; createDialog ""HQ_fort_dialog"";");
	};
};
class NATO_Options 		{
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, $STR_D_ASK_NI);
	BTN_BACK("closeDialog 0; createDialog ""radio_comm_commander"";");

	BTN_L1(-1,$STR_D_ATT_MI, $STR_D_COST20, "closeDialog 0; [""NATOCA""] execVM ""NatoDialog.sqf"";");
	BTN_L2(-1,$STR_D_ARM_CO, $STR_D_COST20, "closeDialog 0; [""NATOArmor""] execVM ""NatoDialog.sqf"";");
	BTN_L3(-1,$STR_D_ARTI, $STR_D_COST10, "closeDialog 0; [""NATOArty""] execVM ""NatoDialog.sqf"";");
	BTN_L4(-1,$STR_D_ROADB, $STR_D_COST10, "closeDialog 0; [""NATORoadblock""] execVM ""NatoDialog.sqf"";");
	BTN_L5(-1, $STR_D_NATO_QRF, $STR_D_COST10, "closeDialog 0; [""NATOQRF""] execVM ""NatoDialog.sqf"";");  //Stef 30-08

	BTN_R1(-1,$STR_D_NATO_UAV, $STR_D_COST10, "closeDialog 0; [""NATOUAV""] execVM ""NatoDialog.sqf"";");
	BTN_R2(-1,$STR_D_AMMD, $STR_D_COST5, "closeDialog 0; [""NATOAmmo""] execVM ""NatoDialog.sqf"";");
	BTN_R3(-1,$STR_D_CAS_SU, $STR_D_COST10, "closeDialog 0; [""NATOCAS""] execVM ""NatoDialog.sqf"";");
	BTN_R4(-1,$STR_D_BOMBR, $STR_D_COST10, "closeDialog 0; createDialog ""carpet_bombing"";");
	BTN_R5(-1,$STR_D_WE_OPFOR, $STR_D_COST100, "closeDialog 0; [""NATORED""] execVM ""NatoDialog.sqf"";");

	//BTN_M(BTN_Y_5, -1, "NATO QRF", "Cost: 10 points", "closeDialog 0; [""NATOQRF""] execVM ""NatoDialog.sqf"";");   removed to make it even left and right

	};
};

class squad_recruit 	{
	idd=100;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_10);
	AS_FRAME_D(FRAME_H_10, $STR_D_SQ_RECR_OP);
	BTN_BACK("closeDialog 0; createDialog ""radio_comm_commander"";");

	BTN_L1(104, $STR_D_RECRU_INF_SQ, "", "closeDialog 0; [guer_grp_squad] spawn addFIAsquadHC");
	BTN_L2(105, $STR_D_RECRU_INF_TE, "", "closeDialog 0; [guer_grp_team] spawn addFIAsquadHC");
	BTN_L3(106, $STR_D_RECRU_AT_SQ, "", "closeDialog 0; [guer_grp_AT] spawn addFIAsquadHC");
	BTN_L4(110, $STR_D_RECRU_AA_TR, "", "closeDialog 0; [guer_stat_AA] spawn addFIAsquadHC");

	BTN_R1(107, $STR_D_RECRU_SNI_TEAM, "", "closeDialog 0; [guer_grp_sniper] spawn addFIAsquadHC");
	BTN_R2(109, $STR_D_RECRU_AT_TR, "", "closeDialog 0; [guer_stat_AT] spawn addFIAsquadHC");
	BTN_R3(108, $STR_D_RECRU_SEN, "", "closeDialog 0; [guer_grp_sentry] spawn addFIAsquadHC");
	BTN_R4(111, $STR_D_RECRU_MOR_TEAM, "", "closeDialog 0; [guer_stat_mortar] spawn addFIAsquadHC");

	BTN_M(BTN_Y_5, 112, $STR_D_RECRU_ENGIN, "", "closeDialog 0; [""delete""] spawn mineDialog;");

	};
};

class minebuild_menu	{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_BUI_MINF);
	BTN_BACK("closeDialog 0; createDialog ""build_menu"";");

	BTN_L1(-1, $STR_D_APERS_MIN, "", "closeDialog 0; [""APERSMine""] spawn mineDialog");
	BTN_R1(-1, $STR_D_AT_MIN, "", "closeDialog 0; [""ATMine""] spawn mineDialog");

	};
};
class garage_sell {
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_SELL_GAR_VEH);
	BTN_BACK("closeDialog 0; createDialog ""vehicle_manager"";");

	BTN_L1(-1, $STR_D_GAR_VEH, "", "closeDialog 0; if (player != Slowhand) then {[false] call AS_fnc_garageVehicle} else {if (isMultiplayer) then {createDialog ""garage_check""} else {[true] call AS_fnc_garageVehicle}};");
	BTN_R1(-1, $STR_D_SELL_VEH, "", "closeDialog 0; if (player == Slowhand) then {[] call AS_fnc_sellVehicle} else {hint localize ""STR_DH_OTCCSV""};");
	};
};
class garage_check {
	idd=-1;
	movingenable=false;

	class controls {

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_PER_FIAG);
	BTN_BACK("closeDialog 0; createDialog ""garage_sell"";");

	BTN_L1(-1, $STR_D_PERG, "", "closeDialog 0; [false] call AS_fnc_garageVehicle;");
	BTN_R1(-1, $STR_D_FIAG, "", "closeDialog 0; [true] call AS_fnc_garageVehicle;");

	};
};
class fasttravel_dialog { // 340
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_FAST_TR);
	BTN_BACK("closeDialog 0; if (player == Slowhand) then {createDialog ""radio_comm_commander""} else {createDialog ""radio_comm_player""};");

	BTN_L1(-1, $STR_D_FAST_TRO, $STR_D_TAFIACZ, "closeDialog 0; [] execVM ""fastTravelRadio.sqf"";");
	BTN_R1(-1, $STR_D_FAST_TRN, $STR_D_OFIACNHQ, "closeDialog 0; [] spawn AS_fnc_fastTravel;");

	};
};
class camp_dialog { // 350
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_4);
	AS_FRAME_D(FRAME_H_4, $STR_D_CAMP_MG);
	BTN_BACK("closeDialog 0; createDialog ""build_menu"";");

	BTN_L1(-1, $STR_D_EST_CAMP, "Price: 800 Euros", "closeDialog 0; [""create""] spawn ftravelDialog");
	BTN_R1(-1, $STR_D_DEL_CAMP, "", "closeDialog 0; [""delete""] spawn ftravelDialog");

	BTN_M(BTN_Y_2, -1, $STR_D_REN_CAMP, "", "closeDialog 0; [""rename""] spawn ftravelDialog");

	};
};
class tfar_menu{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_2);
	AS_FRAME_D(FRAME_H_2, $STR_D_TFAR_MENU);
	BTN_BACK(A_CLOSE);

	BTN_L1(-1, $STR_D_SAVE_RS, $STR_D_STFARRS, "closeDialog 0; [player] spawn AS_fnc_saveTFARsettings");

	BTN_R1(-1, $STR_D_LOAD_RS, $STR_D_LPSTFARRS, "closeDialog 0; [player] spawn AS_fnc_loadTFARsettings");
	};
};
class maintenance_menu{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, $STR_D_MAIN_MENU);
	BTN_BACK("closeDialog 0; createDialog ""com_menu"";");

	// #define STR_MAINT_ARS "closeDialog 0; [] remoteExec [""AS_fnc_MAINT_arsenal"", 2];" Stef, removed, it caused double arsenal
	#define STR_GO_GAR ""
	#define STR_MAINT_PAN "closeDialog 0; [] remoteExec [""AS_fnc_togglePetrosAnim"", 2];"
	#define STR_MAINT_PET "closeDialog 0; [true] remoteExec [""fn_togglePetrosAnim"", 2]; [] remoteExec [""AS_fnc_MAINT_resetPetros"", 2];"
	#define STR_MAINT_MOV "closeDialog 0; [] remoteExec ['AS_fnc_addMoveObjAction',Slowhand];"
	#define STR_MAINT_AXP "if (activeBE) then {activeBE = true} else {activeBE = false}; hint format [""Current setting: %1"", [""off"", ""on""] select activeBE];"

	BTN_L1(-1, $STR_D_GARB_CLEA, $STR_D_DELC_DV_OGIMF, STR_GO_GAR);
	BTN_L2(-1, $STR_D_TOGPA, $STR_D_TTIAOP, STR_MAINT_PAN);
	BTN_L3(-1, $STR_D_TOG_ARM_XPS, $STR_D_TTEAXPS, STR_MAINT_AXP);

	BTN_R1(-1, $STR_D_RESHQ, $STR_D_IYMTLOOYHAI, "closeDialog 0; createDialog ""HQ_reset_menu"";");
	BTN_R2(-1, $STR_D_RESPP, $STR_D_TPAMHNTTCAHQ, STR_MAINT_PET);
	BTN_R3(-1, $STR_D_MSHQI, $STR_D_RYBTMSNHQA, STR_MAINT_MOV);
	};
};
class com_options{
	idd=-1;
	movingenable=false;

	class controls
	{

	AS_BOX_D(BOX_H_6);
	AS_FRAME_D(FRAME_H_6, $STR_D_OPMENU);
	BTN_BACK("closeDialog 0; createDialog ""com_menu"";");

	#define STR_COM_OPT_FT "if (server getVariable ""enableFTold"") then {server setVariable [""enableFTold"",false,true]; [[petros,""locHint"",""STR_DH_FTLTCNHQ""],""commsMP""] call BIS_fnc_MP;} else {server setVariable [""enableFTold"",true,true]; [[petros,""locHint"",""STR_DH_EFTSE""],""commsMP""] call BIS_fnc_MP;};"
	#define STR_COM_OPT_INC "if (server getVariable ""easyMode"") then {server setVariable [""easyMode"",false,true]; [[petros,""locHint"",""STR_DH_EMD.""],""commsMP""] call BIS_fnc_MP;} else {server setVariable [""easyMode"",true,true]; [[petros,""locHint"",""STR_DH_FIAIPI""],""commsMP""] call BIS_fnc_MP;};"
	#define STR_COM_OPT_ARS "if (server getVariable ""enableMemAcc"") then {server setVariable [""enableMemAcc"",false,true]; [[petros,""locHint"",""STR_DH_AASTD""],""commsMP""] call BIS_fnc_MP;} else {server setVariable [""enableMemAcc"",true,true]; [[petros,""locHint"",""STR_DH_MNGTKTG""],""commsMP""] call BIS_fnc_MP;};"
	#define STR_COM_OPT_AXP "if (activeBE) then {activeBE = false} else {activeBE = true}; publicVariable ""activeBE""; hint format [""Current setting: %1"", [""off"", ""on""] select activeBE];"
	#define STR_COM_OPT_WPP "if (server getVariable [""enableWpnProf"",false]) then {server setVariable [""enableWpnProf"",false,true]; [] remoteExec [""AS_fnc_resetSkills"", [0,-2] select isDedicated,true]} else {server setVariable [""enableWpnProf"",true,true]}; hint format [""Current setting: %1"", [""on"", ""off""] select (server getVariable [""enableWpnProf"",false])];"

	BTN_L1(-1, $STR_D_FTOOF, $STR_D_TTOFTSOOF, STR_COM_OPT_FT);
	BTN_L2(-1, $STR_D_TII, "", STR_COM_OPT_INC);

	BTN_R1(-1, $STR_D_ARSAOOF, $STR_D_SMAEFGRUATA, STR_COM_OPT_ARS);
	BTN_R2(-1, $STR_D_TAXPS, $STR_D_TTEAXPSOOF, STR_COM_OPT_AXP);

	BTN_M(BTN_Y_3, -1, $STR_D_WEAP_PROF, $STR_D_TTEWPSOOF, STR_COM_OPT_WPP);
	};
};
*/

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

#include "UI\menu.hpp"