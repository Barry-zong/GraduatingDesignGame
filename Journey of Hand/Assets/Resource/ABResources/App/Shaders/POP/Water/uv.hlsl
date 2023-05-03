// 对冲型uv动画
float4 PackedUV(float2 sourceUV, float2 time, float speed)
{
	float2 uv1  = sourceUV.xy + (time.xy * speed);
	float2 uv2  = (sourceUV.xy * 0.5) + ((1 - time.xy) * speed * 0.5);
	return float4(uv1.xy, uv2.xy);
}

// uv位移
float2 Panner(float2 uv, float2 offset)
{
	return uv + offset*_Time.yy;
}

// 四散采样模拟波浪
float3 MotionFourWayChaos(sampler2D tex, float2 uv, float speed)
{
	float2 uv1 = Panner(uv + float2(0.000, 0.000), float2(0.1, 0.1) * speed);
	float2 uv2 = Panner(uv + float2(0.418, 0.355), float2(-0.1, -0.1) * speed);
	float2 uv3 = Panner(uv + float2(0.865, 0.148), float2(-0.1, 0.1) * speed);
	float2 uv4 = Panner(uv + float2(0.651, 0.752), float2(0.1, -0.1) * speed);

	float3 sample1 = tex2D(tex, uv1).rgb;
	float3 sample2 = tex2D(tex, uv2).rgb;
	float3 sample3 = tex2D(tex, uv3).rgb;
	float3 sample4 = tex2D(tex, uv4).rgb;

	return (sample1 + sample2 + sample3 + sample4) * 0.25;
}

// 焦散uv采样
float3 SampleCaustics(float3 depthPos, float tiling, float speed)
{
	//float4 lightSpaceUVs = mul(_MainLightWorldToShadow[0], float4(depthPos.xyz, 1)) ;
	float2 causticUV = (depthPos.xz * tiling) * 0.5;
	float3 caustics  = MotionFourWayChaos(_Caustics, causticUV, speed);
	return caustics;
}

//