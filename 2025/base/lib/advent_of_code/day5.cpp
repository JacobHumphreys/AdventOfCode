#include "advent_of_code.h"
#include "files.h"
#include <algorithm>
#include <cassert>
#include <climits>
#include <cstddef>
#include <cstdint>
#include <map>
#include <optional>
#include <print>
#include <ranges>
#include <string>
#include <vector>

using std::string;
using std::vector;

using std::optional;
using std::ranges::views::filter;
using std::ranges::views::transform;

struct Range {
    int64_t lower, upper;

    bool inRange(int64_t value) { return value <= upper and value >= lower; }

    string toString() { return std::format("{}-{}", lower, upper); }

    optional<Range> merge(Range other) {
        int64_t lower_merged, upper_merged;

        if (inRange(other.lower)) {
            lower_merged = this->lower;
        } else if (other.inRange(lower)) {
            lower_merged = other.lower;
        } else {
            return {};
        }

        if (inRange(other.upper)) { // this.upper >= other.upper
            upper_merged = this->upper;
        } else if (other.inRange(upper)) { // other.upper >= this.upper
            upper_merged = other.upper;
        } else { // lists cannot be merged
            return {};
        }

        return (Range) { .lower = lower_merged, .upper = upper_merged };
    };

    bool operator==(Range other) {
        return this->lower == other.lower and this->upper == other.upper;
    }
};

vector<Range> mergeRanges(vector<Range> ranges) {
    bool combined = false;

    do {
        combined = false;

        std::map<string, bool> combination_map;

        vector<Range> combined_list;
        for (size_t i = 0; i < ranges.size(); i++) {
            auto outer_range = ranges[i];
            for (size_t j = i + 1; j < ranges.size(); j++) {
                auto inner_range = ranges[j];

                auto merged = outer_range.merge(inner_range);
                if (!merged.has_value()) {
                    continue;
                }

                if (std::find(combined_list.begin(), combined_list.end(), merged.value())
                    == combined_list.end()) {
                    combined_list.push_back(merged.value());
                }

                combined = true;
                combination_map[outer_range.toString()] = true;
                combination_map[inner_range.toString()] = true;
            }

            if (!combination_map[outer_range.toString()]) {
                combined_list.push_back(outer_range);
            }
        }

        ranges = combined_list;
    } while (combined);

    return ranges;
}

vector<Range> parseRanges(vector<string> lines) {
    vector<Range> ranges;

    for (auto line : lines) {
        if (size_t index = line.find('-'); index != string::npos) {
            long lower = std::stol(line.substr(0, index + 1));
            long upper = std::stol(line.substr(index + 1));

            ranges.push_back({ lower, upper });
            continue;
        }
        break;
    }

    return ranges;
};

vector<int64_t> parseValues(vector<string> lines) {
    auto v = transform(
        filter(
            lines, [](string str) { return str.find('-') == string::npos and str.length() != 0; }),
        [](string str) -> int64_t { return std::stol(str); });

    return vector<int64_t>(v.begin(), v.end());
};

uint64_t getValidValues(vector<Range> merged_ranges, vector<int64_t> values) {
    uint64_t valid_counter = 0;

    for (auto range : merged_ranges) {
        for (auto value : values) {
            if (range.inRange(value)) {
                valid_counter += 1;
            }
        }
    }

    return valid_counter;
}

uint64_t getValidValues(vector<Range> ranges) {

    uint64_t values = 0;

    for (auto range : ranges) {
        values += static_cast<uint64_t>(range.upper - range.lower) + 1;
    }

    return values;
}

int day5::run(string filepath, int part) {
    auto lines = readFileToVec(filepath);

    auto ranges = parseRanges(lines);
    ranges = mergeRanges(ranges);

    std::println("Finishd Merging");

    auto values = parseValues(lines);

    if (part == 2) {
        values.clear();
    }

    std::println("Count: {}", part == 1 ? getValidValues(ranges, values) : getValidValues(ranges));

    return 0;
}
