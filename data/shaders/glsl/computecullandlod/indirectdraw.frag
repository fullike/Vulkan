#version 450

layout (location = 0) in vec3 inNormal;
layout (location = 1) in vec3 inColor;
layout (location = 2) in vec3 inViewVec;
layout (location = 3) in vec3 inLightVec;
layout (location = 4) in vec2 inUV;
layout (location = 5) in flat uint inInstanceId;
layout (location = 0) out vec4 outFragColor;

layout (set = 0, binding = 1) uniform sampler2D textures[5];

struct InstanceData
{
    vec3 pos;
    uint idx;
};

layout (binding = 2) buffer Instances
{
    InstanceData instances[];
};

layout (binding = 3) buffer InstanceIds
{
    uint ids[];
};

void main()
{
    uint idx = ids[inInstanceId];
    uint texId = instances[idx].idx;
    vec3 color = texture(textures[texId], inUV.xy).rgb;
	vec3 N = normalize(inNormal);
	vec3 L = normalize(inLightVec);
	vec3 ambient = vec3(0.25);
	vec3 diffuse = vec3(max(dot(N, L), 0.0));
    outFragColor = vec4((ambient + diffuse) * color, 1.0);
}
