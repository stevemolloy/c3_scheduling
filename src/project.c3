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

fn void? Project.add_successor_link_to_task(Project* self, usz task_ind, usz succ_ind) {
    if (task_ind > self.len()) {
        io::printfn("Task %d not found", task_ind);
        return UNKNOWN_TASK?;
    }
    if (succ_ind > self.len()) {
        io::printfn("Task %d not found", succ_ind);
        return UNKNOWN_TASK?;
    }

    self.get_ref(task_ind).successors.push(succ_ind);
    self.get_ref(succ_ind).predecessors.push(task_ind);
}

fn void? Project.add_predecessor_link_to_task(Project* self, usz task_ind, usz pred_ind) {
    // io::printfn("Called add_predecessor_link_to_task with task_ind = %d and pred_ind = %d", task_ind, pred_ind);
    if (task_ind >= self.len()) {
        io::printfn("Task %d not found", task_ind);
        return UNKNOWN_TASK?;
    }
    if (pred_ind >= self.len()) {
        io::printfn("Task %d not found", pred_ind);
        return UNKNOWN_TASK?;
    }

    self.get_ref(pred_ind).successors.push(task_ind);
    self.get_ref(task_ind).predecessors.push(pred_ind);
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

