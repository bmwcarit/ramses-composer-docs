<!--
SPDX-License-Identifier: MPL-2.0

This file is part of Ramses Composer
(see https://github.com/GENIVI/ramses-composer-docs).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

# Render Pipeline


## The Concept

### Render passes

Rendering in Ramses scenes starts with render passes. All render passes in the scene are rendered in the ascending order given by their "Order" property. 
Each render pass renders all mesh nodes gathered by the render layers it references, using the camera set in the "Camera" property and renders into the render buffers
defined by the render target set in the "Target" property.

Render passes can be en-/disabled, a disabled render pass is not rendered.

### Render targets

Render targets in Ramses to define a set of render buffers which are used during rendering by a render pass. A render target is essentially just a collection of
render buffers. There are a few constraints how render buffers can be associated with a render target:

* All render buffers must have the same size.
* Only one render buffer can be a depth/stencil buffer, the rest must be color buffers.
* A render target must have a valid first render buffer.
* If several render buffers are set, there cannot be empty slots or invalid render buffers between them.
* Each render buffer can only be added once to a render target.

All of these constraints are checked by Ramses Composer and a scene error is created, if at least one of them is not fulfilled.

### Render buffer

Render buffers in Ramses are used to define the buffers a render pass can render to, and which can later be used in samplers in shaders. 
A render buffer can be set to a given resolution and format, and its sampling parameters can be defined.

### Render layers

Render layers are used to gather mesh nodes which must be rendered with a render pass. A render pass references render layers,
and the render layers determine mesh nodes and other render layer which are used to render them.

Which mesh nodes and other render layers are part of a given render layer is determined by a tag system:

* Each node can be tagged with any number of tags using its "Tags" property.
* If a mesh node tag matches one of the tags in the render layer "Renderable Tags" property, the mesh node is a rendered with the render layer.
    * The mesh node must also match the material filter to be rendered, see below.
* If a node tag matches one of the tags in the render layer "Renderable Tags" property, 
  all mesh nodes in the scenegraph branch rooted by the tagged node are rendered with the render layer.
    * The mesh nodes must also match the material filter to be rendered, see below.
* The rendered mesh nodes in a render layer can further be filtered using the material filter:
    * If "Material Filter Behaviour" is set to "Exclude materials with any of the listed tags", the render layer will only render mesh nodes
      which **do not** reference a material tagged with one of the tags in "Material Filter Tags".
    * If "Material Filter Behaviour" is set to "Include materials with any of the listed tags", the render layer will only render mesh nodes
      which **do** reference a material tagged with one of the tags in "Material Filter Tags".
    * Given that often render passes expect to render mesh nodes with certain materials, the material filter can be used to easily
      render scene graphs with many mesh nodes by just tagging the root node and the materials.
* Each render layer can also be tagged with any number of tags using its "Tags" property. Similar to the nodes, render layer A is part
  of render layer B if one of the tags in the "Tags" property of A matches one of the tags in Bs "Renderable Tags" property.
    * It is not allowed to add a render layer to itself (directly or indirectly).
* The render order within a render layer is defined either by the order index given by the tag referencing the mesh node or render layer
  or by the scene graph order of the mesh nodes.
    * It is an error if the same mesh node is added twice to the same render layer with different order indices.
    * Ramses Composer will generate a warning if a render layer is rendered by another render layer which is using scene graph order,
      as the order between the referenced render layer and the referenced mesh nodes is unclear.

### Good practice

It is good practice for the user to keep a largely centrally managed list of most render passes, render layers and render targets
in one file which is then added as external references to other scenes. This allows for a shared render pipeline across
several scenes with external references.

The Ramses Composer file defining the render passes can contain either directly or as an external reference the parts of the
material library relevant to the material filters in the render layer.

A few caveats:

  * Currently it is due to a bug not possible to create external references of render passes. This will be fixed in the near future.
  * Ramses Composer would probably benefit from featuring a "multi-pass" material which would essentially be just a collection
    of normal materials, and could be referenced by a mesh node. If those multi-pass materials and the corresponding render pipeline
    would be pre-configured, adding new mesh nodes to e. g. both a normal and a shadow render pass would be as simple as just assigning
    the appropriate multi-pass material. Please let us know if you need such a feature, so we can prioritize it.

## Examples

## Simple scene (default setup)

In the default scene, Ramses Composer automatically creates a render pass and a render layer. The render pass and the render layer
are configured to automatically render the contents of the root node in the scene:

* The render pass "MainRenderPass" references the render layer "MainRenderLayer".
* The "MainRenderLayer" uses as "Renderable Tags" the "render_main" tag.
* The root node "Node" is tagged with "render_main".

As a consequence of this setup anything which is in "Node" will be rendered. However, if you add a second root node, you will need
to tag it or its contents with "render_main" to make sure it is rendered.

## Transparent cars

In this example we want to render a few cars semi-transparent behind each other. 
We are using the prefabs from the [Nested prefabs](../nested_prefabs/manual.md) example,
but we place them such that they are behind each other:

![](docs/ToyCars1.png)

To make our live easier we disable the "Private Material" option in all mesh nodes, so 
we can control the opacity of all cars directly through the "opacity" property in "plainMaterial".
Also make sure to set the "Render Order" in "MainRenderLayer" to "Render order value in 'Renderable Tags'"
(see toy_cars1.rca).

If we just set the "opacity" in "plainMaterial" to something less than 1 and render the cars semi-transparent, 
each car becomes transparent for its own parts which is not what we want. Also the render order between the cars is not correct yet:

![](docs/ToyCars2.png)

Your image might look a bit different - the order in which we render the cars is not defined right now, and depending 
on which order Ramses happens to choose, the cars might look different.

Let us first focus on the first problem: how can we render one car semitransparent but using the z-buffer while doing it?
To avoid complications lets focus on the "SUV" first, and make the two other cars invisible.

To render only the front side of the SUV we render the car twice: first the car is rendered only to the z-buffer, 
but not to the color buffer. Then it is rendered in the color buffer but only if the z-coordinate is equal to the one already in the z-buffer.
This causes only the frontmost pixel to be rendered into the color buffer, which is what we want. To achieve that we need to first create
a material which only renders the z-buffer. 

To do that we just make a copy of "plainMaterial" and its shaders, and then
modify the fragment shader to have an empty "main()", and remove all code no longer needed. We call the new material
"onlyZMat" and its shaders "onlyZ".

Now we need to duplicate all mesh nodes in the scene, so we have one mesh node rendering only into the z-buffer, and
one mesh node rendering in the color buffer. For a real scene with many mesh nodes that could be quite annoying - 
and here is where the "multi-pass material" mentioned at the end of the "Concepts" section would be really handy. 

For this scene however, we only need to duplicate three mesh nodes - one in the "Wheel" prefab and one each
in the "Car" and the "SUV" prefab. So we duplicate those mesh nodes, and assign
to the new mesh nodes the "onlyZMat" material.

To render first all mesh nodes with the "onlyZMat" material, we tag the "onlyZMat" material with "onlyZ".
Then we make two new render layers, called "ZOnlyRenderLayer" and "ColorOnlyRenderLayer". Both use
"render_main" as their "Renderable Tags" and both user "onlyZ" in their "Material Filter Tags". In 
"ZOnlyRenderLayer" the "Material Filter Behaviour" is set to "Include ..." and in "ColorOnlyRenderLayer" it
is set to "Exclude...". Now the "ZOnlyRenderLayer" will render all mesh nodes using the "onlyZMat" material,
and the "ColorOnlyRenderLayer" will render all mesh nodes **not** using the "onlyZMat" material - that is
the mesh nodes using "plainMaterial".

To make use of those two new render layers, we tag "ZOnlyRenderLayer" with "z" and "ColorOnlyRenderLayer"
with "color", and modify "MainRenderLayer" to use as "Renderable Tags" "z" with render order "0" and
"color" with render order "1".

All those changes together will now cause "MainRenderPass" to first render all mesh nodes using the "onlyZMat"
material and then all mesh nodes not using the "onlyZMat" material - and hence the rendered car now looks "normal"
again (see toy_cars2.rca):

![](docs/ToyCars3.png)

However, making the other cars visible again does not yield the desired result, the cars seem to be opaque.
The reason for that is that we need to render the cars back to front, first the z-buffer, then the color buffer,
to make sure that the occluded parts of the cars in the back are rendered before the z-buffer 
of the front car is written. So the order of rendering must be:

1. Back car, z-buffer,
2. Back car, color buffer,
3. Middle car, z-buffer,
4. Middle car, color buffer,
5. Front car, z-buffer,
6. Front car, color buffer.

To do that, we tag each car individually using "car_back", "car_middle" and "car_front",
create three of each "ZOnlyRenderLayer" and "ColorOnlyRenderLayer" using "car_back", "car_middle" and
"car_front" as renderable tags, tag the render layers with "z_back", "color_back", "z_middle", "color_middle",
"z_front" and "color_front" and remove the "render_main" tag from the scene completely. 

Now the only thing that remains is to reconfigure MainRenderLayer to use "z_back", "color_back", "z_middle", "color_middle",
"z_front" and "color_front" in that render order as "Renderable Tags", and the scene will 
render each car semi-transparent but for each car only the frontmost pixels (see toy_cars3.rca):

![](docs/ToyCars4.png)

