// Copyright 2020 Google LLC

struct VSInput
{
    uint InstanceId : SV_InstanceID;
[[vk::location(0)]] float4 Pos : POSITION0;
[[vk::location(1)]] float3 Normal : NORMAL0;
[[vk::location(2)]] float3 Color : COLOR0;
};

struct UBO
{
	float4x4 projection;
	float4x4 modelview;
};

cbuffer ubo : register(b0) { UBO ubo; }

struct InstanceData
{
    float3 pos;
    uint idx;
};

StructuredBuffer<InstanceData> instances : register(t2);
StructuredBuffer<uint> ids : register(t3);

struct VSOutput
{
	float4 Pos : SV_POSITION;
[[vk::location(0)]] float3 Normal : NORMAL0;
[[vk::location(1)]] float3 Color : COLOR0;
[[vk::location(2)]] float3 ViewVec : TEXCOORD1;
[[vk::location(3)]] float3 LightVec : TEXCOORD2;
[[vk::location(4)]] float2 UV : TEXCOORD3;
[[vk::location(5)]] uint InstanceId : TEXCOORD4;
	
};

VSOutput main(VSInput input)
{
	VSOutput output = (VSOutput)0;
    output.UV = input.Pos.xy;
	output.Color = input.Color;
	output.Normal = input.Normal;
    output.InstanceId = input.InstanceId;

    uint idx = ids[input.InstanceId];
	
    float4 pos = float4((input.Pos.xyz * 1.f) + instances[idx].pos, 1.0);

	output.Pos = mul(ubo.projection, mul(ubo.modelview, pos));

	float4 wPos = mul(ubo.modelview, float4(pos.xyz, 1.0));
	float4 lPos = float4(0.0, 10.0, 50.0, 1.0);
	output.LightVec = lPos.xyz - pos.xyz;
	output.ViewVec = -pos.xyz;
	return output;
}
