#include "advent_of_code.h"
#include "files.h"
#include "string"
#include "jlib.h"
#include <algorithm>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <print>
#include <sys/types.h>
#include <vector>

using std::string;
using std::vector;

uint32_t sumNeighbors(vector<string> data, Vec2 position) {
    uint32_t sum = 0;

    for (int32_t y_offset = -1; y_offset <= 1; y_offset++) {
        for (int32_t x_offset = -1; x_offset <= 1; x_offset++) {

            if ((position.y == 0 and y_offset == -1)
                or (static_cast<uint64_t>(position.y) == data.size() - 1 and y_offset == 1)) {
                continue;
            }

            size_t y_pos = static_cast<size_t>(position.y + y_offset);
            assert(y_pos < data.size());

            if ((position.x == 0 and x_offset == -1)
                or (static_cast<uint64_t>(position.x) == data[y_pos].length() - 1
                    and x_offset == 1)) {
                continue;
            }

            size_t x_pos = static_cast<size_t>(position.x + x_offset);

            if (x_offset == 0 and y_offset == 0) {
                continue;
            }

            assert(x_pos < data[y_pos].size());

            if (data[y_pos][x_pos] == '@') {
                sum++;
            }
        }
    }

    return sum;
}

vector<string> markAvaliableRolls(vector<string> lines) {
    auto output = lines;

    for (size_t i = 0; i < lines.size(); i++) {
        for (size_t j = 0; j < lines[i].length(); j++) {
            if (lines[i][j] != '@') {
                continue;
            }

            Vec2 position = Vec2(static_cast<int32_t>(j), static_cast<int32_t>(i));
            uint32_t sum = sumNeighbors(lines, position);

            if (sum < 4) {
                output[i][j] = 'x';
            }
        }
    }

    return output;
}

uint64_t countAvaliableRolls(vector<string> lines) {
    uint64_t total = 0;
    for (auto line : lines) {
        total = static_cast<uint64_t>(std::count(line.begin(), line.end(), 'x'));
    }
    return total;
}

int day4::run(string filepath, int part) {
    auto lines = readFileToVec(filepath);
    auto output = lines;

    u_int64_t running_sum = 0;

    uint64_t avaliable_rolls = 0;

    do {
        lines = markAvaliableRolls(lines);
        avaliable_rolls = countAvaliableRolls(lines);
    } while (avaliable_rolls != 0 and part == 2);

    running_sum += avaliable_rolls;

    std::println("{}", running_sum);

    return 0;
}
