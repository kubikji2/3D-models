// METRIC GEAR
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//    Written by Gerald Guy Lafreniere (aka spingoogL). Journeyman Red Seal Machinist.



// DEFINE THESE FOR THE GEAR PROFILE.
    MetricModule=1.5;
    NumberOfTeeth=42; // Integer as big as your CPU can handle, but smaller than 4 may not work.
    PressureAngle=20;
    HelixAngle=-30; // Positive number for LeftHand, Negative number for RightHand
    AngularResolution=1; // 1 works good, smaller gives higher resolution.
    Width=10; // Width = Thickness of gear
    LayerThickness=1; // measured in mm
    BackLash=0.01; // Multiplied by the circular pitch to add clearance at the Pitch Diameter.


////////////////////////////////
/////    START GEAR INFO   /////
////////////////////////////////    

m=MetricModule; // Smaller value indicates a smaller tooth profile, must be same for two gears to mesh.
mstr=str("\nMODULE:\t\t",m);
n=NumberOfTeeth; // Used to determine arc size at root and crest of gear.
nstr=str("\t\tNUMBER OF TEETH:\t",n);
pa=PressureAngle; // 0<90.  Standards are 14.5, 20, 25 degrees.  A smaller angle creates a weaker tooth
			// A larger angle creates a stronger tooth, but puts more pressure on the bearing.
pastr=str("\nPRESSURE ANGLE:\t",pa);
ha=HelixAngle; // 0 to < 90, 0 makes a straight spur gear, a 90 would make round grooves, 
			//and a division by zero.  Value is needed to calculate corrected circular pitch
hastr=str("\t\tHELIX ANGLE:\t\t",ha);
r=AngularResolution;   // How many points will define the full involute profile. 1 will creates 90 points. 2=>45. 0.1=>900
    bl=BackLash;
    rstr=str("\nRESOLUTION:\t\t",r);
	pi=3.141592654;
    gearstr=str("\n---------- USER DEFINED ----------\nMODULE:\t",m,"\t\tNUMBER OF TEETH:\t",n,"\nPRESSURE ANGLE:\t",pa,"\t\tHELIX ANGLE:\t\t",ha,"\n---------- CALCULATED ----------");

// Spur and Helical Gear variables

		//Circular Pitch, Corrected Circular Pitch
//	cp=cos(ha)*(pi/dp);
    cp=pi*m;
    ccp=pi*m/cos(ha); // corrected cp
    cpstr=str("\nCircluarPitch:\t\t",cp);
    ccpstr=str("\t\tCorrectedCP:\t",ccp);

		//Pitch Diameter
	pd=(n*ccp)/pi;
    pdr=pd/2;
    pdstr=str("\nPitch Diameter:\t\t",pd);
    pdrstr=str("\t\tPitch Radius:\t",pdr);

		//Outside Diameter
	od=pd+m+m;
    odr=od/2;
    odstr=str("\nOutside Diameter:\t",od);
    odrstr=str("\t\tOD Radius:\t",odr);

		//Addendum
	a=cp/pi;
    astr=str("\nAddendum:\t\t",a);

		//Dedendum
    d=(cp/20)+a;
    dstr=str("\t\tDedendum:\t",d);

        //Clearance
    cl=cp/20;
    clstr=str("\nClearance:\t\t",cl);
    
		//Whole Depth
	wd=a+d;
    wdstr=str("\t\tWhole Depth:\t",wd);

		//Chordal (corrected) addendum
	ca=( (1 - cos ( 90 / n )) * ( pd / 2) ) + a;
    castr=str("\nChordal Addendum:\t",ca);

        //Chordal thickness
    ct=sin(90/n)*pd;
    ctstr=str("\t\tChordal Thickness:  ",ct);

		//Base Circle
	bc=pd*cos(pa);
    bcstr=str("\nBase Circle Diameter:\t",bc);
    bcr=bc/2;
    bcrstr=str("\t\tBase Circle Radius:  ",bcr);

		//Root Diameter, and Root Radius
	rd=pd-d-d;
    rdstr=str("\nRoot Diameter:\t\t",rd);
	rr=rd/2;
    rrstr=str("\t\tRoot Radius:\t",rr);

        //Minor Diameter ( without clearance )
    md=pd-a-a;
    mdstr=str("\nMinor Diameter:\t\t",md);
    mdr=md/2;
    mdrstr=str("\t\tMinor Radius:\t",mdr);
    
		//Tooth Thickness
	tt=cp/2;
    ttstr=str("\nTooth Thickness(arc):\t",tt);
    
        //Tooth Angles
    ta=360/n;
    tastr=str("\nTooth Angle:\t",ta);
    tta=ta/2;
    ttastr=str("\t\tTooth Thickness Angle:\t",tta);


    gearInfo=str(
        "---GEAR INFORMATION---\"",
        "\n---------- USER DEFINED ----------",
        mstr, nstr, pastr, hastr, rstr,
        "\n---------- CALCULATED ----------",
        cpstr, ccpstr, pdstr, pdrstr, odstr, odrstr,
        astr, dstr, clstr, wdstr, castr, ctstr,
        bcstr, bcrstr, rdstr, rrstr, mdstr, mdrstr,
        ttstr, pdrstr, tastr, ttastr,
        "\n----------\n");
    echo(gearInfo);
