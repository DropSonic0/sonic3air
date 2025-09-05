# Building using Make

## Playstation 3
1. [Follow the instructions from ps3toolchain to get your build environment set up.](github.com/ps3dev/ps3toolchain)
```
sudo export PKG_CONFIG_PATH=$PS3DEV/portlibs/ppu/lib/pkgconfig/
```
3. In this directory (Oxygen/sonic3air/build/_ps3):
```
make PLATFORM=PS3
```
Output will be at `bin/PS3/sonic3air.self`.