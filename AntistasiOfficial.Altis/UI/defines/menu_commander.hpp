// NAV COMMANDER
#define NAVCOM_ACT_NATO "['com_nato', (_this select 0)] spawn AS_fnc_UI_createMenu"
#define NAVCOM_ACT_SQUAD_REC "['com_squad_rec', (_this select 0)] spawn AS_fnc_UI_createMenu"
#define NAVCOM_ACT_SQUAD_MGMT "['com_squad_mgmt', (_this select 0)] spawn AS_fnc_UI_createMenu"
#define NAVCOM_ACT_BUILD "['com_build', (_this select 0)] spawn AS_fnc_UI_createMenu"
#define NAVCOM_ACT_INFO "['com_info', (_this select 0)] spawn AS_fnc_UI_createMenu"
#define NAVCOM_ACT_MAINT "['com_maint', (_this select 0)] spawn AS_fnc_UI_createMenu"

#define NAVCOM_TEXTS ["STR_UI_NAVCOM_NATO_TEXT", "STR_UI_NAVCOM_SQR_TEXT", "STR_UI_NAVCOM_SQM_TEXT", "STR_UI_NAVCOM_BUILD_TEXT", "STR_UI_NAVCOM_INFO_TEXT", "STR_UI_NAVCOM_MAINT_TEXT"]
#define NAVCOM_TTS ["STR_UI_NAVCOM_NATO_TT", "STR_UI_NAVCOM_SQR_TT", "STR_UI_NAVCOM_SQM_TT", "STR_UI_NAVCOM_BUILD_TT", "STR_UI_NAVCOM_INFO_TT", "STR_UI_NAVCOM_MAINT_TT"]

// NATO
#define NATO_ATT "closeDialog 0; ['NATOCA'] execVM 'NatoDialog.sqf';"
#define NATO_ARM "closeDialog 0; ['NATOArmor'] execVM 'NatoDialog.sqf';"
#define NATO_ART "closeDialog 0; ['NATOArty'] execVM 'NatoDialog.sqf';"
#define NATO_RB "closeDialog 0; ['NATORoadblock'] execVM 'NatoDialog.sqf';"

#define NATO_UAV "closeDialog 0; ['NATOUAV'] execVM 'NatoDialog.sqf';"
#define NATO_AMMO "closeDialog 0; ['NATOAmmo'] execVM 'NatoDialog.sqf';"
#define NATO_CAS "closeDialog 0; ['NATOCAS'] execVM 'NatoDialog.sqf';"
#define NATO_BOMB "closeDialog 0; createDialog 'carpet_bombing';"

#define NATO_QRF "closeDialog 0; ['NATOQRF'] execVM 'NatoDialog.sqf';"
#define NATO_RED "closeDialog 0; ['NATORED'] execVM 'NatoDialog.sqf';"  //Stef 30-08

#define NATO_TEXTS_L ["STR_UI_ALLY_CA_TEXT", "STR_UI_ALLY_ARM_TEXT", "STR_UI_ALLY_ART_TEXT", "STR_UI_ALLY_RB_TEXT", "STR_UI_ALLY_QRF_TEXT"]
#define NATO_TEXTS_R ["STR_UI_ALLY_UAV_TEXT", "STR_UI_ALLY_AMMO_TEXT", "STR_UI_ALLY_CAS_TEXT", "STR_UI_ALLY_BOMB_TEXT", "STR_UI_ALLY_RED_TEXT"]
//#define NATO_TEXTS_M   moved to make it even

#define NATO_TTS_L ["STR_UI_ALLY_CA_TT", "STR_UI_ALLY_ARM_TT", "STR_UI_ALLY_ART_TT", "STR_UI_ALLY_RB_TT", "STR_UI_ALLY_QRF_TT"]
#define NATO_TTS_R ["STR_UI_ALLY_UAV_TT", "STR_UI_ALLY_AMMO_TT", "STR_UI_ALLY_CAS_TT", "STR_UI_ALLY_BOMB_TT", "STR_UI_ALLY_RED_TT"]
//#define NATO_TTS_M "STR_UI_ALLY_QRF_TT" moved to make it even

