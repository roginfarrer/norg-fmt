const std = @import("std");
const clap = @import("clap");
const ts = @import("tree-sitter");

const version = "0.1.0a";
const copyright_notice =
    \\Copyright (C) 2022 NTBBloodbath <bloodbathalchemist@protonmail.com> and Vhyrro <vhyrro@gmail.com>
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

extern fn tree_sitter_norg() ts.TSLanguage;

pub fn main() !void {
    // Standard output/err
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdErr().writer();

    // Create an arena allocator to reduce time spent allocating
    // and freeing memory during runtime.
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    var arena = arena_state.allocator();

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

    if (res.args.help or res.positionals.len == 0) {
        // We print a small usage message banner as zig-clap does not implement it
        try stdout.print("{s}", .{"Usage: norg-fmt [flags] [FILE...]\n\nFlags:\n"});
        return clap.help(stdout, clap.Help, &params, .{});
    } else if (res.args.version) {
        try stdout.print("norg-fmt v{s}. A formatter for Norg documents.\n{s}", .{ version, copyright_notice });
        return;
    }

    for (res.positionals) |filepath| {
        var file = std.fs.cwd().openFile(filepath, .{}) catch {
            try stderr.print("INFO: file {s} not found.", .{filepath});

            continue;
        };
        defer file.close();

        const file_contents = file.readToEndAlloc(arena, comptime std.math.pow(u64, 2, 32)) catch |err| switch (err) {
            error.FileTooBig => {
                try stderr.print("ERROR: could not read file {s} - the file is too big! Please file an issue on github.", .{filepath});
                continue;
            },
            else => return err,
        };

        const language = ts.Language.from(tree_sitter_norg());
        const parser = try ts.Parser.init(language);
        defer parser.deinit();

        const tree = try parser.parse_string(file_contents, .UTF8, null);
        defer tree.deinit();

        var root = tree.root();
        std.debug.print("{s}", .{root.type()});
    }
}

test "Load Norg parser" {
    var norg_parser = ts.Language.from(tree_sitter_norg());
    try std.testing.expectEqual(norg_parser.version(), 13);
}
