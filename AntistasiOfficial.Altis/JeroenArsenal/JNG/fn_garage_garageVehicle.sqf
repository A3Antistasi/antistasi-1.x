#include "defineCommon.inc"

params [ ["_vehicle",objNull,[objNull]] ];

//incase you are looking to attached item
if !(isnull (attachedto _vehicle))then{_vehicle = attachedto _vehicle};

//close if it couldnt save
_message = _vehicle call jn_fnc_garage_canGarageVehicle;
if!(_message isEqualTo "")exitWith {hint _message};

//check ace cargo
_aceCargo = _vehicle getVariable ["ace_cargo_loaded", []];
private _aceCargoNames = [];
if (count _aceCargo > 0) then {
    {
        private _aci = _x; // ACE Cargo Item
        // Not-spawned cargo items are stored as strings by ACE (like the default replacement wheels)
        if (_aci isEqualType objNull) then {
            if ((_aci call jn_fnc_garage_getVehicleIndex) != -1) then {
                private _dataAndIndex = _aci call jn_fnc_garage_getVehicleData;
                _dataAndIndex remoteExecCall ["jn_fnc_garage_addVehicle",2];
                private _data = _dataAndIndex select 0;
                private _name = _data select 0;
                _aceCargoNames pushBack _name;
            };
        };
    } forEach _aceCargo;
};

//save it on server
_dataAndIndex = _vehicle call jn_fnc_garage_getVehicleData;
_dataAndIndex remoteExecCall ["jn_fnc_garage_addVehicle",2];

//delete attach weapon
private _attachItems = [];
{
	private _type = (_x getVariable ["jnl_cargo",[-1,0]]) select 0;
	if(_type == 0)then{
		_x hideObject true;
		detach _x;
		deleteVehicle _x;
	};
} forEach attachedObjects _vehicle;

deleteVehicle _vehicle;

//set message it was saved
_data = _dataAndIndex select 0;
SPLIT_SAVE
if (count _aceCargo == 0) then {
    hint (_name + " has been stored in garage");
} else {
    hint ((toString ([_name] + _aceCargoNames)) + " have been stored in garage");
};
