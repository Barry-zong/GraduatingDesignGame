#ifndef UNIVERSAL_POP_SCENE_LIT_INPUT_INCLUDED
#define UNIVERSAL_POP_SCENE_LIT_INPUT_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
#include "POP_Scene_SurfaceInput.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/ParallaxMapping.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"

#if defined(_DETAIL_MULX2) || defined(_DETAIL_SCALED)
#define _DETAIL
#endif

// NOTE: Do not ifdef the properties here as SRP batcher can not handle different layouts.
CBUFFER_START(UnityPerMaterial)
float4 _BaseMap_ST;
float4 _DetailAlbedoMap_ST;
half4 _BaseColor;
half4 _SpecColor;
half4 _EmissionColor;
half _Cutoff;
half _Smoothness;
half _Metallic;
half _BumpScale;
half _Parallax;
half _OcclusionStrength;
half _ClearCoatMask;
half _ClearCoatSmoothness;
half _DetailAlbedoMapScale;
half _DetailNormalMapScale;
half _Surface;
half _SSSScattering, _SSSPower, _SSSIntensity;
half4 _SSSColor;
half _FresnelIntensity, _FresnelPow;
half4 _FresnelColor;
half _CasuticsSpeed, _CasuticsTilling;
half _EmissionIntensity;

half _SmoothnessRemappingLow, _SmoothnessRemappingHigh, _SmoothnessRemappingLevelLow, _SmoothnessRemappingLevelHigh,
     _MetallicRemappingLow, _MetallicRemappingHigh, _MetallicRemappingLevelLow, _MetallicRemappingLevelHigh;
half _MossPower, _MossThreshold, _MossSmoothness;
CBUFFER_END
//uniform  half4 _EnvColor;

// NOTE: Do not ifdef the properties for dots instancing, but ifdef the actual usage.
// Otherwise you might break CPU-side as property constant-buffer offsets change per variant.
// NOTE: Dots instancing is orthogonal to the constant buffer above.
#ifdef UNITY_DOTS_INSTANCING_ENABLED
UNITY_DOTS_INSTANCING_START(MaterialPropertyMetadata)
    UNITY_DOTS_INSTANCED_PROP(float4, _BaseColor)
    UNITY_DOTS_INSTANCED_PROP(float4, _SpecColor)
    UNITY_DOTS_INSTANCED_PROP(float4, _EmissionColor)
    UNITY_DOTS_INSTANCED_PROP(float , _Cutoff)
    UNITY_DOTS_INSTANCED_PROP(float , _Smoothness)
    UNITY_DOTS_INSTANCED_PROP(float , _Metallic)
    UNITY_DOTS_INSTANCED_PROP(float , _BumpScale)
    UNITY_DOTS_INSTANCED_PROP(float , _Parallax)
    UNITY_DOTS_INSTANCED_PROP(float , _OcclusionStrength)
    UNITY_DOTS_INSTANCED_PROP(float , _ClearCoatMask)
    UNITY_DOTS_INSTANCED_PROP(float , _ClearCoatSmoothness)
    UNITY_DOTS_INSTANCED_PROP(float , _DetailAlbedoMapScale)
    UNITY_DOTS_INSTANCED_PROP(float , _DetailNormalMapScale)
    UNITY_DOTS_INSTANCED_PROP(float , _Surface)
UNITY_DOTS_INSTANCING_END(MaterialPropertyMetadata)

#define _BaseColor              UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float4 , Metadata_BaseColor)
#define _SpecColor              UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float4 , Metadata_SpecColor)
#define _EmissionColor          UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float4 , Metadata_EmissionColor)
#define _Cutoff                 UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_Cutoff)
#define _Smoothness             UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_Smoothness)
#define _Metallic               UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_Metallic)
#define _BumpScale              UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_BumpScale)
#define _Parallax               UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_Parallax)
#define _OcclusionStrength      UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_OcclusionStrength)
#define _ClearCoatMask          UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_ClearCoatMask)
#define _ClearCoatSmoothness    UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_ClearCoatSmoothness)
#define _DetailAlbedoMapScale   UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_DetailAlbedoMapScale)
#define _DetailNormalMapScale   UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_DetailNormalMapScale)
#define _Surface                UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_Surface)
#endif

