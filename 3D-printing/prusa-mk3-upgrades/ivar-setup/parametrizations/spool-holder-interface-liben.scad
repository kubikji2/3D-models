use<../spool-holder-interface.scad>


$fn = $preview?36:72;

has_interface = false;

spool_holder_interface( ziptie_thickness = 1.5,
                        ziptie_width = 4,
                        ziptie_head = has_interface ? undef : 6.5,
                        wall_thickness = 4,
                        clearance = 0.2,
                        bolt_descriptor="M3x10",
                        bolt_standard="DIN84A",
                        nut_standard="DIN934",
                        has_spool_interface=has_interface);