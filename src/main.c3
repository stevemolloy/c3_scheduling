module c3_scheduling;

import std::io;
import std::collections::list;

alias DayNum = int;
alias HourNum = float;

enum DurationType { WORKING_TIME, ELAPSED_TIME, }

struct Time {
    DayNum day;
    HourNum hour;
}

fn void Time.print(Time self) {
    io::printf("Day: %d, Hour: %f", self.day, self.hour);
}

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
    if (self.duration_type == ELAPSED_TIME) {
        io::printf(" (elapsed) ");
    }
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

alias Project = List{Task};

fn void Project.start(Project* self) {
    self.push(new_task("Start", 0.0));
}

fn void Project.add_task(Project* self, String name, float duration) {
    self.push(new_task(name, duration));
    
    usz num_eles = self.len();
    self.get_ref(num_eles - 2).successors.push(num_eles - 1);
    self.get_ref(num_eles - 1).predecessors.push(num_eles - 2);
}

fn Time Task.add_start(Task* self, Time start) {
    self.start.day = start.day;
    self.start.hour = start.hour;

    start.hour += self.duration;
    while (start.hour > 8.0) {
        start.hour -= 8.0;
        start.day += 1;
        while (start.day % 7 > 4) start.day += 1;
    }

    return start;
}

fn Time Task.schedule(Task* self, Project project, Time start_time) {
    start_time = self.add_start(start_time);

    foreach (ind : self.successors) {
        project.get_ref(ind).schedule(project, start_time);
    }

    return start_time;
}

fn void Project.schedule(Project *self, Time start_time) {
    Task* task = self.get_ref(0);
    task.schedule(*self, start_time);
}

fn void Project.print(Project *self) {
    foreach (t: self) t.print();
}

fn int main(String[] args) {
	Project project;

    project.start();
    project.add_task("testing 1", 6.0);
    project.add_task("testing 2", 12.0);
    project.add_task("testing 3", 12.0);

    Time start;
    project.schedule(start);
    project.print();

	return 0;
}