// SQUAD RECRUITMENT
#define SR_INFSQUAD "[guer_grp_squad] spawn addFIAsquadHC"
#define SR_INFTEAM "[guer_grp_team] spawn addFIAsquadHC"
#define SR_ATSQUAD "[guer_grp_AT] spawn addFIAsquadHC"
#define SR_AATRUCK "[guer_stat_AA] spawn addFIAsquadHC"

#define SR_SNPRTEAM "[guer_grp_sniper] spawn addFIAsquadHC"
#define SR_ATTRUCK "[guer_stat_AT] spawn addFIAsquadHC"
#define SR_SENTRY "[guer_grp_sentry] spawn addFIAsquadHC"
#define SR_MORTAR "[guer_stat_mortar] spawn addFIAsquadHC"

#define SR_ENG "['delete'] spawn mineDialog;"

#define SR_TEXTS_L ["STR_UI_SR_INFSQU_TEXT", "STR_UI_SR_INFTEAM_TEXT", "STR_UI_SR_ATSQ_TEXT", "STR_UI_SR_AATR_TEXT"]
#define SR_TEXTS_R ["STR_UI_SR_SNPR_TEXT", "STR_UI_SR_ATTR_TEXT", "STR_UI_SR_SENTRY_TEXT", "STR_UI_SR_MORTAR_TEXT"]
#define SR_TEXTS_M "STR_UI_SR_ENG_TEXT"

#define SR_TTS_L ["STR_UI_SR_INFSQU_TT", "STR_UI_SR_INFTEAM_TT", "STR_UI_SR_ATSQ_TT", "STR_UI_SR_AATR_TT"]
#define SR_TTS_R ["STR_UI_SR_SNPR_TT", "STR_UI_SR_ATTR_TT", "STR_UI_SR_SENTRY_TT", "STR_UI_SR_MORTAR_TT"]
#define SR_TTS_M "STR_UI_SR_ENG_TT"

// SQUAD MANAGEMENT
#define SM_ADDVEH "[] execVM 'REINF\addSquadVeh.sqf';"
#define SM_VEHSTATS "['stats'] execVM 'REINF\vehStats.sqf';"
#define SM_MOUNT "['mount'] execVM 'REINF\vehStats.sqf';"
#define SM_AUTOT "[] execVM 'AI\staticAutoT.sqf';"

#define SM_TEXTS ["STR_UI_SM_ADDVEH_TEXT", "STR_UI_SM_VEHSTATS_TEXT", "STR_UI_SM_MOUNT_TEXT", "STR_UI_SM_AUTOT_TEXT"]
#define SM_TTS ["STR_UI_SM_ADDVEH_TT", "STR_UI_SM_VEHSTATS_TT", "STR_UI_SM_MOUNT_TT", "STR_UI_SM_AUTOT_TT"]

// EMPLACEMENT MENU
#define EMP_BLDRB "closeDialog 0; ['create'] spawn puestoDialog;"
#define EMP_DELRB "closeDialog 0; ['delete'] spawn puestoDialog;"
#define EMP_MNAPERS "['APERSMine'] spawn mineDialog;"
#define EMP_MNAT "['ATMine'] spawn mineDialog;"

#define EMP_CMPEST "closeDialog 0; ['create'] spawn ftravelDialog;"
#define EMP_CMPDEL "closeDialog 0; ['delete'] spawn ftravelDialog;"
#define EMP_CMPREN "closeDialog 0; ['rename'] spawn ftravelDialog;"

#define EMP_HQFORT "closeDialog 0; createDialog 'HQ_fort_dialog';"

