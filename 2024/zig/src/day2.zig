const std = @import("std");
const io = std.io;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const day1 = @import("day1.zig");

pub fn run(alloc: Allocator) !void {
    var file = try std.fs.cwd().openFile("realInput.txt", .{});
    defer file.close();

    var file_reader = file.reader();

    var buffer: [4096]u8 = undefined; // Increase buffer size
    var temp_buffer: []u8 = &buffer;
    var num_safe: u32 = 0;

    var leftOverBuff: [1024]u8 = undefined;
    var leftOverLen: usize = 0;
    while (true) {
        const read_bytes = try file_reader.read(temp_buffer);
        if (read_bytes == 0) break;

        const chunk = temp_buffer[0..read_bytes];

        const combined = try std.mem.concat(alloc, u8, &.{ leftOverBuff[0..leftOverLen], chunk });
        defer alloc.free(combined);

        var lines = std.mem.split(u8, combined, "\n");
        while (lines.next()) |line| {
            if (lines.peek() == null) {
                std.mem.copyForwards(u8, &leftOverBuff, line);
                leftOverLen = line.len;
                break;
            }

            var list_buffer: [64]i32 = undefined;
            const num_list = try getNumbersFromLine(line, &list_buffer);

            if (try isSafeWithDampen(num_list, false)) {
                num_safe += 1;
            }
        }
    }

    std.debug.print("safe: {}\n", .{num_safe});
}

const CHANGE = enum { INCREASING, DECREASING, UNKNOWN };
fn isSafe(num_list: []i32) bool {
    if (num_list.len <= 1) return false;

    var change = CHANGE.UNKNOWN;
    for (num_list, 0..) |value, i| {
        if (i == num_list.len - 1) return true;

        const next_value = num_list[i + 1];
        const delta = next_value - value;
        const current_change = if (delta > 0) CHANGE.INCREASING else CHANGE.DECREASING;

        const distance = if (delta < 0) delta * -1 else delta;

        if (distance < 1 or distance > 3) return false;

        if (change == CHANGE.UNKNOWN) {
            change = current_change;
        } else if (current_change != change) {
            return false;
        }
    }
    unreachable;
}

fn isSafeWithDampen(num_list: []i32, dampened: bool) Allocator.Error!bool {
    if (num_list.len <= 1) return false;

    var change = CHANGE.UNKNOWN;
    for (num_list, 0..) |value, i| {
        if (i == num_list.len - 1) return true;

        const next_value = num_list[i + 1];
        const delta = next_value - value;
        const current_change = if (delta > 0) CHANGE.INCREASING else CHANGE.DECREASING;

        const distance = if (delta < 0) delta * -1 else delta;

        if (distance < 1 or distance > 3) {
            if (dampened) return false;

            if (try dampen_list(num_list, i)) return true;
            return dampen_list(num_list, i + 1);
        }

        if (change == CHANGE.UNKNOWN) {
            change = current_change;
        } else if (current_change != change) {
            if (dampened) return false;

            if (try dampen_list(num_list, i)) return true;
            if (try dampen_list(num_list, i + 1)) return true;
            if (i == 1) return dampen_list(num_list, i - 1);

            return false;
        }
    }
    unreachable;
}

fn dampen_list(num_list: []i32, i: usize) Allocator.Error!bool {
    var buff: [4 * 32]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buff);
    const alloc = fba.allocator();
    var dampened_list = ArrayList(i32).init(alloc);
    try dampened_list.appendSlice(num_list);
    _ = dampened_list.orderedRemove(i);
    const dampened_slice = try dampened_list.toOwnedSlice();
    const safe_with_dampen = isSafeWithDampen(dampened_slice, true);
    alloc.free(dampened_slice);
    return safe_with_dampen;
}

pub fn getNumbersFromLine(line: []const u8, buffer: *[64]i32) ![]i32 {
    var num_buff: [15]u8 = undefined;
    var num_size: usize = 0;
    var list_size: usize = 0;
    for (line, 0..) |char, i| {
        if (day1.isNum(char)) {
            num_buff[num_size] = char;
            num_size += 1;
            if (line.len - 1 != i) continue;
        }

        if (std.mem.eql(u8, num_buff[0..num_size], "")) continue;

        const val = try std.fmt.parseInt(i32, num_buff[0..num_size], 10);
        buffer[list_size] = val;
        list_size += 1;
        num_size = 0;
    }
    return buffer[0..list_size];
}
