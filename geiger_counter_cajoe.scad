$fn=8;

board_z=1;
wall=1.6;
gap=0.5;
screw_dia=3.3;
screw_length=20;

bat_x=99.2;
bat_y=29.5;
bat_z1=20;
bat_z2=7.5;
bat_con_usbc_x=10.1;
bat_con_usbc_z=3.6;
bat_con_usbc_off_x=81;
bat_con_usbc_off_y=bat_y-gap;
bat_con_usbc_off_z=bat_z2-board_z-bat_con_usbc_z-0.2;
bat_con_button_x=4;
bat_con_button_z=2.5;
bat_con_button_off_x=8;
bat_con_button_off_y=bat_y-gap;
bat_con_button_off_z=bat_z2+1.5;
bat_display_x=17;
bat_display_y=3.2;
bat_display_off_x=63.5;
bat_display_off_y=21.5;
bat_display_off_z=0;
bat_screw_dia=screw_dia;
bat_screw_off_x=2.2;
bat_screw_off_y=2.2;

cajoe_x=108;
cajoe_y=62.5;
cajoe_z1=15;
cajoe_z2=5;
cajoe_con_audio_dia=6;
cajoe_con_audio_off_x=cajoe_x;
cajoe_con_audio_off_y=47-cajoe_con_audio_dia/2;
cajoe_con_audio_off_z=cajoe_z2+2.9-cajoe_con_audio_dia/2;
cajoe_con_power_dia=7;
cajoe_con_power_off_x=0;
cajoe_con_power_off_y=41-cajoe_con_power_dia/2;
cajoe_con_power_off_z=cajoe_z2+6.5-cajoe_con_power_dia/2;
cajoe_switch_y=8;
cajoe_switch_x=wall;
cajoe_switch_z=3.5;
cajoe_switch_off_x=0;
cajoe_switch_off_y=25;
cajoe_switch_off_z=cajoe_z2-board_z+1.8;
cajoe_screw_dia=screw_dia;
cajoe_screw_off_x=2.8;
cajoe_screw_off_y=2.8;

esp_y=25.5;
esp_x=34.5;
esp_z1=3;
esp_z2=4.7;
esp_con_usb_y=10;
esp_con_usb_z=5;
esp_con_usb_off_y=8.2-1.1;
esp_con_usb_off_x=esp_x;
esp_con_usb_off_z=-1;

oled_board_x=35;
oled_board_y=33.2;
oled_board_z1=2.1;
oled_board_z2=2.3;
oled_board_screw_dia=2;
oled_board_screw_off_x=1.75;
oled_board_screw_off_y=1.75;

oled_display_x=35; //27.2
oled_display_y=19; //23
oled_display_z=2;
oled_display_off_y=4;
oled_display_off_x=0;

cajoe_pad_x=cajoe_screw_dia+cajoe_screw_off_x;
cajoe_pad_y=cajoe_screw_dia+cajoe_screw_off_y;

bat_pad_x=bat_screw_dia+bat_screw_off_x;
bat_pad_y=bat_screw_dia+bat_screw_off_y;

oled_board_pad_x=oled_board_screw_dia+oled_board_screw_off_x;
oled_board_pad_y=oled_board_screw_dia+oled_board_screw_off_y;

case_x=cajoe_x + 2*gap + 2*wall;
case_y=cajoe_y + bat_y + 4*gap + 2*wall;
case_z=bat_z1 + bat_z2 + 2*gap + 2*wall;

case_z2=wall+bat_z2+board_z;
case_z1=case_z-case_z2;

tubecuts_x=case_x-10;
tubecut_num=15;
tubecut_x=tubecuts_x/tubecut_num/2;


top();
//bottom();




module bottom()
{
    difference()
    {
        union()
        {
            case_lower();
            place_bat() pads(bat_x,bat_y,bat_z2-board_z,bat_pad_x,bat_pad_y,gap=gap);
            place_cajoe() pads(cajoe_x,cajoe_y,cajoe_z2-board_z,cajoe_pad_x,cajoe_pad_y,gap=gap);
            case_connector();
        }
        place_cajoe() cajoe_screws();
        place_cajoe() cajoe_connections();
        place_bat() bat_screws();
        place_bat() bat_connections();
        translate([0,0,cajoe_z2+gap]) tubecut();
    }
}

