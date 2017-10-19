params ["_weapon"];
private _return = "";
switch (_weapon) do {
	case "rhs_weap_svd": {
		_return = "rhs_weap_svds";
	};
	default {
		_return = "hgun_PDW2000_F";
	};
};
_return