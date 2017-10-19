#define ranks2 ["Corporal", "Private"]
#define ranks3 ["Corporal", "Private", "Private"]
#define ranks4 ["Corporal", "Private", "Private", "Private"]
#define ranks5 ["Corporal", "Private", "Private", "Private", "Private"]
#define ranks6 ["Sergeant", "Corporal", "Private", "Private", "Private", "Private"]
#define ranks7 ["Sergeant", "Corporal", "Private", "Private", "Private", "Private", "Private"]
#define ranks8 ["Sergeant", "Corporal", "Private", "Private", "Private", "Private", "Private", "Private"]
#define ranks9 ["Lieutenant", "Sergeant", "Corporal", "Corporal", "Corporal", "Private", "Private", "Private", "Private"]
#define ranks10 ["Lieutenant", "Sergeant", "Corporal", "Corporal", "Corporal", "Private", "Private", "Private", "Private", "Private"]
#define ranks11 ["Lieutenant", "Sergeant", "Corporal", "Corporal", "Corporal", "Private", "Private", "Private", "Private", "Private", "Private"]
#define ranks12 ["Lieutenant", "Sergeant", "Corporal", "Corporal", "Corporal", "Private", "Private", "Private", "Private", "Private", "Private", "Private"]
#define ranks13 ["Captain", "Lieutenant", "Sergeant", "Corporal", "Corporal", "Corporal", "Private", "Private", "Private", "Private", "Private", "Private", "Private"]


params ["_number"];
private ["_ranks"];

switch (_number) do {
	case 2: {ranks2};
	case 3: {ranks3};
	case 4: {ranks4};
	case 5: {ranks5};
	case 6: {ranks6};
	case 7: {ranks7};
	case 8: {ranks8};
	case 9: {ranks9};
	case 10: {ranks10};
	case 11: {ranks11};
	case 12: {ranks12};
	case 13: {ranks13};

	default {
		[];
	};
};
