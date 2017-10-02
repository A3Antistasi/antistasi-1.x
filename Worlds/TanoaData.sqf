if !(worldName == "Tanoa") exitWith {};

power = []; // power plants
bases = []; // army bases
aeropuertos = []; // airports
recursos = []; // resources
fabricas = []; // factories
puestos = []; // outposts
puestosAA = []; // AA outposts
puertos = []; // harbours
controles = []; // roadblocks
colinas = []; // mountaintops
colinasAA = []; // mountaintops for special purposes (compositions, etc)
artyEmplacements = []; // artillery encampments
seaMarkers = []; // naval patrol zones

posAntenas = [[10113.9,11743.3,0],[2682.73,2592.63,0],[10950,11518,0],[9118.67,10182,0.000680923],[9565.26,9109.53,2.04544],[12705.9,7460.76,-0.00025177],[6882.55,7518.02,-2.38419e-007],[10756.4,6314,0.000848293],[6029.12,10158.8,0],[14183.9,8544.25,-3.91006e-005],[13186.6,11974.7,0],[11741.6,13086.5,-1.04904e-005],[11527.3,13155.8,0],[8379.38,13613,-0.000881195],[4209.16,11728.2,0.00281525],[2666.99,11680,0],[2671.42,12314.2,-0.000335693],[2327.81,13462.8,2.00272e-005],[2196.15,13196,9.53674e-007],[3921.22,13869.6,0.000519753],[2012.83,6502.85,0.914762],[2068.3,3431.05,1.77652],[5664.71,4959.17,0],[9350.2,4185.88,0.991756],[12528.7,2441.39,-0.000589848],[11770.4,2975.41,-7.39098e-005],[11196.7,5084.55,0.000939369],[12806.7,4898.42,3.98159e-005],[12432.9,14247.8,1.07415]];

posbancos = [];

safeDistance_undercover = 250;
safeDistance_garage = 200;
safeDistance_recruit = 200;
safeDistance_garrison = 200;
safeDistance_fasttravel = 250;

static_defPosHQ = [5032.81,2611.2,0.00124454];

bld_smallBunker = "Land_BagBunker_01_small_green_F";