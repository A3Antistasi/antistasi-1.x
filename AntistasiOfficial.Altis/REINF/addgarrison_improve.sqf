//Project:

//1) Assign an AI group to Garrison
    //input (valid for only 1 group so far)
    _group = groupSelectedUnits player; //will this work for High command bar?
    _pos = getpos _group
    _marker = [markers,_pos] call BIS_Fnc_nearestPosition;
    //input checks
    if (_pos distance _marker > 50) exitWith  {hint "Bring units closer to the emplacement"};
      
    //add unit-type to garrison and delete previous units
    
    
    
//2) Assign a vehicle as garrison
    //input
    _veh = cursorobject //using Y menu
    _pos = getpos _veh
    _marker = [markers,_pos] call BIS_Fnc_nearestPosition;
    
    
    //checks
    //if is vehicle, and alive
    if (_pos distance _marker > 50) exitWith  {hint "Bring units closer to the emplacement"};
    
    //WiP
