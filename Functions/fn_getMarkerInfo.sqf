private ["_popFIA","_popAAF","_pop","_data","_numCiv","_prestigeOPFOR","_prestigeBLUFOR","_text","_posicionTel"];
posicionTel = [];

_popFIA = 0;
_popAAF = 0;
_pop = 0;
{
	_data = server getVariable _x;
	_numCiv = _data select 0;
	_prestigeOPFOR = _data select 2;
	_prestigeBLUFOR = _data select 3;
	_popFIA = _popFIA + (_numCiv * (_prestigeBLUFOR / 100));
	_popAAF = _popAAF + (_numCiv * (_prestigeOPFOR / 100));
	_pop = _pop + _numCiv;
} forEach ciudades;
_popFIA = round _popFIA;
_popAAF = round _popAAF;

_text = format ["%1\n\nTotal population: %2\n%3 Support: %4\n%5 Support: %6 \n\nDestroyed Cities: %7\n\nClick on a zone for detailed info.", worldName, _pop, A3_Str_PLAYER, _popFIA, A3_Str_INDEP, _popAAF, {_x in destroyedCities} count ciudades];
hint _text;

_fn_text = {
	params ["_text", "_type"];
	private ["_return"];
	call {
		if (_type == "power") exitWith {
			_return = format ["%1\n%2Powered",_text, ["Not ", ""] select ([_location] call AS_fnc_powerCheck)];
		};
		if (_type == "radio") exitWith {
			_return = format ["%1\nRadio Comms %2",_text, ["Off", "On"] select ([_location] call AS_fnc_radioCheck)];
		};
		if (_type == "garrison") exitWith {
			_return = format ["%1\nGarrison has taken %2 casualties",_text, ["no/minimal", "significant"] select (_location in reducedGarrisons)];
		};
		if (_type == "both") exitWith {
			_return = [_text, "power"] call _fn_text;
			_return = [_return, "radio"] call _fn_text;
		};
		if (_type == "all") exitWith {
			_return = [_text, "power"] call _fn_text;
			_return = [_return, "radio"] call _fn_text;
			_return = [_return, "garrison"] call _fn_text;
		};
	};
	_return
};

openMap true;
onMapSingleClick "posicionTel = _pos;";

while {visibleMap} do {
	sleep 1;
	if (count posicionTel > 0) then {
		_posicionTel = posicionTel;
		_location = [markers, _posicionTel] call BIS_Fnc_nearestPosition;
		_text = "Click on a zone";
		call {
			if (_location == "FIA_HQ") exitWith {
				_text = format ["%1 HQ%2", A3_Str_PLAYER, [_location] call AS_fnc_getGarrisonInfo];
			};
			if (_location in ciudades) exitWith {
				_data = server getVariable _location;
				_numCiv = _data select 0;
				_prestigeOPFOR = _data select 2;
				_prestigeBLUFOR = _data select 3;
				_text = format ["%1\n\nPopulation %2\n%3 Support: %4%7\n%5 Support: %6%7",[_location,false] call AS_fnc_location,_numCiv, A3_Str_INDEP, _prestigeOPFOR, A3_Str_PLAYER, _prestigeBLUFOR,"%"];
				_text = [_text, "both"] call _fn_text;
				if (_location in destroyedCities) then {_text = format ["%1\nDESTROYED",_text]};
			};

			if (_location in aeropuertos) exitWith {
				if (_location in mrkAAF) then {
					_text = format ["%1 Airport", A3_Str_INDEP];
					_text = [_text, "radio"] call _fn_text;
					_text = [_text, "garrison"] call _fn_text;
					_text = format ["%1\nStatus: %2",_text, ["Busy", "Idle"] select (dateToNumber date > server getVariable _location)];
				} else {
					_text = format ["%1 Airport%2", A3_Str_PLAYER, [_location] call AS_fnc_getGarrisonInfo];
				};
			};

			if (_location in power) exitWith {
				if (_location in mrkAAF) then {
					_text = format ["%1 Powerplant", A3_Str_INDEP];
					_text = [_text, "radio"] call _fn_text;
					_text = [_text, "garrison"] call _fn_text;
				} else {
					_text = format ["%1 Powerplant%2", A3_Str_PLAYER, [_location] call AS_fnc_getGarrisonInfo];
				};
				if (_location in destroyedCities) then {_text = format ["%1\nDESTROYED",_text]};
			};

			if (_location in recursos) exitWith {
				if (_location in mrkAAF) then {
					_text = format ["%1 Resources", A3_Str_INDEP];
					_text = [_text, "all"] call _fn_text;
				} else {
					_text = format ["%1 Resources%2", A3_Str_PLAYER, [_location] call AS_fnc_getGarrisonInfo];
					_text = [_text, "power"] call _fn_text;
				};
				if (_location in destroyedCities) then {_text = format ["%1\nDESTROYED",_text]};
			};

			if (_location in fabricas) exitWith {
				if (_location in mrkAAF) then {
					_text = format ["%1 Factory", A3_Str_INDEP];
					_text = [_text, "all"] call _fn_text;
				} else {
					_text = format ["%1 Factory%2", A3_Str_PLAYER, [_location] call AS_fnc_getGarrisonInfo];
					_text = [_text, "power"] call _fn_text;
				};
				if (_location in destroyedCities) then {_text = format ["%1\nDESTROYED",_text]};
				};

			if (_location in puestos) exitWith {
				if (_location in mrkAAF) then {
					_text = format ["%1 Grand Outpost", A3_Str_INDEP];
					_text = [_text, "radio"] call _fn_text;
					_text = [_text, "garrison"] call _fn_text;
				} else {
					_text = format ["%1 Grand Outpost%2", A3_Str_PLAYER, [_location] call AS_fnc_getGarrisonInfo];
				};
			};

			if (_location in puertos) exitWith {
				if (_location in mrkAAF) then {
					_text = format ["%1 Seaport", A3_Str_INDEP];
					_text = [_text, "radio"] call _fn_text;
					_text = [_text, "garrison"] call _fn_text;
				} else {
					_text = format ["%1 Seaport%2", A3_Str_PLAYER, [_location] call AS_fnc_getGarrisonInfo];
				};
			};

			if (_location in bases) exitWith {
				if (_location in mrkAAF) then {
					_text = format ["%1 Base", A3_Str_INDEP];
					_text = [_text, "radio"] call _fn_text;
					_text = [_text, "garrison"] call _fn_text;
					_text = format ["%1\nStatus: %2",_text, ["Busy", "Idle"] select (dateToNumber date > server getVariable _location)];
				} else {
					_text = format ["%1 Base%2", A3_Str_PLAYER, [_location] call AS_fnc_getGarrisonInfo];
				};
			};
		};

		hint format ["%1",_text];
	};

	posicionTel = [];
};

onMapSingleClick "";