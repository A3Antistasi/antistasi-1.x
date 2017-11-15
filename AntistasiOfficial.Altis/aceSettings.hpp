
    class ace_medical_level {
        title = "$STR_ACE_MEDICAL_LEVEL";
        ACE_setting = 1;
        values[] = {1, 2};
        texts[] =  {"Basic", "Advanced"};
        default = 1;
        typeName = "SCALAR";
        force = 0;
    };

    class ace_interaction_enableTeamManagement {
        title = "$STR_ACE_ENABLE_TEAM_MANAGEMENT";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 0;
        typeName = "BOOL";
        force = 1;
    };

    class ace_missileguidance_enabled {
        title = "$STR_ACE_LAUNCHERS";
        ACE_setting = 1;
        values[] = {0,1,2};
        texts[] = {"Off","On", "Not quite sure"};
        default = 2;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_map_BFT_HideAiGroups {
        title = "$STR_ACE_HIDE_AI_GROUPS_ON_MAP";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_map_BFT_ShowPlayerNames {
        title = "$STR_ACE_SHOW_PLAYER_NAMES_MAP";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_map_defaultChannel {
        title = "$STR_ACE_MAP_DEFAULT_CHANNEL";
        ACE_setting = 1;
        values[] = {0,5};
        texts[] = {"0","5"};
        default = 5;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_medical_increaseTrainingInLocations {
        title = "$STR_ACE_LOCATIONS_BOOST_MEDICAL_TRAINING";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_medical_enableRevive {
        title = "$STR_ACE_MEDICAL_E_REV";
        ACE_setting = 1;
        values[] = {0,2};
        texts[] = {"0","2"};
        default = 2;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_medical_maxReviveTime {
        title = "$STR_ACE_MAN_RT";
        ACE_setting = 1;
        values[] = {0,150,300};
        texts[] = {"0","150","300"};
        default = 300;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_medical_litterCleanUpDelay {
        title = "$STR_ACE_MEDICAL_CLEAN_ULD";
        ACE_setting = 1;
        values[] = {0,300, 600};
        texts[] = {"0","300","600"};
        default = 600;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_medical_medicSetting_basicEpi {
        title = "$STR_ACE_FULL_HEAL_OEIRTM";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 0;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_microdagr_mapDataAvailable {
        title = "$STR_ACE_MDAGR_MF";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_repair_repairDamageThreshold_engineer {
        title = "$STR_ACE_HOW_MDCAER";
        ACE_setting = 1;
        values[] = {0,0.5,1};
        texts[] = {"0","Half","Full"};
        default = 1;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_repair_fullRepairLocation {
        title = "$STR_ACE_FULL_RL";
        ACE_setting = 1;
        values[] = {0,3};
        texts[] = {"Anywhere","Repair Facility"};
        default = 3;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_repair_engineerSetting_fullRepair {
        title = "$STR_ACE_WHO_CPEAFR";
        ACE_setting = 1;
        values[] = {0,1,2};
        texts[] = {"Anybody","Engineers","Repair Specialists"};
        default = 1;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_advanced_fatigue_enabled {
        title = "$STR_ACE_ADVANCED_FATIQUE";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 0;
        typeName = "BOOL";
        force = 1;
    };

    class ace_advanced_fatigue_performanceFactor {
        title = "$STR_ACE_ADVANCED_FATIQUE_PF";
        ACE_setting = 1;
        values[] = {0,1.5};
        texts[] = {"0","1.5"};
        default = 1.5;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_advanced_fatigue_recoveryFactor {
        title = "$STR_ACE_ADVANCED_FATIQUE_RF";
        ACE_setting = 1;
        values[] = {0,1.5};
        texts[] = {"0","1.5"};
        default = 1.5;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_advanced_fatigue_terrainGradientFactor {
        title = "$STR_ACE_ADVANCED_FATIQUE_TGF";
        ACE_setting = 1;
        values[] = {0,0.6};
        texts[] = {"0","0.6"};
        default = 0.6;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_explosives_explodeOnDefuse {
        title = "$STR_ACE_EXP_EOD";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 0;
        typeName = "BOOL";
        force = 1;
    };

    class ace_advanced_ballistics_enabled {
        title = "$STR_ACE_AD_BAL";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_advanced_ballistics_disabledInFullAutoMode {
        title = "$STR_ACE_DISABLE_AD_BIFA";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_advanced_ballistics_simulationRadius {
        title = "$STR_ACE_AD_BSR";
        ACE_setting = 1;
        values[] = {0,1500};
        texts[] = {"0","1500"};
        default = 1500;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_map_mapIllumination {
        title = "$STR_ACE_ML";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Deactivated","Activated"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_repair_wheelRepairRequiredItems {
        title = "$STR_ACE_WHEEL_RRT";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"None","Toolkit"};
        default = 1;
        typeName = "SCALAR";
        force = 1;
    };