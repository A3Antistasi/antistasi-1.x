
private ["_texto","_datos","_numCiv","_prestigeOPFOR","_prestigeBLUFOR","_power","_busy","_sitio","_posicionTel","_garrison"];
posicionTel = [];

_popFIA = 0;
_popAAF = 0;
_pop = 0;
{
_datos = server getVariable _x;
_numCiv = _datos select 0;
_prestigeOPFOR = _datos select 2;
_prestigeBLUFOR = _datos select 3;
_popFIA = _popFIA + (_numCiv * (_prestigeBLUFOR / 100));
_popAAF = _popAAF + (_numCiv * (_prestigeOPFOR / 100));
_pop = _pop + _numCiv;
} forEach ciudades;
_popFIA = round _popFIA;
_popAAF = round _popAAF;
hint format ["Altis\n\nTotal pop: %1\nFIA Support: %2\nAAF SUpport: %3 \n\nDestroyed Cities: %4\n\nClick on the zone",_pop, _popFIA, _popAAF, {_x in destroyedCities} count ciudades];

openMap true;

onMapSingleClick "posicionTel = _pos;";


//Plot the frontline. Sparker
[ws_frontlineSmooth, 1, false] call WS_fnc_plotGrid;
////////////////////////////////

//waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
while {visibleMap} do
	{
	sleep 1;
	if (count posicionTel > 0) then
		{
		_posicionTel = posicionTel;
		//_sitio = [marcadores, _posicionTel] call BIS_Fnc_nearestPosition;
		_sitio = [markers, _posicionTel] call BIS_Fnc_nearestPosition; //Sparker
		_texto = "Click on a zone";
		if (_sitio == "FIA_HQ") then
			{
			_texto = format ["FIA HQ%1",[_sitio] call AS_fnc_getGarrisonInfo];
			};
		if (_sitio in ciudades) then
			{
			_datos = server getVariable _sitio;

			_numCiv = _datos select 0;
			_prestigeOPFOR = _datos select 2;
			_prestigeBLUFOR = _datos select 3;
			_power = [_sitio] call AS_fnc_powercheck;
			//_texto = format ["%1\n\nPop %2\nAAF Support: %3 %5\nFIA Support: %4 %5",[_sitio,false] call fn_location,_numCiv,_prestigeOPFOR,_prestigeBLUFOR,"%"];
			_texto = format ["%1\n\nPop %2\nAAF Support: %3 %5\nFIA Support: %4 %5",[_sitio,false] call AS_fnc_location,_numCiv,_prestigeOPFOR,_prestigeBLUFOR,"%"];
			if (_power) then {_texto = format ["%1\nPowered",_texto]} else {_texto = format ["%1\nNot Powered",_texto]};
			if (_sitio in mrkAAF) then {if ([_sitio] call AS_fnc_radiocheck) then {_texto = format ["%1\nRadio Comms ON",_texto]} else {_texto = format ["%1\nRadio Comms OFF",_texto]}};
			if (_sitio in destroyedCities) then {_texto = format ["%1\nDESTROYED",_texto]};
			};
		/*
		if ((_sitio in colinas) and (_sitio in mrkAAF)) then
			{
			_texto = "AAF Small Outpost";
			};
		*/
		if (_sitio in aeropuertos) then
			{
			if (_sitio in mrkAAF) then
				{
				_texto = "AAF Airport";
				_busy = if (dateToNumber date > server getVariable _sitio) then {false} else {true};
				if ([_sitio] call AS_fnc_radiocheck) then {_texto = format ["%1\n\nRadio Comms ON",_texto]} else {_texto = format ["%1\n\nRadio Comms OFF",_texto]};
				if (!_busy) then {_texto = format ["%1\nStatus: Idle",_texto]} else {_texto = format ["%1\nStatus: Busy",_texto]};
				}
			else
				{
				_texto = format ["FIA Airport%1",[_sitio] call AS_fnc_getGarrisonInfo];
				};
			};
		if (_sitio in power) then
			{
			if (_sitio in mrkAAF) then
				{
				_texto = "AAF Powerplant";
				if ([_sitio] call AS_fnc_radiocheck) then {_texto = format ["%1\n\nRadio Comms ON",_texto]} else {_texto = format ["%1\n\nRadio Comms OFF",_texto]};
				}
			else
				{
				_texto = format ["FIA Powerplant%1",[_sitio] call AS_fnc_getGarrisonInfo];
				};
			if (_sitio in destroyedCities) then {_texto = format ["%1\nDESTROYED",_texto]};
			};
		if (_sitio in recursos) then
			{
			if (_sitio in mrkAAF) then
				{
				_texto = "AAF Resources";
				}
			else
				{
				_texto = format ["FIA Resources%1",[_sitio] call AS_fnc_getGarrisonInfo];
				};
			_power = [_sitio] call AS_fnc_powercheck;
			if (!_power) then {_texto = format ["%1\n\nNo Powered",_texto]} else {_texto = format ["%1\n\nPowered",_texto]};
			if (_sitio in mrkAAF) then {if ([_sitio] call AS_fnc_radiocheck) then {_texto = format ["%1\nRadio Comms ON",_texto]} else {_texto = format ["%1\nRadio Comms OFF",_texto]}};
			if (_sitio in destroyedCities) then {_texto = format ["%1\nDESTROYED",_texto]};
			};
		if (_sitio in fabricas) then
			{
			if (_sitio in mrkAAF) then
				{
				_texto = "AAF Factory";
				}
			else
				{
				_texto = format ["FIA Factory%1",[_sitio] call AS_fnc_getGarrisonInfo];
				};
			_power = [_sitio] call AS_fnc_powercheck;
			if (!_power) then {_texto = format ["%1\n\nNo Powered",_texto]} else {_texto = format ["%1\n\nPowered",_texto]};
			if (_sitio in mrkAAF) then {if ([_sitio] call AS_fnc_radiocheck) then {_texto = format ["%1\nRadio Comms ON",_texto]} else {_texto = format ["%1\nRadio Comms OFF",_texto]}};
			if (_sitio in destroyedCities) then {_texto = format ["%1\nDESTROYED",_texto]};
			};
		if (_sitio in puestos) then
			{
			if (_sitio in mrkAAF) then
				{
				_texto = "AAF Grand Outpost";
				if ([_sitio] call AS_fnc_radiocheck) then {_texto = format ["%1\n\nRadio Comms ON",_texto]} else {_texto = format ["%1\n\nRadio Comms OFF",_texto]};
				}
			else
				{
				_texto = format ["FIA Grand Outpost%1",[_sitio] call AS_fnc_getGarrisonInfo];
				};
			};
		/*
		if ((_sitio in controles) and (_sitio in mrkAAF)) then
			{
			_texto = "AAF Roadblock";
			};
		*/
		if (_sitio in puertos) then
			{
			if (_sitio in mrkAAF) then
				{
				_texto = "AAF Seaport";
				if ([_sitio] call AS_fnc_radiocheck) then {_texto = format ["%1\n\nRadio Comms ON",_texto]} else {_texto = format ["%1\n\nRadio Comms OFF",_texto]};
				}
			else
				{
				_texto = format ["FIA Seaport%1",[_sitio] call AS_fnc_getGarrisonInfo];
				};
			};
		if (_sitio in bases) then
			{
			if (_sitio in mrkAAF) then
				{
				_texto = "AAF Base";
				_busy = if (dateToNumber date > server getVariable _sitio) then {false} else {true};
				if ([_sitio] call AS_fnc_radiocheck) then {_texto = format ["%1\n\nRadio Comms ON",_texto]} else {_texto = format ["%1\n\nRadio Comms OFF",_texto]};
				if (!_busy) then {_texto = format ["%1\nStatus: Idle",_texto]} else {_texto = format ["%1\nStatus: Busy",_texto]};
				}
			else
				{
				_texto = format ["FIA Base%1",[_sitio] call AS_fnc_getGarrisonInfo];
				};
			};
		hint format ["%1",_texto];
		};
	posicionTel = [];
	};
onMapSingleClick "";

//Remove the frontline. Sparker
call WS_fnc_unplotGrid;
///////////////////////////////