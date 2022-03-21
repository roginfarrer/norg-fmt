#include <cstdlib>
#include <iostream>

#include <rang.hpp>

namespace neorg::logger {
    void dbg(std::string dbg_message) {
        std::cerr << rang::fg::gray << rang::style::bold << "debug: " << rang::style::reset
                  << dbg_message << std::endl;
    }

    void err(std::string err_message) {
        std::cerr << rang::fg::red << rang::style::bold << "error: " << rang::style::reset
                  << err_message << std::endl;
    }

    void err_fatal(std::string err_message) {
        std::cerr << rang::fg::red << rang::style::bold << "fatal: " << rang::style::reset
                  << err_message << std::endl;
        std::exit(1);
    }
} // namespace neorg::logger
