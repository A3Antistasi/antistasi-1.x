/****************************************************************
File: UPSMON_filterbuilding.sqf
Author: Azroul13

Description:
	Filter the building, avoid bridge building or building with no position.

Parameter(s):
	<--- Building
Returns:
	boolean
****************************************************************/

private ["_bld","_marker","_return","_in","_UPSMON_Bld_remove"];

_bld = _this select 0;
_marker = _this select 1;
_return = false;
_in = true;

_UPSMON_Bld_remove = ["Bridge_PathLod_base_F","Land_Slum_House03_F","Land_Bridge_01_PathLod_F","Land_Bridge_Asphalt_PathLod_F","Land_Bridge_Concrete_PathLod_F","Land_Bridge_HighWay_PathLod_F","Land_Bridge_01_F","Land_Bridge_Asphalt_F","Land_Bridge_Concrete_F","Land_Bridge_HighWay_F","Land_Canal_Wall_Stairs_F","cmp_shed_f","cargo40_blue_f","research_house_v1_f","cargo_house_v1_f","u_shed_ind_f"];
if (!((typeof _bld) in _UPSMON_Bld_remove)) then
{
	If (_marker != "") then
	{
		_in = [getposATL _bld,_marker] call UPSMON_pos_fnc_isBlacklisted;
	};
	if (_in) then
	{
		if ([_bld,1] call BIS_fnc_isBuildingEnterable) then
		{
			_return = true;
		};
	};
};

_return;