<!--
SPDX-License-Identifier: MPL-2.0

This file is part of Ramses Composer
(see https://github.com/COVESA/ramses-composer-docs).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

# Animations

![](./docs/cube_anim.gif)

This tutorial shows how to import animation data using the glTF format.

## A general note on animation data

Animation data can typically grow large and cause performance problems if not carefully optimized.
glTF offers a good compromise between animation quality and exported data size. In order to utilize glTF
to its best, it's adviced to get a good understanding how the different interpolation mechanisms works, and
most importantly - consult the documentation of your DCC tool of choice regarding keyframe conversion and
compression.

## Creating a simple animation with Blender

In this tutorial, we use the excellent glTF exporter of Blender 2.83 LTS. You can just use [the existing scene
in the Blender subfolder](./blender/) or create it yourself by following the steps below.

* Select the default blender cube in a new project
* In the animation panel, change the "End" frame from 250 to 60 to reduce the animation time
* Select the 1st frame in the animation editor
* Press 'i' for recording keyframes
* From the dropdown menu, select "Rotate, scale, and translate" keyframe type
* Enter some values in the property fields - e.g. set the scaling to 1, 2, 3
* Move to frame 60
* Press 'i' again, select some other values for the last keyframe (e.g. random rotation, translation and scale values)

Next, we need to export the cube alongside its animation using the glTF export menu. For details how to export
from Blender, check [the corresponding section basic cube tutorial](../hello_world/manual.md#Export-glTF-from-Blender).

Make sure you click the "Export Animations" setting in the export menu:

![](./docs/export_anim_setting.png)

If you uncollapse the "Animation" export menu, you will notice a setting called "Always sample animations". It's
on by default, but what it causes is that every single frame results in a data point in the resulting glTF file.
So if you have a simple linear animation over 120 frames, you will export 120 data points instead of just two (which would
result in the exact same visual result as 120 key points). We suggest not using this feature of the exporter, unless really
needed.

## Importing the animation

Let's import the animated cube in the Ramses Composer. If you haven't yet, check out the [section in the glTF import
tutorual](../complex_import/manual.md#Scene-graph-and-resources) which explains how to import complex glTF files. When importing
the glTF file, you will notice the animation resources in the list of available items to import:

![](./docs/import_menu.png)

After importing those, you will see the animation channels in the resource menu:

![](./docs/channel_resources.png)

You can inspect their properties in the property panel:

![](./docs/channel_info.png)

Notice that the keyframes are 2 instead of 60. This is because we didn't subsample the animation during export, but
use cubic spline interpolation to achieve a smooth animation instead.

Furthermore, the scene graph now contains a Node which also has an animation object assigned to it:

![](./docs/scene_graph.png)

The animation is statically assigned to the node and its outputs are linked to the node transformation properties. Looking
at the Animation properties, you will see the animation channels alongside the state of the animation object and its current
output values:

![](./docs/animation.png)

You can set the "play", "loop" and "rewind on pause" properties or link them to scripts to control the state of the animation.
This works exactly as with other scripts, see the [section on linking Lua properties in the Monkey example](../monkey/manual.md#Lua-Scripting) for details.

## How to control time

Currently there is no direct way to control the time progression of animations with Lua. We are addressing this
in the logic engine and will update this tutorial after we have a solution. In Ramses Composer 0.11.0, the time is
automatically passed to all animation objects in a strictly progressing fashion, and scripts are only allowed to set
the state of an animation - running, paused, stopped, and rewind.