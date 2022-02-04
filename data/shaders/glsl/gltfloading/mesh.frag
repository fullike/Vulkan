#version 460

struct InstanceData
{
    vec3 pos;
    uint idx;
};

layout (binding = 1) buffer Instances
{
    InstanceData instances[];
};

struct MeshData
{
    uint StartSection;
    uint SectionCount;
};

layout (binding = 2) buffer Meshes
{
    MeshData meshes[];
};

struct SectionData
{
    uint StartPrimitive;
    uint PrimitiveCount;
	uint TextureIndex;
};

layout (binding = 3) buffer Sections
{
    SectionData sections[];
};

layout (binding = 4) uniform sampler2D samplerColorMap[16];

layout (location = 0) in vec3 inNormal;
layout (location = 1) in vec3 inColor;
layout (location = 2) in vec2 inUV;
layout (location = 3) in vec3 inViewVec;
layout (location = 4) in vec3 inLightVec;
layout (location = 5) in flat ivec3 inIds;

layout (location = 0) out vec4 outFragColor;

SectionData GetSection(uint MeshId, uint PrimitiveId)
{
	MeshData mesh = meshes[MeshId];
	for (uint i = 0; i < mesh.SectionCount; i++)
	{
		SectionData section = sections[mesh.StartSection + i];
		if (PrimitiveId < section.StartPrimitive + section.PrimitiveCount)
			return section;
	}
	return SectionData(0,0,0);
}

void main() 
{
    SectionData section = GetSection(0, gl_PrimitiveID);
    vec4 color = texture(samplerColorMap[section.TextureIndex], inUV) * vec4(inColor, 1.0);

	vec3 N = normalize(inNormal);
	vec3 L = normalize(inLightVec);
	vec3 V = normalize(inViewVec);
	vec3 R = reflect(-L, N);
	vec3 diffuse = max(dot(N, L), 0.15) * inColor;
	vec3 specular = pow(max(dot(R, V), 0.0), 16.0) * vec3(0.75);
	outFragColor = vec4(diffuse * color.rgb + specular, 1.0);		
}