params ["_vehicle"];

sleep 5;

if( ({_x distance _vehicle < 100} count (allUnits select {(side _x == side_blue)})) > 1 ) exitWith {};
if (isNull _vehicle) exitWith {};

if (!alive _vehicle) then {
	_vehicle hideObjectGlobal true;
	deleteVehicle _vehicle;
};