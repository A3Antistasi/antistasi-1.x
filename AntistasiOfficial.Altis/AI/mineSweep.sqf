if (!isServer and hasInterface) exitWith {};

private ["_coste","_grupo","_unit","_minas","_tam","_roads","_camion","_mina"];

_coste = (server getVariable guer_sol_EXP) + ([guer_veh_engineer] call vehiclePrice);

[-1,-1*_coste] remoteExec ["resourcesFIA",2];

_grupo = createGroup side_blue;

_unit = _grupo createUnit [guer_sol_EXP, getMarkerPos guer_respawn, [], 0, "NONE"];
_grupo setGroupId ["MineSw"];
_minas = [];
sleep 1;
_tam = 10;
while {true} do
	{
	_roads = getMarkerPos guer_respawn nearRoads _tam;
	if (count _roads < 1) then {_tam = _tam + 10};
	if (count _roads > 0) exitWith {};
	};
_road = _roads select 0;
_pos = position _road findEmptyPosition [1,30,guer_veh_truck];

_camion = guer_veh_engineer createVehicle _pos;

[_camion] spawn VEHinit;
[_unit] spawn AS_fnc_initialiseFIAUnit;
_grupo addVehicle _camion;
_camion setVariable ["owner",_grupo,true];
_unit assignAsDriver _camion;
[_unit] orderGetIn true;
//_unit setBehaviour "SAFE";
Slowhand hcSetGroup [_grupo];
_grupo setVariable ["isHCgroup", true, true];

while {alive _unit} do
	{
	waitUntil {sleep 1;(!alive _unit) or (unitReady _unit)};
	if (alive _unit) then
		{
		if (alive _camion) then
			{
			if ((count magazineCargo _camion > 0) and (_unit distance (getMarkerPos guer_respawn) < 50)) then
				{
				[_camion,caja] remoteExec ["AS_fnc_transferGear",2];
				sleep 30;
				};
			};
		_minas = (detectedMines side_blue) select {(_x distance _unit) < 100};
		if (count _minas == 0) then
			{
			waitUntil {sleep 1;(!alive _unit) or (!unitReady _unit)};
			}
		else
			{
			moveOut _unit;
			[_unit] orderGetin false;
			_minas = [_minas,[],{_unit distance _x},"ASCEND"] call BIS_fnc_sortBy;
			_cuenta = 0;
			_total = count _minas;
			while {(alive _unit) and (_cuenta < _total)} do
				{
				_mina = _minas select _cuenta;
				_unit doMove position _mina;
				_timeOut = time + 120;
				waitUntil {sleep 0.5; (_unit distance _mina < 8) or (!alive _unit) or (time > _timeOut)};
				if (alive _unit) then
					{
					_unit action ["Deactivate",_unit,_mina];
					//_unit action ["deactivateMine", _unit];
					sleep 3;
					_toDelete = nearestObjects [position _unit, ["WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 9];
					if (count _toDelete > 0) then
						{
						_wh = _toDelete select 0;
						if (alive _camion) then {_camion addMagazineCargoGlobal [((magazineCargo _wh) select 0),1]};
						deleteVehicle _mina;
						deleteVehicle _wh;
						};
					_cuenta = _cuenta + 1;
					};
				};
			[_unit] orderGetIn true;
			};
		};
	sleep 1;
	};