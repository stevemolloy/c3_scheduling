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
    self.push(new_task(name, duration));
    
    usz num_eles = self.len();
    self.get_ref(num_eles - 2).successors.push(num_eles - 1);
    self.get_ref(num_eles - 1).predecessors.push(num_eles - 2);
}

fn void Project.schedule(Project *self, Time start_time) {
    Task* task = self.get_ref(0);
    task.schedule(*self, start_time);
}

fn void Project.print(Project *self) {
    foreach (t: self) t.print();
}