module top()
{
    difference()
    {
        union()
        {
            case_upper();
            place_oled() oled_board_pads();
            place_esp() holder(esp_x,esp_y,esp_z1,esp_z2,board_z+1*gap,wall,gap,1);
        }
        place_oled() oled_display_opening();
        place_oled() oled_board_screws();
        place_esp() esp_connections();
        place_bat() bat_connections();
        place_cajoe() cajoe_connections();
        translate([0,0,case_z2+2*wall]) tubecut();
        case_connector(gap=0.2);
        case_screws_cut();
        radioactive_logo();
    }
    difference()
    {
        case_screws();
        case_connector(gap=0.2);
    }
}

/////////////////
// ESP modules //
/////////////////

module place_esp()
{
    translate([case_x-esp_x-wall+1-gap,
               wall+30,
               case_z-wall-esp_z1-esp_z2])
    {
        children();
    }
}

module esp_connections()
{
    translate([esp_con_usb_off_x-1,esp_con_usb_off_y,esp_con_usb_off_z])
    {
        cube([1+2*wall+2*gap,esp_con_usb_y,esp_con_usb_z]);
    }
}


//////////////////
// Oled modules //
//////////////////

module place_oled()
{
    translate([wall+20,
               wall+20,
               case_z-wall-oled_board_z1-oled_board_z2])
    {
        children();
    }
}

module oled_board_pads()
{
    translate([0,0,oled_board_z2])
    {
        difference()
        {
            cube([oled_board_x,oled_board_y,oled_board_z1]);
            cross(oled_board_x,oled_board_y,oled_board_z1,oled_board_pad_x,oled_board_pad_y);
        }
    }
}

module oled_board_screws()
{
    translate([0,0,0])
    {
        screws(oled_board_x,
               oled_board_y,
               oled_board_screw_off_x,
               oled_board_screw_off_y,
               oled_board_screw_dia,
               2*wall-gap+oled_board_z1);
    }
}

module oled_display_opening()
{
    translate([oled_display_off_x,oled_display_off_y,oled_board_z1+oled_board_z2])
    {
        hull()
        {
            cube([oled_display_x,oled_display_y,gap+wall]);
            translate([-wall/2,-wall/2,wall])
            {
                cube([oled_display_x+wall,oled_display_y+wall,gap]);
            }
        }
    }
}

////////////////////
// cajoe modules //
////////////////////
module place_cajoe(){
    translate([wall+gap,wall+gap,wall])
    {
        children();
    }
}

module cajoe_screws()
{
    translate([0,0,-gap-wall])
    {
        screws(cajoe_x,
               cajoe_y,
               cajoe_screw_off_x,
               cajoe_screw_off_y,
               cajoe_screw_dia,
               wall+gap+cajoe_z2-board_z);
    }
}

module cajoe_connections()
{
    translate([cajoe_switch_off_x-cajoe_switch_x-gap,
               cajoe_switch_off_y,
               cajoe_switch_off_z])
    {
        cube([cajoe_switch_x,cajoe_switch_y,cajoe_switch_z]);
    }

    translate([cajoe_con_audio_off_x+gap,
               cajoe_con_audio_off_y,
               cajoe_con_audio_off_z])
    {
        translate([0,cajoe_con_audio_dia/2,cajoe_con_audio_dia/2])
        {
            rotate([0,90,0])
            {
                cylinder(h=wall,d=cajoe_con_audio_dia);
            }
        }
    }

    translate([cajoe_con_power_off_x-wall-gap,
               cajoe_con_power_off_y,
               cajoe_con_power_off_z])
    {
        translate([0,cajoe_con_power_dia/2,cajoe_con_power_dia/2])
        {
            rotate([0,90,0])
            {
                cylinder(h=wall,d=cajoe_con_power_dia);
            }
        }
    }
}


/////////////////////
// Battery modules //
/////////////////////

module place_bat(){
    translate([wall+gap+8.8,case_y-gap-bat_y-wall,wall])
    {
        children();
    }
}

module bat_pads()
{
    difference()
    {
        cube([bat_x,bat_y,bat_z2-board_z]);
        cross(bat_x,bat_y,bat_z2-board_z,bat_pad_x,bat_pad_y);
    }
}

