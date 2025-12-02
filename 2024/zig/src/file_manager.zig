const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn readFullFile(file_name: []const u8, allocator: Allocator) ![]const u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();
    var local_allocator = arena.allocator();

    var file_chunks = ArrayList([]const u8).init(local_allocator);
    defer file_chunks.deinit();
    var file = try std.fs.cwd().openFile(file_name, .{});
    defer file.close();

    var file_reader = file.reader();

    var buffer: [1024 * 4]u8 = undefined; // Increase buffer size
    var temp_buffer: []u8 = &buffer;

    var char_count: usize = 0;
    while (true) {
        const read_bytes = try file_reader.read(temp_buffer);
        if (read_bytes == 0) break;

        const chunk = temp_buffer[0..read_bytes];
        const heap_chunk = try local_allocator.alloc(u8, chunk.len);
        std.mem.copyForwards(u8, heap_chunk, chunk);
        try file_chunks.append(heap_chunk);
        char_count += chunk.len;
    }

    var file_data = try allocator.alloc(u8, char_count);
    var index: usize = 0;
    for (file_chunks.items) |chunk| {
        if (index >= file_data.len) break;
        for (chunk) |char| {
            file_data[index] = char;
            index += 1;
        }
    }
    return file_data;
}

pub fn splitByLineMutable(data: *[]u8, allocator: Allocator) ![]*[]u8 {
    var line_count: usize = 0;
    for (data.*) |char| {
        if (char == '\n') line_count += 1;
    }
    var lines = try allocator.alloc(*[]u8, line_count);
    var index: usize = 0;
    var endPoint: usize = 0;
    for (data.*, 0..) |char, i| {
        if (char == '\n' or i == data.len - 1) {
            var slice = data.*[endPoint..i];
            if (i == data.len - 1) slice = data.*[endPoint..];
            lines[index] = &slice;
            endPoint = i + 1;
            index += 1;
        }
    }
    return lines;
}

pub fn splitByLine(data: []const u8, allocator: Allocator) ![][]const u8 {
    var line_count: usize = 0;
    for (data) |char| {
        if (char == '\n') line_count += 1;
    }
    var lines = try allocator.alloc([]const u8, line_count);
    var index: usize = 0;
    var it = std.mem.splitSequence(u8, data, "\n");
    var line: ?[]const u8 = it.first();
    while (line != null) {
        if (index >= line_count) break;
        lines[index] = line.?;
        index += 1;
        defer line = it.next();
    }
    return lines;
}
