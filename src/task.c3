module c3_scheduling;

import std::io;
import std::collections::list;

enum DurationType { WORKING_TIME, ELAPSED_TIME, }

struct Task {
    String name;
    Time start;
    HourNum duration;
    Time end;
    DurationType duration_type;
    List{usz} successors;
    List{usz} predecessors;
}

fn Task new_task(String name, float duration) {
    Task retval = {.name = name, .duration = duration};
    return retval;
}

fn void Task.print(Task* self) {
    self.start.print();
    io::printf(" --> ");
    self.end.print();
    io::printf(" ( ");
    io::printf("%0.2f hours ) \"%s\" ", self.duration, self.name);
    if (self.duration_type == ELAPSED_TIME) io::printf(" (elapsed) ");
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

fn Time add_start(Task* task, Time start) {
    start.fast_forward_to_working_hours();

    if (greater(start, task.start)) {
        task.start = start;
    } else {
        start = task.start;
    }

    start.hour += task.duration;
    if (task.duration_type != ELAPSED_TIME) start.fix_to_working_hours();

    task.end = start;

    return start;
}

fn Time schedule_task(Task* task, Project project, Time start_time) {
    start_time = add_start(task, start_time);

    foreach (ind : task.successors) {
        schedule_task(project.get_ref(ind), project, start_time);
    }

    return start_time;
}

