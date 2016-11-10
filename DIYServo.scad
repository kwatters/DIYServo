module kneebottom() {
    h=61;
    w=61;
    d=61;
    cube(w,d,h,center=true);
}
    
module motorhole() {
    h = radius*2+base;
    r = 37.5/2-4;
    // min bevel gear diameter (for motor side)
    w2 = 30;
    h2 = h-base;
    d2 = r*5;
    postwidth = w2+5;
    screwClearance = 3;
    
    translate([0,0,0]) {
        cylinder(h,r,r,center=true);
    }
    translate([0,0,-motoroffset]) {
        cylinder(10,r+screwClearance,r,center=true);
    }
    translate([0,0,h2/2]) {
        union() {
            translate([0,0,0]) {
                cube([w2,d2,h2],center=true);
            } ;   
            translate([-postwidth,0,0]) {
                cube([w2,d2,h2],center=true);
            };
            translate([postwidth,0,0]) {
                cube([w2,d2,h2],center=true);
            };  
        };
    };
};
 

module motorholematch() {
    h = radius*2+base;
    r = 32/2;
    // min bevel gear diameter (for motor side)
    w2 = 30;
    h2 = h-base;
    d2 = r*5;
    postwidth = w2+30;
    translate([0,0,0]) {
        cylinder(h,r,r,center=true);
    }
    translate([0,0,base]) {
        union() {  
            translate([0,0,h2/2]) {
                cube([w2+10,d2,h2],center=true);
            };
            translate([-postwidth,0,h2/2]) {
                cube([w2,d2,h2],center=true);
            };
            translate([postwidth,0,h2/2]) {
                cube([w2,d2,h2],center=true);
            };
        };
    };
};

module base() {
    difference() {
        kneebottom();
        motorhole();        
    }
}
    
module angletop () {
    w=65;
    d=65;
    h=65;
    
    d2=30;
    
    translate([0,0,0]) {
        rotate([0,90,0]) {
            //cube([w,d,h],center=true);
            cylinder(d,d2,d2,center=true,$fn=50);
        };    
        
    };
    translate([0,0,-25]) {
        cube([w,d,h],center=true);
    };
}
    
module roundedbase() {
    intersection() {
        base();
        angletop();
    }   
} 
module screwhole() {
    // screw size
    r=3.5;
    h=86;
    rotate([0,90,0]) {
        cylinder(h,r,r,center=true,$fn=100);    
    };
    
    // TODO: want to move the hex head to the inside gear.
    hexHead();
    roundHead();
};

module gear (diam1, thick, angle, ded, add, twidth, tnumber, toothfraction) {

	//Trig to find top diameter:

	triangbase = thick / tan(angle);
	topdiameter =  (diam1 - 2 * triangbase) - ded;

	//Miscellaneous variables:

	bottomdiameter = diam1 - ded;
	howmuchistri = toothfraction * (add + ded);
	toothlength = (add + ded) - howmuchistri; 
	xthick = twidth/2;

	union() {

		difference () {

			cylinder(h = thick, r1 = bottomdiameter/2, r2 = topdiameter/2, $fn = 75, center = true);
			cylinder(h = 2*thick, r = holediam / 2, center = true, $fn = 75);
			centershape(thick, topdiameter);

			}

		}

		for ( i = [1:tnumber] ) {

			rotate( i*360/tnumber, [0, 0, 1])
			translate ([0, 0, thick / -2])

			geartooth (bottomdiameter, topdiameter, xthick, toothlength, thick, howmuchistri);

		}

}

module centershape (thick, diam) {

if (centercircles > 0) {

	for ( f = [1:centercircles] ) {

		rotate( f*360/centercircles, [0, 0, 1])
		translate ([diam/4, 0, 0 ])
		cylinder ( h = 2*thick, r = centercircdiam/2, $fn = 75, center = true);

	}

}

}

module geartooth (diam1, diam2, xthickness, tlength, zthick, point){

// Sorry... polyhedra are so messy in openSCAD
// In case you're wondering, the following polyhedra are one
// tooth. The first is rectangular, the second has triangles.

	if (point == 0) {

	polyhedron ( points = 
[[-xthickness, diam2/2, zthick], [-xthickness, tlength + diam2/2, zthick], [-xthickness, tlength + diam1/2, 0], [-xthickness, diam1/2, 0], [xthickness, diam2/2, zthick], [xthickness, tlength + diam2/2, zthick], [xthickness, tlength + diam1/2, 0], [xthickness, diam1/2, 0]
], faces = [[0,2,1], [0,3,2],[3,0,4],[1,2,5],[0,5,4],[0,1,5],[5,2,6],[7,3,4],[4,5,6],[4,6,7],[6,2,7],[2,3,7]]);

	}

