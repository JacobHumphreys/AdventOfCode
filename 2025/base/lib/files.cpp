#include <files.h>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <format>

using std::string;
using std::vector;

vector<string> readFileToVec(string path) {
    auto file = std::fstream(path);

    if (!file.is_open()) {
        throw std::runtime_error(std::format("Could not open file: {}", path));
    }

    vector<string> contents;

    string line;
    while (std::getline(file, line, '\n')) {

        line.erase(std::remove(line.begin(), line.end(), '\r'), line.end());
        line.erase(std::remove(line.begin(), line.end(), '\n'), line.end());

        if (line.empty()) {
            continue;
        }

        contents.push_back(line);
    }

    return contents;
}
