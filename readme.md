<!--
SPDX-License-Identifier: MPL-2.0

This file is part of Ramses Composer
(see https://github.com/COVESA/ramses-composer-docs).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->
# Ramses Composer Documentation

![](ramses-composer-logo.png)

This repository contains the documentation for Ramses Composer, the authoring tool for the open source RAMSES rendering ecosystem.

## Basics

These tutorials explain the basic features of the Composer, how to import, manage, modify and export
your data.

[Introduction](introduction/README.md) - What exactly is this Ramses Composer good for?

[First basic project](./hello_world/README.md) - A simple cube.

[A more interesting project](./monkey/README.md) - A monkey head with flat shading.

[Data and scope](./data_and_scopes/README.md) - Details on object types, data and scope.

[Complex import](./complex_import/README.md) - Import multiple objects from a single glTF file.

[Animations](./animations/README.md) - Import and control animations from glTF.

[Exporting to Ramses](./export/README.md) - Export optimized Ramses binary assets.

## Structuring your project

How to manage a more complex project, allow collaboration with multiple artists or teams,
eliminate duplication and maintain clear structure? The following tutorials provide some answers.

[Introducing prefabs](prefabs/README.md) - This example shows you how to create encapsulated, reusable objects with the Prefab mechanism.

[Nested prefabs](nested_prefabs/README.md) - Demonstrates how to construct complex Prefabs using other Prefabs as building blocks.

[External references](external_references/README.md) - Explains how to import and use building blocks from different projects.

[Best practices](./best_practices/README.md) - Suggests best practices for project structure.

## Advanced guides

Need a specific Lua feature, or need to know how rotation math works? Advanced details here!

[Conventions](./conventions/README.md) - Coordinate systems and import specifics.

[Scripting with LUA](./lua_syntax/README.md) - Advanced Lua scripting tips.

[Render Order](./ordering/README.md) - Controlling the render order.

[Offscreen Rendering](./offscreen/README.md) - Offscreen Rendering.

[Versions](./versions/README.md) - Supported versions, API and ABI compatibility.

## Troubleshooting

[Using the Log Output Console](using_log_console/README.md)

[Common Issues](common_issues/README.md)

[Crash dumps](crash_dumps/README.md)


## Related resources

You will find the source code of Ramses Composer and instructions on how to build it in the main [Ramses Composer repository](https://github.com/COVESA/ramses-composer). For a general overview of the Ramses ecosystem and its other components, visit
also [these pages](https://ramses-sdk.readthedocs.io/).

## License

Like the Ramses Composer, this documentation is also published under the MPL-2.0 license.
Some of the example glTF assets are taken from the official Khronos repositories - the corresponding
example projects mention the source and license information in their respective README.md documents.
Some of the example projects contain a custom Blender file. These files are also published under the MPL-2.0 license.
