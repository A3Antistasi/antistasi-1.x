

autoSaveTest = {

	for "_i" from 5 to 1 step -1 do{

		//move saves
		_saveName1 = ("antistasi_autoSave_" + str _i);
		_save1 = profileNamespace getVariable _saveName1;
		_saveName2 = ("antistasi_autoSave_" + str (_i+1));
	 	profileNamespace setVariable [_saveName2,_save1];

	 	//create new
		if(_i == 1)then{
			_newsave call newSave;
			profileNamespace setVariable [_saveName1,_newsave];
		};

	};

	saveProfileNamespace;
};

_b = "test";

_name = QUOTE(_b);

diag_log ["tet",[_name,_b]];