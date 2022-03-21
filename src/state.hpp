#pragma once
#include <iostream>
#include <tree_sitter/api.h>

using std::string;

// NOTE: we will maybe not need current_ln and file_pos, this is a reminder to remove them later
struct State {
    int current_ln = 0;
    int file_pos = 0;
    string neorg_in_file;
    string neorg_out_file;
    TSNode root_node;
};
