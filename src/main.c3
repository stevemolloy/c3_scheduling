module c3_scheduling;

import std::io;
import std::collections::list;

int task_id = 0;
def Project = List(<Task>);

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
    io::printf("\n");
}

fn void Project.start(Project* self) {
    self.push(new_task("Start", 0.0));
}

fn void Project.add_task(Project* self, String name, float duration) {
    Task task = {
        .id = task_id,
        .name = name,
        .duration = duration,
    };
    task_id += 1;

    task.predecessors.push(self.get_ref(self.len()-1));

    Task* last = self.get_ref(self.len() - 1);
    last.successors.push(&task);

    self.push(task);
}

fn int main(String[] args) {
	Project project;

    io::printn("Starting:");
    project.start();
    foreach (task : project) task.print();

    io::printn("Added a task:");
    project.add_task("testing 1", 0.5);
    foreach (task : project) task.print();

    io::printn("Added a task:");
    project.add_task("testing 2", 2.5);
    foreach (task : project) task.print();

    io::printn("Added a task:");
    project.add_task("testing 3", 1.5);
    foreach (task : project) task.print();

	return 0;
}