	if (point > 0 ) {

		polyhedron ( points = 
[[-xthickness, diam2/2, zthick], [-xthickness, tlength + diam2/2, zthick], [-xthickness, tlength + diam1/2, 0], [-xthickness, diam1/2, 0], [xthickness, diam2/2, zthick], [xthickness, tlength + diam2/2, zthick], [xthickness, tlength + diam1/2, 0], [xthickness, diam1/2, 0],[0, tlength + diam2/2 + point, zthick],[0, tlength + diam1/2 + point, 0]
], faces = [[0,2,1], [0,3,2],[3,0,4],[1,2,8],[0,5,4],[0,1,5],[5,9,6],[7,3,4],[4,5,6],[4,6,7],[6,2,7],[2,3,7],[1,8,5],[2,6,9],[2,9,8],[5,8,9],]);

	}

}




module lloydgear() {
    basediameter = 18;   // pitch diameter of widest part 
    depth = 5;           // depth of the gear
    degrees = 90;        // base angle of the gear
    //dedendum = 1/2;      // dedendum
    dedendum = 1;      // dedendum
    addendum = 1;      // addendum
    holediam = 6;        // diameter of center hole
    teethnumber = 32;    // number of teeth
    toothwidth = 1.75;      // width of teeth
    toothshape = 1.0;   // how much of the tooth is triangular	
    maxh = 100;
    maxrad = 20;
    centeroffset = -15;
    difference() { 
        translate([0,0,0]) {
          gear(basediameter, 
             depth, 
             degrees, 
             dedendum, 
             addendum, 
             toothwidth, 
             teethnumber, 
             toothshape); 
        };
        translate([0,0,-5]) {
            shaft();
        };
    };
};


module lloydgearNoShaft() {
    basediameter = 18;   // pitch diameter of widest part 
    depth = 5;           // depth of the gear
    degrees = 90;        // base angle of the gear
    //dedendum = 1/2;      // dedendum
    dedendum = 1;      // dedendum
    addendum = 1;      // addendum
    holediam = 6;        // diameter of center hole
    teethnumber = 32;    // number of teeth
    toothwidth = 1.75;      // width of teeth
    toothshape = 1.0;   // how much of the tooth is triangular	
    maxh = 100;
    maxrad = 20;
    centeroffset = -15;
    difference() { 
        translate([0,0,0]) {
          gear(basediameter, 
             depth, 
             degrees, 
             dedendum, 
             addendum, 
             toothwidth, 
             teethnumber, 
             toothshape); 
        };
        translate([0,0,-5]) {
            shaftNoFlat();
        };
    };
};

module partwithscrewhole() {
    difference() {
        union() {
            lloydgear();
            roundedbase();
        }
        screwhole();
    }    
}


module roundbottom() {
    
    intersection() {
        cylinder(40,30,30,$fn=100);
        partwithscrewhole();
    }

}
module lloydtop() {
  
    difference() {
        translate([0,0,15]) {
            kneebottom();
        };
        translate([0,0,5]) {
            motorholematch();        
        }
    }
    
};



module roundtop() {

    intersection() {
        difference() {
            intersection() {
                cylinder(30,30,30,$fn=100);
                lloydtop();
            };
            translate([0,0,8]) {
                screwhole();
            }
        };
        translate([0,0,-2.5]) {
            angletop();  
        };      
    };

}
module baseshape() {
    // radius of the pvc pipe
    r = radius;
    // height of the part (base + curve heights)
   // base = 20;
    h = base + r;
    
    // cylinder(h,r,r,$fn=100);
    difference() {
        intersection() {
            union() {
                translate([-h/2-r/2,0,h]) {
                    rotate([0,90,0]) {
                        cylinder(h+r,r,r,$fn=resolution);
                    }
                }
                cylinder(h,r,r,$fn=resolution);
            }
            cylinder(h+2*r,r,r,$fn=resolution);
        };
        translate([0,0,base+r]) {
            screwhole();
        }
    };
}


module toppart() {
    difference() {
        union() {
            difference() {
                baseshape();
                translate([0,0,base]) {
                    motorhole();
                };
            };
            translate([0,0,base+radius]) {
                rotate([0,90,0]) {
                    biggear();
                };

            };
        };
        translate([0,0,base+radius]) {
            screwhole();
        };
    };
    motormount();
};