#define EMP_TEXTS_L ["STR_UI_EMP_BLDRB_TEXT", "STR_UI_EMP_DELRB_TEXT", "STR_UI_EMP_MNAP_TEXT", "STR_UI_EMP_MNAT_TEXT"]
#define EMP_TEXTS_R ["STR_UI_EMP_CMPEST_TEXT", "STR_UI_EMP_CMPDEL_TEXT", "STR_UI_EMP_CMPREN_TEXT", "STR_UI_EMP_HQFORT_TEXT"]

#define EMP_TTS_L ["STR_UI_EMP_BLDRB_TT", "STR_UI_EMP_DELRB_TT", "STR_UI_EMP_MNAP_TT", "STR_UI_EMP_MNAT_TT"]
#define EMP_TTS_R ["STR_UI_EMP_CMPEST_TT", "STR_UI_EMP_CMPDEL_TT", "STR_UI_EMP_CMPREN_TT", "STR_UI_EMP_HQFORT_TT"]

// INFO MENU
#define INFO_FIA "['status'] remoteExecCall ['AS_fnc_infoScreen', 2];"

#define INFO_MRESTR "if(server getVariable [""jna_mrestricted"",false]) then {server setvariable [""jna_mrestricted"",flase,true]; jna_minItemMember = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];  (_this select 0) ctrlSetTextColor [0.18,0.545,0.341,1];systemchat 'Arsenal items are free for all'} \
	else {server setvariable [""jna_mrestricted"",true,true]; jna_minItemMember = [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,500,20,20,20,10,500]; (_this select 0) ctrlSetTextColor [1,0,0,1]; systemchat 'Arsenal items below a threshold are restricted to non members'};"


#define INFO_ACEMEDIC "if (ace_medical_level == 2) then { 							\
		{(jna_dataList select 24) pushbackunique _x} foreach aceadvmedical;			\
	} else { 																		\
		{																			\
			jna_datalist set [24,  (jna_dataList select 24) - _x] 					\
		} foreach [aceadvmedical];													\
	};closeDialog 0;"


#define INFO_AXP_RES "['restrictions'] remoteExecCall ['fnc_BE_broadcast', 2];"
#define INFO_AXP_PRO "['progress'] remoteExecCall ['fnc_BE_broadcast', 2];"

#define INFO_TEXTS ["STR_UI_INFO_AXPREST_TEXT", "STR_UI_INFO_MRESTR_TEXT", "STR_UI_INFO_ACEMEDIC_TEXT"]
#define INFO_TTS ["STR_UI_INFO_AXPREST_TT", "STR_UI_INFO_MRESTR_TT", "STR_UI_INFO_ACEMEDIC_TT"]
/* original ones, i changed them because there 9are no working restrictions
#define INFO_TEXTS ["STR_UI_INFO_FIA_TEXT", "STR_UI_INFO_AXPREST_TEXT", "STR_UI_INFO_AXPPRO_TEXT"]
#define INFO_TTS ["STR_UI_INFO_FIA_TT", "STR_UI_INFO_AXPREST_TT", "STR_UI_INFO_AXPPRO_TT"] */

// MAINT MENU
#define STR_GO_GAR "[] execVM 'garbageCleaner.sqf';"
#define MAINT_PET "[true] remoteExec ['AS_fn_togglePetrosAnim', 2]; [] remoteExec ['fnc_MAINT_resetPetros', 2];"
#define MAINT_MOV "[] remoteExec ['AS_fnc_addMoveObjAction',Slowhand];"
#define MAINT_RES "createDialog 'HQ_reset_menu';"

#define MAINT_TEXTS ["STR_UI_MAINT_GAR_TEXT", "STR_UI_MAINT_PET_TEXT", "STR_UI_MAINT_MOV_TEXT", "STR_UI_MAINT_RES_TEXT"]
#define MAINT_TTS ["STR_UI_MAINT_GAR_TT", "STR_UI_MAINT_PET_TT", "STR_UI_MAINT_MOV_TT", "STR_UI_MAINT_RES_TT"]
