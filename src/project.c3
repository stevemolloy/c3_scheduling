module c3_scheduling;

import std::io;
import std::collections::list;

alias Project = List{Task};

faultdef UNKNOWN_TASK;

fn void Project.start(Project* self) {
    self.push(new_task("Start", 0.0));
}

fn void? add_task_with_predecessors(Project* project, String name, float duration, usz[] predecessors) {
    foreach (p : predecessors) {
        if (p > project.len()) {
            io::printfn("Task #%d does not exist.", p);
            return UNKNOWN_TASK?;
        }
    }

    usz ind = project.len();
    project.push(new_task(name, duration));
    foreach (p : predecessors) {
        project.get_ref(ind).predecessors.push(p);
        project.get_ref(p).successors.push(ind);
    }
}

fn void add_successor_task(Project* project, String name, float duration) {
    if (catch add_task_with_predecessors(project, name, duration, {project.len() - 1})) {
        io::printn("Cannot add a successor task to an empty project");
    }
}

fn void? add_successor_link_to_task(Project* project, usz task_ind, usz succ_ind) {
    if (task_ind > project.len()) {
        io::printfn("Task %d not found", task_ind);
        return UNKNOWN_TASK?;
    }
    if (succ_ind > project.len()) {
        io::printfn("Task %d not found", succ_ind);
        return UNKNOWN_TASK?;
    }

    project.get_ref(task_ind).successors.push(succ_ind);
    project.get_ref(succ_ind).predecessors.push(task_ind);
}

fn void? add_predecessor_link_to_task(Project* project, usz task_ind, usz pred_ind) {
    // io::printfn("Called add_predecessor_link_to_task with task_ind = %d and pred_ind = %d", task_ind, pred_ind);
    if (task_ind >= project.len()) {
        io::printfn("Task %d not found", task_ind);
        return UNKNOWN_TASK?;
    }
    if (pred_ind >= project.len()) {
        io::printfn("Task %d not found", pred_ind);
        return UNKNOWN_TASK?;
    }

    project.get_ref(pred_ind).successors.push(task_ind);
    project.get_ref(task_ind).predecessors.push(pred_ind);
}

fn void schedule_project(Project *project, Time start_time) {
    Task* task = project.get_ref(0);
    schedule_task(task, *project, start_time);
}

fn void Project.print(Project *self) {
    foreach (i, t: self) {
        io::printf("%d :: ", i);
        t.print();
    }
}

