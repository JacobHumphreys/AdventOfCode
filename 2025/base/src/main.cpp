#include <cstdlib>
#include "advent_of_code.h"
#include "debug.h"
#include <bits/getopt_core.h>
#include <optional>
#include <string>

using std::optional;
using std::string;

int main(int argc, char** argv) {

    optional<string> filepath;
    optional<int> day;
    optional<int> part;

    int opt;
    while ((opt = getopt(argc, argv, "p:d:f:")) != -1) {
        switch (opt) {
        case 'p':
            part = std::atoi(optarg);
            break;
        case 'f':
            filepath = optarg;
            break;
        case 'd':
            day = std::atoi(optarg);
            break;
        }
    };

    if (!(filepath.has_value() and day.has_value() and part.has_value())) {
        error_print("missing arg");
        return 1;
    }

    switch (day.value()) {
    case 1:
        return day1::run(filepath.value());
    case 2:
        return day2::run(filepath.value(), part.value());
    case 3:
        return day3::run(filepath.value(), part.value());
    case 4:
        return day4::run(filepath.value(), part.value());
    case 5:
        return day5::run(filepath.value(), part.value());
    }
}