module bat_screws()
{
    translate([0,0,-gap-wall])
    {
        screws(bat_x,
               bat_y,
               bat_screw_off_x,
               bat_screw_off_y,
               bat_screw_dia,
               wall+gap+bat_z2-board_z);
    }
}

module bat_connections()
{
    translate([bat_con_usbc_off_x,bat_con_usbc_off_y+gap,bat_con_usbc_off_z])
    {
        cube([bat_con_usbc_x,wall+gap,bat_con_usbc_z]);
    }

    translate([bat_con_button_off_x,bat_con_button_off_y+gap,bat_con_button_off_z])
    {
        cube([bat_con_button_x,wall+gap,bat_con_button_z]);
    }
    translate([bat_display_off_x,bat_display_off_y,bat_display_off_z-wall])
    {
        cube([bat_display_x,bat_display_y,wall]);
    }
}


//////////////////
// Case modules //
//////////////////

module case_upper()
{
    intersection()
    {
        case();
        translate([0,0,case_z2])
        {
            cube([case_x,case_y,case_z1]);
        }
    }
}

module case_lower()
{
    intersection()
    {
        case();
        cube([case_x,case_y,case_z2]);
    }
}

module case()
{
    difference()
    {
        case_frame([case_x,case_y,case_z]);
        translate([wall,wall,wall])
        {
            case_frame([case_x,case_y,case_z]-2*[wall,wall,wall]);
            cube_round([case_x,case_y,cajoe_z1+cajoe_z2+board_z]-2*[wall,wall,wall],mki=2);
        }
    }
}

module tubecut()
{
    translate([7.5,0,0])
    {
        for(i=[0:tubecut_x:tubecuts_x/2-tubecut_x])
        {
            translate([2*i,0,0])
            {
                //cube([tubecut_x,10,case_z1]);
                for(i=[tubecut_x/2:tubecut_x:tubecut_x])
                {
                    translate([0,0,2*i])
                    {
                        rotate([270,0,0])
                        {
                            cylinder(h=10,d=tubecut_x);
                        }
                    }
                }
            }
        }
    }
}


module case_connector(gap=0)
{
    translate([wall/2-gap,wall/2-gap,case_z2-wall+gap])
    {
        difference()
        {
            cube_round([case_x-wall+2*gap,case_y-wall+2*gap,2*wall+gap]);
            //cross(case_x-wall+2*gap,case_y-wall+2*gap,2*wall+gap,10,10,mki=0);
            translate([wall/2+2*gap,wall/2+2*gap,0])
            {
                cube_round([case_x-2*wall-2*gap,case_y-2*wall-2*gap,2*wall+gap],mki=2);
            }
        }
    }
}


module case_screws()
{
    intersection()
    {
        case_frame([case_x,case_y,case_z]);
        union()
            {
            translate([wall+gap+cajoe_screw_off_x,wall+gap+cajoe_screw_off_y,0])
            {
                screw_connector(cajoe_z2+wall+gap,case_z);
            }
            translate([case_x-(wall+gap+cajoe_screw_off_x),wall+gap+cajoe_screw_off_y,0])
            {
                screw_connector(cajoe_z2+wall+gap,case_z);
            }
            translate([wall+gap+bat_screw_off_x,case_y-wall-gap-bat_screw_off_y,0])
            {
                screw_connector(bat_z2+wall+gap,case_z);
            }
            translate([wall+gap+bat_x-bat_screw_off_x,case_y-wall-gap-bat_screw_off_y,0])
            {
                screw_connector(bat_z2+wall+gap,case_z);
            }
        }
    }
}

module case_screws_cut()
{
    translate([wall+gap+cajoe_screw_off_x,wall+gap+cajoe_screw_off_y,screw_length])
    {
        cylinder(d=2.2*screw_dia+wall,h=case_z);
    }
    translate([case_x-(wall+gap+cajoe_screw_off_x),wall+gap+cajoe_screw_off_y,screw_length])
    {
        cylinder(d=2.2*screw_dia+wall,h=case_z);
    }
    translate([wall+gap+bat_screw_off_x,case_y-wall-gap-bat_screw_off_y,screw_length])
    {
        cylinder(d=2.2*screw_dia+wall,h=case_z);
    }
    translate([wall+gap+bat_x-bat_screw_off_x,case_y-wall-gap-bat_screw_off_y,screw_length])
    {
        cylinder(d=2.2*screw_dia,h=case_z);
    }
}

