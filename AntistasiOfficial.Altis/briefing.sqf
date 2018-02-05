waitUntil {!isNull player};

//Briefing - records order is reversed in game

player createDiaryRecord ["Diary",[localize "STR_BR_8CNT",localize "STR_BR_8CNT_T"]];

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
