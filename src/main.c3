module c3_scheduling;

import std::io;
import std::collections::list;

fn int main(String[] args) {
	Project project;

    project.start();
    project.add_successor_task("testing 1", 1.0);
    project.add_successor_task("testing 2", 1.0);
    project.add_successor_task("testing 3", 1.0);
    project.add_successor_task("testing 4", 1.0);
    project.add_successor_task("testing 5", 1.0);
    project.add_successor_task("testing 6", 1.0);
    project.add_successor_task("testing 7", 1.0);
    project.add_successor_task("testing 8", 1.0);
    project.add_successor_task("testing 9", 1.0);
    project.add_successor_task("testing 10", 1.0);
    project.add_successor_task("testing 11", 1.0);
    project.add_successor_task("testing 12", 1.0);
    project.add_successor_task("testing 13", 1.0);
    project.add_successor_task("testing 14", 1.0);
    project.add_successor_task("testing 15", 1.0);
    if (catch project.add_task_with_predecessors("testing 16", 1.0, {0, 2, 4, 6})) return 1;

    Time start;
    project.schedule(start);
    project.print();

	return 0;
}
