const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const include_paths = b.option(
        []const std.Build.LazyPath,
        "include_paths",
        "Include directories used to build the backends",
    ) orelse &.{};

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

    for (include_paths) |include_path| {
        lib.root_module.addIncludePath(include_path);
    }

    const backends = .{
        // Platform backends
        .{ "android", ".cpp", "Android native" },
        .{ "glfw", ".cpp", "GLFW" },
        .{ "osx", ".mm", "macOS native" },
        .{ "sdl2", ".cpp", "SDL2" },
        .{ "sdl3", ".cpp", "SDL3" },
        .{ "win32", ".cpp", "Win32 native" },
        .{ "glut", ".cpp", "GLUT/FreeGLUT" },

        // Render backends
        .{ "dx9", ".cpp", "DirectX9" },
        .{ "dx10", ".cpp", "DirectX10" },
        .{ "dx11", ".cpp", "DirectX11" },
        .{ "dx12", ".cpp", "DirectX12" },
        .{ "metal", ".mm", "Metal" },
        .{ "opengl2", ".cpp", "OpenGL 2 (legacy)" },
        .{ "opengl3", ".cpp", "OpenGL (3/4, ES 2/3, WebGL)" },
        .{ "sdlgpu3", ".cpp", "SDL_GPU" },
        .{ "sdlrenderer2", ".cpp", "SDL2 SDL_Renderer" },
        .{ "sdlrenderer3", ".cpp", "SDL3 SDL_Renderer" },
        .{ "vulkan", ".cpp", "Vulkan" },
        .{ "wgpu", ".cpp", "WebGPU" },

        // Framework backends.
        .{ "allegro5", ".cpp", "Allegro5" },

        .{ "null", ".cpp", "null (blind)" },
    };

    inline for (backends) |backend| {
        const do_compile_backend = b.option(bool, backend[0], "Compile the " ++ backend[0] ++ " backend") orelse false;
        if (do_compile_backend) {
            lib.root_module.addCSourceFile(.{
                .file = upstream.path("backends/imgui_impl_" ++ backend[0] ++ backend[1]),
            });
            const header = "backends/imgui_impl_" ++ backend[0] ++ ".h";
            lib.installHeader(upstream.path(header), header);
        }
    }

    b.installArtifact(lib);
}
