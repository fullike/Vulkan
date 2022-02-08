// Copyright 2020 Google LLC

struct VSOutput
{
[[vk::location(0)]] float3 Normal : NORMAL0;
[[vk::location(1)]] float3 Color : COLOR0;
[[vk::location(2)]] float3 ViewVec : TEXCOORD1;
[[vk::location(3)]] float3 LightVec : TEXCOORD2;
[[vk::location(4)]] float2 UV : TEXCOORD3;
[[vk::location(5)]] uint InstanceId : TEXCOORD4;
};

Texture2D textures[256] : register(t1);
SamplerState samplerColorMap : register(s1);

struct InstanceData
{
    float3 pos;
    uint idx;
};

StructuredBuffer<InstanceData> instances : register(t2);
StructuredBuffer<uint> ids : register(t3);


float4 main(VSOutput input) : SV_TARGET
{
    uint idx = ids[input.InstanceId];
    uint texId = instances[idx].idx;
    float3 color = textures[texId].Sample(samplerColorMap, input.UV.xy).rgb;
    float3 N = normalize(input.Normal);
    float3 L = normalize(input.LightVec);
    float ambient = float(0.25);
    float diffuse = float(max(dot(N, L), 0.0));
    return float4((ambient + diffuse) * color, 1.0);
}
