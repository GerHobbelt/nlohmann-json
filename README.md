# JSON for Modern C++ (lightweight)

This is a lightweight version of the [nlohmann/json-cpp][0]. It tracks `single_include` folder only.

The original repository is very heavy (hundreds of MB). There is no need to track everything just to compile a single file if you use the library as a submodule. That's the main reason why we rewrote the original repo.

## Requirements

- `cmake` (`3.16.3`)
- `ninja-build` (`1.10.0`)

## Usage

See: `CMakeLists.txt` and `main.cpp` in [demos/demo_simple][1].

## Run demo

```sh
make
_build/demo_simple
```

**Example**

```sh
$ _build/demo_simple
{
    "age": 32,
    "gender": "male",
    "name": "Rob",
    "posture": {
        "height": 56,
        "width": 160
    }
}
```



[0]: https://github.com/OneMeterCom/json-cpp
[1]: demos/demo_simple/
