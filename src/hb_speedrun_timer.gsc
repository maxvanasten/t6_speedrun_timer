#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;

// Include splitfile you'd like to use

// ORIGINS NML + STAFFS + STAFFS UPGRADED
#include scripts\zm\hb_splits\origins_staffs;

// ROUND 50 SPEEDRUN
// #include scripts\zm\hb_splits\sr50;

// Configuration
config()
{
    cfg = spawnstruct();
    // Main timer config
    cfg.main_timer_color = (0.7, 0.1, 0.1); // Color of the main timer
    cfg.timer_font = "Objective";
    cfg.timer_font_size = 1.5;
    // Split ui config
    cfg.text_color = (0.7, 0.7, 0.7); // Color of the regular text
    cfg.delta_time_color = "^5"; // Color of the time since the last split
    cfg.total_time_color = "^3"; // Color of the time since the beginning of the game   
    cfg.splits_font = "Objective";
    cfg.splits_font_size = 1.2;

    cfg.position_x = -275;
    cfg.position_y = 100;

    return cfg;
}

init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for ( ;; )
    {
        level waittill ("connecting", player);
        player thread onPlayerSpawned ();
    }
}

onPlayerSpawned()
{
    self endon ("disconnect");

    self thread initialize ();
}

initialize()
{
    level endon ("game_ended");
    self endon ("disconnect");
    // Wait for initial blackscreen to pass
    flag_wait ("initial_blackscreen_passed");

    // DEV: Give points to test nml split
    // self.score = 10000;

    // Initialize time variables
    level.start_time = gettime(); // The time since the start of the game
    level.split_time = level.start_time; // The time since the last split was completed
    // Initialize split variables
    self.splits = get_splits(); // get_splits() is a function provided by the split file
    self.current_split = 0; // The index of the current split
    self.run_complete = 0; // = 1 when all of the splits are complete

    self.split_complete = 0; // = 1 when the current split is complete

    setup_main_timer ();
    self setup_split_ui ();
    self update_split_ui ();

    for ( ;; )
    {
        self thread check_split (self.splits[self.current_split].identifier);
        self thread main_loop ();
        wait 0.05;
    }
}

main_loop()
{
    if (self.run_complete)
    {
        return;
    }
    
    identifier = self.splits[self.current_split].identifier;

    if (self.split_complete == 1)
    {
        self.split_complete = 0;
        self.splits[self.current_split].time_string = "<"+config().delta_time_color+get_time_as_string("delta")+"^7> - ("+config().total_time_color+get_time_as_string("total")+"^7)";
        level.split_time = gettime();
        self thread update_split_ui ();
        if (isDefined(self.splits[self.current_split + 1]))
        {
            self.current_split = self.current_split + 1;
        }
        else
        {
            self.run_complete = 1;
        }
    }
}

create_split(identifier, name)
{
    split = spawnstruct();
    split.identifier = identifier;
    split.name = name;
    split.time_string = "-";
    
    return split;
}

setup_split_ui()
{
    self.split_ui = createFontString (config().splits_font, config().splits_font_size);
    self.split_ui setPoint ("CENTER", "CENTER", config().position_x, config().position_y+25);
    self.split_ui.alpha = 1;
    self.split_ui.hidewheninmenu = 1;
    self.split_ui.hidewhendead = 1;
    self.split_ui.color = config().text_color;
    self.split_ui setText("Loading...");
}

// Run this whenever a split is completed
update_split_ui()
{
    content = "";

    for (i = 0; i < self.splits.size; i++)
    {
        content += "["+self.splits[i].name+"]: "+self.splits[i].time_string+"\n";
    }

    self.split_ui setText(content);
}

setup_main_timer()
{
    timer = createFontString (config().timer_font, config().timer_font_size);
    timer setPoint ("CENTER", "CENTER", config().position_x, config().position_y);
    timer.alpha = 1;
    timer.hidewheninmenu = 1;
    timer.hidewhendead = 1;
    timer.color = config().main_timer_color;
    timer setTenthsTimerUp (0.05); 
}

get_time_as_string(type)
{
    time = 0;

    switch (type)
    {
        case "total":
            time = gettime() - level.start_time;
            break;
        case "delta":
            time = gettime() - level.split_time;
            break;
    }

    result = "";

    seconds = int(time / 1000);
    minutes = int(seconds / 60);

    ms = (time % 1000) / 10;
    r_seconds = seconds % 60;

    if (minutes > 9)
    {
        result += minutes + ":";
    }
    else
    {
        result += "0" + minutes + ":";
    }

    if (r_seconds > 9)
    {
        result += r_seconds + ".";
    }
    else
    {
        result += "0" + r_seconds + ".";
    }

    if (ms > 9)
    {
        result += ms;
    }
    else
    {
        result += "0" + ms;
    }

    return result;
}