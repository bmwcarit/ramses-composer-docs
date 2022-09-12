<!--
SPDX-License-Identifier: MPL-2.0

This file is part of Ramses Composer
(see https://github.com/COVESA/ramses-composer-docs).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

# TracePlayer
The Ramses Composer offers scene player, where users can load and play back RaCo trace (.rctrace) files.  
TracePlayer is mainly used to play back:
- recorded trace from the car, for scene debugging purposes
- predefined sequence of scene states, for demos and scene validation purposes

## Basic Functionalities
![](docs/traceplayer_notrace.png "TracePlayer - No Trace Loaded")

The TracePlayer has typical playback features of Load, Play, Pause, Stop, Looping, Step-forward/backward, and Jump-to.  
First, you need to browse to a valid .rctrace file and load it using the 3-dots icon.  
![](docs/traceplayer_init.png "TracePlayer - Initial State")

TracePlayer parses .rctrace file, then updates properties of relevant Lua nodes in the scene based on their names.Therefore, you need to make sure to add the equivalent interface Lua scripts to the scene and match their names.  
On the other hand, **IN** interfaces of the Lua script have to match the same structure on the properties in the .rctrace file.

## .rctrace File Format
The trace file is a JSON-based file and has the file extension ".rctrace". The trace file is a JSON array of frames, where each frame is a JSON object containing two JSON objects children elements "SceneData" and "TracePlayerData".  
**SceneData** is a JSON object that contains a list of features; those features are parsed and mapped by name by TracePlayer to the corresponding Lua nodes in the scene. Supported property types are boolean, integer, double, and strings.  
**TracePlayerData** is a JSON object that contains timestamp of a frame in milliseconds.

An example of a valid trace can look like the following:

```json
[
    {   // frame#1 
        "SceneData" :
        {
            "Feature_1" :    // TracePlayer will look the scene up for a Lua node with the name "Feature_1". It shall have IN interface structs named "Function_1" and "Function_2"
            {
                "Function_1" :  //  "Function_1" struct shall contain "active", "ranking", "speed", and "color" IN properties with equivalent types
                {
                    "active" : true,    // BOOL
                    "ranking" : 7,      // INT
                    "speed" : 123.50,   // FLOAT
                    "color" : "blue"    // STRING
                },
                "Function_2" :
                {
                    "length" : 12.0,
                    "width" : 5.50,
                }
            },
            "Feature_2" :
            {
                "Function_1" :
                {
                    "class" : 3
                },
                "Function_2" :
                {
                    "positionX" : 1.789,
                    "positionY" : 45.887,
                }
            }
        },
        "TracePlayerData" :
        {
            "timestamp(ms)" : 1
        }
    },
    {   // frame#2
        "SceneData" :
        {
            /* list of features */
        },
        "TracePlayerData" :
        {
            "timestamp(ms)" : 2
        }
    },
    {   // frame#3
        "SceneData" :
        {
            /* list of features */
        },
        "TracePlayerData" :
        {
            "timestamp(ms)" : 3
        }
    }
]
```
## Animation Control
*(preliminary function and subject to change soon)*  
The TracePlayer offers the following two properties in TracePlayerData script as interface for animation:
- **activate_animation**: a boolean flag that is set once playback starts, and reset once a jump or a stop is triggered.
- **timestamp_milli**: an integer of timeline timestamp, which should be used as the reference timer for animation
## Example (G05_OSS)
Load **G05_main.rca** scene into Ramses Composer; refer to documentation in scene [g05_oss](../digital-car-3d/G05/README.md).  
Edit, save, and reload the RaCo trace [g05_demo](traces/g05_demo.rctrace); change timestamp of frames and properties to see different playback in Ramses Composer renderer.