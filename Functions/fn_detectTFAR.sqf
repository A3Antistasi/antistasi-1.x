activeTFAR = false;

if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
    activeTFAR = true;
    unlockedItems pushBackUnique "ItemRadio";
	unlockedItems pushBackUnique guer_radio_TFAR;
    tf_no_auto_long_range_radio = true; publicVariable "tf_no_auto_long_range_radio";
	tf_west_radio_code = ""; publicVariable "tf_west_radio_code";
	tf_east_radio_code = tf_west_radio_code; publicVariable "tf_east_radio_code";
	tf_guer_radio_code = tf_west_radio_code; publicVariable "tf_guer_radio_code";
	tf_same_sw_frequencies_for_side = true; publicVariable "tf_same_sw_frequencies_for_side";
	tf_same_lr_frequencies_for_side = true; publicVariable "tf_same_lr_frequencies_for_side";
};