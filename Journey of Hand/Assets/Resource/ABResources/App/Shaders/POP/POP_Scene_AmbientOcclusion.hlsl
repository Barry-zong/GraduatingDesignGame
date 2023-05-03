#ifndef AMBIENT_POP_SCENE_OCCLUSION_INCLUDED
#define AMBIENT_POP_SCENE_OCCLUSION_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "POP_Scene_SurfaceData.hlsl"

// Ambient occlusion
TEXTURE2D_X(_ScreenSpaceOcclusionTexture);
SAMPLER(sampler_ScreenSpaceOcclusionTexture);

struct POPAmbientOcclusionFactor
{
    half indirectAmbientOcclusion;
    half directAmbientOcclusion;
};

half SampleAmbientOcclusion(float2 normalizedScreenSpaceUV)
{
    float2 uv = UnityStereoTransformScreenSpaceTex(normalizedScreenSpaceUV);
    return half(SAMPLE_TEXTURE2D_X(_ScreenSpaceOcclusionTexture, sampler_ScreenSpaceOcclusionTexture, uv).x);
}

POPAmbientOcclusionFactor GetScreenSpaceAmbientOcclusion(float2 normalizedScreenSpaceUV)
{
    POPAmbientOcclusionFactor aoFactor;

    #if defined(_SCREEN_SPACE_OCCLUSION) && !defined(_SURFACE_TYPE_TRANSPARENT)
    float ssao = SampleAmbientOcclusion(normalizedScreenSpaceUV);

    aoFactor.indirectAmbientOcclusion = ssao;
    aoFactor.directAmbientOcclusion = lerp(half(1.0), ssao, _AmbientOcclusionParam.w);
    #else
    aoFactor.directAmbientOcclusion = 1;
    aoFactor.indirectAmbientOcclusion = 1;
    #endif

    #if defined(DEBUG_DISPLAY)
    switch(_DebugLightingMode)
    {
        case DEBUGLIGHTINGMODE_LIGHTING_WITHOUT_NORMAL_MAPS:
            aoFactor.directAmbientOcclusion = 0.5;
            aoFactor.indirectAmbientOcclusion = 0.5;
            break;

        case DEBUGLIGHTINGMODE_LIGHTING_WITH_NORMAL_MAPS:
            aoFactor.directAmbientOcclusion *= 0.5;
            aoFactor.indirectAmbientOcclusion *= 0.5;
            break;
    }
    #endif

    return aoFactor;
}

POPAmbientOcclusionFactor CreateAmbientOcclusionFactor(float2 normalizedScreenSpaceUV, half occlusion)
{
    POPAmbientOcclusionFactor aoFactor = GetScreenSpaceAmbientOcclusion(normalizedScreenSpaceUV);

    aoFactor.indirectAmbientOcclusion = min(aoFactor.indirectAmbientOcclusion, occlusion);
    return aoFactor;
}

POPAmbientOcclusionFactor CreateAmbientOcclusionFactor(InputData inputData, POP_SurfaceData surfaceData)
{
    return CreateAmbientOcclusionFactor(inputData.normalizedScreenSpaceUV, surfaceData.occlusion);
}

#endif
