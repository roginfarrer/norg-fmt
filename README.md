# norg-fmt

norg-fmt is a formatter for [Neorg](https://github.com/nvim-neorg/neorg). It is in a very early
stage right now.


## Building from source

### Requirements

- `Zig` >= 0.10
- C/C++ compiler (required by tree-sitter bindings)



Now that you've checked for requirements you can proceed to build `norg-fmt`:
```bash
git clone --depth=1 https://github.com/nvim-neorg/norg-fmt.git
cd norg-fmt
git submodule update --init --recursive --progress
zig build -Drelease-safe
```

**NOTE**: Produced binary is under `zig-out/bin` directory.


### Compatibility

norg-fmt should work as expected for all platforms (Windows, Linux, MacOS), however if you
find any issue when compiling/running it, please feel free to fill an
[issue](https://github.com/nvim-neorg/norg-fmt/issues/new).


## Usage


Nothing here but chickens ...


## License

norg-fmt is licensed under [GPLv3](./LICENSE) license.


<!--
vim:sw=2:ts=2:cole=3:cocu=n:tw=100:norl:nofen
-->
