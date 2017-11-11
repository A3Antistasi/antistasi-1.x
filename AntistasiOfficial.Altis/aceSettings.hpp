
    class ace_medical_level {
        title = "ACE: Medical Level";
        ACE_setting = 1;
        values[] = {1, 2};
        texts[] =  {"Basic", "Advanced"};
        default = 1;
        typeName = "SCALAR";
        force = 0;
    };

    class ace_interaction_enableTeamManagement {
        title = "ACE: Enable Team Management";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 0;
        typeName = "BOOL";
        force = 1;
    };

    class ace_missileguidance_enabled {
        title = "ACE: Launchers";
        ACE_setting = 1;
        values[] = {0,1,2};
        texts[] = {"Off","On", "Not quite sure"};
        default = 2;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_map_BFT_HideAiGroups {
        title = "ACE: Hide AI groups on map?";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_map_BFT_ShowPlayerNames {
        title = "ACE: Show player names map?";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_map_defaultChannel {
        title = "ACE: Map default channel";
        ACE_setting = 1;
        values[] = {0,5};
        texts[] = {"0","5"};
        default = 5;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_medical_increaseTrainingInLocations {
        title = "ACE: Locations boost medical training?";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_medical_enableRevive {
        title = "ACE: Medical, enable revive?";
        ACE_setting = 1;
        values[] = {0,2};
        texts[] = {"0","2"};
        default = 2;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_medical_maxReviveTime {
        title = "ACE: Max revive time?";
        ACE_setting = 1;
        values[] = {0,150,300};
        texts[] = {"0","150","300"};
        default = 300;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_medical_litterCleanUpDelay {
        title = "ACE: Medical, clean up litter delay?";
        ACE_setting = 1;
        values[] = {0,300, 600};
        texts[] = {"0","300","600"};
        default = 600;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_medical_medicSetting_basicEpi {
        title = "ACE: Full heal on epi injection restricted to medic?";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 0;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_microdagr_mapDataAvailable {
        title = "ACE: MicroDAGR map fill";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_repair_repairDamageThreshold_engineer {
        title = "ACE: How much damage can an engineer repair?";
        ACE_setting = 1;
        values[] = {0,0.5,1};
        texts[] = {"0","Half","Full"};
        default = 1;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_repair_fullRepairLocation {
        title = "ACE: Full repair locations?";
        ACE_setting = 1;
        values[] = {0,3};
        texts[] = {"Anywhere","Repair Facility"};
        default = 3;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_repair_engineerSetting_fullRepair {
        title = "ACE: Who can perform a full repair?";
        ACE_setting = 1;
        values[] = {0,1,2};
        texts[] = {"Anybody","Engineers","Repair Specialists"};
        default = 1;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_advanced_fatigue_enabled {
        title = "ACE: Advanced Fatigue";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 0;
        typeName = "BOOL";
        force = 1;
    };

    class ace_advanced_fatigue_performanceFactor {
        title = "ACE: Advanced Fatigue performance factor";
        ACE_setting = 1;
        values[] = {0,1.5};
        texts[] = {"0","1.5"};
        default = 1.5;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_advanced_fatigue_recoveryFactor {
        title = "ACE: Advanced Fatigue recovery factor";
        ACE_setting = 1;
        values[] = {0,1.5};
        texts[] = {"0","1.5"};
        default = 1.5;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_advanced_fatigue_terrainGradientFactor {
        title = "ACE: Advanced Fatigue terrain gradient factor";
        ACE_setting = 1;
        values[] = {0,0.6};
        texts[] = {"0","0.6"};
        default = 0.6;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_explosives_explodeOnDefuse {
        title = "ACE: Explosives explode on defusal?";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 0;
        typeName = "BOOL";
        force = 1;
    };

    class ace_advanced_ballistics_enabled {
        title = "ACE: Advanced ballistics?";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_advanced_ballistics_disabledInFullAutoMode {
        title = "ACE: Disable Advanced Ballistics in full auto?";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_advanced_ballistics_simulationRadius {
        title = "ACE: Advanced ballistics simulation radius";
        ACE_setting = 1;
        values[] = {0,1500};
        texts[] = {"0","1500"};
        default = 1500;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_map_mapIllumination {
        title = "ACE: Map Illumination";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Deactivated","Activated"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_repair_wheelRepairRequiredItems {
        title = "ACE: Wheel repair requires toolkit";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"None","Toolkit"};
        default = 1;
        typeName = "SCALAR";
        force = 1;
    };
