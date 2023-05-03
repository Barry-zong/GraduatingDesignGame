#ifndef UNIVERSAL_POP_SCENE_LIT_META_PASS_INCLUDED
#define UNIVERSAL_POP_SCENE_LIT_META_PASS_INCLUDED

#include "POP_Scene_UniversalMetaPass.hlsl"

half4 UniversalFragmentMetaLit(Varyings input) : SV_Target
{
    POP_SurfaceData surfaceData;
    InitializeStandardLitSurfaceData(half4(input.uv, 0, 0), float3(0, 0, 0), half4(0, 0, 0, 0), half4(0, 0, 0, 0), surfaceData);

    BRDFData brdfData;
    InitializeBRDFData(surfaceData.albedo, surfaceData.metallic, surfaceData.specular, surfaceData.smoothness, surfaceData.alpha, brdfData);

    MetaInput metaInput;
    metaInput.Albedo = brdfData.diffuse + brdfData.specular * brdfData.roughness * 0.5;
    metaInput.Emission = surfaceData.emission;
    return UniversalFragmentMeta(input, metaInput);
}
#endif
