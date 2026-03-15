include<spool-rack-parameters.scad>

_r = sr_rod_d/2;
_R = sr_filament_spool_max_d/2;
rod_spacing = 2*sqrt((_R+_r)*(_R+_r) - (_R-_r)*(_R-_r));
echo(rod_spacing);