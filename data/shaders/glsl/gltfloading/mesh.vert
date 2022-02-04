#version 460

layout (location = 0) in vec3 inPos;
layout (location = 1) in vec3 inNormal;
layout (location = 2) in vec2 inUV;
layout (location = 3) in vec3 inColor;

layout (set = 0, binding = 0) uniform UBOScene
{
	mat4 projection;
	mat4 view;
	vec4 lightPos;
} uboScene;

struct InstanceData
{
    vec3 pos;
    uint idx;
};

layout (binding = 1) buffer Instances
{
    InstanceData instances[];
};

layout (location = 0) out vec3 outNormal;
layout (location = 1) out vec3 outColor;
layout (location = 2) out vec2 outUV;
layout (location = 3) out vec3 outViewVec;
layout (location = 4) out vec3 outLightVec;
layout (location = 5) out ivec3 outIds;

void main() 
{
	outNormal = inNormal;
	outColor = inColor;
	outUV = inUV;
	vec3 world = inPos + instances[gl_InstanceIndex].pos;
	gl_Position = uboScene.projection * uboScene.view * vec4(world, 1.0);
	
	vec4 pos = uboScene.view * vec4(world, 1.0);
	outNormal = mat3(uboScene.view) * inNormal;
	vec3 lPos = mat3(uboScene.view) * uboScene.lightPos.xyz;
	outLightVec = lPos - pos.xyz;
	outViewVec = -pos.xyz;
    outIds = ivec3(gl_DrawID, gl_InstanceIndex, 0);
}