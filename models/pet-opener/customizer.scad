use<pet-opener.scad>

$fn = $preview ? 36 : 72;


// lever parameters
lever_diameter = 20;
lever_length = 60;

pet_bottle_opener(  lever_diameter=lever_diameter,
                    lever_length=lever_length);