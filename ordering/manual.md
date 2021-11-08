<!--
SPDX-License-Identifier: MPL-2.0

This file is part of Ramses Composer
(see https://github.com/GENIVI/ramses-composer-docs).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

# Ordering example

![](./docs/viewport_preview.png)

This example shows different ways to define rendering order for objects in a scene.

# Overview

Usually, the rendering order of objects is not something to take care of, as that is something
that the depth buffer takes care of: objects which are in front will overwrite the pixels of
objects in the back. However, sometimes it's important to have a specific order of objects.
For example transparent objects need to be rendered back-to-front, as they don't fully occlude
each other. Also, some techniques like shadow mapping, reflections, or depth-prepass require
a given order or special rules which objects should be rendered at which time.

In this chapter we demonstrate different ordering techniques and how to use and combine them.

# Contents of a Ramses Composer project

In order to understand how ordering of content works, it's essential to understand first
what the content is inside a Ramses Composer project.

A newly created project contains following default objects (which can be deleted later):

* A scene graph with one `Node`, one (child) `MeshNode`, and a camera

![](./docs/default_scene_contents.png)

* A default render layer and render pass

![](./docs/default_render_setup.png)

* The root `Node` has a default tag `render_main`

![](./docs/default_node_tag.png)

* The default `RenderLayer` has a tag entry `render_main`, same as the root node

![](./docs/default_renderlayer_tag.png)

* The default `RenderPass` has the default `RenderLayer` in its first slot, and uses the default camera

![](./docs/default_slots.png)

The way this works is:

* The `RenderLayer` collects all nodes from the scene with the given tag (`render_main`) and their child nodes recursively
* The `RenderPass` renders everything from the `RenderLayer` using the selected `Camera`
* The order of the meshes is influenced by multiple factors, as we will learn in the next sections

# Ordering techniques

The order of rendering is influenced by three factors and can be conbined in different ways.
We demonstrate each of them separately in the next sections, and you can find a separate example
project for each of them. Each project has three MeshNodes with different colors rendered in a specific way, but the ordering technique is different for each of them.

## Order based on scene graph order

Example project: [1_by_scene_graph](./1_by_scene_graph.rca).

The simples approach to order MeshNodes is by their order in the scene graph.
To activate this option, you can select the `Scene graph order` in the RenderLayer panel:

![](./docs/scene_graph_order.png)

When this option is selected, all nodes will be sorted in the exact same order as they appear in the
SceneGraph panel - i.e. parent nodes are rendered before their children, and children are sorted
first-to-last.

## Order based on tags inside RenderLayer

Example project: [2_by_tags_priority](./2_by_tags_priority.rca).

If you want a more advanced sorting, you can use multiple tags to cluster different parts of the
scene (e.g. "glass", "opaque_back", "opaque_front" etc.) and then sort all objects based on their tags.

In this example, we have three quads in different colors, and have a different tag for each color:

![](./docs/color_tags_1.png)

Notice that each colored MeshNode has its own tag, and all tags (red, green, blue) are listed in the
`RenderLayer` renderable tags property field. If you edit the field, you will see that each of the tags
has its own order number assigned to it:

![](./docs/color_tags_2.png)

Furthermore, the `Render order` property further down is set to `Render order value in Renderable tags`.
This means that this `RenderLayer` will sort its content based on the numbers assigned with each tag.
In particular, it will sort tags based on their Render Order (starting with lowest), then sort all
mesh nodes which fit to one or more of the tags, and will sort them based on their tags order.

Note that if tags have the same number, their relative order is not defined. The same is true for mesh nodes which fit to more than one tag, and the tags have different order.

## Order based on RenderPass slots

Example project: [3_by_render_pass](./3_by_render_pass.rca).

Finally, a `RenderPass` is the place where `RenderLayer` objects are collected and rendered with a
`Camera` object. This is where `RenderLayer` can be ordered between each other too, by the slots they are
assigned to.

In this example, we have a dedicated `RenderLayer` for each quad - red, blue and green:

![](./docs/multiple_layers.png)

The layers are ordered in different slots in the main `RenderPass`:

![](./docs/renderpass_slots.png)

If you change the order in these slots, the quads will be rendered in the corresponding order.

# Combining the techniques

The ordering mechanisms described in this example are compatible to each other and can be combined.
It is possible to use different mechanisms for different RenderLayer or RenderPass objects.
It is also possible to refer to tags used in nested projects (see [external references](../external_references/manual.md)).

To understand which Ramses objects are generated based on the RenderPass, RenderLayer and SceneGraph
structures, see [the data and scopes section](../data_and_scopes/manual.md).
