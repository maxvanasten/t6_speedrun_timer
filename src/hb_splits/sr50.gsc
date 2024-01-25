// Speedrun to round 50
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;

// Include the core script
#include scripts\zm\hb_speedrun_timer;

get_splits()
{
    splits = [];

    splits[splits.size] = create_split("round_5", "Round 5");
    splits[splits.size] = create_split("round_10", "Round 10");
    splits[splits.size] = create_split("round_20", "Round 20");
    splits[splits.size] = create_split("round_30", "Round 30");
    splits[splits.size] = create_split("round_40", "Round 40");
    splits[splits.size] = create_split("round_50", "Round 50");

    return splits;
}

check_split(identifier)
{
    current_round = level.round_number;

    switch(identifier)
    {
        case "round_5":
            if (current_round == 5)
            {
                self.split_complete = 1;
            }
            break;
        case "round_10":
            if (current_round == 10)
            {
                self.split_complete = 1;
            }
            break;
        case "round_20":
            if (current_round == 20)
            {
                self.split_complete = 1;
            }
            break;
        case "round_30":
            if (current_round == 30)
            {
                self.split_complete = 1;
            }
            break;
        case "round_40":
            if (current_round == 40)
            {
                self.split_complete = 1;
            }
            break;
        case "round_50":
            if (current_round == 50)
            {
                self.split_complete = 1;
            }
            break;
    }
}