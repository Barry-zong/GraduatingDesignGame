float SampleIntersection(float2 uv, float gradient, float time)
{
	//return gradient;
	float ripple    = sin(time * 10 - (gradient * _RippleDist)) * _RippleStrength ;

	float noise_mask01     = tex2D(_FoamTex, uv/10 + half2(time * 4, 0)).r;
	float noise_mask02     = tex2D(_FoamTex, uv/5 + half2(0, time * 4)).r;
	float noise_mask = (noise_mask01 * noise_mask02) * 2;
	//return  noise_mask;
	float2 till_uv  = float2(uv.x, uv.y) * _IntersectTilling;
	float noise     = tex2D(_IntersectionNoise, till_uv + time).r;
	
	
	float dist      = saturate(gradient / _IntersectFalloff);
	
	noise           = saturate((noise + ripple) * dist + dist);
	
	float inter     = step(_IntersectClip, noise) * noise_mask * 2;
	//return noise_mask;
	return saturate(inter);
}

float2 SampleFoam(float4 uvs, float clipping, float mask)
{

	float f1     = tex2D(_FoamTex, uvs.xy).r;
	float f2     = tex2D(_FoamTex, uvs.zw).r;

	float foam   = saturate(f1 + f2) * mask;
	// 柔和轮廓
	float foam1  = smoothstep(clipping, 1, foam);
	// 硬轮廓z
	float foam2  = step(clipping, foam);

	return float2(foam1,foam2) ;
	//return foam1;
}