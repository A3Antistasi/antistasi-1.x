waitUntil {!isNull player};

//Briefing - records order is reversed in game

player createDiaryRecord ["Diary",[localize "STR_BR_8CNT","
Author: Barbolani<br/>
Coding since 1.2: Chris supervised by RickyTan & Kendo<br/>
Coding since 1.7.6: Jeroen & Sparker<br/>
Coding since 1.7.16: IrLED<br/>
Tweaking, fixing and supervising github commits since 1.7.12: Stef<br/><br/>

Scripts:<br/>
UPSMon by Monsada, Kronzy and Cool=Azroul13 <br/>
Jeroen Arsenal System by Jeroen Not.<br/>
Jeroen Garage System by Jeroen Not.<br/>
Persistent Save by zooloo75.<br/>
Tags by Marker and Melbo.<br/>
Advanced Towing by duda<br/>
iniDIBI2 by code34<br/>
Vcom AI by Genesis92x<br/><br/>

Briefing by Stef, Dethleffs, Fireman, everyone of the Official Community who add suggestions and corrections
IrLED: headlessclient balanced unit assignment, Vcom AI integration.<br/>
AlexTriada, VelvetNight and BeZZuBik41: Russian translate and Multilingual platform<br/>
nuker: For testing and ideas.<br/>
Ghost: For MP DS testing and teaching me how to run a DS.<br/>
Nirvana and CWW clan for testing.<br/>
LanCommi on dedi server testing.<br/>
neuron: lots of testing and help in steam page.<br/>
Gillaustio and Farooq for inspirational works on revive system.<br/>
Valtas: support, testing bug reports and building the first serious open Dedi for Antistasi.<br/>
Goon and jw custom: part of the code for the NAPALM script.<br/>
Larrow: very valuable scripting help in BIS forums.<br/>
Billw: lots of help on testing and bug detection.<br/>
tommytom73: HC testing.<br/>
Manko: earplug snippet.<br/>
harmdhast: help on some scripting.<br/>
DeathTouchWilly: first Official Antistasi Manual.<br/>
daveallen10: ACE Integration scripts.<br/>
RickyTan: tons of help and testing in the Official Servers, Head of Antistasi Official Community since March 2016 ‘till June 2017 and making the community more financially aware.<br/>
Toshi: Antistasi porting on other islands.<br/>
Kendo and Tuck for templates.<br/>
And all those players who spend their time on making comments, suggestions and reports on Steam and Antistasi Official Community."]];

player createDiaryRecord ["Diary",[localize "STR_BR_6COMPMOD",localize "STR_BR_6CP"]];

player createDiaryRecord ["Diary",[localize "STR_BR_5ANTOPT",localize "STR_BR_5AO"]];

player createDiaryRecord ["Diary",[localize "STR_BR_4GAMED",localize "STR_BR_4GD"]];

player createDiaryRecord ["Diary",[localize "STR_BR_3SSANDP",localize "STR_BR_3SS"]];

player createDiaryRecord ["Diary",[localize "STR_BR_2SALORE",localize "STR_BR_2SLR"]];

player createDiaryRecord ["Diary",[localize "STR_BR_1WELCOME",localize "STR_BR_1W"]];

//Begin Tutorial
_index =player createDiarySubject ["bt",localize "STR_BR_BT0"];

player createDiaryRecord ["bt",[localize"STR_BR_BT0HQ",localize "STR_BR_BT_QH"]];

player createDiaryRecord ["bt",[localize "STR_BR_BT1TIB",localize "STR_BR_BT_TIB"]];

player createDiaryRecord ["bt",[localize "STR_BR_BT2YM",localize "STR_BR_BT_YM"]];

player createDiaryRecord ["bt",[localize "STR_BR_BT3WTD",localize "STR_BR_BT_WTD"]];

player createDiaryRecord ["bt",[localize "STR_BR_BT4JAS",localize "STR_BR_BT_JAS"]];

player createDiaryRecord ["bt",[localize "STR_BR_BT5TA",localize "STR_BR_BT_TA"]];

player createDiaryRecord ["bt",[localize "STR_BR_BT6HT",localize "STR_BR_BT_HT"]];

player createDiaryRecord ["bt",[localize "STR_BR_BT7MI",localize "STR_BR_BT_MI"]];
//Antistasi Features
_index =player createDiarySubject ["af",localize "STR_BR_AF0"];

player createDiaryRecord ["af",[localize "STR_BR_AF1CS",localize "STR_BR_AF_CS"]];

player createDiaryRecord ["af",[localize "STR_BR_AF2AIME",localize "STR_BR_AF_AIME"]];

player createDiaryRecord ["af",[localize "STR_BR_AF3AXPNL",localize "STR_BR_AF_AXPNL"]];

player createDiaryRecord ["af",[localize "STR_BR_AF7JAG",localize "STR_BR_AF_JAG"]];

player createDiaryRecord ["af",[localize "STR_BR_AF9JNSL",localize "STR_BR_AF_JNSL"]];

player createDiaryRecord ["af",[localize "STR_BR_AF4FT",localize "STR_BRAF_FT"]];

player createDiaryRecord ["af",[localize "STR_BR_AF8JNES",localize "STR_BR_AF_JNES"]];

player createDiaryRecord ["af",[localize "STR_BR_AF10FS",localize "STR_BR_AF_FS"]];

player createDiaryRecord ["af",[localize "STR_BR_AF5SM",localize "STR_BR_AF_SM"]];

player createDiaryRecord ["af",[localize "STR_BR_AF6U",localize "STR_BR_AF_U"]];

//Commander Options
_index =player createDiarySubject ["cm",localize "STR_BR_CM0"];

player createDiaryRecord ["cm",[localize "STR_BR_CM1MHQ",localize "STR_BR_CM_MHQ"]];

player createDiaryRecord ["cm",[localize "STR_BR_CM2FFS",localize "STR_BR_CM_FFS"]];

player createDiaryRecord ["cm",[localize "STR_BR_CM3R",localize "STR_BR_CM_R"]];

player createDiaryRecord ["cm",[localize "STR_BR_CM4G",localize "STR_BR_CM_G"]];

player createDiaryRecord ["cm",[localize "STR_BR_CM5E",localize "STR_BR_CM_E"]];

player createDiaryRecord ["cm",[localize "STR_BR_CM6M",localize "STR_BR_CM_M"]];
