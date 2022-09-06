const std = @import("std");
const tree_sitter = @import("tree-sitter");

extern fn tree_sitter_norg() tree_sitter.language.TSLanguage;

pub fn main() !void {
    // FIXME: this seems to not be working as expected, refer to build.zig file
    var parser = tree_sitter.language.Language.from(tree_sitter_norg());
    try std.io.getStdOut().writer().print("Parser version: {any}\n", .{parser.version()});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
