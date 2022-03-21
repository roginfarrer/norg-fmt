#pragma once
#include <iostream>

namespace neorg::logger {
    void dbg(std::string dbg_message);

    void err(std::string err_message);

    void err_fatal(std::string err_message);
} // namespace sun::logger
