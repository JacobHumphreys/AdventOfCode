const std = @import("std");
const d1 = @import("day1.zig");
const d2 = @import("day2.zig");
const d3 = @import("day3.zig");
const d4 = @import("day4.zig");
const d5 = @import("day5.zig");
const d6 = @import("day6.zig");
const PageAllocator = std.heap.page_allocator;

pub fn main() !void {
//    var buff: [1024 * 64]u8 = undefined;
//    var fba = std.heap.FixedBufferAllocator.init(&buff);
//    const alloc = fba.allocator();

    const start = std.time.microTimestamp();
    try d5.run(PageAllocator);
    const final = std.time.microTimestamp() - start;
    std.debug.print("Total Time: {} micro s \n", .{final});
}
