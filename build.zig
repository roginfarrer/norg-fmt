const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("norg-fmt", "src/main.zig");
    exe.use_stage1 = true;
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.addPackagePath("tree-sitter", "deps/zig-tree-sitter/src/lib.zig");
    exe.linkLibC();
    exe.linkLibCpp();
    exe.addIncludeDir("deps/tree-sitter-norg/src/");
    exe.addCSourceFile("deps/tree-sitter-norg/src/parser.c", &[_][]const u8 { "-std=c99" });
    exe.addCSourceFile("deps/tree-sitter-norg/src/scanner.cc", &[_][]const u8 { "-std=c++14" });
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

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
