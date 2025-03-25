module c3_scheduling;

import std::io;

alias DayNum = int;
alias HourNum = float;

struct Time {
    DayNum day;
    HourNum hour;
}

fn void Time.print(Time self) {
    io::printf("Day: %d, Hour: %f", self.day, self.hour);
}

fn void Time.fix_to_working_hours(Time* self) {
    while (self.hour > 8.0) {
        self.hour -= 8.0;
        self.day += 1;
        while (self.day % 7 > 4) self.day += 1;
    }
}

