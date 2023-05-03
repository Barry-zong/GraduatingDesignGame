struct TranslucencyData
{
	float3 transmissionColor;
	float waveHeight;
	float mask;
	float strength;

	float outputMask;
};

TranslucencyData PopulateTranslucencyData(float3 transmissionColor, float3 lightDir, float3 viewDir, float3 WorldNormal, float3 worldTangentNormal, float waveHeight, float mask, float2 params)
{
	TranslucencyData d   = (TranslucencyData)0;
	d.transmissionColor  = transmissionColor;
	d.waveHeight         = waveHeight;
	d.mask               = mask; //Shadows, foam, intersection, etc
	d.strength           = params.x;

	float tMask          = saturate(pow(saturate(dot(-viewDir, lightDir) - mask), params.y));
	float waveSlope      = saturate(dot(WorldNormal, viewDir));
	float microWaveSlope = saturate(dot(worldTangentNormal, float3(0,1,0)));

	half sunAngle        = saturate(dot(float3(0, 1, 0), lightDir));
	half angleMask       = saturate(sunAngle * 10); 
	tMask               *= angleMask;
	
	float transmission   = tMask * waveHeight * waveSlope * microWaveSlope * params.x;

	d.outputMask         = transmission;

	return d;
}

float3 ApplyTranslucency(in float3 baseColor, TranslucencyData data)
{
	// 透光混合
	baseColor.rgb = lerp(baseColor.rgb, data.transmissionColor, data.outputMask);
	return baseColor.rgb;
}