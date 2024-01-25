#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;

// Include splitfile
#include scripts\zm\hb_splits\origins_staffs;

log(text)
{
    Print (text);
    Printf (text);
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

    flag_wait ("initial_blackscreen_passed");

    // DEV: Give points to test nml split
    // self.score = 10000;

    level.start_time = gettime();
    level.split_time = level.start_time;

    self.splits = get_splits();
    self.current_split = 0;
    self.run_complete = 0;

    self.split_complete = 0;

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
        log("[main_loop]: Setting time_string for "+identifier+" to "+get_time_as_string("delta")+" - "+get_time_as_string("total"));
        self.split_complete = 0;
        self.splits[self.current_split].time_string = "<^5"+get_time_as_string("delta")+"^7> - (^3"+get_time_as_string("total")+"^7)";
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
    log("create_split: "+split.identifier);
    return split;
}

setup_split_ui()
{
    self.split_ui = createFontString ("Objective", 1.5);
    self.split_ui setPoint ("CENTER", "CENTER", 300, -175);
    self.split_ui.alpha = 1;
    self.split_ui.hidewheninmenu = 1;
    self.split_ui.hidewhendead = 1;
    self.split_ui.color = (0.7, 0.7, 0.7);
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
    timer = createFontString ("Objective", 1.5);
    timer setPoint ("CENTER", "CENTER", 300, -200);
    timer.alpha = 1;
    timer.hidewheninmenu = 1;
    timer.hidewhendead = 1;
    timer.color = (1.0, 0.4, 0.4);
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