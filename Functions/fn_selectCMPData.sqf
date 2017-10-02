params ["_marker"];
private ["_data"];

switch (_marker) do {
	case "Agela": {
		_data = AS_MTN_Agela;
	};
	case "Agia Stemma": {
		_data = AS_MTN_AgiaStemma;
	};
	case "Agios Andreas": {
		_data = AS_MTN_AgiosAndreas;
	};
	case "Agios Minas": {
		_data = AS_MTN_AgiosMinas;
	};
	case "Amoni": {
		_data = AS_MTN_Amoni;
	};
	case "Didymos": {
		_data = AS_MTN_Didymos;
	};
	case "Kira": {
		_data = AS_MTN_Kira;
	};
	case "Pyrsos": {
		_data = AS_MTN_Pyrsos;
	};
	case "Riga": {
		_data = AS_MTN_Riga;
	};
	case "Skopos": {
		_data = AS_MTN_Skopos;
	};
	case "Synneforos": {
		_data = AS_MTN_Synneforos;
	};
	case "Thronos": {
		_data = AS_MTN_Thronos;
	};

	case "puesto_2": {
		_data = AS_OP_2;
	};
	case "puesto_6": {
		_data = AS_OP_6;
	};
	case "puesto_11": {
		_data = AS_OP_11;
	};
	case "puesto_17": {
		_data = AS_OP_17;
	};
	case "puesto_23": {
		_data = AS_OP_23;
	};
};

_data