TEXTURE2D(_ParallaxMap);
SAMPLER(sampler_ParallaxMap);
TEXTURE2D(_OcclusionMap);
SAMPLER(sampler_OcclusionMap);
TEXTURE2D(_DetailMask);
SAMPLER(sampler_DetailMask);
TEXTURE2D(_DetailAlbedoMap);
SAMPLER(sampler_DetailAlbedoMap);
TEXTURE2D(_DetailNormalMap);
SAMPLER(sampler_DetailNormalMap);
TEXTURE2D(_MetallicGlossMap);
SAMPLER(sampler_MetallicGlossMap);
TEXTURE2D(_SpecGlossMap);
SAMPLER(sampler_SpecGlossMap);
TEXTURE2D(_ClearCoatMap);
SAMPLER(sampler_ClearCoatMap);
TEXTURE2D(_ThicknessMap);
SAMPLER(sampler_ThicknessMap);
TEXTURE2D(_CasuticsMap);
SAMPLER(sampler_CasuticsMap);


#ifdef _SPECULAR_SETUP
    #define SAMPLE_METALLICSPECULAR(uv) SAMPLE_TEXTURE2D(_SpecGlossMap, sampler_SpecGlossMap, uv)
#else
#define SAMPLE_METALLICSPECULAR(uv) SAMPLE_TEXTURE2D(_MetallicGlossMap, sampler_MetallicGlossMap, uv)
#endif

half4 SampleMetallicSpecGloss(float2 uv, half albedoAlpha)
{
    half4 specGloss;
    specGloss = half4(SAMPLE_METALLICSPECULAR(uv));
    return specGloss;
}

half SampleOcclusion(float2 uv)
{
    #ifdef _OCCLUSIONMAP
    // TODO: Controls things like these by exposing SHADER_QUALITY levels (low, medium, high)
    #if defined(SHADER_API_GLES)
            return SAMPLE_TEXTURE2D(_OcclusionMap, sampler_OcclusionMap, uv).g;
    #else
            half occ = SAMPLE_TEXTURE2D(_OcclusionMap, sampler_OcclusionMap, uv).g;
            return LerpWhiteTo(occ, _OcclusionStrength);
    #endif
    #else
    return half(1.0);
    #endif
}


// uv位移
float2 Panner(float2 uv, float2 offset)
{
    return uv + offset * _Time.yy;
}

half3 SampleCaustics(float2 uv)
{
    float2 causticUV = (uv * _CasuticsTilling) * 0.5;
    float2 uv1 = Panner(causticUV + float2(0.000, 0.000), float2(0.1, 0.1) * _CasuticsSpeed);
    float2 uv2 = Panner(causticUV + float2(0.418, 0.355), float2(-0.1, -0.1) * _CasuticsSpeed);
    float2 uv3 = Panner(causticUV + float2(0.865, 0.148), float2(-0.1, 0.1) * _CasuticsSpeed);
    float2 uv4 = Panner(causticUV + float2(0.651, 0.752), float2(0.1, -0.1) * _CasuticsSpeed);

    float3 sample1 = SAMPLE_TEXTURE2D(_CasuticsMap, sampler_CasuticsMap, uv1).rgb;
    float3 sample2 = SAMPLE_TEXTURE2D(_CasuticsMap, sampler_CasuticsMap, uv2).rgb;
    float3 sample3 = SAMPLE_TEXTURE2D(_CasuticsMap, sampler_CasuticsMap, uv3).rgb;
    float3 sample4 = SAMPLE_TEXTURE2D(_CasuticsMap, sampler_CasuticsMap, uv4).rgb;
    return (sample1 + sample2 + sample3 + sample4) * 0.25;
}


// Returns clear coat parameters
// .x/.r == mask
// .y/.g == smoothness
half2 SampleClearCoat(float2 uv)
{
    #if defined(_CLEARCOAT) || defined(_CLEARCOATMAP)
    half2 clearCoatMaskSmoothness = half2(_ClearCoatMask, _ClearCoatSmoothness);

    #if defined(_CLEARCOATMAP)
    clearCoatMaskSmoothness *= SAMPLE_TEXTURE2D(_ClearCoatMap, sampler_ClearCoatMap, uv).rg;
    #endif

    return clearCoatMaskSmoothness;
    #else
    return half2(0.0, 1.0);
    #endif  // _CLEARCOAT
}

