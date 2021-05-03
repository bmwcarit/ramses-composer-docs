function interface()
    IN.colorDoors = VEC4F
    IN.colorSteeringWheel = VEC4F
    IN.colorSeat = VEC4F

    OUT.colorDoors = VEC3F
    OUT.colorSteeringWheel = VEC4F
    OUT.colorSeat = VEC4F
end

function run()
    OUT.colorDoors = IN.colorDoors
    OUT.colorSteeringWheel = IN.colorSteeringWheel
    OUT.colorSeat = IN.colorSeat

end
