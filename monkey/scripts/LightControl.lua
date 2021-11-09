
-- This script emulates a colorful disco-like light
-- The light position is static, but can be switched from three
-- different positions: left, right, and top (use numbers 0, 1, 2 on light_id to toggle)
-- Additionally, the light color is animated to produce a disco-like effect. This is
-- triggered by the time progression (time_ms input, supposed to be provided with a monotonic
-- timer with milliseconds precision during runtime).

function interface()
    -- Input: index into an array static light positions
    IN.light_id = INT
    -- Input: time, if available (steady clock, in milliseconds, starts at 1, use 0 to disable)
    IN.time_ms = INT

    -- Output: direction of light in that static position
    OUT.light_direction = VEC3F
    -- Output: color of light
    OUT.light_color = VEC3F
end

function run()
    local lightId = IN.light_id
    if lightId < 0 or lightId > 2 then
        lightId = 0
    end

    local lightDirections = {
        [0] = {1, 0, -2},
        [1] = {-1, 0, -2},
        [2] = {0, -3, -1}
    }

    OUT.light_direction = lightDirections[lightId]

    if IN.time_ms ~= 0 then
        OUT.light_color = {
            math.abs(math.sin(IN.time_ms / 1000.0)),
            math.abs(math.cos(IN.time_ms / 10000.0)),
            math.abs(math.sin(IN.time_ms / 10000.0))
        }
    else
        OUT.light_color = {0.1, 0.1, 1.0}
    end
end
