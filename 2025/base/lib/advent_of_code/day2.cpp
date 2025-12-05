#include <cassert>
#include "advent_of_code.h"
#include "files.h"
#include <cstddef>
#include <cstdint>
#include <format>
#include <print>
#include <vector>
#include <string>
#include <optional>

using std::string;
using std::vector;
using std::optional;

vector<string> split(string str, const char delim) {
    size_t index;
    bool scanning = true;

    vector<string> tokens;
    while (scanning) {
        string token;
        if ((index = str.find(delim)) == string::npos) {
            token = str;
            scanning = false;
        } else {
            token = str.substr(0, index);
            str = str.substr(index + 1);
        }

        tokens.push_back(token);
    }

    return tokens;
}

optional<vector<string>> splitLength(const string &str, const size_t length) {
    if ( str.length() % length != 0) {
        return {};
    }
    vector<string> tokens;
    for (size_t i = 0; i < str.length() / length; i++) {
        size_t start = i * length;
        tokens.push_back(str.substr(start, length));
    }
    return tokens;
}

bool isReflective(const string &val_str) {
    if (val_str.length() % 2 == 1) {
        return false;
    }
    for (size_t i = 0; i < val_str.length() / 2; i++) {
        if (val_str[i] != val_str[(val_str.length() / 2) + i]) {
            return false;
        }
    }
    return true;
}

bool isRepetitive(const string &val_str) {
    for (size_t section_size = val_str.length() / 2; section_size > 0; section_size-- ) {
        auto sections = splitLength(val_str, section_size);
        if (!sections.has_value()) {
            continue;
        }

        bool match = true;
        for (size_t i = 0; i < sections.value().size() - 1; i++) {
            auto this_s = sections.value()[i];
            auto next = sections.value()[i + 1];
            if (this_s != next) {
                match = false;
            }
        }

        if (match)
            return true;
    }
    return false;
}

int day2::run(string filepath, int part) {
    assert(isReflective("123123"));
    assert(isReflective("11"));
    assert(!isReflective("25"));

    assert(isRepetitive("123123"));
    assert(isRepetitive("11"));
    assert(!isRepetitive("252"));
    assert(isRepetitive("123123123"));
    assert(!isRepetitive("2121212118"));

    auto data = readFileToVec(filepath);

    auto line = data[0];

    auto ranges = split(line, ',');

    uint64_t total = 0;

    for (string range: ranges) {
        size_t split = range.find('-');
        int64_t lower = std::stol(range.substr(0, split));
        int64_t upper = std::stol(range.substr(split + 1));

        for (int64_t value = lower; value <= upper; value++) {
            string val_str = std::format("{}", value);

            if (isReflective(val_str) and part == 1) {
                total += static_cast<uint64_t>(value);
            } else if (isRepetitive(val_str) and part == 2) {
                total += static_cast<uint64_t>(value);
            }
        }
    }

    std::println("Total {}", total);
    return 0;
}
