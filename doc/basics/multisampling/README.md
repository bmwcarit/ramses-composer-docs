<!--
SPDX-License-Identifier: MPL-2.0

This file is part of Ramses Composer
(see https://github.com/bmwcarit/ramses-composer-docs).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

# Multisampling example
*You can find the example project [here](https://github.com/bmwcarit/ramses-composer-docs/tree/master/doc/basics/multisampling).*

![](./docs/msaa_result_scene.png)

This example shows how to render anti-aliased graphics with multisampling (MSAA) with the Ramses Composer. We use offscreen rendering approach discussed in [offscreen rendering example](../offscreen/README.md).

## Scene graph and resources

The sample shows two duck images. Both are rendered in low resolution (256x256) to make jagged edges clearly visible. Left image does not use multisampling. Right one uses 4 samples per pixel. Outcome of MSAA is especially noticeable on the edges of the duck on the right: jagged edges effect is reduced by color approximation.

The sample scene consists of:

* `DuckMeshNode` which is a textured duck mesh
* `DuckCamera` used for offscreen rendering of the duck
* `LeftQuadMeshNode` showing non-multisample renderbuffer contents
* `RightQuadMeshNode` showing 4xMSAA renderbuffer contents
* Default `PerspectiveCamera` for the final scene displaying two quads

Left quad is rendered using with offscreen rendered texture using `TextureMaterial` without multisampling.

## MSAA rendering

For MSAA rendering, multisample renderbuffers and special fragment shader are used.

`RenderTargetMSx4` is set up as follows:

* `ColorMSx4` and `DepthMSx4` Sample Count = `4` are created. They are set to `RenderTargetMSx4` multisample buffer fields. All RenderBuffers in MSAA RenderTarget must have same Sample Count.
* `DuckRenderPassMSx4` renders `DuckRenderLayer` nodes using `DuckCamera` to `RenderTargetMSx4`.

![](./docs/msaa_render_target.png)

## Displaying multisample renderbuffer contents

We want to display the `ColorMSx4` MSAA renderbuffer as texture on `RightQuadMeshNode`.

To use `ColorMSx4` renderbuffer as texture uniform, the fragment shader must accept `sampler2DMS textureSampler` uniform representing a Multisample Texture. `int sampleCount` uniform specifies amount of samples per fragment. Below is full code of fragment shader:

    #version 310 es
    precision highp float;

    uniform highp sampler2DMS textureSampler;
    uniform highp int sampleCount;

    in lowp vec2 v_TextureCoordinate;
    out vec4 fragColor;

    void main(void)
    {
        vec4 color = vec4(0.0);

        for (int i = 0; i < sampleCount; i++)
            color += texelFetch(textureSampler, ivec2(v_TextureCoordinate * vec2(textureSize(textureSampler))), i);

        color /= float(sampleCount);
        fragColor = color;
    }

Vertex shader does not need special code for MSAA.

Now we can create `TextureMaterialMS` material and use MSAA fragment shader. `ColorMSx4` textureSampler and sampleCount = `4` are specified as uniforms.

![](./docs/msaa_material.png)

Finally, `RightQuadMeshNode` is assigned `TextureMaterialMS` material and displays multisample renderbuffer content.

## Preview MSAA settings

Ramses Composer allows enable MSAA in Preview:

![](./docs/msaa_preview_settings.png)

Specified MSAA setting is applied to Preview renderbuffer displaying contents of Default Framebuffer target. This setting is effective in Ramses Composer Preview only.