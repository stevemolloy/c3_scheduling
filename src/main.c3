module c3_scheduling;

import std::io;
import std::collections::list;

int task_id = 0;

enum DurationType { WORKING_TIME, ELAPSED_TIME, }

struct Task {
    int id;
    String name;
    float duration;
    DurationType duration_type;
    List(<Task*>) successors;
    List(<Task*>) predecessors;
}

fn Task new_task(String name, float duration) {
    Task retval = {.id = task_id, .name = name, .duration = duration};
    task_id += 1;
    return retval;
}

fn void Task.print(Task* self) {
    io::printf("%2d: \"%s\" -- %0.2f hours ", self.id, self.name, self.duration);
    if (self.duration_type == ELAPSED_TIME) {
        io::printf(" (elapsed) ");
    }
    io::printf("Successors: ");
    foreach (i, succ : self.successors) {
        if (i!=0) io::printf(", ");
        io::printf("%d ", succ.id);
    }
    io::printf("Predecessors: ");
    foreach (i, pred : self.predecessors) {
        if (i!=0) io::printf(", ");
        io::printf("%d ", pred.id);
    }
    io::printf("\n");
}

def Project = List(<Task>);

fn void Project.start(Project* self) {
    self.push(new_task("Start", 0.0));
}

fn void Project.add_task(Project* self, String name, float duration) {
    Task task = new_task(name, duration);
    task.predecessors.push(self.get_ref(self.len()-1));

    Task* last = self.get_ref(self.len() - 1);
    last.successors.push(@clone(task));

    self.push(task);
}

fn int main(String[] args) {
	Project project;

    project.start();

    project.add_task("testing 1", 0.5);
    project.add_task("testing 2", 2.5);
    project.add_task("testing 3", 1.5);

    foreach (task : project) task.print();

	return 0;
}
