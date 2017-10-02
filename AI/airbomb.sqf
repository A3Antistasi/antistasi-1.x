if (not isServer) exitWith {};

_plane = _this select 0;

_ammo = "Bomb_03_F";
_cuenta = 8;
_cluster = false;
if (count _this > 1) then
	{
	_ammo = "G_40mm_HEDP";
	if (_this select 1 == "NAPALM") then {_cuenta = 24} else {_cuenta = 48};
	_cluster = true;
	};

sleep random 5;

for "_i" from 1 to _cuenta do
	{
	if (!_cluster) then {sleep 0.6} else {sleep 0.1};
	if (alive _plane) then
		{
		_bomb = _ammo createvehicle ([getPos _plane select 0,getPos _plane select 1,(getPos _plane select 2)- 4]);
		waituntil {!isnull _bomb};
		_bomb setDir (getDir _plane);
		if (!_cluster) then
			{
			_bomb setVelocity [0,0,-50]
			}
		else
			{
			if (_this select 1 == "NAPALM") then
				{
				_bomb setVelocity [-5 + (random 10),-5 + (random 10),-50];
				[_bomb] spawn
					{
					_bomba = _this select 0;
					_pos = [];
					while {!isNull _bomba} do
						{
						_pos = getPosASL _bomba;
						sleep 0.1;
						};
					[[_pos],"AI\napalm.sqf"] remoteExec ["execVM",[0,-2] select isDedicated,true];
					};
				}
			else
				{
				_bomb setVelocity [-35 + (random 70),-35 + (random 70),-50];
				};
			};
		/*
		_bomb setCenterOfMass [0,1,0];
		_bomb setMass 100;
		_bomb setVelocity [0,0,-300];
		_bomb setVectorDirAndUp [[0,0,-1],[0,0.8,0]];
		*/
		};
};
