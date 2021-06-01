<!--
SPDX-License-Identifier: MPL-2.0

This file is part of Ramses Composer
(see https://github.com/GENIVI/ramses-composer-docs).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

# Data and scope

The Ramses Composer is a tool which controls the state of a 3D project before the [export step](../export/manual.md) to binary Ramses formats.
It is important to understand the lifecycle and origin of Composer objects and their data in order to use them efficiently, reduce unneeded
duplication of resources, and store the data in a way that it can be configured for different use-cases and export scenarios.
This section of the documentation explains when data is copied and when referenced, and how objects behave in the different categories
of content (scene, resources, prefabs, and external project references).

This manual page is intended for advanced usage of the Composer.
For introduction to the individual features, have a look at the dedicated examples:

* [Hello World](../hello_world/manual.md) - fundamentals of references to external resources
* [Monkey heads](../monkey/manual.md#lua-scripting) - links between properties inside the project
* [Prefabs](../prefabs/manual.md) - packaging of data in reusable components

<!-- TODO add external references here too, once finished -->

## Composer data and imported resources

The Composer has its own data model which it stores in a single file - the \<project\>.rca file. Data which is imported from external sources via a file URI
is not duplicated internally, but instead kept as a reference (to the originating file) as a relative path. Therefore, an `rca` file should be
always distributed together with the imported files at the correct location specified in the URIs. It is strongly advised to keep these files in subfolders of the directory where the
`rca` file lives in order to make the project portable, i.e. be able to move and archive the whole folder for easy distribution and versioning.

For options to use absolute paths and best practices for project structure, refer to
[the dedicated section](../best_practices/manual.md#relative-and-absolute-paths).

<!-- TODO this section needs to be extended/adapted once external references are implemented. How are external projects and their references
supposed to be managed? As subfolders? Relative paths? ... -->

## Composer data and exported binary files

The Composer currently exports two binary files - a `ramses` file (contains the exported Ramses scene) and a
`rlogic` file (contains the exported Ramses Logic content and references the Ramses scene).
All references to non-native Ramses objects are resolved to native Ramses content on export.
This includes external resources (shaders, PNG, glTF, etc), prefabs and external project references.

During the export, the Ramses scene is exported in the same state as it is in the Composer at the time of export.
Refer to the [export manual](../export/manual.md)
for details how to use the export functionality. See the [section below](#mapping-to-ramses-objects) for
details which data is exported and which objects to expect.

<!--TODO Once we have external references, we should mention them here and link the page-->

## Scene Graph objects

The Scene Graph tree in the Composer represents in broad terms the Ramses scene which will be
created on `export`. Each object there corresponds to one or more exported Ramses objects. See
the [section below](#mapping-to-ramses-objects) for details on the exact mapping.

All objects in the Composer Scene Graph have their own data. The exceptions to this rule are:

* Links - if two properties are linked to the same output - the link will make sure they receive the same value
* Materials - `MeshNode` objects contain a reference to a material, but the `MeshNode`s' local material settings are independent from the default settings of the material

<!-- TODO rework this once we fix materials behavior... The above sentence can not be generalized - if two meshes refer to the
same material, they get their own copy of the data, but if they refer to the same mesh - they share the mesh. This makes
sense if one knows the Ramses API, but it doesn't make much sense from a user/data point of view. The UI is also particularly
confusing - it appears as if the material is being referenced (i.e. the data is somewhere else) but it's not-->

## Copy and Deep Copy

Any object in the Composer can be copied and pasted. By default, a copy is "shallow", i.e. it does not recursively copy references to other objects.
If you want to do a "deep copy", you have to use the "Copy (Deep)/Cut (Deep)" function available via right click. See the sections below for details.

The copy function appends a suffix of the form `<orig. name> (N)` to the name of pasted objects when a name conflict occurs - both for shallow and deep copies.

### Shallow copy

When an object is shallow copied, all its values will be copied. This also includes references to other objects in the scene (e.g. MeshNode -> Mesh), so pasted objects share the same references as the copied objects. When the referenced object does not exist in the scene anymore, the reference will be set to `<empty>`.

### Deep copy

When deep-copied, other objects referenced in the copied objects will also get copied. When pasting, the references in the copied objects will be replaced with references to the newly created reference objects. Note that deep-copying an object with links will not create a copy of the linked LuaScript when pasting, but copies the links. Also note that deep-copy-pasting PrefabInstances will generate new copies of the referenced Prefab, but not vice versa.

<!-- TODO document how this affects ext refs -->

## Mapping to Ramses objects

Here is a table which describes which Ramses (and Logic) objects are generated for each of the
Composer objects:

| Composer type     |From View          |Exported Ramses object(s)                              |Exported Logic object(s)   |Notes |
|-------------------|-------------------|-------------------------------------------------------|---------------------------|-------------------------------------|
|Node               |Scene              |ramses::Node                       | rlogic::RamsesNodeBinding | Child nodes are assigned as children in Ramses. RamsesNodeBinding points to Ramses node. |
|MeshNode           |Scene              |ramses::MeshNode ramses::Appearance ramses::GeometryBinding| rlogic::RamsesNodeBinding rlogic::RamsesAppearanceBinding| Same as Node, but with Appearance and GeometryBinding which refers to array resources (see Mesh) |
|PerspectiveCamera  |Scene              |ramses::PerspectiveCamera                              |                           | Most recently modified object of this type is assigned to the default Ramses RenderPass |
|OrthographicCamera |Scene              |ramses::OrthographicCamera                             |                           | Most recently modified object of this type is assigned to the default Ramses RenderPass |
|Material           |Resources          |ramses::Effect                                         |                           | Holds the Effect, not the appearance and uniform values (see MeshNode) |
|Mesh               |Resources          |ramses::ArrayResource                                  |                           | Holds geometry data referenced by ramses::MeshNode's ramses::GeometryBinding |
|Texture            |Resources          |ramses::Texture2D  ramses::TextureSampler              |                           | Currently static |
|CubeMap            |Resources          |ramses::TextureCube  ramses::TextureSampler            |                           | Currently static |
|LuaScript          |Scene or Resources |                                                       | rlogic::LuaScript         | LuaScripts can be global (Resources tab) or local (Scene Graph tab) |
|PrefabInstance     |Scene              | Various                                               | Various                   | Exported content depends on referenced Prefab. Each PrefabInstance creates its own copy based on Prefab contents.  |
|Prefab             |Prefab             |                                                       |                           | Content created only if referenced by a PrefabInstance. Underlying nodes and scripts are exported as if they had their own Scene Graph. Ramses nodes are parented to the parent node of the corresponding PrefabInstance |
|                   |                   | ramses::RenderPass                                    |                           | There is a single global RenderPass which contains a single global RenderGroup. All mesh nodes are assigned to this RenderGroup in the render order of the Scene Graph|

LuaScripts generally belong to a scene. You will find them showing up in the Resource view for scripts which are positioned in the top-level of the scene hierarchy. We plan to remove this in an upcoming version of the composer.

<!-- TODO Update docs once we remove scripts from resources window view -->

LuaScripts which belong to a PrefabInstance are created as if they were directly attached to a scene. Currently, all such scripts are exported as copies - one copy per PrefabInstance.

<!-- TODO Update docs once we create them with different names. Also, need to document what happens with ext refs! -->

## Additional note on prefabs

Prefabs should not export anything unless used in a PrefabInstance. Currently, LuaScripts are being exported from Prefabs even when not referenced. We plan to change this in a future release.

<!-- TODO Fix and update docs -->

Furthermore, Prefab(Instance) scene content is instantiated (copied) on all places where a PrefabInstance is attached in the scene. The content copies currently share the same names. This excludes Resources like Textures, Vertex arrays and Effects - they are exported once even if used by multiple MeshNodes/PrefabInstances.

## Default Resources

Ramses Composer contains default resources, serving as placeholder resources. A default resource used in a scene will also get exported.

### CubeMap

The default CubeMap shows fallback textures on all sides.

### Meshes

The default Mesh in RaCo is a simple cube.

### Material

There are two default Materials.

Using a Mesh that does not contain normals will result in the first default Material: a single matte color with the RGBA values [1.0, 0.0, 0.2, 1.0] that spans the entire Mesh.

Using a Mesh that contains normals but no Material will result in the second default Material: an orange color with the RGBA values [1.0, 0.5, 0.0, 1.0] and surface reflection.

### Texture

The default Texture in RaCo consists of a singular "test card" image that shows the UV coordinate roots and what conventions for these coordinates' origin are being used (currently OpenGL or DirectX).
