const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("imgui", .{});
    const lib = b.addLibrary(.{
        .name = "imgui",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });

    lib.installHeader(upstream.path("imgui.h"), "imgui.h");
    lib.installHeader(upstream.path("imconfig.h"), "imconfig.h");
    lib.installHeader(upstream.path("imgui_internal.h"), "imgui_internal.h");
    lib.root_module.addIncludePath(upstream.path(""));
    lib.root_module.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = &.{
            "imgui.cpp",
            "imgui_draw.cpp",
            "imgui_demo.cpp",
            "imgui_tables.cpp",
            "imgui_widgets.cpp",
        },
    });

    const backends = .{
        // Platform backends
        .{ "android", ".cpp" },
        .{ "glfw", ".cpp" },
        .{ "osx", ".mm" },
        .{ "sdl2", ".cpp" },
        .{ "sdl3", ".cpp" },
        .{ "win32", ".cpp" },
        .{ "glut", ".cpp" },

        // Render backends
        .{ "dx9", ".cpp" },
        .{ "dx10", ".cpp" },
        .{ "dx11", ".cpp" },
        .{ "dx12", ".cpp" },
        .{ "metal", ".mm" },
        .{ "opengl2", ".cpp" },
        .{ "opengl3", ".cpp" },
        .{ "sdlgpu3", ".cpp" },
        .{ "sdlrenderer2", ".cpp" },
        .{ "sdlrenderer3", ".cpp" },
        .{ "vulkan", ".cpp" },
        .{ "wgpu", ".cpp" },
    };

    inline for (backends) |backend| {
        const include = b.option(bool, backend[0], "Compile the " ++ backend[0] ++ " backend") orelse false;
        if (include) {
            lib.root_module.addCSourceFile(.{
                .file = upstream.path("backends/imgui_impl_" ++ backend[0] ++ backend[1]),
            });
            const header = "backends/imgui_impl_" ++ backend[0] ++ ".h";
            lib.installHeader(upstream.path(header), header);
        }
    }

    b.installArtifact(lib);
}
