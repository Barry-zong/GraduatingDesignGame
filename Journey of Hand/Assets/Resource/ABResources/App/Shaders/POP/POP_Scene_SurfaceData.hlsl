#ifndef UNIVERSAL_POP_SCENE_SURFACE_DATA_INCLUDED
#define UNIVERSAL_POP_SCENE_SURFACE_DATA_INCLUDED

struct POP_SurfaceData
{
    half3 albedo;
    half3 specular;
    half  metallic;
    half  smoothness;
    half3 normalTS;
    half3 emission;
    half  occlusion;
    half  alpha;
    half  clearCoatMask;
    half  clearCoatSmoothness;
    half thickness;
};

#endif
