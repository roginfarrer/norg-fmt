const std = @import("std");
const tree_sitter = @import("tree-sitter");

extern fn tree_sitter_norg() tree_sitter.TSLanguage;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const example_source = comptime 
    \\* Hello, Norg!
    \\  This is a paragraph with /italic/
    \\  text. It does have *bold*, too.
    ;
    var norg_parser = tree_sitter.Language.from(tree_sitter_norg());
    var parser = try tree_sitter.Parser.init(norg_parser);

    var ast = try parser.parse_string(example_source, tree_sitter.Encoding.UTF8, null);
    var root_node = ast.root();
    var root_start = root_node.start_point();
    var root_end = root_node.end_point();

    try stdout.print("Document info:\n - Start pos: {any}, {any}\n - End   pos: {any}, {any}\n\n", .{ root_start.row, root_start.column, root_end.row, root_end.column });
    try stdout.print("Document content:\n{s}\n\n", .{example_source});

    var sexp = root_node.sexp();
    try stdout.print("Document sexp:\n{s}\n", .{sexp});

    // Free memory used by the parser
    ast.deinit();
    parser.deinit();
}

test "Load Norg parser" {
    var norg_parser = tree_sitter.Language.from(tree_sitter_norg());
    try std.testing.expectEqual(norg_parser.version(), 13);
}
