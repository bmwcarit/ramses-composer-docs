<!--
SPDX-License-Identifier: MPL-2.0

This file is part of Ramses Composer
(see https://github.com/GENIVI/ramses-composer-docs).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->
# Ramses Composer Documentation

![](ramses-composer-logo.png)

This repository contains the documentation for Ramses Composer, the authoring tool for the open source RAMSES rendering ecosystem.

## Basics

These tutorials explain the basic features of the Composer, how to import, manage, modify and export
your data.

[Introduction](introduction/manual.md) - What exactly is this Ramses Composer good for?

[First basic project](./hello_world/manual.md) - A simple cube.

[A more interesting project](./monkey/manual.md) - A monkey head with flat shading.

[Data and scope](./data_and_scopes/manual.md) - Details on object types, data and scope.

[Complex import](./complex_import/manual.md) - Import multiple objects from a single glTF file.

[Exporting to Ramses](./export/manual.md) - Export optimized Ramses binary assets.

## Structuring your project

How to manage a more complex project, allow collaboration with multiple artists or teams,
eliminate duplication and maintain clear structure? The following tutorials provide some answers.

[Introducing prefabs](prefabs/manual.md) - This example shows you how to create encapsulated, reusable objects with the Prefab mechanism.

[Nested prefabs](nested_prefabs/manual.md) - Demonstrates how to construct complex Prefabs using other Prefabs as building blocks.

[External references](external_references/manual.md) - Explains how to import and use building blocks from different projects.

[Best practices](./best_practices/manual.md) - Suggests best practices for project structure.

## Advanced guides

Need a specific Lua feature, or need to know how rotation math works? Advanced details here!

[Conventions](./conventions/manual.md) - Coordinate systems and import specifics.

[Scripting with LUA](./lua_syntax/manual.md) - Advanced Lua scripting tips.

[Versions](./versions/manual.md) - Supported versions, API and ABI compatibility.

## Troubleshooting

[Using the Log Output Console](using_log_console/manual.md)

[Common Issues](common_issues/manual.md)

[Crash dumps](crash_dumps/manual.md)


## Related resources

You will find the source code of Ramses Composer and instructions on how to build it in the main [Ramses Composer repository](https://github.com/GENIVI/ramses-composer). For a general overview of the Ramses ecosystem and its other components, visit
also [these pages](https://ramses-sdk.readthedocs.io/).

## License

Like the Ramses Composer, this documentation is also published under the MPL-2.0 license.
Some of the example glTF assets are taken from the official Khronos repositories - the corresponding
example projects mention the source and license information in their respective manual.md documents.
Some of the example projects contain a custom Blender file. These files are also published under the MPL-2.0 license.
