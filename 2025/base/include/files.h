#pragma once

#include <vector>
#include <string>

// throws runtime_error if file was not opened
std::vector<std::string> readFileToVec(std::string path);
