private ["_unit","_Pweapon","_Sweapon","_cuenta","_magazines","_hayCaja","_distancia","_objetos","_target","_muerto","_check","_timeOut","_arma","_armas","_rearming","_basePosible","_hmd","_casco"];

_unit = _this select 0;

if ((!alive _unit) or (isPlayer _unit) or (vehicle _unit != _unit) or (player != leader group player) or (captive _unit)) exitWith {};
if (_unit getVariable "inconsciente") exitWith {};
_ayudando = _unit getVariable "ayudando";
if (!(isNil "_ayudando")) exitWith {_unit groupChat "I cannot rearm right now. I'm healing a comrade"};
_rearming = _unit getVariable "rearming";
if (_rearming) exitWith {_unit groupChat "I am currently rearming"};

_unit setVariable ["rearming",true];

_Pweapon = primaryWeapon _unit;
_Sweapon = secondaryWeapon _unit;

_objetos = [];
_hayCaja = false;
_arma = "";
_armas = [];
_distancia = 51;
_objetos = nearestObjects [_unit, ["ReammoBox_F","LandVehicle","WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 50];
if (caja in _objetos) then {_objetos = _objetos - [caja]};
_necesita = false;
_muertos = [];

{
_muerto = _x;
if (_muerto distance _unit < _distancia) then
	{
	_busy = _muerto getVariable "busy";
	if (isNil "_busy") then
		{
		_muertos pushBack _muerto;
		};
	};
} forEach allDead;

if (_Pweapon != "") then
	{
	if (_Pweapon in baseRifles) then
		{
		_necesita = true;
		if (count _objetos > 0) then
			{
			{
			_objeto = _x;
			if (_unit distance _objeto < _distancia) then
				{
				_busy = _objeto getVariable "busy";
				if ((count weaponCargo _objeto > 0) and (isNil "_busy")) then
					{
					_armas = weaponCargo _objeto;
					for "_i" from 0 to (count _armas - 1) do
						{
						_posible = _armas select _i;
						_basePosible = [_posible] call BIS_fnc_baseWeapon;
						if (!(_posible in baseRifles) and ((_basePosible in gear_assaultRifles) or (_basePosible in gear_sniperRifles) or (_basePosible in gear_machineGuns))) then
							{
							_target = _objeto;
							_hayCaja = true;
							_distancia = _unit distance _objeto;
							_arma = _posible;
							};
						};
					};
				};
			} forEach _objetos;
			};
		if ((_hayCaja) and (_unit getVariable "rearming")) then
			{
			_unit stop false;
			if ((!alive _target) or (not(_target isKindOf "ReammoBox_F"))) then {_target setVariable ["busy",true]};
			_unit doMove (getPosATL _target);
			_unit groupChat "Picking a better weapon";
			_timeOut = time + 60;
			waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
			if ((unitReady _unit) and (alive _unit) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
			if (_unit distance _target < 3) then
				{
				_unit action ["TakeWeapon",_target,_arma];
				sleep 5;
				if (primaryWeapon _unit == _arma) then
					{
					_unit groupChat "I have a better weapon now";
					if (_target isKindOf "ReammoBox_F") then {_unit action ["rearm",_target]};
					}
				else
					{
					_unit groupChat "Couldn't take this weapon";
					};
				}
			else
				{
				_unit groupChat "Cannot take a better weapon";
				};
			_target setVariable ["busy",nil];
			_unit doFollow player;
			};
		_distancia = 51;
		_Pweapon = primaryWeapon _unit;
		sleep 3;
		};
	_hayCaja = false;
	_cuenta = 4;
	if (_Pweapon in gear_machineGuns) then {_cuenta = 2};
	_magazines = getArray (configFile / "CfgWeapons" / _Pweapon / "magazines");
	if ({_x in _magazines} count (magazines _unit) < _cuenta) then
		{
		_necesita = true;
		_hayCaja = false;
		if (count _objetos > 0) then
			{
			{
			_objeto = _x;
			if (({_x in _magazines} count magazineCargo _objeto) > 0) then
				{
				if (_unit distance _objeto < _distancia) then
					{
					_target = _objeto;
					_hayCaja = true;
					_distancia = _unit distance _objeto;
					};
				};
			} forEach _objetos;
			};
		{
		_muerto = _x;
		_busy = _muerto getVariable "busy";
		if (({_x in _magazines} count (magazines _muerto) > 0) and (isNil "_busy")) then
			{
			_target = _muerto;
			_hayCaja = true;
			_distancia = _muerto distance _unit;
			};
		} forEach _muertos;
		};
	if ((_hayCaja) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		if ((!alive _target) or (not(_target isKindOf "ReammoBox_F"))) then {_target setVariable ["busy",true]};
		_unit doMove (getPosATL _target);
		_unit groupChat "Rearming";
		_timeOut = time + 60;
		waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if ((unitReady _unit) and (alive _unit) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
		if (_unit distance _target < 3) then
			{
			_unit action ["rearm",_target];
			if ({_x in _magazines} count (magazines _unit) >= _cuenta) then
				{
				_unit groupChat "Rearmed";
				}
			else
				{
				_unit groupChat "Partially Rearmed";
				};
			}
		else
			{
			_unit groupChat "Cannot rearm";
			};
		_target setVariable ["busy",nil];
		_unit doFollow player;
		}
	else
		{
		_unit groupChat "No source to rearm my primary weapon";
		};
	};
_hayCaja = false;
if ((_Sweapon == "") and (loadAbs _unit < 340)) then
	{
	if (count _objetos > 0) then
		{
		{
		_objeto = _x;
		if (_unit distance _objeto < _distancia) then
			{
			_busy = _objeto getVariable "busy";
			if ((count weaponCargo _objeto > 0) and (isNil "_busy")) then
				{
				_armas = weaponCargo _objeto;
				for "_i" from 0 to (count _armas - 1) do
					{
					_posible = _armas select _i;
					if ((_posible in gear_missileLaunchers) or (_posible in gear_rocketLaunchers)) then
						{
						_target = _objeto;
						_hayCaja = true;
						_distancia = _unit distance _objeto;
						_arma = _posible;
						};
					};
				};
			};
		} forEach _objetos;
		};
	if ((_hayCaja) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		if ((!alive _target) or (not(_target isKindOf "ReammoBox_F"))) then {_target setVariable ["busy",true]};
		_unit doMove (getPosATL _target);
		_unit groupChat "Picking a secondary weapon";
		_timeOut = time + 60;
		waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if ((unitReady _unit) and (alive _unit) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
		if (_unit distance _target < 3) then
			{
			_unit action ["TakeWeapon",_target,_arma];
			sleep 3;
			if (secondaryWeapon _unit == _arma) then
				{
				_unit groupChat "I have a secondary weapon now";
				if (_target isKindOf "ReammoBox_F") then {sleep 3;_unit action ["rearm",_target]};
				}
			else
				{
				_unit groupChat "Couldn't take this weapon";
				};
			}
		else
			{
			_unit groupChat "Cannot take a secondary weapon";
			};
		_target setVariable ["busy",nil];
		_unit doFollow player;
		};
	_Sweapon = secondaryWeapon _unit;
	_distancia = 51;
	sleep 3;
	};
_hayCaja = false;
if (_Sweapon != "") then
	{
	_magazines = getArray (configFile / "CfgWeapons" / _Sweapon / "magazines");
	if ({_x in _magazines} count (magazines _unit) < 2) then
		{
		_necesita = true;
		_hayCaja = false;
		_distancia = 50;
		if (count _objetos > 0) then
			{
			{
			_objeto = _x;
			if ({_x in _magazines} count magazineCargo _objeto > 0) then
				{
				if (_unit distance _objeto < _distancia) then
					{
					_target = _objeto;
					_hayCaja = true;
					_distancia = _unit distance _objeto;
					};
				};
			} forEach _objetos;
			};
		{
		_muerto = _x;
		_busy = _muerto getVariable "busy";
		if (({_x in _magazines} count (magazines _muerto) > 0) and (isNil "_busy")) then
			{
			_target = _muerto;
			_hayCaja = true;
			_distancia = _muerto distance _unit;
			};
		} forEach _muertos;
		};
	if ((_hayCaja) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		if (!alive _target) then {_target setVariable ["busy",true]};
		_unit doMove (position _target);
		_unit groupChat "Rearming";
		_timeOut = time + 60;
		waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if ((unitReady _unit) and (alive _unit) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
		if (_unit distance _target < 3) then
			{
			if ((backpack _unit == "") and (backPack _target != "")) then
				{
				_unit addBackPackGlobal ((backpack _target) call BIS_fnc_basicBackpack);
				_unit action ["rearm",_target];
				sleep 3;
				{_unit addMagazine [_x,1]} forEach (magazineCargo (backpackContainer _target));
				removeBackpackGlobal _target;
				}
			else
				{
				_unit action ["rearm",_target];
				};

			if ({_x in _magazines} count (magazines _unit) >= 2) then
				{
				_unit groupChat "Rearmed";
				}
			else
				{
				_unit groupChat "Partially Rearmed";
				};
			}
		else
			{
			_unit groupChat "Cannot rearm";
			};
		_target setVariable ["busy",nil];
		}
	else
		{
		_unit groupChat "No source to rearm my secondary weapon.";
		};
	sleep 3;
	};
_hayCaja = false;
if (not("ItemRadio" in assignedItems _unit)) then
	{
	_necesita = true;
	_hayCaja = false;
	_distancia = 50;
	{
	_muerto = _x;
	_busy = _muerto getVariable "busy";
	if (("ItemRadio" in (assignedItems _muerto)) and (isNil "_busy")) then
		{
		_target = _muerto;
		_hayCaja = true;
		_distancia = _muerto distance _unit;
		};
	} forEach _muertos;
	if ((_hayCaja) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		_target setVariable ["busy",true];
		_unit doMove (getPosATL _target);
		_unit groupChat "Picking a Radio";
		_timeOut = time + 60;
		waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if (_unit distance _target < 3) then
			{
			_unit action ["rearm",_target];
			_unit linkItem "ItemRadio";
			_target unlinkItem "ItemRadio";
			}
		else
			{
			_unit groupChat "Cannot pick the Radio";
			};
		_target setVariable ["busy",nil];
		_unit doFollow player;
		};
	};
_hayCaja = false;
if (hmd _unit == "") then
	{
	_necesita = true;
	_hayCaja = false;
	_distancia = 50;
	{
	_muerto = _x;
	_busy = _muerto getVariable "busy";
	if ((hmd _muerto != "") and (isNil "_busy")) then
		{
		_target = _muerto;
		_hayCaja = true;
		_distancia = _muerto distance _unit;
		};
	} forEach _muertos;

	if ((_hayCaja) and (_unit getVariable "rearming")) then
		{
		_hayCaja = false;
		_distancia = 50;
		{
		_muerto = _x;
		_busy = _muerto getVariable "busy";
		if ((hmd _muerto != "") and (isNil "_busy")) then
			{
			_target = _muerto;
			_hayCaja = true;
			_distancia = _muerto distance _unit;
			};
		} forEach _muertos;
		if (_hayCaja) then
			{
			_unit stop false;
			_target setVariable ["busy",true];
			_hmd = hmd _target;
			_unit doMove (getPosATL _target);
			_unit groupChat "Picking NV Googles";
			_timeOut = time + 60;
			waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
			if (_unit distance _target < 3) then
				{
				_unit action ["rearm",_target];
				_unit linkItem _hmd;
				_target unlinkItem _hmd;
				}
			else
				{
				_unit groupChat "Cannot pick those NV Googles";
				};
			_target setVariable ["busy",nil];
			_unit doFollow player;
			};
		};
	};
_hayCaja = false;
if (not(headgear _unit in genHelmets)) then
	{
	_necesita = true;
	_hayCaja = false;
	_distancia = 50;
	{
	_muerto = _x;
	_busy = _muerto getVariable "busy";
	if (((headgear _muerto) in genHelmets) and (isNil "_busy")) then
		{
		_target = _muerto;
		_hayCaja = true;
		_distancia = _muerto distance _unit;
		};
	} forEach _muertos;
	if ((_hayCaja) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		_target setVariable ["busy",true];
		_casco = headgear _target;
		_unit doMove (getPosATL _target);
		_unit groupChat "Picking a Helmet";
		_timeOut = time + 60;
		waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if (_unit distance _target < 3) then
			{
			_unit action ["rearm",_target];
			_unit addHeadgear _casco;
			removeHeadgear _target;
			}
		else
			{
			_unit groupChat "Cannot pick this Helmet";
			};
		_target setVariable ["busy",nil];
		_unit doFollow player;
		};
	};

if (!_necesita) then {_unit groupChat "No need to rearm"} else {_unit groupChat "Rearming Done"};
_unit setVariable ["rearming",false];