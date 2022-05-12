
function interface(IN,OUT)

	IN.rotationAngle = Type:Float()
	IN.steeringAngle = Type:Float()

	OUT.rotationAngle = Type:Float()
	OUT.steeringAngle = Type:Float()
	
end

function run(IN,OUT)

	OUT.rotationAngle = IN.rotationAngle
	OUT.steeringAngle = IN.steeringAngle
  
end