void ApplyPerPixelDisplacement(half3 viewDirTS, inout float2 uv)
{
    #if defined(_PARALLAXMAP)
    uv += ParallaxMapping(TEXTURE2D_ARGS(_ParallaxMap, sampler_ParallaxMap), viewDirTS, _Parallax, uv);
    #endif
}

// Used for scaling detail albedo. Main features:
// - Depending if detailAlbedo brightens or darkens, scale magnifies effect.
// - No effect is applied if detailAlbedo is 0.5.
half3 ScaleDetailAlbedo(half3 detailAlbedo, half scale)
{
    // detailAlbedo = detailAlbedo * 2.0h - 1.0h;
    // detailAlbedo *= _DetailAlbedoMapScale;
    // detailAlbedo = detailAlbedo * 0.5h + 0.5h;
    // return detailAlbedo * 2.0f;

    // A bit more optimized
    return half(2.0) * detailAlbedo * scale - scale + half(1.0);
}

half3 ApplyDetailAlbedo(float2 detailUv, half3 albedo, half detailMask)
{
    #if defined(_DETAIL)
    half3 detailAlbedo = SAMPLE_TEXTURE2D(_DetailAlbedoMap, sampler_DetailAlbedoMap, detailUv).rgb;

    // In order to have same performance as builtin, we do scaling only if scale is not 1.0 (Scaled version has 6 additional instructions)
    #if defined(_DETAIL_SCALED)
    detailAlbedo = ScaleDetailAlbedo(detailAlbedo, _DetailAlbedoMapScale);
    #else
    detailAlbedo = half(2.0) * detailAlbedo;
    #endif

    return albedo * LerpWhiteTo(detailAlbedo, detailMask);
    #else
    return albedo;
    #endif
}

half3 ApplyDetailNormal(float2 detailUv, half3 normalTS, half detailMask)
{
    #if defined(_DETAIL)
    #if BUMP_SCALE_NOT_SUPPORTED
    half3 detailNormalTS = UnpackNormal(SAMPLE_TEXTURE2D(_DetailNormalMap, sampler_DetailNormalMap, detailUv));
    #else
    half3 detailNormalTS = UnpackNormalScale(SAMPLE_TEXTURE2D(_DetailNormalMap, sampler_DetailNormalMap, detailUv), _DetailNormalMapScale);
    #endif

    // With UNITY_NO_DXT5nm unpacked vector is not normalized for BlendNormalRNM
    // For visual consistancy we going to do in all cases
    detailNormalTS = normalize(detailNormalTS);

    return lerp(normalTS, BlendNormalRNM(normalTS, detailNormalTS), detailMask); // todo: detailMask should lerp the angle of the quaternion rotation, not the normals
    #else
    return normalTS;
    #endif
}

