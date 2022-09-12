const std = @import("std");
const clap = @import("clap");
const tree_sitter = @import("tree-sitter");

const version = "0.1.0a";
const copyright_notice =
\\Copyright (C) 2022  NTBBloodbath <bloodbathalchemist@protonmail.com>
\\
\\This program is free software: you can redistribute it and/or modify
\\it under the terms of the GNU General Public License as published by
\\the Free Software Foundation, either version 3 of the License, or
\\(at your option) any later version.
\\
\\This program is distributed in the hope that it will be useful,
\\but WITHOUT ANY WARRANTY; without even the implied warranty of
\\MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
\\GNU General Public License for more details.
\\
\\You should have received a copy of the GNU General Public License
\\along with this program.  If not, see <https://www.gnu.org/licenses/>.
\\
;

extern fn tree_sitter_norg() tree_sitter.TSLanguage;

pub fn main() !void {
    // Standard output/err
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();

    // Create an arena allocator to reduce time spent allocating
    // and freeing memory during runtime.
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    _ = arena_state.allocator();

    // Cmdline
    // ------------
    const params = comptime clap.parseParamsComptime(
        \\-h, --help         Display this help and exit.
        \\-v, --version      Display norg-fmt version and exit.
        \\<file>...
        \\
    );
    const parsers = comptime .{
        .file = clap.parsers.string,
    };
    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, parsers, .{
        .diagnostic = &diag,
    }) catch |err| {
        // Report useful error and exit
        diag.report(stderr, err) catch {};
        return err;
    };
    defer res.deinit();

    if (res.args.help) {
        // We print a small usage message banner as zig-clap does not implement it
        try stdout.writeAll("Usage: norg-fmt [flags] [FILE...]\n\nFlags:\n");
        return clap.help(stdout, clap.Help, &params, .{});
    }
    if (res.args.version) {
        try stdout.print("norg-fmt v{s}. Norg documents formatter.\n{s}", .{version, copyright_notice});
        return;
    }
    // TODO(ntbbloodbath): handle passed norg files to format them later instead of printing them
    for (res.positionals) |pos|
        try stdout.print("{s}\n", .{pos});

    // NOTE: this is a temporal code block used for debugging and development purposes, will be deleted
    //       later once we get TODO items done.
    if (res.positionals.len == 0) {
        // Sample debugging output
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
}

test "Load Norg parser" {
    var norg_parser = tree_sitter.Language.from(tree_sitter_norg());
    try std.testing.expectEqual(norg_parser.version(), 13);
}
