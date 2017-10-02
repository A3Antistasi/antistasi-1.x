private ["_unit","_muzzle","_enemy"];

_unit = _this select 0;
_ayudado = _this select 1;

if (time < _unit getVariable ["smokeUsed",time - 1]) exitWith {};

if (vehicle _unit != _unit) exitWith {};

_unit setVariable ["smokeUsed",time + 60];

_muzzle = [_unit] call returnMuzzle;
if (_muzzle !="") then
	{
	_enemy = _ayudado findNearestEnemy _unit;
	if (!isNull _enemy) then
		{
		if (([objNull, "VIEW"] checkVisibility [eyePos _ayudado, eyePos _enemy]) > 0) then
			{
			_unit stop true;
			_unit doWatch _enemy;
			_unit lookAt _enemy;
			_unit doTarget _enemy;
			if (_unit != _ayudado) then {sleep 5} else {sleep 1};
			_unit forceWeaponFire [_muzzle,_muzzle];
			_unit stop false;
			_unit doFollow (leader _unit);
			};
		};
	};
