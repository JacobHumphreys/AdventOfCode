const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const FileManager = @import("file_manager.zig");

const vec2 = struct {
    x: isize,
    y: isize,
    pub fn eql(self: vec2, other: vec2) bool {
        return self.x == other.x and self.y == other.y;
    }
};

const directions = struct {
    const UP = vec2{ .x = 0, .y = -1 };
    const DOWN = vec2{ .x = 0, .y = 1 };
    const LEFT = vec2{ .x = -1, .y = 0 };
    const RIGHT = vec2{ .x = 1, .y = 0 };

    pub fn rotate90(dir: vec2) vec2 {
        if (dir.eql(UP)) return RIGHT;
        if (dir.eql(DOWN)) return LEFT;
        if (dir.eql(LEFT)) return UP;
        if (dir.eql(RIGHT)) return DOWN;
        unreachable;
    }
};

pub fn run(alloc: Allocator) !void {
    const data = try FileManager.readFullFile("testInput.txt", alloc);
    defer alloc.free(data);
    const lines = try FileManager.splitByLine(data, alloc);
    defer alloc.free(lines);

    var new_lines = lines;

    var line_arena = std.heap.ArenaAllocator.init(alloc);
    const line_alloc = line_arena.allocator();
    defer line_arena.deinit();

    var direction = directions.UP;
    while (true) {
        const location = getGuardLocation(new_lines);

        if (location.eql(.{ .x = -1, .y = -1 })) break;

        const update = try offsetUntilObstical(location, direction, new_lines, line_alloc);

        new_lines = update;

        direction = directions.rotate90(direction);
    }

    std.debug.print("\n", .{});
    for (new_lines) |line| {
        std.debug.print("{s}\n", .{line});
    }

    var visited: u32 = 0;
    for (new_lines) |value| {
        for (value) |char| {
            if (char == 'X') visited += 1;
        }
    }

    std.debug.print("{}\n", .{visited});
}

pub fn offsetUntilObstical(location: vec2, offset: vec2, lines: [][]const u8, alloc: Allocator) ![][]const u8 {
    var line_changes = try alloc.alloc([]const u8, lines.len);
    for (line_changes, 0..) |_, i| {
        line_changes[i] = lines[i];
    }
    var new_y = location.y;
    var new_x = location.x;

    while (true) {
        const line = line_changes[@intCast(new_y)];
        var updated_line = try alloc.alloc(u8, line.len);
        std.mem.copyForwards(u8, updated_line, line);

        if (line[@intCast(new_x)] == '#') {
            new_y -= offset.y;
            new_x -= offset.x;
            const old_line = line_changes[@intCast(new_y)];
            var updated_old_line = try alloc.alloc(u8, old_line.len);
            std.mem.copyForwards(u8, updated_old_line, old_line);

            updated_old_line[@intCast(new_x)] = '^';
            line_changes[@intCast(new_y)] = updated_old_line;
            break;
        }

        updated_line[@intCast(new_x)] = 'X';
        line_changes[@intCast(new_y)] = updated_line;

        new_y += if ((new_y > 0 and offset.y < 0) or (new_y >= 0 and offset.y >= 0)) offset.y else break;
        new_x += if ((new_x > 0 and offset.x < 0) or (new_x >= 0 and offset.x >= 0)) offset.x else break;
        if (new_y == lines.len) break;
        if (new_x == line.len) break;
    }
    return line_changes;
}

pub fn getGuardLocation(lines: [][]const u8) vec2 {
    for (lines, 0..) |line, y| {
        for (line, 0..) |char, x| {
            if (char == '^') {
                return .{ .x = @intCast(x), .y = @intCast(y) };
            }
        }
    }
    return .{ .x = -1, .y = -1 };
}

test "s" {
    const alloc = std.testing.allocator;
    try run(alloc);
}
