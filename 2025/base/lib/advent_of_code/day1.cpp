#include "advent_of_code.h"
#include "debug.h"
#include "files.h"
#include <cstddef>
#include <exception>
#include <fstream>
#include <print>
#include <vector>

using std::string;
using std::vector;

int mod(int numerator, int denominator) {
    int value = numerator % denominator;
    return value >= 0 ? value : value + denominator;
}

int simulateRotation(int position, int range_size, int direction) {
    return mod(position + direction, range_size);
}

int day1::run(string filepath) {
    const string path = filepath;

    string output_file_path;
    if (size_t index = path.find_last_of('/'); index != string::npos) {
        output_file_path = "./output/day1/" + path.substr(index + 1);
    } else {
        output_file_path = "./output/day1/" + path;
    }

    std::println("{}", output_file_path);

    if (std::fstream(output_file_path).is_open()) {
        std::remove(output_file_path.c_str());
    }

    std::fstream out = std::fstream(output_file_path, std::ios::out | std::ios::app);

    vector<string> input;
    try {
        input = readFileToVec(path);
    } catch (std::exception& e) {
        error_print(e.what());
        return 1;
    }

    int position = 50;

    int total = 0;
    int range_size = 100;
    int total_with_clicks = 0;
    for (string line : input) {
        int direction = std::stoi(line.substr(1));
        direction = line[0] == 'L' ? -direction : direction;

        // std::println(out, "Position: {} | Direction {}", position, direction);
        // std::print(out, "\tSum: {} -> ", position + direction);

        if (int sum = position + direction; sum <= 0 or sum >= range_size) {
            int amount = std::abs((sum <= 0 ? sum - range_size : sum) / range_size);

            // This took too long to get right
            if (position == 0 and direction <= 0) {
                amount -= 1;
            }
            // std::println(out, "Clicks: {}", amount);
            total_with_clicks += amount;
        }

        position = simulateRotation(position, range_size, direction);
        // std::println(out, "\tNew Position: {}", position);

        if (position == 0) {
            total += 1;
        }
    }

    std::println(out, "Password: {}", total);
    std::println(out, "Password 2: {}", total_with_clicks);

    out.close();

    return 0;
}
