#pragma once

#include <cstdint>
struct Vec2 {
    int32_t x, y;

    Vec2(int32_t x, int32_t y)
        : x(x)
        , y(y) { }

    Vec2 operator+(Vec2 other) { return Vec2(this->x + other.x, this->y + other.y); }
    void operator+=(Vec2 other) {
        this->x += other.x;
        this->y += other.y;
    }

    bool operator==(Vec2 other) { return this->x == other.x and this->y == other.y; }

    Vec2 operator-(Vec2 other) { return Vec2(this->x - other.x, this->y - other.y); }
    void operator-=(Vec2 other) {
        this->x -= other.x;
        this->y -= other.y;
    }
};

namespace Vectors {

Vec2 zero2 = Vec2(0, 0);

}
