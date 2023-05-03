// 将世界位置修正到深度投影平面上
float3 DecalSpaceWorldPos(float4 screenPos, float3 viewDir, float depth)
{
	float3 camPos        = _WorldSpaceCameraPos.xyz;
	float3 worldPos      = depth * (viewDir/screenPos.w) - camPos;
	float3 perspWorldPos = -worldPos;
	return perspWorldPos;
}

// 求解模型表面沿法线方向与深度信息的距离
float DepthDistance(float3 wPos, float3 viewPos, float3 normal)
{
	float3 dist = (wPos - viewPos);
	return ((dist.x * normal.x) + (dist.y * normal.y) + (dist.z * normal.z));
}