inline void InitializeStandardLitSurfaceData(float4 uv, float3 normalWS, half4 tangentWS, half4 color, out POP_SurfaceData outSurfaceData)
{
    //UNITY_INITIALIZE_OUTPUT(POP_SurfaceData, outSurfaceData);
    half4 albedoAlpha = SampleAlbedoAlpha(uv.xy, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap));
    outSurfaceData.alpha = Alpha(albedoAlpha.a, _BaseColor, _Cutoff);
    
    half4 specGloss = SampleMetallicSpecGloss(uv.xy, albedoAlpha.a);

    #ifdef _USE_ALBEDO_ON
    outSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb + specGloss.a * _EmissionColor.rgb * _EmissionIntensity * albedoAlpha.rgb;
    outSurfaceData.emission = 0;
    #else
    outSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;
    outSurfaceData.emission = specGloss.a * _EmissionColor.rgb * _EmissionIntensity;
    #endif
    
    half f_smoothness = (_SmoothnessRemappingLevelHigh - _SmoothnessRemappingLevelLow)/(_SmoothnessRemappingHigh - _SmoothnessRemappingLow);
    half f_metallic = (_MetallicRemappingLevelHigh - _MetallicRemappingLevelLow)/(_MetallicRemappingHigh - _MetallicRemappingLow);
    half remappingMetallic = (specGloss.r - _MetallicRemappingLow) * f_metallic;
    remappingMetallic = clamp(remappingMetallic, 0, 1);
    half remappingSmoothness = (specGloss.g - _SmoothnessRemappingLow) * f_smoothness;
    remappingSmoothness = clamp(remappingSmoothness, 0, 1);
    
    outSurfaceData.metallic = remappingMetallic;
    outSurfaceData.smoothness = remappingSmoothness;
    outSurfaceData.specular = half3(0.0, 0.0, 0.0);
    //outSurfaceData.normalTS = SampleNormal(uv, TEXTURE2D_ARGS(_BumpMap, sampler_BumpMap), _BumpScale);
    outSurfaceData.normalTS = UnpackNormal(SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, uv.xy));
    outSurfaceData.occlusion = LerpWhiteTo(specGloss.b, _OcclusionStrength);
    outSurfaceData.thickness = 0;
    #if defined(_MOSS)
    float sgn = tangentWS.w; // should be either +1 or -1
    float3 bitangent = sgn * cross(normalWS.xyz, tangentWS.xyz);
    half3x3 tangentToWorld = half3x3(tangentWS.xyz, bitangent.xyz, normalWS.xyz);
    half3 moss_normalWS = TransformTangentToWorld(outSurfaceData.normalTS, tangentToWorld);
    //half mossPower = 0.001 + _MossThreshold * 0.999;
    //half mossMask = saturate(pow(dot(saturate(moss_normalWS), float3(0,1,0)) + _MossPower, mossPower));
    #ifdef  _PAINT_ON
    half mossMask = color.r;
    #else
    half SnowThreshold = dot(moss_normalWS, float3(0, 1, 0)) - lerp(1, -1, _MossThreshold);
    half mossMask = saturate(SnowThreshold / _MossPower);
    #endif
    outSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;
    float2 mossUv = uv * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
    half3 detailAlbedo = SAMPLE_TEXTURE2D(_DetailAlbedoMap, sampler_DetailAlbedoMap, mossUv).rgb;
    outSurfaceData.albedo =  detailAlbedo * mossMask + outSurfaceData.albedo * (1 - mossMask);
    half3 detailNormalTS = UnpackNormal(SAMPLE_TEXTURE2D(_DetailNormalMap, sampler_DetailNormalMap, mossUv));
    detailNormalTS = normalize(detailNormalTS);
    outSurfaceData.normalTS = lerp(outSurfaceData.normalTS, BlendNormalRNM(outSurfaceData.normalTS, detailNormalTS), mossMask);
    outSurfaceData.smoothness = _MossSmoothness * mossMask + outSurfaceData.smoothness * (1 - mossMask);
    #else
    #endif


    #ifdef CAUSTICS_ON
    half3 cuastics = SampleCaustics(uv.zw);
    outSurfaceData.albedo += cuastics;
    #endif

    #if defined(_CLEARCOAT) || defined(_CLEARCOATMAP)
    half2 clearCoat = SampleClearCoat(uv);
    outSurfaceData.clearCoatMask       = clearCoat.r;
    outSurfaceData.clearCoatSmoothness = clearCoat.g;
    #else
    outSurfaceData.clearCoatMask = half(0.0);
    outSurfaceData.clearCoatSmoothness = half(0.0);
    #endif

    #if defined(_DETAIL)
    half detailMask = SAMPLE_TEXTURE2D(_DetailMask, sampler_DetailMask, uv).a;
    float2 detailUv = uv * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
    outSurfaceData.albedo = ApplyDetailAlbedo(detailUv, outSurfaceData.albedo, detailMask);
    outSurfaceData.normalTS = ApplyDetailNormal(detailUv, outSurfaceData.normalTS, detailMask);
    #endif

    #if defined(_SSS)
    outSurfaceData.thickness = SAMPLE_TEXTURE2D(_ThicknessMap, sampler_ThicknessMap, uv).r;
    #endif
}

#endif // UNIVERSAL_INPUT_SURFACE_PBR_INCLUDED