module bottompart() {
 
    difference() {
    baseshape();
    translate([0,0,0]) {
        motorholematch();
    }
   }
}
module biggear() {
    scale = 5;
    mask = 23.62;
    scale2= 2.25;
    scalez=5;
   
     scale([2.2,2.2,2.2]) {
  
        intersection() {
            scale([scale,scale,scale]) {
                import("c:\\BevelGears.stl", convexity=3);
            };
            rotate([0,0,45]) {
                cube([mask,mask,mask], center=true);
            };
        };
  
    };
   
};


module littlegear() {
    scale = 5;
    offset = -12.5;
    mask = 13.1;
    s2 = 2.0;
    translate([0,0,-.4]) {
    difference() {
     scale([s2,s2,s2]) {  
        intersection() {
            translate([offset+.4,offset-1.5,7]) {
                scale([scale,scale,scale]) {
                    import("c:\\BevelGears.stl", convexity=3);
                };
            };
            rotate([0,0,45]) {
                cube([mask,mask,mask], center=true);
            };
        };
        };
        shaft();
    };
};
};



module littlegearWithMountingBox() {
    x = 25.4*.707+.66;
    z = 7;
    m = 1.75;

    difference() {
        difference() {
            translate([0,0,z/2]) {
                cube([x,x,z], center=true);    
            };

            rotate([0,0,45]) {
                union() {
                    translate([-x/2,0,z-.001]) {
                            cylinder(z*2,m,m, center=true, $fn=resolution);
                    };
                    translate([0,-x/2,z-.001]) {
                            cylinder(z*2,m,m, center=true, $fn=resolution);
                    };
                    translate([0,x/2,z-.001]) {
                            cylinder(z*2,m,m, center=true, $fn=resolution);
                    };
                    translate([x/2,0,z-.001]) {
                            cylinder(z*2,m,m, center=true, $fn=resolution);
                    };
                };
            };
        };
        translate([0,0,-1]) {
            shaft();
        }
    };

    translate([0,0,z]) {
        rotate([0,0,-3]) {
            littlegear();
        };
    };
};

module shaftNoFlat() {
      h=20;
    diameter = 3.25;
    width=6;
    depth=6;
    height=20;
    
        cylinder(h,diameter,diameter,center=false, $fn=20);
        
    
}

module shaft() {
    h=20;
    diameter = 3.25;
    width=6;
    depth=6;
    height=20;
    difference() {
        cylinder(h,diameter,diameter,center=false, $fn=20);
        translate([-3,2.5,0]) {
            cube([width,depth,height], center=false);
        };
    };
};

module motormount() {
    h=base-12;
    d = 37.5/2+5;
    sd = 20.75/2;
    screwR = 1.75;
    offset = 26/2;
    difference() {
        translate([0,0,h/2]) {
            difference() {
                cylinder(h,d,d,center=true,$fn=resolution);
                cylinder(h+.01,sd,sd,center=true,$fn=resolution);
            }; 
        };
        translate([0,0,h/2]) {
            union() {
                translate([-offset,0,0]) {
                    cylinder(h+0.1,screwR,screwR,center=true, $fn=resolution);
                };
                translate([offset,0,0]) {
                    cylinder(h+0.1,screwR,screwR,center=true, $fn=resolution);
                };   
                translate([0,-offset,0]) {
                    cylinder(h+0.1,screwR,screwR,center=true, $fn=resolution);
                };
                translate([0,offset,0]) {
                    cylinder(h+0.1,screwR,screwR,center=true, $fn=resolution);
                };
            };
        };
    };
    // screw hole
    
};

module potmodel() {
    potheight = 7;
    diameter = 13.5;
    winglength=24;
    wingwith=3;
    cylinder(potheight,diameter/2,diameter/2, center=true, $fn=resolution);
    translate([diameter/2-1,0,0]) {
        cube([diameter,diameter,potheight],center=true);
    };
    cube([wingwith,winglength,potheight], center=true);
};

module potmodelLarge() {
    potheight = 14;
    diameter = 12.25*2;
   winglength=20;
   wingwith=winglength;
    cylinder(potheight,diameter/2,diameter/2, center=true, $fn=resolution);
    //translate([diameter/2-1,0,0]) {
    //    cube([diameter,diameter,potheight],center=true);
    //};
  translate([diameter/3,0,0]) {
    cube([wingwith,winglength,potheight], center=true);
  }
};


