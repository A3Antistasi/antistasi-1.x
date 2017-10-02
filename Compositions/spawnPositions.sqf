fnc_getpresetSpawnPos = {
	params ["_marker", ["_type", "road"]];

	if (typeName _marker == "ARRAY") then {
		_marker = [markers, _marker] call BIS_Fnc_nearestPosition;
	};

	private _return = getMarkerPos _marker;

	if (_type == "road") then {
		if (_marker in bases) then {
			call {
				if (_marker == "base") exitWith { // Selakano
					_return = [19986.9,6550.68,0];
				};
				if (_marker == "base_1") exitWith { // Pyrgos
					_return = [17577.4,13127.5,0];
				};
				if (_marker == "base_2") exitWith { // Paros
					_return = [21014.7,19279.1,0];
				};
				if (_marker == "base_3") exitWith { // Sofia
					_return = [23442,21132.9,0];
				};
				if (_marker == "base_4") exitWith { // Gravia
					_return = [15144.5,17376,0];
				};
				if (_marker == "base_5") exitWith { // Lakka
					_return = [12983.2,16457.1,0];
				};
				if (_marker == "base_6") exitWith { // Frini
					_return = [14207.4,21085.6,0];
				};
				if (_marker == "base_7") exitWith { // Telos
					_return = [16653.2,19058.2,0];
				};
				if (_marker == "base_9") exitWith { // Galati
					_return = [9721.14,19476.5,0];
				};
				if (_marker == "base_10") exitWith { // Therisa/peninsula
					_return = [12324.3,8756.59,0];
				};
				if (_marker == "base_11") exitWith { // Zaros
					_return = [8358.95,10125.8,0];
				};
				if (_marker == "base_12") exitWith { // Aggelochori
					_return = [5163.59,14234.9,0];
				};
			};
		};
	} else {
		if (_marker in bases) then {
			call {
				if (_marker == "base") exitWith { // Selakano
					_return = [20061.4,6665.48,0];
				};
				if (_marker == "base_1") exitWith { // Pyrgos
					_return = [17408.9,13175.6,0];
				};
				if (_marker == "base_2") exitWith { // Paros
					_return = [21055,19167.2,0];
				};
				if (_marker == "base_3") exitWith { // Sofia
					_return = [23581.5,21129.3,0];
				};
				if (_marker == "base_4") exitWith { // Gravia
					_return = [15191.1,17296.4,0];
				};
				if (_marker == "base_5") exitWith { // Lakka
					_return = [12873.3,16705.4,0];
				};
				if (_marker == "base_6") exitWith { // Frini
					_return = [14152.1,21229.5,0];
				};
				if (_marker == "base_7") exitWith { // Telos
					_return = [16546.9,19012.9,0];
				};
				if (_marker == "base_9") exitWith { // Galati
					_return = [9899.35,19345.7,0];
				};
				if (_marker == "base_10") exitWith { // Therisa/peninsula
					_return = [12258.4,8916.55,0];
				};
				if (_marker == "base_11") exitWith { // Zaros
					_return = [8375.14,10100.7,0];
				};
				if (_marker == "base_12") exitWith { // Aggelochori
					_return = [5294.69,14100.3,0];
				};
			};
		};
	};
	_return
};