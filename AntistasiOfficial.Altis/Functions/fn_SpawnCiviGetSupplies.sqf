params ["_pos"];
diag_log format ["position of crate1 = %1",_pos];
systemchat format ["position of crate1 = %1",_pos];
private ["_pos"];

_civcount = {side _x == civilian} count allunits;
if (_civcount < 50) then {
  _group = createGroup civilian;

  for "_i" from 0 to 8 do{
      _buildings = nearestObjects [_pos, ["House", "Building"], 100];
      _civhouse =  position (selectrandom _buildings);
      _civType = selectRandom CIV_units;
      _civ = _group createunit [_civType, _civhouse, [],0, "NONE"];
    };

  {_x  domove _pos} foreach (units _group);
  sleep 120;

  _buildings = nearestObjects [_pos, ["House", "Building"], 50];
  _civhouse =  position (selectrandom _buildings);
  {_x domove _civhouse} foreach (units _group);

  sleep 30;
  {deletevehicle _x} foreach (units _group);
  deletegroup _group;
};
