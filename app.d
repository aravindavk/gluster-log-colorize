import std.stdio : stdin, writeln, writef, write;
import std.array : split;
import std.regex : ctRegex, matchAll;

// To print Text in Color in bash terminal
// ESC[ATTR;FG_COLOR;BG_COLORm<TEXT>ESC[RESET
auto ESC = "\033";
auto RESET = "\033[0m";

// Bash Attributes
auto ATTR_NORMAL = "[0;";
auto ATTR_BOLD = "[1;";

// Bash Foreground colors
auto FG_BLACK = "30";
auto FG_RED = "31";
auto FG_GREEN = "32";
auto FG_YELLOW = "33";
auto FG_BLUE = "34";
auto FG_PURPLE = "35";
auto FG_CYAN = "36";
auto FG_WHITE = "37";

// Bash Background Colors
auto BG_BLACK = "40";
auto BG_RED = "41";
auto BG_GREEN = "42";
auto BG_YELLOW = "43";
auto BG_BLUE = "44";
auto BG_PURPLE = "45";
auto BG_CYAN = "46";
auto BG_WHITE = "47";

string normal_color(string color)
{
    return ESC ~ ATTR_NORMAL ~ color ~ "m";
}

string bold_color(string color)
{
    return ESC ~ ATTR_BOLD ~ color ~ "m";
}

string normal_color(string color, string bg)
{
    return ESC ~ ATTR_NORMAL ~ color ~ ";" ~ bg ~ "m";
}

string bold_color(string color, string bg)
{
    return ESC ~ ATTR_BOLD ~ color ~ ";" ~ bg ~ "m";
}

string level_color(char[] lvl)
{
    switch (lvl)
    {
    case "I":
        return bold_color(FG_BLACK, BG_GREEN);
    case "E":
        return bold_color(FG_WHITE, BG_RED);
    case "W":
        return bold_color(FG_BLACK, BG_YELLOW);
    default:
        return normal_color(FG_BLACK, BG_WHITE);
    }
}

// [TS] LOG_LEVEL [MSGID: <ID>] [FILE:LINE:FUNC] DOMAIN: MSG
// MSGID is optional and MSG can be structured log format or can be normal msg
auto log_pattern = ctRegex!(`\[([^\]]+)\]\s` ~ `([IEWTD])\s`
        ~ `(\[MSGID:\s([^\]]+)\]\s)?` ~ `\[([^\]]+)\]\s` ~ `([^:]+):\s` ~ `(.+)`);

void main()
{
    foreach (line; stdin.byLine)
    {
        auto m = line.matchAll(log_pattern);
        if (!m.empty > 0)
        {
            // Timestamp
            writef("%s%26s%s ", normal_color(FG_YELLOW), m.front[1], RESET);

            // Log Level
            writef("%s %s %s ", level_color(m.front[2]), m.front[2], RESET);

            // Optional MSGID
            if (m.front[3] != "" && m.front[4] != "" && m.front[4] != "0")
            {
                writef("%sMSGID: %5s%s ", normal_color(FG_BLACK, BG_YELLOW), m.front[4], RESET);
            }

            // File Info
            write(bold_color(FG_BLACK), m.front[5], RESET, " ");

            // Domain
            write(normal_color(FG_BLUE), m.front[6], RESET, " ");

            // Message, Check for structured log format
            auto msg_parts = m.front[7].split("\t");
            write(normal_color(FG_WHITE), msg_parts[0], RESET, " ");

            if (msg_parts.length > 1)
            {
                for (int i = 1; i < msg_parts.length; i++)
                {
                    auto key_value = msg_parts[i].split("=");
                    write(bold_color(FG_BLUE), key_value[0], RESET);
                    if (key_value.length > 1)
                    {
                        write("=", normal_color(FG_WHITE), key_value[1], RESET, " ");
                    }
                }
            }

            // New Line
            writeln();
        }
        else
        {
            // If format is unknown
            writeln(line);
        }
    }
}
