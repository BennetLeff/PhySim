#version 410

uniform sampler2D diffuse;

uniform struct Light
{
    vec3 position;
    float[3] color;
} light;

uniform mat4 transform;

in vec2 texCoord0;
in vec3 normal0;
in vec3 position0;

out vec4 finalColor;

void main()
{
    vec3 lightVec = vec3(light.color[0], light.color[1], light.color[2]);

	mat3 normalMatrix = transpose(inverse(mat3(transform)));
    vec3 normal = normalize(normalMatrix * normal0);

	//calculate the location of this fragment (pixel) in world coordinates
    vec3 fragPosition = vec3(transform * vec4(position0, 1));
    
    //calculate the vector from this pixels surface to the light source
    vec3 surfaceToLight = light.position - fragPosition;

    //calculate the cosine of the angle of incidence
    float brightness = dot(normal, surfaceToLight) / (length(surfaceToLight) * length(normal));
    brightness = clamp(brightness, 0, 1);

    //calculate final color of the pixel, based on:
    // 1. The angle of incidence: brightness
    // 2. The color/intensities of the light: light.intensities
    // 3. The texture and texture coord: texture(tex, fragTexCoord)
    vec4 surfaceColor = texture(diffuse, texCoord0);
    
    finalColor = vec4(brightness * lightVec *  surfaceColor.rgb, surfaceColor.a);
}