module radioactive_logo()
{
    translate([case_x/1.9,case_y/4,case_z-wall/2])
    {
        linear_extrude(wall/2)
        {
            scale(0.2)
            {
                import("radioactive.svg");
            }
        }
    }
}

/////////////////////
// General modules //
/////////////////////

module pads(x,y,z,pad_x,pad_y,gap=0)
{
    //translate([-gap,-gap,0])
    {
        difference()
        {
            translate([-gap,-gap,0])
            cube([x+2*gap,y+2*gap,z]);
            cross(x,y,z,pad_x,pad_y,mki=4);
        }
    }
}

module screw_connector(off_z,total_height)
{
    translate([0,0,off_z])
    {
        difference()
        {
            union()
            {
                translate([0,0,screw_length-wall-off_z])
                {
                    cylinder(d=2.2*screw_dia+wall,h=total_height-screw_length+wall);
                }
                cylinder(d=screw_dia+1.5*wall,h=screw_length-off_z);
            }
            cylinder(d=screw_dia,h=screw_length-off_z);
            translate([0,0,screw_length-off_z])
            {
                cylinder(d=2.2*screw_dia,h=total_height-screw_length);
            }
        }
    }
}

module screws(x,y,off_x,off_y,dia,height)
{
    translate([off_x,off_y,0])
    {
        cylinder(h=height,d=dia);
        cylinder(h=dia,d=1.98*dia,$fn=6);
    }
    translate([off_x,y-off_y,0])
    {
        cylinder(h=height,d=dia);
        cylinder(h=dia,d=1.98*dia,$fn=6);
    }
    translate([x-off_x,y-off_y,0])
    {
        cylinder(h=height,d=dia);
        cylinder(h=dia,d=1.98*dia,$fn=6);
    }
    translate([x-off_x,off_y,0])
    {
        cylinder(h=height,d=dia);
        cylinder(h=dia,d=1.98*dia,$fn=6);
    }
}

module holder(x,y,z1,z2,board_z,wall,gap,cutout)
{
    difference()
    {
        translate([0,-wall,0])
        {
            cube([x-cutout+wall+gap,
                  y+2*wall+2*gap,
                  z1+z2]);
        }
        translate([0,cutout/2,0]){
            cube([x-cutout,y-cutout,z1]);
        }
        translate([0,0,z1]){
            cube([x,y,board_z]);
        }
        translate([0,cutout/2,z1+board_z]){
            cube([x-cutout,y-cutout,z2]);
        }
    }
}

module case_frame(dim)
{
    intersection()
    {
        cube_round(dim);
        translate([0,0,-15/2+2])
        {
            cube_round(dim+[0,0,15/2-2],mki=20,plane="yz");
        }
    }
}

module cross(x,y,z,cut_x,cut_y,mki=0)
{
    translate([cut_x,0,0])
        {
            cube_round([x-2*cut_x,y,z],mki=mki);
        }
        translate([0,cut_y,0])
        {
            cube_round([x,y-2*cut_y,z],mki=mki);
        }
}

module cube_round(dim,mki=5,plane="xy"){
    if(mki<=0)
    {
        cube(dim);
    }
    else
    {
        if(plane=="xy")
        {
            translate([mki/2,mki/2,0])
            {
                linear_extrude(dim[2])
                {
                    minkowski()
                    {
                        square([dim[0]-mki,dim[1]-mki]);
                        circle(d=mki);
                    }
                }
            }
        }
        if(plane=="yz")
        {
            translate([0,mki/2,dim[2]-mki/2])
            {
                rotate([0,90,0])
                {
                    linear_extrude(dim[0])
                    {
                        minkowski()
                        {
                            square([dim[2]-mki,dim[1]-mki]);
                            circle(d=mki);
                        }
                    }
                }
            }
        }
        if(plane=="xz")
        {
            translate([mki/2,dim[1],mki/2])
            {
                rotate([90,0,0])
                {
                    linear_extrude(dim[1])
                    {
                        minkowski()
                        {
                            square([dim[0]-mki,dim[2]-mki]);
                            circle(d=mki);
                        }
                    }
                }
            }
        }
    }
}

