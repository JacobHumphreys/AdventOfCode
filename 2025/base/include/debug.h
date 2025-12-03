#pragma once

#include "format"
#include "print"
#include "iostream"

#define error_print(error) std::println(std::cerr, "Error: {}", error)
#define error_print_fmt(fmt, args...) std::println(std::cerr, "Error: {}", std::format(fmt, args))
