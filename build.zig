const std = @import("std");
const Build = std.Build;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "triangle",
        .root_source_file= .{.path = "src/main.zig"},
        .target=target,
        .optimize=optimize
    });

    exe.addCSourceFile(.{
        .file = Build.LazyPath.relative("src/glad.c"),
        .flags = &[_][]const u8{"-std=c99"}
    });
    exe.addIncludePath(Build.LazyPath.relative("./include"));

    exe.linkLibC();
    exe.linkSystemLibrary("glfw3");
    exe.addLibraryPath(.{.path = "./lib/"});
    switch (target.getOsTag()) {
        .windows => {
            exe.linkSystemLibrary("gdi32");
            exe.linkSystemLibrary("user32");
            exe.linkSystemLibrary("kernel32");
            exe.linkSystemLibrary("opengl32");
        },
        .linux => {
            exe.linkSystemLibrary("x11");
            exe.linkSystemLibrary("gl");
        },
        else => {}
    }

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
