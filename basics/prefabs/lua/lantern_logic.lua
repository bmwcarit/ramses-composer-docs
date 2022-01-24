
function interface()

  IN.lightSwitch = BOOL

  OUT.emissive = VEC3F
  
	OUT.ambientColor = VEC3F
	OUT.ambientLight = FLOAT

end

function run()

 	if IN.lightSwitch then
		OUT.emissive = { 1,1,1 }
	else
		OUT.emissive = { 0,0,0 }
	end
  
	OUT.ambientColor = { 1, 1, 1 }
	OUT.ambientLight = 1

end