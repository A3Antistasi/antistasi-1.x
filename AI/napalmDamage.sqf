_pos = _this select 0;

_argumentos = ["Car","Truck","Man","Air"];

if (isServer) then {_argumentos = ["All", "", "House", "Wall"]};
_timeOut = time + 70;
while {time < _timeOut} do
	{
	_units = nearestobjects [_pos, _argumentos, 70];
	{
	if (local _x) then
		{
		if (not(_x isKindOf "Tank")) then
			{
			if (alive _x) then
				{
				_distMult = (1-((_x distance _pos)/70))/2;
				if (_x isKindOf "Man") then
					{
					_dam = damage _x + _distMult;
					if ((_dam >= 1) and (isPlayer _x)) then
						{
						_x setdamage 0;
						_x setVariable ["inconsciente",true,true];
						[_x] spawn respawn;
						}
					else
						{
						_x setDamage _dam;
						};
					if (_x isKindOf "CAManBase") then
						{
						[_x] spawn
							{
							_tipo = _this select 0;
							sleep random 3;
							playSound3D [(injuredSounds call BIS_fnc_selectRandom),_tipo];
							};
						};
					}
				else
					{
					if ((_x isKindOf "Truck") or (_x isKindOf "Car") or (_x isKindOf "Air")) then
						{
						_x setDamage (damage _x + (_distMult/2));
						}
					else
						{
						if (_x isKindOf "Building") then
							{
							_x setDamage (damage _x + (_distMult/16));
							}
						else
							{
							 if (str _x find ": t_" > -1) then
							 	{
							 	_x setDamage 1;
							 	}
							 else
							 	{
							 	_x setDamage (damage _x + (_distMult/4));
							 	};
							};
						};
					};
				};
			};
		};
	} forEach _units;
	sleep 5;
	};