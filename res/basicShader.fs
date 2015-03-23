#version 150

#define MAXLIGHTS 10

uniform sampler2D diffuse;

uniform struct Light
{
    vec3 position;
    float[3] color;
} lights[1];

uniform mat4 transform;

in vec2 texCoord0;
in vec3 normal0;
in vec3 position0;

out vec4 finalColor;


vec3 applyLight(Light light)
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

    return vec3(brightness * lightVec *  surfaceColor.rgb);
}


void main()
{
    vec4 surfaceColor = texture(diffuse, texCoord0);

    //combine color from all the lights
    vec3 linearColor = vec3(0);
    for(int i = 0; i < 1; i++){
        linearColor += applyLight(lights[i]);
    }
    
    //final color (after gamma correction)
    vec3 gamma = vec3(1.0/2.2);
    finalColor = vec4(pow(linearColor, gamma), surfaceColor.a);

    //finalColor = applyLight(lights[0]);
}