#version 450

// Vertex attributes
layout (location = 0) in vec4 inPos;
layout (location = 1) in vec3 inNormal;
layout (location = 2) in vec3 inColor;

layout (binding = 0) uniform UBO 
{
	mat4 projection;
	mat4 modelview;
} ubo;

struct InstanceData
{
    vec3 pos;
    uint idx;
};

layout (binding = 2) buffer Instances
{
    InstanceData instances[];
};

layout (location = 0) out vec3 outNormal;
layout (location = 1) out vec3 outColor;
layout (location = 2) out vec3 outViewVec;
layout (location = 3) out vec3 outLightVec;
layout (location = 4) out vec2 outUV;
layout (location = 5) out uint outInstanceId;

out gl_PerVertex
{
	vec4 gl_Position;
};

void main() 
{
    outUV = inPos.xy;
	outColor = inColor;
	outNormal = inNormal;
    outInstanceId = gl_InstanceIndex;
	
    vec4 pos = vec4((inPos.xyz * 1.f) + instances[gl_InstanceIndex].pos, 1.0);

	gl_Position = ubo.projection * ubo.modelview * pos;
	
	vec4 wPos = ubo.modelview * vec4(pos.xyz, 1.0); 
	vec4 lPos = vec4(0.0, 10.0, 50.0, 1.0);
	outLightVec = lPos.xyz - pos.xyz;
	outViewVec = -pos.xyz;	
}
