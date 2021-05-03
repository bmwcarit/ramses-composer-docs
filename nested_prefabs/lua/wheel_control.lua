
function interface()

	IN.rotationAngle = FLOAT
	IN.steeringAngle = FLOAT
  IN.reverse = BOOL

	OUT.driveRotation = VEC3F
	OUT.steerRotation = VEC3F
	
end

function run()

  local rotation = IN.rotationAngle
  local steering = IN.steeringAngle
  
  -- clamp steering to realistic values
  steering = math.min( 30, math.max( -30, steering ))
  
  if( IN.reverse ) then
    -- reverse turn direction for wheels on other side
    rotation = -rotation
    -- turn wheels on other side around 180 degrees
    steering = steering + 180
  end
  
  OUT.driveRotation = { 0, rotation, 0 }
  OUT.steerRotation = { 0, 0, steering }
  
end
