if (player != Slowhand) exitWith {hint "Only Commander Slowhand has access to this function"};

//if ((count weaponCargo caja >0) or (count magazineCargo caja >0) or (count itemCargo caja >0) or (count backpackCargo caja >0)) exitWith {hint "You must first empty your Ammobox in order to move the HQ"};

hint "Move the Arsenal ammo crate and the Vehicle ammo crate and Petros to the new location";

petros enableAI "MOVE";
petros enableAI "AUTOTARGET";
petros forceSpeed -1;

[[petros,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
//removeAllActions petros;
//[true] remoteExecCall ["AS_fnc_togglePetrosAnim", 2];
[petros] join Slowhand;
petros setBehaviour "AWARE";
if (isMultiplayer) then
	{
	//caja hideObjectGlobal true; //Redo it with Jeroen's crate loading script. Sparker
	//cajaVeh hideObjectGlobal true;
	mapa hideObjectGlobal true;
	fuego hideObjectGlobal true;
	bandera hideObjectGlobal true;
	}
else
	{
	//caja hideObject true;
	//cajaVeh hideObject true;
	mapa hideObject true;
	fuego hideObject true;
	bandera hideObject true;
	};

fuego inflame false;

if (count (server getVariable ["obj_vehiclePad",[]]) > 0) then {
	[obj_vehiclePad, {deleteVehicle _this}] remoteExec ["call", 0];
	[obj_vehiclePad, {obj_vehiclePad = nil}] remoteExec ["call", 0];
	server setVariable ["AS_vehicleOrientation", 0, true];
	server setVariable ["obj_vehiclePad",[],true];
};

//guer_respawn setMarkerPos [0,0,0];
guer_respawn setMarkerAlpha 0;
_garrison = garrison getVariable ["FIA_HQ", []];
_posicion = getMarkerPos "FIA_HQ";
if (count _garrison > 0) then
	{
	_coste = 0;
	_hr = 0;
	if ({(alive _x) and (!captive _x) and ((side _x == side_green) or (side _x == side_red)) and (_x distance _posicion < 500)} count allUnits > 0) then
		{
		hint "HQ Garrison will stay here and hold the enemy";
		}
	else
		{
		_size = ["FIA_HQ"] call sizeMarker;
		{
		if ((side _x == side_blue) and (not(_x getVariable ["BLUFORSpawn",false])) and (_x distance _posicion < _size) and (_x != petros)) then
			{
			if (!alive _x) then
				{
				if (typeOf _x in guer_soldierArray) then
					{
					if (typeOf _x == guer_sol_UN) then {_coste = _coste - ([guer_stat_mortar] call vehiclePrice)};
					_hr = _hr - 1;
					_coste = _coste - (server getVariable (typeOf _x));
					};
				};
			if (typeOf (vehicle _x) == guer_stat_mortar) then {deleteVehicle vehicle _x};
			deleteVehicle _x;
			};
		} forEach allUnits;
		};
	{
	if (_x == guer_sol_UN) then {_coste = _coste + ([guer_stat_mortar] call vehiclePrice)};
	_hr = _hr + 1;
	_coste = _coste + (server getVariable _x);
	} forEach _garrison;
	[_hr,_coste] remoteExec ["resourcesFIA",2];
	garrison setVariable ["FIA_HQ",[],true];
	hint format ["Garrison removed\n\nRecovered Money: %1 €\nRecovered HR: %2",_coste,_hr];
	};

sleep 5;

petros addAction [localize "STR_act_buildHQ", {[] spawn buildHQ},nil,0,false,true];

//Add actions to load the cargo boxes
caja call jn_fnc_logistics_addAction;
cajaVeh call jn_fnc_logistics_addAction;