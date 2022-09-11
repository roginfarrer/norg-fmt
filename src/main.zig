const std = @import("std");
const tree_sitter = @import("tree-sitter");

extern fn tree_sitter_norg() tree_sitter.TSLanguage;

pub fn main() !void {
    var parser = tree_sitter.Language.from(tree_sitter_norg());
    try std.io.getStdOut().writer().print("Parser version: {any}\n", .{parser.version()});
}
