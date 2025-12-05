#include "advent_of_code.h"
#include "files.h"
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <print>
#include <string>

using std::string;
using std::optional;

uint64_t getBankVoltage(string bank, size_t length) {
    string num;
    for (size_t i = 0; i < length; i++) {
        num += ' ';
    }
    assert(length == num.size());

    optional<size_t> last_i = {};
    for (size_t digit_index = 0; digit_index < length; digit_index++) {
        size_t prefix_length = last_i.has_value() ? last_i.value() + 1 : 0;
        size_t postfix_length = (length - (digit_index + 1));

        size_t window_len = bank.length() - (prefix_length) - (postfix_length);
        for (size_t min_index = prefix_length; min_index <= last_i.value_or(0) + window_len; window_len++) {
            assert(window_len < bank.length());

            string window = bank.substr(min_index, window_len);

            string digit;
            for (int i = 9; i >= 0; i--) {
                digit = std::to_string(i);
                assert(digit.length() == 1);

                size_t index = window.find(digit);

                if (index == string::npos) {
                    continue;
                }

                if (last_i.has_value())
                    last_i.value() = index + (min_index);
                else
                    last_i = index;

                break;
            }

            num[digit_index] = digit[0];
            break;
        }
    }

    return static_cast<uint64_t>(std::stol(string(num.begin(), num.end())));
}

int day3::run(std::string filepath, int part) {
    auto data = readFileToVec(filepath);

    size_t size = 2;
    if (part == 2) {
        size = 12;
    }

    uint64_t total = 0;
    for (auto line: data) {
        uint64_t voltage = getBankVoltage(line, size);
        total += voltage;
    }

    std::println("Total: {}", total);


    return 0;
}
