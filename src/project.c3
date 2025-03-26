module c3_scheduling;

import std::io;
import std::collections::list;

alias Project = List{Task};

faultdef UNKNOWN_TASK;

fn void Project.start(Project* self) {
    self.push(new_task("Start", 0.0));
}

fn void? Project.add_task_with_predecessors(Project* self, String name, float duration, usz[] predecessors) {
    foreach (p : predecessors) {
        if (p > self.len()) {
            io::printfn("Task #%d does not exist.", p);
            return UNKNOWN_TASK?;
        }
    }

    usz ind = self.len();
    self.push(new_task(name, duration));
    foreach (p : predecessors) {
        self.get_ref(ind).predecessors.push(p);
        self.get_ref(p).successors.push(ind);
    }
}

fn void Project.add_successor_task(Project* self, String name, float duration) {
    if (catch self.add_task_with_predecessors(name, duration, {self.len() - 1})) {
        io::printn("Cannot add a successor task to an empty project");
    }
}

fn void Project.schedule(Project *self, Time start_time) {
    Task* task = self.get_ref(0);
    task.schedule(*self, start_time);
}

fn void Project.print(Project *self) {
    foreach (i, t: self) {
        io::printf("%d :: ", i);
        t.print();
    }
}

