use<makerbeam-model.scad>


function makerbeam_get_color_based_on_length(length) = 
    length == 300 ?  "orangered" :
        length == 200 ? "gold" :
            length == 150 ? "limegreen":
                length == 100 ? "dodgerblue" : "dimgray";

module makerbeam_prefab(length, align="", zet="")
{

    _clr = makerbeam_get_color_based_on_length(length);

    color(_clr)
        makerbeam(length=length, align=align, zet=zet);
}