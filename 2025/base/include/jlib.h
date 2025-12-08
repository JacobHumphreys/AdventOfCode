#pragma once

#ifdef __cplusplus

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

const Vec2 zero2 = Vec2(0, 0);

}


#else

#include "stdint.h"

typedef struct {
    int32_t x, y;
} Vec2;


Vec2 Vec2_add(Vec2 left, Vec2 right){
    return (Vec2){left.x + right.x, left.y + right.y};
}

Vec2 Vec2_sub(Vec2 left, Vec2 right){
    return (Vec2){left.x - right.x, left.y - right.y};
}

#endif // __cplusplus
