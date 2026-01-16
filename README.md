
# Dear ImGui Zig

This is a port of [Dear ImGui](https://github.com/ocornut/imgui) to the [Zig](https://ziglang.org/) build system. This package only builds ImGui and the specified backend code, it does not import any of the backends themselves, nor does it provide custom zig bindings. This means that you'll have to provide both the binaries and the include directories for the backends you want to use yourself.

## How to use it

### As a library

First, fetch this repository:

```sh
zig fetch --save git+https://github.com/JurMax/dear_imgui_zig
```

Next, add it to your `build.zig`:

```zig
const imgui = b.dependency("dear_imgui_zig", .{
    .target = target,
    .optimize = optimize,
    .sdl3 = true, // Mark any backend you want to use like this
    .vulkan = true,
    .include_paths = &[_]std.Build.LazyPath{
        // Add the include path manually, or leave blank to use system headers.
        // sdl3_dependency.path("include"),
    }
});
exe.linkLibrary(imgui.artifact("imgui"));
```

This will add the Dear ImGui library and headers to `exe`.

### Supported backends

All backends included in the Dear ImGui repository are supported, see the [Docs](https://github.com/ocornut/imgui/blob/master/docs/BACKENDS.md) for more information.

Platforms Backends:

    android      ; Android native app API
    glfw         ; GLFW (Windows, macOS, Linux, etc.) http://www.glfw.org/
    osx          ; macOS native API (not as feature complete as glfw/sdl backends)
    sdl2         ; SDL2 (Windows, macOS, Linux, iOS, Android) https://www.libsdl.org
    sdl3         ; SDL3 (Windows, macOS, Linux, iOS, Android) https://www.libsdl.org
    win32        ; Win32 native API (Windows)
    glut         ; GLUT/FreeGLUT (this is prehistoric software and absolutely not recommended today!)

Renderer Backends:

    dx9          ; DirectX9
    dx10         ; DirectX10
    dx11         ; DirectX11
    dx12         ; DirectX12
    metal        ; Metal (ObjC or C++)
    opengl2      ; OpenGL 2 (legacy fixed pipeline. Don't use with modern OpenGL code!)
    opengl3      ; OpenGL 3/4, OpenGL ES 2/3, WebGL
    sdlgpu3      ; SDL_GPU (portable 3D graphics API of SDL3)
    sdlrenderer2 ; SDL_Renderer (optional component of SDL2 available from SDL 2.0.18+)
    sdlrenderer3 ; SDL_Renderer (optional component of SDL3. Prefer using SDL_GPU!).
    vulkan       ; Vulkan
    wgpu         ; WebGPU (web + desktop)

Other backends:

    allegro5     ; The Allegro5 game programming library https://liballeg.org/
    null         ; No backend, for running ImGui headless/blind
