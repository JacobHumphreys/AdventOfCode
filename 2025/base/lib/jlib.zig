const jlib = @cImport(@cInclude("jlib.h"));

const Vec2 = struct {
    x: i32,
    y: i32,

    pub fn init(x: i32, y: i32) Vec2 {
        return .{ x, y };
    }

    pub fn fromC(c_vec: jlib.Vec2) Vec2 {
        const vec: *Vec2 = @ptrCast(c_vec);
        return vec.*;
    }

    pub fn add(self: *Vec2, other: Vec2) Vec2 {
        return fromC(jlib.Vec2_add(self.toC(), other.toC()));
    }

    pub fn toC(self: *Vec2) jlib.Vec2 {
        return @as(*jlib.Vec2, @ptrCast(self)).*;
    }

    pub fn sub(self: *Vec2, other: Vec2) Vec2 {
        return fromC(jlib.Vec2_sub(self.toC(), other.toC()));
    }
};
