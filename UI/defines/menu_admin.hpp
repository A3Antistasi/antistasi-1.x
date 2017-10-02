#define ADMIN_ADDMEMBER "['add'] call memberAdd;"
#define ADMIN_REMMEMBER "['remove'] call memberAdd;"
#define ADMIN_TGLWPN "if (server getVariable ['enableWpnProf',false]) then {server setVariable ['enableWpnProf',false,true]; \
[] remoteExec ['AS_fnc_resetSkills', [0,-2] select isDedicated,true]; (_this select 0) ctrlSetTextColor [1,0,0,1];} \
else {server setVariable ['enableWpnProf',true,true]; (_this select 0) ctrlSetTextColor [0.18,0.545,0.341,1];}" \

#define ADMIN_TGLAXP "if (activeBE) then {activeBE = true} else {activeBE = false};"
#define ADMIN_FORCE1ST "[] remoteExec ['AS_fnc_toggle1PSEH', [0,-2] select isDedicated]; (_this select 0) ctrlSetTextColor ([[1,0,0,1], [0.18,0.545,0.341,1]] select (isNil 'AS_1PS_EH'))"

#define ADMIN_TGLFT "server setVariable ['enableFTold', [true, false] select (server getVariable ['enableFTold', false])]; \
	(_this select 0) ctrlSetTextColor ([[1,0,0,1], [0.18,0.545,0.341,1]] select (server getVariable ['enableFTold', false]))" \

#define ADMIN_TGLARS "server setVariable ['enableMemAcc', [true, false] select (server getVariable ['enableMemAcc', false])]; \
	(_this select 0) ctrlSetTextColor ([[1,0,0,1], [0.18,0.545,0.341,1]] select (server getVariable ['enableMemAcc', false]))" \

#define ADMIN_GEARRESET "[true] remoteExec ['AS_fnc_MAINT_arsenal', 2];"
#define ADMIN_TGLTM "server setVariable ['testMode', [true, false] select (server getVariable ['testMode', false]), true]; \
	(_this select 0) ctrlSetTextColor ([[1,0,0,1], [0.18,0.545,0.341,1]] select (server getVariable ['testMode', false]))" \

#define ADMIN_TEXTS_L ["STR_UI_ADMIN_ADDMEM_TEXT", "STR_UI_ADMIN_REMMEM_TEXT", "STR_UI_ADMIN_TGLWPN_TEXT", "STR_UI_ADMIN_TGLAXP_TEXT", "STR_UI_ADMIN_FORCE1ST_TEXT"]
#define ADMIN_TEXTS_R ["STR_UI_ADMIN_TGLFT_TEXT", "STR_UI_ADMIN_TGLARS_TEXT", "STR_UI_ADMIN_GEARRES_TEXT", "STR_UI_ADMIN_TGLTM_TEXT"]

#define ADMIN_TTS_L ["STR_UI_ADMIN_ADDMEM_TT", "STR_UI_ADMIN_REMMEM_TT", "STR_UI_ADMIN_TGLWPN_TT", "STR_UI_ADMIN_TGLAXP_TT", "STR_UI_ADMIN_FORCE1ST_TT"]
#define ADMIN_TTS_R ["STR_UI_ADMIN_TGLFT_TT", "STR_UI_ADMIN_TGLARS_TT", "STR_UI_ADMIN_GEARRES_TT", "STR_UI_ADMIN_TGLTM_TT"]

