const std = @import("std");
const io = std.io;
const ArrayList = std.ArrayList;
const Arena = std.heap.ArenaAllocator;

pub fn run(Allocator: std.mem.Allocator) !void {
    var arena = Arena.init(Allocator);
    const alloc = arena.allocator();
    defer arena.deinit();

    var file = try std.fs.cwd().openFile("testInput.txt", .{});
    defer file.close();
    var reader = file.reader();
    var buffer: [1024]u8 = undefined;
    var line = try reader.readUntilDelimiterOrEof(&buffer, '\n');

    var left = ArrayList(i32).init(alloc);
    var right = ArrayList(i32).init(alloc);

    while (!std.mem.eql(u8, line.?, "")) {
        var num_list = try getNumbersFromLine(line.?, alloc);
        defer num_list.deinit();
        try left.append(num_list.items[0]);
        try right.append(num_list.items[1]);
        line = try reader.readUntilDelimiterOrEof(&buffer, '\n');
        if (line == null) break;
    }

    //    const pairs = try getDistances(&left_values, &right_values, alloc);
    const frequencies = try getFrequencies(&left, &right, alloc);

    var total: i32 = 0;
    for (frequencies) |val| {
        total += val;
    }
    std.debug.print("{}\n", .{total});
}

fn getFrequencies(left_values: *ArrayList(i32), right_values: *ArrayList(i32), alloc: std.mem.Allocator) ![]i32 {
    var frequencies = ArrayList(i32).init(alloc);
    var occurances: i32 = 0;
    for (left_values.items) |left_num| {
        for (right_values.items) |right_num| {
            if (left_num == right_num) occurances += 1;
        }
        try frequencies.append(left_num * occurances);
        occurances = 0;
    }
    return frequencies.toOwnedSlice();
}

fn getDistances(left_values: *ArrayList(i32), right_values: *ArrayList(i32), alloc: std.mem.Allocator) ![]i32 {
    var pairs = ArrayList(u32).init(alloc);
    while (left_values.items.len > 0) {
        const left_min: u32 = getMin(left_values.*);
        const right_min: u32 = getMin(right_values.*);
        for (0..left_values.items.len) |i| {
            if (left_values.items[i] == left_min) {
                _ = left_values.orderedRemove(i);
                break;
            }
        }
        for (0..right_values.items.len) |i| {
            if (right_values.items[i] == right_min) {
                _ = right_values.orderedRemove(i);
                break;
            }
        }

        try pairs.append(distance(right_min, left_min));
    }
    return try pairs.toOwnedSlice();
}

fn getMin(list: ArrayList(i32)) i32 {
    var min: u32 = list.items[0];
    for (list.items) |value| {
        if (value < min) {
            min = value;
        }
    }
    return min;
}

pub fn distance(first: i32, second: i32) i32 {
    const big = if (first >= second) first else second;
    const small = if (first < second) first else second;
    return big - small;
}

pub fn getNumbersFromLine(line: []const u8, alloc: std.mem.Allocator) !ArrayList(i32) {
    var currentNum = ArrayList(u8).init(alloc);
    defer currentNum.deinit();
    var numlist = ArrayList(i32).init(alloc);
    for (line, 0..) |char, i| {
        if (isNum(char)) {
            try currentNum.append(char);
            if (line.len - 1 != i) continue;
        }

        if (std.mem.eql(u8, currentNum.items, "")) continue;

        const val = try std.fmt.parseInt(i32, currentNum.items, 10);
        try numlist.append(val);
        var j = currentNum.items.len;
        while (j > 0) {
            _ = currentNum.orderedRemove(j - 1);
            j -= 1;
        }
    }
    return numlist;
}

pub fn isNum(value: u8) bool {
    if (value < 48 or value > 57) {
        return false;
    }
    return true;
}

//test "parseMem" {
//    var list = try getNumbersFromLine("1 2 3", std.testing.allocator);
//    defer list.deinit();
//}
//
//test "day1Leaks" {
//    try run(std.testing.allocator);
//}
