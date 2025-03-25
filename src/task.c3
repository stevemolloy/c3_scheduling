module c3_scheduling;

import std::io;
import std::collections::list;

enum DurationType { WORKING_TIME, ELAPSED_TIME, }

struct Task {
    String name;
    Time start;
    HourNum duration;
    DurationType duration_type;
    List{usz} successors;
    List{usz} predecessors;
}

fn Task new_task(String name, float duration) {
    Task retval = {.name = name, .duration = duration};
    return retval;
}

fn void Task.print(Task* self) {
    io::printf("\"%s\" -- %0.2f hours ", self.name, self.duration);
    if (self.duration_type == ELAPSED_TIME) io::printf(" (elapsed) ");
    self.start.print();
    io::printf(" ");
    io::printf("Successors: ");
    foreach (i, succ : self.successors) {
        if (i!=0) io::printf(", ");
        io::printf("%d ", succ);
    }
    io::printf("Predecessors: ");
    foreach (i, pred : self.predecessors) {
        if (i!=0) io::printf(", ");
        io::printf("%d ", pred);
    }
    io::printf("\n");
}

fn Time Task.add_start(Task* self, Time start) {
    start.fix_to_working_hours();

    self.start.day = start.day;
    self.start.hour = start.hour;

    start.hour += self.duration;
    if (self.duration_type != ELAPSED_TIME) start.fix_to_working_hours();

    return start;
}

fn Time Task.schedule(Task* self, Project project, Time start_time) {
    start_time = self.add_start(start_time);

    foreach (ind : self.successors) {
        project.get_ref(ind).schedule(project, start_time);
    }

    return start_time;
}

