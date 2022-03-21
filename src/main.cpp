#include <cstring>
#include <fstream>
#include <iostream>
#include <sstream>

#include "cli.hpp"
#include "logger.hpp"
#include "state.hpp"
#include <argparse/argparse.hpp>
#include <tree_sitter/api.h>

extern "C" {
TSLanguage *tree_sitter_norg();
}

int main(int argc, char *argv[]) {
    // ===== Initialize CLI
    argparse::ArgumentParser cli = neorg::cli::init(argc, argv);

    // Get source code files from stdin
    std::vector<std::string> files;
    try {
        files = cli.get<std::vector<std::string>>("[FILE] ...");
    } catch (std::logic_error &err) {
        // Raise an error and print help message if no files were passed
        neorg::logger::err("No neorg files provided");
        std::cout << cli.help().str();
    }

    // TODO: scan every passed file instead of just first one
    std::string input_file_name(files[0]);
    std::ifstream file(input_file_name);
    if (!file)
        neorg::logger::err_fatal("Unable to open '" + input_file_name +
                                 "' file: " + strerror(errno));

    std::ostringstream ss;
    ss << file.rdbuf();
    std::string neorg_file_contents = ss.str();

    // Create a new tree-sitter parser
    TSParser *parser = ts_parser_new();

    // Set the parser's language
    ts_parser_set_language(parser, tree_sitter_norg());

    // Generate syntax tree for given norg file
    TSTree *tree = ts_parser_parse_string(parser, NULL, neorg_file_contents.c_str(),
                                          neorg_file_contents.length());

    // Get the root node of the syntax tree
    TSNode root_node = ts_tree_root_node(tree);

    // Initialize formatter state
    State state = {
        0,                   // current line
        0,                   // file position
        neorg_file_contents, // neorg files content
        input_file_name,     // neorg files names
        root_node,           // Tree-Sitter root node
    };

    // Print the syntax tree as an S-expression.
    std::string tree_rep = ts_node_string(root_node);
    neorg::logger::dbg(tree_rep);

    // Free heap memory
    ts_tree_delete(tree);
    ts_parser_delete(parser);

    std::exit(0);
}
