params ["_vehicle"];

sleep 5;

if (isNull _vehicle) exitWith {};

if (!alive _vehicle) then {
	_vehicle hideObjectGlobal true;
	deleteVehicle _vehicle;
};