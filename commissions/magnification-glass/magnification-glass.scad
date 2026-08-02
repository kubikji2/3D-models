//tohle je model, kdyby ses náhodou nudil a povedlo se ti to líp, tak placka je válec s poloměrem 45mm a výškou 15mm, držadlo je vytažené z eplipsoidu, který jsem ve scatchapu udělal tak, že jsem si udělal kolmice s průnikem uprostřed, jedna úsečka má 32mm, druhá na ni kolmá 15mm udělal kružnici ze středu s r=15mm a poté jsem ji roztáhl do krajů té 32mm úsečky, a poté vytažená elipsoida 100mm, poté napojil válec na tuto rukojeť (ale mě ta rukojeť vždy vyčnívala... takže mám pak ty rozměry v modelu co posílám jiné, protože jsem to držadlo tam nahoře zúžil a zašoupnul do válce)

module mg(){
    scale([32/15,1,1]) cylinder(d1=15,d2=12,h=100);
    
    translate([0,0,140]) rotate([90,0,0])
    difference()
    {
        cylinder(r=45,h=15,center=true);
    //translate([0,0,5]) cylinder();
    }
}


$fn = 250;

//%import("placka_003.stl");
translate([]) rotate([90,0,135]) color([0.5,0.5,0.5]) mg();