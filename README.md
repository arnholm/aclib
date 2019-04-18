# aclib - AngelCAD Script Library

This library contains reusable components and functions for the [AngelCAD](https://github.com/arnholm/angelcad) 3D Modeller. These are intended to be #included from your scripts (there are no main() functions in these files).

AngelCAD 1.3 and newer supports libraries located in subfolders of the Library root foolder

| OS | Library root folder |
| ---- | -------- |
| Linux   | ~/.angelcad/libraries/  |
| Windows | %localappdata%\AngelCAD\libraries |

For example, if you clone aclib under the Library root folder, you can use the library as follows

```AngelScript
#include "aclib/trim.as"
```

## aclib files

* trim.as : functions for trimming an object in any direction
