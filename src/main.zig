const std = @import("std");
const c = @import("c.zig");

const WINDOW_HEIGHT: c_int = 800;
const WINDOW_WIDTH: c_int = 600;

pub fn main() void {
    if(c.glfwInit() == c.GL_FALSE) @panic("GLFW Init failed.");
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

    var window: *c.GLFWwindow = c.glfwCreateWindow(WINDOW_HEIGHT, WINDOW_WIDTH, "ZigGl", null, null) orelse @panic("Unable to create window");
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);

    const gladLoadResult = c.gladLoadGLLoader(@as(c.GLADloadproc, @ptrCast(&c.glfwGetProcAddress)));
    if(gladLoadResult == c.GL_FALSE) {
        @panic("failed to initialize glad");
    }

    _ =c.glfwSetFramebufferSizeCallback(window, framebufferSizeCallback);

    c.glViewport(0, 0, WINDOW_HEIGHT, WINDOW_WIDTH);

    while(c.glfwWindowShouldClose(window) == c.GL_FALSE) {
        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
    }
}

fn framebufferSizeCallback(window: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    _ = window;
    c.glViewport(0, 0, width, height);
}
