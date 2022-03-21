#pragma once
#include <argparse/argparse.hpp>

namespace neorg::cli {
    argparse::ArgumentParser init(int argc, char *argv[]);
}
