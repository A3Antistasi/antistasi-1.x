//if (player != Slowhand) exitWith {hint "Only Commander can ask for NATO support"};
_tipo = _this select 0;

if (!allowPlayerRecruit) exitWith {hint "Server is very loaded. \nWait one minute or change FPS settings in order to fulfill this request"};
if (_tipo in misiones) exitWith {hint "NATO is already busy with this kind of mission"};
if (!([player] call hasRadio)) exitWith {hint "You need a radio in your inventory to be able to give orders to other squads"};

// check if FIA controls a radio tower
// /begin
/*
_s = antenas - mrkAAF;
_c = 0;

if (count _s > 0) then {
	for "_i" from 0 to (count _s - 1) do {
		_antenna = _s select _i;
		_cercano = [markers, getPos _antenna] call BIS_fnc_nearestPosition;
		if (_cercano in mrkFIA) then {_c = _c + 1};
	};
};


if (_c < 1) exitWith {
	_l1 = ["Radio Operator", "I cannot get NATO on the horn. I might have more luck if I were able to jerry-rig this radio to a proper radio tower..."];
	[[_l1],"SIDE",0.15] execVM "createConv.sqf";
};
*/
// /end

_bases = bases - mrkAAF;
_aeropuertos = aeropuertos - mrkAAF;

if (((_tipo == "NATOArty") or (_tipo == "NATOArmor") or (_tipo == "NATORoadblock")) and (count _bases == 0)) exitWith {hint "You need to conquer at least one base to perform this action"};

_costeNATO = 5;
_textoHint = "";

switch (_tipo) do {
	case "NATOCA": {
		_costeNATO = 20;
		_textohint = "Click on the base or airport you want NATO to attack";
	};
	case "NATOArmor": {
		_costeNATO = 20;
		_textohint = "Click on the base from which you want NATO to attack";
	};
	case "NATOAmmo": {
		_costeNATO = 5;
		_textohint = "Click on the spot where you want the Ammodrop";
	};
	case "NATOArty": {
		_costeNATO = 10;
		_textohint = "Click on the base from which you want Artillery Support";
	};
	case "NATOCAS": {
		_costeNATO = 10;
		_textohint = "Click on the airport from which you want NATO to attack";
	};
	case "NATORoadblock": {
		_costeNATO = 10;
		_textohint = "Click on the spot where you want NATO to setup a roadblock";
	};
	case "NATOQRF": {
		_costeNATO = 10;
		_textohint = "Click on the base or airport/carrier from which you want NATO to dispatch a QRF";
	};
	case "NATORED": {           //Stef 30-08 adding a way to reduce CSATprestige by spending NATO
		_costeNATO = 100;
		_textohint = "You informed about supporting enemy faction emplacement, its destruction will reduce their concern about the island";
	};
};

_NATOSupp = server getVariable "prestigeNATO";

if (_NATOSupp < _costeNATO) exitWith {hint format ["We lack of enough NATO Support in order to proceed with this request (%1 needed)",_costeNATO]};

if (_tipo == "NATOCAS") exitWith {[] remoteExec [_tipo, call AS_fnc_getNextWorker]};
if (_tipo == "NATOUAV") exitWith {[] remoteExec [_tipo, call AS_fnc_getNextWorker]};

if (_tipo == "NATORED") exitWith {[-100,-10] remoteExec ["prestige",2];}; //Stef 30-08 added the support change, maybe add a sleep 5 minute to take effect to simulate jets moving to them.


posicionTel = [];

hint format ["%1",_textohint];

openMap true;
onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (!visibleMap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_posicionTel =+ posicionTel;
if ((_tipo != "NATOArmor") or (_tipo == "NATORoadblock")) then {openMap false};

// break, in case no valid point of origin was selected
_salir = false;

// location for the QRF to depart from -- default: NATO carrier
_loc = "spawnNATO";


// roadblocks, only allowed on roads
if (_tipo == "NATORoadblock") exitWith {
	_check = isOnRoad _posicionTel;
	if !(_check) exitWith {hint "Roadblocks can only be placed on roads."};
	[_posicionTel] remoteExec [_tipo, call AS_fnc_getNextWorker];
};

if (_tipo == "NATOAmmo") exitWith {[_posiciontel,_NATOSupp] remoteExec [_tipo,  call AS_fnc_getNextWorker]};

_sitio = [markers, _posicionTel] call BIS_Fnc_nearestPosition;

if (_tipo == "NATOQRF") exitWith {
	_sitioName = "the NATO carrier";
	if ((_sitio in _bases) || (_sitio in _aeropuertos)) then {
		_loc = _sitio;
		_sitioName = [_sitio] call AS_fnc_localizar;
	};

	posicionTel = [];
	hint format ["QRF departing from %1. Mark the target for the QRF.",_sitioName];

	openMap true;
	onMapSingleClick "posicionTel = _pos;";

	waitUntil {sleep 1; (count posicionTel > 0) or (!visibleMap)};
	onMapSingleClick "";

	if (!visibleMap) exitWith {};

	_destino =+ posicionTel;
	openMap false;

	if (surfaceIsWater _destino) exitWith {hint "No LCS available this decade, QRF is restricted to land."};
	hint "QRF inbound.";
	[_loc,_destino] remoteExec ["NATOQRF", call AS_fnc_getNextWorker];
};

if (_posicionTel distance getMarkerPos _sitio > 50) exitWith {hint "You must click near a map marker"};

if (_tipo == "NATOArty") exitWith {
	if (not(_sitio in _bases)) exitWith {hint "Artillery support can only be obtained from bases."};
	[_sitio] remoteExec ["NATOArty",  call AS_fnc_getNextWorker];
};

if (_tipo == "NATOArmor") then {
	if (not(_sitio in _bases)) then {
		_salir = true;
		hint "You must click near a friendly base";
	}
	else {
		posicionTel = [];
		hint "Click on the Armored Column destination";

		openMap true;
		onMapSingleClick "posicionTel = _pos;";

		waitUntil {sleep 1; (count posicionTel > 0) or (!visibleMap)};
		onMapSingleClick "";

		if (!visibleMap) then {_salir = true};

		_posicionTel =+ posicionTel;
		openMap false;
		_destino = [markers, _posicionTel] call BIS_Fnc_nearestPosition;
		if (_posicionTel distance getMarkerPos _destino > 50) then {
			hint "You must click near a map marker";
			_salir = true
		}
		else {
			[[_sitio,_destino], "CREATE\NATOArmor.sqf"] remoteExec ["execVM", call AS_fnc_getNextWorker];
		};
	};
};

if (_tipo == "NATOCA") then {
	if ((_sitio in ciudades) or (_sitio in controles) or (_sitio in colinas)) then {_salir = true; hint "NATO won't attack this kind of zone."};
	if (_sitio in mrkFIA) then {_salir = true; hint "NATO Attacks may be only ordered on AAF controlled zones"};
};

if (_salir) exitWith {};

if (_tipo == "NATOCA") then {
	[_sitio] remoteExec [_tipo, call AS_fnc_getNextWorker];
};

