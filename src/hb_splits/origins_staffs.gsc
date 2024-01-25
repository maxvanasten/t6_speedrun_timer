#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\hb_speedrun_timer;

get_splits()
{
    splits = [];

    splits[0] = create_split("nml", "No mans land");
    splits[1] = create_split("staff_1", "Staff I");
    splits[2] = create_split("staff_2", "Staff II");
    splits[3] = create_split("staff_3", "Staff III");
    splits[4] = create_split("staff_4", "Staff IV");
    splits[5] = create_split("staffs_upgraded", "Staffs upgraded");
    log("Amount of splits: "+splits.size);
    return splits;
}

check_split(split_identifier)
{
    switch(split_identifier)
    {
        case "nml":
            flag_wait("activate_zone_nml");
            self.split_complete = 1;
            break;
        case "staff_1":
            if (level.n_staffs_crafted == 1)
            {
                self.split_complete = 1;
            }
            break;
        case "staff_2":
            if (level.n_staffs_crafted == 2)
            {
                self.split_complete = 1;
            }
            break;
        case "staff_3":
            if (level.n_staffs_crafted == 3)
            {
                self.split_complete = 1;
            }
            break;
        case "staff_4":
            if (level.n_staffs_crafted == 4)
            {
                self.split_complete = 1;
            }
            break;
        case "all_staffs_upgraded":
            flag_wait("ee_all_staffs_upgraded");
            self.split_complete = 1;
            break;
    }
}