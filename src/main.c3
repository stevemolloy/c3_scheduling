module c3_scheduling;

import std::io;
import std::io::file;
import std::collections::list;

fn int main(String[] args) {
    // String filename = "./resources/input_data.csv";
    String filename = "./resources/short_input_data.csv";
    String? contents = (String)file::load(mem, filename);
    if (catch contents) {
        io::printfn("Could not load %s", filename);
        return 1;
    }
    defer free(contents);

    String[] lines = contents.split(mem, "\n");
    defer free(lines);

	Project project;
    foreach (i, line : lines) {
        line = line.trim();
        String[] tokens = line.split(mem, ";");
        defer free(tokens);

        String name;
        HourNum duration;
        List{usz} predecessors;
        foreach (token_ind, token : tokens) {
            token = token.trim();
            if (token_ind == 0) {
                name = token;
            } else if (token_ind == 1) {
                HourNum? test = token.to_float();
                if (catch test) return 1;
                duration = test;
            } else if (token_ind == 2 && token.len > 0) {
                String[] preds = token.split(mem, ",");
                defer free (preds);
                foreach (pred_str : preds) {
                    pred_str = pred_str.trim();
                    if (pred_str.len == 0) continue;
                    uint? task_ind = pred_str.to_uint();
                    if (catch task_ind) {
                        io::printfn("Could not convert %s to uint", pred_str);
                        return 1;
                    }
                    task_ind -= 1; // Stupid one-based indexing
                    predecessors.push(task_ind);
                }
            }
        }

        if (name.len > 0 || duration > 0) {
            usz curr_ind = project.len();

            project.push(new_task(name, duration));
            if (predecessors.len() > 0) {
                foreach (predecessor : predecessors) {
                    if (catch add_predecessor_link_to_task(&project, curr_ind, predecessor)) return 1;
                }
            }
        }
    }

    Time start;
    schedule_project(&project, start);
    project.print();

	return 0;
}