//////////////////////////////
/////    END GEAR INFO   /////
//////////////////////////////

/////////////////////////////////////////////
/////   START OF INVOLUTE GENERATION    /////
/////////////////////////////////////////////


// Set Values based on whether the Base Circle is larger than the clearance point.
// Define Involute Angle at the therhetical root of the profile.
IARoot= bcr > pdr-a ? 0 : getInvoluteAngleAtRadius(pdr-a);
//echo(IARoot);

// Define the Clearance Point.  Either on the X axis or in the Involute Profile
ClearancePT= bcr > pdr-a ? [pdr-a,0] : getInvoluteCoordinateAtAngle(IARoot);
//echo(ClearancePT);

// Find Involute Angle at OD.  The angle value may be misleading if you look hard at it.
// It is a value used for creating the involute form, not for polar location of the point.
// Set IAEnd
IAMajor=getInvoluteAngleAtRadius(odr);
//echo(IAMajor);

// PointList that defines Flank A of tooth form. Uses IAEnd and IAStart.
// Points need to start at the OD and end at the root.
InvPTsA=involuteFuncReverse(IAMajor, IARoot);
//echo(InvPTsA);

// PointList that defines Flank B of tooth form. Uses IAStart and IAEnd.
// Points need to start from the root of the tooth and end at the OD.
InvPTsB=involuteFunc(IARoot, IAMajor);
//echo(InvPTsB);

// Add Bevel point in Clearance zone at root. Equal to Clearance dimension.
// Flank Bevel Point Calculation
BevelPT=[ClearancePT[0]-cl,ClearancePT[1]-cl];
//echo(BevelPT);

// Defince OD point
ODpt=getInvoluteCoordinateAtRadius(odr+2);
//echo(ODpt);

// Add bevel point to end of Involute form A.
FlankPTsA=concat([[ODpt[0]+(2*wd),0]], [[ODpt[0]+(2*wd),ODpt[1]]], InvPTsA, [ClearancePT], [BevelPT]);
//echo(FlankPTsA);

// Add bevel point to start of Involute form B, and OD point to end.
FlankPTsB=concat([BevelPT], [ClearancePT], InvPTsB, [ODpt], [[ODpt[0]+(2*wd),ODpt[1]]]);
//echo(FlankPTsB);

// Define Pitch Diameter Point
PitchPT=getInvoluteCoordinateAtRadius(pdr);
//echo(PitchPT);

// Get Polar Coordinate at Pitch Diameter
PitchPPT=getPolarFromCoordinate(PitchPT);
//echo(PitchPPT);

// Rotate FlankPTsA, compensate for start angle
RotFlankPTsA=rotatePointsOnOrigin(FlankPTsA,((tta*bl)+tta/2)-PitchPPT[1] );
//echo(RotFlankPTsA);

// Rotate FlankPTsB
RotFlankPTsB=rotatePointsOnOrigin(FlankPTsB,((tta*bl)+tta/2)-PitchPPT[1] );
//echo(RotFlankPTsB);

// Mirror RotFlankPTsB
MirRotFlankPTsB=mirrorPointsOnXAxis(RotFlankPTsB);
//echo(MirRotFlankPTsB);

// Combine flank profiles
ToothProfilePTs=concat( RotFlankPTsA, MirRotFlankPTsB);
//echo(ToothProfilePTs);

