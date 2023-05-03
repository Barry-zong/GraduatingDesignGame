
float _SpecularStep;

///// Stylized Specular /////
float3 ToonSpecular(half3 lightColor, half3 lightDir, half3 normal, half3 viewDir, half4 specular, float smoothness)
{
	float3 halfVec  = SafeNormalize(float3(lightDir) + float3(viewDir));
	half NdotH      = saturate(dot(normal, halfVec));
	half VdotH      = clamp(dot(viewDir, halfVec), 0.0, 1.0);
	// 模拟F项
	float F         = pow(1.0 - VdotH, 5.0);
	// 模拟F0
	
	F               = lerp(0.1,1.0,F);
	float3 modifier   = pow(NdotH, smoothness);
	//modifier        = 1.0 - step(modifier, _SpecularStep);
	//modifier        = smoothstep(0.3,0.8,modifier);
	half3 specularReflection  = specular.rgb * modifier;
	return lightColor * specularReflection * F;
}

///// Shadow_Cauculation /////
float GetShadows(float3 wPos)
{
	float4 shadowCoord = TransformWorldToShadowCoord(wPos.xyz);
	return  MainLightShadow(shadowCoord, wPos, half4(0,0,0,0), half4(0,0,0,0));
	/*ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
	half4 shadowParams = GetMainLightShadowParams();
	return SampleShadowmap(TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), shadowCoord, shadowSamplingData, shadowParams, false);*/
}


///// Reflection Probe /////
float3 SampleReflections(float3 reflectionVector, float smoothness, float4 screenPos, float3 normal, float3 viewDir, float2 pixelOffset)
{
	//return reflectionVector;
	float3 probe = saturate(GlossyEnvironmentReflection(reflectionVector, smoothness, 1.0));
	return probe;
}


///// SSR /////
float2 ViewPosToCS(float3 vpos)
{
	float4 proj_pos   = mul(unity_CameraProjection, float4(vpos, 1));
	float3 screenPos  = proj_pos.xyz / proj_pos.w;
	return float2(screenPos.x, screenPos.y) * 0.5 + 0.5;
}

float compareWithDepth(float3 vpos)
{
	float2 uv     = ViewPosToCS(vpos);
	float depth   = tex2D(_CameraDepthTexture, uv).r;
	depth         = LinearEyeDepth(depth, _ZBufferParams);
	int isInside  = uv.x > 0 && uv.x < 1 && uv.y > 0 && uv.y < 1;
	return lerp(0, vpos.z + depth, isInside);
}

bool rayMarching(float3 o, float3 r, out float2 hitUV)
{
	float3 end         = o;
	float stepSize     = 0.5;
	float thinkness    = 0.1;
	float triveled     = 0;
	int max_marching   = 256;
	float max_distance = 500;

	UNITY_LOOP
	for (int i = 1; i <= max_marching; ++i)
	{
		end       += r * stepSize;
		triveled  += stepSize;

		if (triveled > max_distance)
		return false;

		float collied = compareWithDepth(end);
		if (collied < 0)
		{
			if (abs(collied) < thinkness)
			{
				hitUV = ViewPosToCS(end);
				return true;
			}

			//回到当前起点
			end -= r * stepSize;
			triveled -= stepSize;
			//步进减半
			stepSize *= 0.5;
		}
	}
	return false;
}

