#version 430

layout(location = 3) uniform sampler2D diffuse;

uniform float[] lightPosition;
layout(location = 5) uniform float[] lightIntensity;

uniform float[] color;

in vec2 texCoord0;
in vec3 normal0;

in vec3 position0;
in mat4 model;

out vec4 finalColor;

void main()
{
	vec3 intensities = vec3(lightIntensity[0], lightIntensity[1], lightIntensity[2]);
	vec3 lightPos = vec3(lightPosition[0], lightPosition[1], lightPosition[2]);

	mat3 normalMatrix = transpose(inverse(mat3(model)));
	vec3 normal = normalize(normalMatrix * normal0);

	//calculate the location of this fragment (pixel) in world coordinates
    vec3 fragPosition = vec3(model * vec4(position0, 1));
    
    //calculate the vector from this pixels surface to the light source
    vec3 surfaceToLight = lightPos - fragPosition;

    //calculate the cosine of the angle of incidence
    float brightness = dot(normal, surfaceToLight) / (length(surfaceToLight) * length(normal));
    brightness = clamp(brightness, 0, 1);

    //calculate final color of the pixel, based on:
    // 1. The angle of incidence: brightness
    // 2. The color/intensities of the light: light.intensities
    // 3. The texture and texture coord: texture(tex, fragTexCoord)
    vec4 surfaceColor = texture(diffuse, texCoord0);
    
    vec3 intens = vec3(0.3, 0.5, 0.2);

    finalColor = vec4(brightness * intensities * surfaceColor.rgb, surfaceColor.a);

	//gl_FragColor = texture2D(diffuse, texCoord0)
	//				* clamp(dot(-vec3(0, 0, 1), normal0), 0.0, 1.0);
}
