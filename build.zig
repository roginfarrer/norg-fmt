const std = @import("std");
const tree_sitter = @import("deps/zig-tree-sitter/build.zig");

fn linkDependencies(exe: *std.build.LibExeObjStep) void {
    // add zig-tree-sitter dependency
    exe.addPackagePath("tree-sitter", "deps/zig-tree-sitter/src/lib.zig");
    tree_sitter.linkTreeSitter(exe);
    // tree-sitter-norg does use C and C++ so we need to link both.
    // C one is already linked by zig-tree-sitter so we do not need to re-link it
    exe.linkLibCpp();
    exe.addIncludeDir("deps/tree-sitter-norg/src");
    exe.addCSourceFile("deps/tree-sitter-norg/src/parser.c", &[_][]const u8{"-std=c99"});
    exe.addCSourceFile("deps/tree-sitter-norg/src/scanner.cc", &[_][]const u8{"-std=c++14"});
}

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("norg-fmt", "src/main.zig");
    exe.use_stage1 = true;
    exe.setTarget(target);
    exe.setBuildMode(mode);
    linkDependencies(exe);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);
    linkDependencies(exe_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