module ToothProfile(){
    polygon(ToothProfilePTs);
}

// Copy and rotate points to complete 2D gear profile.
module ToothForm(){
	for ( i = [0:n]){
		rotate( i * 360 /n, [0,0,1])
		//translate([0,2.625,0])
		ToothProfile();
	}
}

TWISTEDAngle=360 * ( (tan(ha)*Width ) / ( pd * pi ) );
SLICED=Width/LayerThickness;
//echo(SLICED);

    ///////////////////////////////////////////////////////
    //////////  THIS IS THE DRAWING OF THE GEAR  //////////
    ///////////////////////////////////////////////////////
union(){
    mirror(v= [0,0,1]){
        difference(){
            cylinder (h = Width/2, r=odr, center = false, $fn=64, convexity=10);
            linear_extrude( height=Width+1, twist=TWISTEDAngle, center=true, slices=SLICED, convexity=10){
                ToothForm();
            }
        }
    }
    difference(){
        cylinder (h = Width/2, r=odr, center = false, $fn=64, convexity=10);
        linear_extrude( height=Width+1, twist=TWISTEDAngle, center=true, slices=SLICED, convexity=10){
            ToothForm();
        }
    }
}

///////////////////////////////////////////
/////   END OF INVOLUTE GENERATION    /////
///////////////////////////////////////////

//////////////////////////////////////////////
/////   START OF FUNCTION DEFINITIONS    /////
//////////////////////////////////////////////


// Low budget function to rotate points around [0,0]
function rotatePointsOnOrigin(PTlist,ANGLE)= [for (PT=PTlist)
            let(
            POLARpt=getPolarFromCoordinate(PT),
            NEWangle=ANGLE+POLARpt[1],
            NEWpt=getCoordinateFromPolar([POLARpt[0],NEWangle])
            )
            [NEWpt[0],NEWpt[1]]
            ];

// Low budget function to mirror points along the X axis. Simply inverts Y.
function mirrorPointsOnXAxis(PTlist)= [for (PT=PTlist)
            let(
            NEWy=-1*PT[1]
            )
            [PT[0],NEWy]
            ];


function getMinorInvoluteRadius()=
            (rr>=bcr) ? rr : bcr;
            
function involuteFunc(START,END) = [for (ia=[START:r:END]) 
            let (
            s=(bc*pi)*(ia/360),
            Xc=bcr*cos(ia),
            X=Xc+(s*sin(ia)),
            Yc=bcr*sin(ia),
            Y=Yc-(s*cos(ia))
            )
            //if ( X<=odr)
            [X,Y] 
            ];

function involuteFuncReverse(START,END) = [for (ia=[START:-r:END]) 
            let (
            s=(bc*pi)*(ia/360),
            Xc=bcr*cos(ia),
            X=Xc+(s*sin(ia)),
            Yc=bcr*sin(ia),
            Y=Yc-(s*cos(ia))
            )
            [X,Y] 
            ];

function getInvoluteCoordinateAtRadius(RAD) =  
            let (
            ANG=getInvoluteAngleAtRadius(RAD),
            PT=getInvoluteCoordinateAtAngle(ANG)
            )
            [PT[0],PT[1]]
            ;

// This defines a point where a line interscts the involute profile.
function getInvoluteCoordinateAtAngle(ANG)= 
            let(
            s=(bc*pi)*(ANG/360),
            Xc=bcr*cos(ANG),
            X=Xc+(s*sin(ANG)),
            Yc=bcr*sin(ANG),
            Y=Yc-(s*cos(ANG))
            )
            [X,Y]
            ;

function getInvoluteAngleAtRadius(RAD) = 
            (360*(sqrt((RAD*RAD)-(bcr*bcr))))/(2*pi*bcr);


// Low budget
function getPolarFromCoordinate(PT)=
            let(
            X=PT[0],
            Y=PT[1],
            R=sqrt(pow(X,2)+pow(Y,2)),
            A=atan(Y/X)
            )
            [R,A]
            ;

// Low budget
function getCoordinateFromPolar(PPT)=
            let(
            X=cos(PPT[1])*PPT[0],
            Y=sin(PPT[1])*PPT[0]
            )
            [X,Y];
////////////////////////////////////////////
/////   END OF FUNCTION DEFINITIONS    /////
////////////////////////////////////////////
