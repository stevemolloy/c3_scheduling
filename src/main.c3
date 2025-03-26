module c3_scheduling;

import std::io;
import std::io::file;
import std::collections::list;

fn int main(String[] args) {
	Project project;

    String filename = "./resources/input_data.csv";
    String? contents = (String)file::load(mem, filename);
    if (catch contents) {
        io::printfn("Could not load %s", filename);
        return 1;
    }
    defer free(contents);

    String[] lines = contents.split(mem, "\n");
    defer free(lines);

    foreach (i, line : lines) {
        line = line.trim();
        String[] tokens = line.split(mem, ";");
        defer free(tokens);

        String name;
        HourNum duration;
        foreach (token_ind, token : tokens) {
            token = token.trim();
            if (token_ind == 0) name = token;
            if (token_ind == 1) {
                HourNum? test = token.to_float();
                if (catch test) return 1;
                duration = test;
            }
        }
        if (name.len > 0 || duration > 0) {
            if (project.len() == 0) {
                project.push(new_task(name, duration));
            } else {
                project.add_successor_task(name, duration);
            }
        }
    }

    Time start;
    project.schedule(start);
    project.print();

	return 0;
}
