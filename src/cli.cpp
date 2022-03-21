#include <iostream>

#include <argparse/argparse.hpp>

namespace neorg::cli {
    // CLI private constants
    static const std::string VERSION("0.1.0a");
    static const std::string COPYRIGHT("Copyright (c) 2022 NTBBloodbath. norg-fmt "
                                       "is distributed under GPLv3 license.");

    // Initialize CLI
    argparse::ArgumentParser init(int argc, char *argv[]) {
        // '--version' output
        static const std::string version_output("norg-fmt v" + VERSION + "\n" + COPYRIGHT + "\n");
        // Argparse
        static argparse::ArgumentParser cli("norg-fmt", version_output);
        cli.add_argument("[FILE] ...").help("Neorg file(s)").remaining();

        try {
            cli.parse_args(argc, argv);
        } catch (const std::runtime_error &err) {
            std::cerr << err.what() << std::endl;
            std::cerr << cli;
            std::exit(1);
        }

        return cli;
    }
} // namespace neorg::cli
