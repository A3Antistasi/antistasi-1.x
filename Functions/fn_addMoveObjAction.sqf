private _objs = [];
{
	if ((  str typeof _x find "Land_Camping_Light_F" > -1
	    or str typeof _x find "Land_BagFence_Round_F" > -1
    	or str typeof _x find "CamoNet_BLUFOR_open_F" > -1))
	then {
    	_objs pushBack _x;
		};
} forEach nearestObjects [getPos fuego, [], 60];
{
	removeAllActions _x;
	_x addAction [localize "STR_ACT_MOVEASSET", {[_this select 0,_this select 1,_this select 2,"static"] spawn AS_fnc_moveObject},nil,0,false,true,"","(_this == Slowhand)", 5];
} forEach staticsToSave + _objs;