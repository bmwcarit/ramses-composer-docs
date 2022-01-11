
function interface()

	IN.wheelFactor = FLOAT
	IN.steeringFactor = FLOAT

	OUT.rotationAngle = FLOAT
	OUT.steeringAngle = FLOAT
	
end

function run()

  OUT.rotationAngle = IN.wheelFactor * 360
  OUT.steeringAngle = IN.steeringFactor * 90
  
end
