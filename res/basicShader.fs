#version 150

#define MAXLIGHTS 10

uniform sampler2D diffuse;
uniform float materialShininess;
uniform vec3 materialSpecularColor;
uniform vec3 cameraPosition;

uniform struct Light
{
    vec3 position;
    float[3] color;
    float attenuation;
    float ambientCoefficient;
} lights[MAXLIGHTS];

uniform int numLights;

uniform mat4 transform;

in vec2 texCoord0;
in vec3 normal0;
in vec3 position0;

out vec4 finalColor;


vec3 applyLight(Light light, vec4 surfaceColor, vec3 surfaceToCamera, vec3 surfacePos)
{
    vec3 intensities = vec3(light.color[0], light.color[1], light.color[2]);

    mat3 normalMatrix = transpose(inverse(mat3(transform)));
    vec3 normal = normalize(normalMatrix * normal0);    

    vec3 surfaceToLight = normalize(light.position - surfacePos);

    //ambient
    vec3 ambient = light.ambientCoefficient * surfaceColor.rgb * intensities;

    //diffuse
    float diffuseCoefficient = max(0.0, dot(normal, surfaceToLight));
    vec3 diffuse = diffuseCoefficient * surfaceColor.rgb * intensities;

    //specular
    float specularCoefficient = 0.0;
    if(diffuseCoefficient > 0.0)
    {
        specularCoefficient = pow(max(0.0, dot(surfaceToCamera, reflect(-surfaceToLight, normal))), materialShininess);
    }
    vec3 specular = specularCoefficient * materialSpecularColor * intensities;
    
    //attenuation
    float distanceToLight = length(light.position - surfacePos);
    float attenuation = 1.0 / (1.0 + light.attenuation * pow(distanceToLight, 2));

    return ambient + attenuation*(diffuse + specular);
}


void main()
{
    vec4 surfaceColor = texture(diffuse, texCoord0);
    vec3 surfacePos = vec3(transform * vec4(position0, 1));
    vec3 surfaceToCamera = normalize(cameraPosition - surfacePos);

    //combine color from all the lights
    vec3 linearColor = vec3(0);
    for(int i = 0; i < numLights; i++){
        linearColor += applyLight(lights[i], surfaceColor, surfaceToCamera, surfacePos);
    }
    
    //final color (after gamma correction)
    vec3 gamma = vec3(1.0/2.2);
    finalColor = vec4(pow(linearColor, gamma), surfaceColor.a);
}