module hexHead() {
  rad = 6.5;
  height = 5;
  translate([-12.5,0,0]) {
    rotate([0,90,0]) {
      cylinder(r=rad, h=height, $fn=6);
    }
  }
}
module roundHead() {
  rad = 10.25;
  height = 10.501;
  translate([-30.5,0,0]) {
  rotate([0,90,0]) {
    cylinder(r=rad, h=height, $fn=100);
  }
}
}

module innerRoundHeadWithHex() {
  // a little smaller than round head.
  rad = 10;
  height = 10;
  
    radH = 6.5;
  heightH = 50;
  //translate([-12.5,0,0]) {
    //rotate([0,90,0]) {
      
    //}
  
  //}
  
  screwHoleHeight = 47.5;
translate([-20.5,0,screwHoleHeight]) {
  rotate([0,90,0]) {
  difference() {
      cylinder(r=rad, h=height, $fn=100, center=true);
    translate([0,0,-height/2]) {
      cylinder(r=radH, h=heightH, $fn=6, center=true);
    }
  }
   }
}
}

module bottompartwithpot() {
    // each gear is 10 mm ?actuator is like 6mm... no way ok..
    gear_radius=pot_gear_diameter;
    difference() {
      bottompart();
      translate([28,0,base+radius-gear_radius]) {
        rotate([0,90,0]) {
            potmodelLarge();
        };
      };
    }; 
};




module bottompartwithmountandpot() {
  rs=30;
  t=4;
  hs1=15+t;
  hs2=10+t;
  z3=rs/2-.01;

  // need a way to tighten the hub
  a=40;
  b=5;
  offset = 65;
  z = 35;
  w = 10.25*2;


  difference() {

    difference() {
      bottompartwithpot();
      translate([0,0,z3]) {
        cylinder(rs,hs1,hs2, center=true);
      }
    }

    translate([-12,0,offset]) {
      cube([w,w,z],center=true);
    }

    //toppart();

    translate([0,a/2,10]) {
      rotate([90,0,0]) {
        cylinder(a,b,b, center=true, $fn=100);
      }
    }
  }
  motormount();

}



module toppartwithboltholder() {
  toppart();
  innerRoundHeadWithHex();
}
pot_gear_diameter=20;
spacing = 31;
radius = 61/2.0;
motoroffset=12;
base = 5 + motoroffset;
resolution = 100;


// The 5 peices for this.  top/bottom/gear
// and the 2 external gears
//bottompartwithmountandpot();
//toppartwithboltholder();
//littlegearWithMountingBox();
//lloydgear();
lloydgearNoShaft();


//biggear();
//littlegear();
//toppartwithboltholder();
//innerRoundHeadWithHex();


//screwhole();

//roundtop();
//lloydtop();
//kneebottom();
//lloydgear();

//motorholematch();        
//angletop();
//roundtop();
//intersection() {
//baseshape();
//bottompart();
//motorholematch();
//bottompart();
//motorhole();
//toppart();

//bottompart();
//motormount();

/*
 
translate([-31,0,0]) {
    toppart();
}

translate([31,0,0]) {
    bottompart();
}*/

// bottompart();
//baseshape();





//translate([-25,7,-2]) {
//rotate([0,90,0]) {
//difference() {
 //   scale([2.2,2.2,2.2]) {
//littlegear();
 //   }
 //   shaft();
//};
//};
//};
/*translate([-28,-28,14]) {
 
    biggear();

 } */
/*
translate([5,0,26.5]) {
    rotate([0,90,0]) {
        biggear();
    }
}*/
//toppart();











// littlegearWithMountingBox();
// lloydgear();
/**/

//potmodelLarge();
// lloydgear();


// TODO: make the pot gears! basic spur gear with 20 mm diameter
 // gear (diam1, thick, angle, ded, add, twidth, tnumber, toothfraction) 
//gear(20, 10, 90, 0,0, 2, 20, 0.5);

// for a test print. lets subtract this out of a larger block.
// a base cube
/*
potheight=7;
difference() {
translate([2,0,potheight/2]) {
  cube([25,30,potheight], center=true);
};
translate([0,0,potheight/2+3]) {
    potmodel();
    
};
};*/

// The potentiometer gears!  need for the pot. one for the screw.
// lloydgear();


/*
translate([-spacing,0,0]) {
    roundbottom();
}
translate([spacing,0,0]) {
    roundtop();
} 
*/