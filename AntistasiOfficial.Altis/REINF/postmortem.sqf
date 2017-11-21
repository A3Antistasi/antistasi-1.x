
if(isNil "postmortem_array") then {
    postmortem_array = [];
    [] spawn {
            scriptName "postmortem_cycle";
            while {true} do {
                if (postmortem_array isEqualTo []) then {
                    sleep 60;
                }else{
                    (postmortem_array deleteAt 0) params ["_what","_when"];
                    _when = _when - diag_tickTime;
                    if ( _when > 1 ) then {sleep _when;};
                    deleteVehicle _what;
                    private _group = group _what;
                    if (!isNull _group) then {
                        if ({alive _x} count units _group == 0) then {deleteGroup _group};
                    }else{
                        if (_what in staticsToSave) then {staticsToSave = staticsToSave - [_what]; publicVariable "staticsToSave";};
                    };
                };
            };
    };
};

params ["_dead",["_cleanTOut",cleantime]];
postmortem_array pushBack [_dead, diag_tickTime + _cleanTOut];
