
# Dear ImGui Zig

This is a port of [Dear ImGui](https://github.com/ocornut/imgui) to the [Zig](https://ziglang.org/) build system. This package only builds ImGui and the specified backend code, it does not import any of the backends themselves, nor does it provide custom zig bindings.

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
    .sdl3 = true,   // Mark any backend you want to use like this
    .vulkan = true,
});
exe.linkLibrary(imgui.artifact("imgui"));
```

This will add the Dear ImGui library and headers to `exe`.
