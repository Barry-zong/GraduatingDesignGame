Shader "Universal Render Pipeline/POP/SIM/Scene/Scene Lit Leaf VertexAnimation"
{
    Properties
    {
        // Specular vs Metallic workflow
        //_WorkflowMode("WorkflowMode", Float) = 1.0

        [MainTexture] _BaseMap("Albedo", 2D) = "white" {}
        [MainColor] _BaseColor("Color", Color) = (1,1,1,1)
        //        _GrassDarkColor("GrassDarkColor", Color) = (1,1,1,1)
        //        _MaskColor("MaskColor", Color) = (1,1,1,1)
        //        _PatternRepeat("PatternRepeat", Range(0, 2)) = 0.5
        //        _PatternMaskRepeat("PatternMaskRepeat", Range(0, 1)) = 0.5
        //        _PatternMaskIntensity("PatternMaskIntensity", Range(0, 0.99)) = 0.5

        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

        //_Smoothness("Smoothness", Range(0.0, 1.0)) = 0.5
        // _SmoothnessTextureChannel("Smoothness texture channel", Float) = 0

        // _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        _MetallicGlossMap("MetallicGlossMap", 2D) = "white" {}


        //_SpecColor("Specular", Color) = (0.2, 0.2, 0.2)
        //_SpecGlossMap("Specular", 2D) = "white" {}

        //[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        //[ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0

        //_BumpScale("Scale", Float) = 1.0
        _BumpMap("Normal Map", 2D) = "bump" {}

        //_Parallax("Scale", Range(0.005, 0.08)) = 0.005
        //_ParallaxMap("Height Map", 2D) = "black" {}

        _OcclusionStrength("OcclusionStrength", Range(0.0, 1.0)) = 1.0
        //_OcclusionMap("Occlusion", 2D) = "white" {}

        [HDR] _EmissionColor("EmissionfColor", Color) = (0,0,0)

        //        [Space(18)]
        //        _GrassMap("GrassMap", 2D) = "white" {}
        //        _GrassShadowMap("GrassShadowMap", 2D) = "white" {}
        //        _WindSpeed("_WindSpeed", Range(0,0.2)) = 1
        //        _WindColor("WindColor", Color) = (1, 1, 1, 1)
        //        _WindMap("WindMap", 2D) = "white" {}
        //        _WindIntensity("_WindIntensity", Range(0, 5)) = 2
        //        _WindRepeat("_WindRepeat", Range(0,0.1)) = 1
        //        _GrassRepeat("_GrassRepeat", Range(0,1)) = 1
        //        _GrassShadowRepeat("_GrassShadowRepeat", Range(0,1)) = 1

        [Space(18)]
        [BCategory(Settings)]_SETTINGS("[ SETTINGS ]", Float) = 0
        [HideInInspector]_MotionNoise("Motion Noise", Float) = 1
        _GlobalTurbulence("Global Turbulence", Range( 0 , 1)) = 1
        [BCategory(Grass Motion)]_MOTIONGRASS("[ MOTION GRASS ]", Float) = 0
        _MotionAmplitude("Leaf Motion Amplitude", Range(0, 1)) = 0
        _MotionSpeed("Leaf Motion Speed", Range(0, 20)) = 0
        _MotionScale("Leaf Motion Scale", Range(0, 20)) = 0
        _MotionVariation("Leaf Motion Variation", Range(0, 1)) = 0
        //        [BCategory(Leaf Motion)]_LEAFMOTIONN("[ LEAF MOTIONN ]", Float) = 0
        //		_MotionAmplitude3("Leaf Flutter Amplitude", Float) = 0
        //		_MotionSpeed3("Leaf Flutter Speed", Float) = 0
        //		_MotionScale3("Leaf Flutter Scale", Float) = 0
        //        [BCategory(Interactive Motion)]_INTERACTIVEMOTIONN("[ INTERACTIVE MOTIONN ]", Float) = 0
        //		_PushRadius("Push Radius", Range(0, 10)) = 0
        //		_PushStrength("Push Strength", Range(0, 10)) = 0
        //        _RolePosAdjust("Role Pos Adjust", Range(0, 10)) = 0

        [HideInInspector]_Internal_ADS("Internal_ADS", Float) = 1
        //[HideInInspector]_MetallicGlossMap("_MetallicGlossMap", 2D) = "white" {}
        [HideInInspector]_MainUVs("_MainUVs", Vector) = (1,1,0,0)
        //[HideInInspector]_BumpMap("_BumpMap", 2D) = "white" {}
        //[HideInInspector]_MainTex("_MainTex", 2D) = "white" {}
        [HideInInspector]_CullMode("_CullMode", Float) = 0
        [HideInInspector]_Glossiness("_Glossiness", Float) = 0
        [HideInInspector]_Mode("_Mode", Float) = 0
        //[HideInInspector]_BumpScale("_BumpScale", Float) = 0
        [HideInInspector]_Internal_UnityToBoxophobic("_Internal_UnityToBoxophobic", Float) = 0
        [HideInInspector]_Internal_LitSimple("Internal_LitSimple", Float) = 1
        [HideInInspector]_Internal_TypeGrass("Internal_TypeGrass", Float) = 1
        [HideInInspector]_Internal_DebugMask("Internal_DebugMask", Float) = 1
        [HideInInspector]_Internal_DebugVariation("Internal_DebugVariation", Float) = 1
        [HideInInspector] _texcoord( "", 2D ) = "white" {}
        [HideInInspector] __dirty( "", Int ) = 1

        // _EmissionMap("Emission", 2D) = "white" {}

        //_DetailMask("Detail Mask", 2D) = "white" {}
        //_DetailAlbedoMapScale("Scale", Range(0.0, 2.0)) = 1.0
        //_DetailAlbedoMap("Detail Albedo x2", 2D) = "linearGrey" {}
        //_DetailNormalMapScale("Scale", Range(0.0, 2.0)) = 1.0
        //[Normal] _DetailNormalMap("Normal Map", 2D) = "bump" {}

        // SRP batching compatibility for Clear Coat (Not used in Lit)
        //[HideInInspector] _ClearCoatMask("_ClearCoatMask", Float) = 0.0
        //[HideInInspector] _ClearCoatSmoothness("_ClearCoatSmoothness", Float) = 0.0

        // Blending state
        //_Surface("__surface", Float) = 0.0
        //_Blend("__blend", Float) = 0.0
        //_Cull("__cull", Float) = 2.0
        //[ToggleUI] _AlphaClip("__clip", Float) = 0.0
        //[HideInInspector] _SrcBlend("__src", Float) = 1.0
        //[HideInInspector] _DstBlend("__dst", Float) = 0.0
        //[HideInInspector] _ZWrite("__zw", Float) = 1.0

        //[ToggleUI] _ReceiveShadows("Receive Shadows", Float) = 1.0
        // Editmode props
        _QueueOffset("Queue offset", Float) = 0.0

        // ObsoleteProperties
        //        [HideInInspector] _MainTex("BaseMap", 2D) = "white" {}
        //        [HideInInspector] _Color("Base Color", Color) = (1, 1, 1, 1)
        //        [HideInInspector] _GlossMapScale("Smoothness", Float) = 0.0
        //        [HideInInspector] _Glossiness("Smoothness", Float) = 0.0
        //        [HideInInspector] _GlossyReflections("EnvironmentReflections", Float) = 0.0
        //
        //        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        //        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        //        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
        [HideInInspector]_SHAr ("First Order Harmonic_SHAr", Vector) = (0.1410518,0.1996599,-0.1916448,0.4627451)
        [HideInInspector]_SHAg ("First Order Harmonic_SHAg", Vector) = (0.1914412,0.3132915,-0.251553,0.5294118)
        [HideInInspector]_SHAb ("First Order Harmonic_SHAb", Vector) = (0.2108869,0.4276009,-0.2584893,0.5372549)

        [HideInInspector]_SHBr ("Second Order Harmonic_SHBr", Vector) = (0.04257296,-0.1443495,0.1463619,0.0)
        [HideInInspector]_SHBg ("Second Order Harmonic_SHBg", Vector) = (0.06174606,-0.1617367,0.1746086,0.0)
        [HideInInspector]_SHBb ("Second Order Harmonic_SHBb", Vector) = (0.07339491,-0.1538019,0.173522,0.0)

        [HideInInspector]_SHC ("Third OrderHarmonic_SHC", Vector) = (0.06419951,0.06835041,0.05078474,1.0)

        [Space(18)]
        _Transparency ("Transparency", Range(0, 1)) = 1.0
    }

    SubShader
    {
        // Universal Pipeline tag is required. If Universal render pipeline is not set in the graphics settings
        // this Subshader will fail. One can add a subshader below or fallback to Standard built-in to make this
        // material work with both Universal Render Pipeline and Builtin Unity Pipeline
        //Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "Lit" "IgnoreProjector" = "True" "ShaderModel"="3.0"}
        Tags
        {
            "Queue"="AlphaTest" "RenderType" = "TransparentCutout" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "Lit" "IgnoreProjector" = "True" "ShaderModel"="3.0"
        }
        LOD 300

        // ------------------------------------------------------------------
        //  Forward pass. Shades all light in a single pass. GI + emission + Fog
        Pass
        {
            // Lightmode matches the ShaderPassName set in UniversalRenderPipeline.cs. SRPDefaultUnlit and passes with
            // no LightMode tag are also rendered by Universal Render Pipeline
            Name "ForwardLit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            //#pragma exclude_renderers gles gles3 glcore
            #pragma target 3.0
            // -------------------------------------
            // Material Keywords
            // #pragma shader_feature_local _NORMALMAP
            // #pragma shader_feature_local _PARALLAXMAP
            // #pragma shader_feature_local _RECEIVE_SHADOWS_OFF
            // #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED
            // #pragma shader_feature_local_fragment _SURFACE_TYPE_TRANSPARENT
            // #pragma shader_feature_local_fragment _ALPHATEST_ON
            // #pragma shader_feature_local_fragment _ALPHAPREMULTIPLY_ON
            // #pragma shader_feature_local_fragment _EMISSION
            // #pragma shader_feature_local_fragment _METALLICSPECGLOSSMAP
            // #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // #pragma shader_feature_local_fragment _OCCLUSIONMAP
            // #pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
            // #pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
            // #pragma shader_feature_local_fragment _SPECULAR_SETUP

            // -------------------------------------
            // Universal Pipeline keywords
            // #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            // #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            // #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            // #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            // #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            // #pragma multi_compile_fragment _ _SHADOWS_SOFT
            // #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            // #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            // #pragma multi_compile_fragment _ _LIGHT_LAYERS
            // #pragma multi_compile_fragment _ _LIGHT_COOKIES
            // #pragma multi_compile _ _CLUSTERED_RENDERING
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS

            // -------------------------------------
            // Unity defined keywords
            // #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            // #pragma multi_compile _ SHADOWS_SHADOWMASK
            // #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            // #pragma multi_compile _ LIGHTMAP_ON
            // #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            // #pragma multi_compile_fog
            // #pragma multi_compile_fragment _ DEBUG_DISPLAY

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #pragma vertex LitPassVertex
            #pragma fragment LitPassFragment


            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD2;
                // float2 staticLightmapUV   : TEXCOORD1;
                // float2 dynamicLightmapUV  : TEXCOORD2;
                float4 color : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float2 uv : TEXCOORD0;

                #if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
                float3 positionWS : TEXCOORD1;
                #endif

                half3 normalWS : TEXCOORD2;
                half4 tangentWS : TEXCOORD3; // xyz: tangent, w: sign
                float3 viewDirWS : TEXCOORD4;

                #ifdef _ADDITIONAL_LIGHTS_VERTEX
                half4 fogFactorAndVertexLight   : TEXCOORD5; // x: fogFactor, yzw: vertex light
                #else
                half fogFactor : TEXCOORD5;
                #endif

                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                float4 shadowCoord              : TEXCOORD6;
                #endif

                #if defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR)
                half3 viewDirTS                 : TEXCOORD7;
                #endif

                //ECLARE_LIGHTMAP_OR_SH(staticLightmapUV, vertexSH, 8);
                half3 vertexSH : TEXCOORD8;
                float2 uv1 : TEXCOORD9;
                float4 positionCS : SV_POSITION;
                float4 color : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
            sampler2D ADS_TurbulenceTex;
            sampler2D ADS_GlobalTex;
            float4 _BaseMap_ST;
            float4 _DetailAlbedoMap_ST;
            half4 _BaseColor, _MaskColor, _WindColor, _GrassDarkColor;
            half4 _EmissionColor;
            half _Cutoff;
            half _OcclusionStrength;
            half _PatternRepeat, _PatternMaskRepeat, _PatternMaskIntensity;
            half _Metallic, _Smoothness;
            half _WindRepeat, _GrassRepeat, _WindSpeed, _WindIntensity, _GrassShadowRepeat;
            half _MotionScale, _MotionSpeed, _MotionVariation, _MotionAmplitude3, _MotionAmplitude, _MotionSpeed3,
                 _MotionScale3, _GlobalSize, _GlobalTurbulence;

            half _Internal_ADS, _Internal_UnityToBoxophobic;
            half _Transparency;
            CBUFFER_END
            half ADS_GlobalScale, ADS_GlobalSpeed, ADS_TurbulenceSpeed, ADS_TurbulenceScale, ADS_GlobalSizeMax,
                 ADS_GlobalSizeMin, ADS_TurbulenceContrast, ADS_GlobalAmplitude;
            half3 ADS_GlobalDirection;

            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(float, _ShakeMotionAmplitude)
            UNITY_DEFINE_INSTANCED_PROP(float, _ShakeMotionSpeed)
            UNITY_INSTANCING_BUFFER_END(Props)

            uniform  half4 _EnvColor;
            uniform float _GIIntensity;
			uniform float _GIContrast;


            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);
            TEXTURE2D(_BumpMap);
            SAMPLER(sampler_BumpMap);
            TEXTURE2D(_EmissionMap);
            SAMPLER(sampler_EmissionMap);
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
            TEXTURE2D(_WindMap);
            SAMPLER(sampler_WindMap);
            TEXTURE2D(_GrassMap);
            SAMPLER(sampler_GrassMap);
            TEXTURE2D(_GrassShadowMap);
            SAMPLER(sampler_GrassShadowMap);
            // TEXTURE2D(ADS_TurbulenceTex);     SAMPLER(sampler_ADS_TurbulenceTex);
            // SAMPLER(sampler_ADS_TurbulenceTex);


            real4 _SHAr;
            real4 _SHAg;
            real4 _SHAb;
            real4 _SHBr;
            real4 _SHBg;
            real4 _SHBb;
            real4 _SHC;


            half3 SampleSHPixel_SIM(half3 L2Term, half3 normalWS)
            {
                half3 res = SHEvalLinearL0L1(normalWS, unity_SHAr, unity_SHAg, unity_SHAb);
                //half3 res = SHEvalLinearL0L1(normalWS, _SHAr, _SHAg, _SHAb);
                return max(half3(0, 0, 0), res);
            }

            inline void InitializeStandardLitSurfaceData_SIM(float2 uv, float4 color, out SurfaceData outSurfaceData,
                                                             float3 worldPos)
            {
                half4 albedoAlpha = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv);
                outSurfaceData.alpha = 1;
                clip(albedoAlpha.a - _Cutoff);
                half4 specGloss = SAMPLE_TEXTURE2D(_MetallicGlossMap, sampler_MetallicGlossMap, uv);
                outSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;
                outSurfaceData.metallic = specGloss.r;
                outSurfaceData.specular = half3(0.0, 0.0, 0.0);
                outSurfaceData.smoothness = _Smoothness;
                outSurfaceData.normalTS = UnpackNormal(SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, uv));
                outSurfaceData.occlusion = LerpWhiteTo(specGloss.b, _OcclusionStrength);
                outSurfaceData.emission = specGloss.a * _EmissionColor.rgb;
                outSurfaceData.clearCoatMask = half(0.0);
                outSurfaceData.clearCoatSmoothness = half(0.0);
            }

            void InitializeInputData_SIM(Varyings input, half3 normalTS, out InputData inputData)
            {
                
                inputData = (InputData)0;
                inputData.positionWS = input.positionWS;
                half3 viewDirWS = GetWorldSpaceNormalizeViewDir(input.positionWS);
                float sgn = input.tangentWS.w; // should be either +1 or -1
                float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
                inputData.tangentToWorld = tangentToWorld;
                inputData.normalWS = TransformTangentToWorld(normalTS, tangentToWorld);
                //inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
                //inputData.normalWS = SafeNormalize(inputData.normalWS);
                inputData.viewDirectionWS = viewDirWS;
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                    inputData.shadowCoord = input.shadowCoord;
                #elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
                    inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
                #else
                inputData.shadowCoord = float4(0, 0, 0, 0);
                #endif
                #ifdef _ADDITIONAL_LIGHTS_VERTEX
                    inputData.fogCoord = InitializeInputDataFog(float4(input.positionWS, 1.0), input.fogFactorAndVertexLight.x);
                    inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
                #else
                inputData.fogCoord = InitializeInputDataFog(float4(input.positionWS, 1.0), input.fogFactor);
                #endif
                inputData.bakedGI = SampleSHPixel_SIM(input.vertexSH, inputData.normalWS);
                inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
                //inputData.shadowMask = SAMPLE_SHADOWMASK(input.staticLightmapUV);
            }


            void InitializeBRDFDataDirect_SIM(half3 albedo, half3 diffuse, half3 specular, half reflectivity,
                                              half oneMinusReflectivity, half smoothness, inout half alpha,
                                              out BRDFData outBRDFData)
            {
                outBRDFData = (BRDFData)0;
                outBRDFData.albedo = albedo;
                outBRDFData.diffuse = diffuse;
                outBRDFData.specular = specular;
                outBRDFData.reflectivity = reflectivity;

                outBRDFData.perceptualRoughness = PerceptualSmoothnessToPerceptualRoughness(smoothness);
                outBRDFData.roughness = max(PerceptualRoughnessToRoughness(outBRDFData.perceptualRoughness),
                                            HALF_MIN_SQRT);
                outBRDFData.roughness2 = max(outBRDFData.roughness * outBRDFData.roughness, HALF_MIN);
                outBRDFData.grazingTerm = saturate(smoothness + reflectivity);
                outBRDFData.normalizationTerm = outBRDFData.roughness * half(4.0) + half(2.0);
                outBRDFData.roughness2MinusOne = outBRDFData.roughness2 - half(1.0);
            }

            void InitializeBRDFData_SIM(half3 albedo, half metallic, half3 specular, half smoothness, inout half alpha,
                                        out BRDFData outBRDFData)
            {
                half oneMinusReflectivity = OneMinusReflectivityMetallic(metallic);
                half reflectivity = half(1.0) - oneMinusReflectivity;
                half3 brdfDiffuse = albedo * oneMinusReflectivity;
                half3 brdfSpecular = lerp(kDieletricSpec.rgb, albedo, metallic);
                InitializeBRDFDataDirect_SIM(albedo, brdfDiffuse, brdfSpecular, reflectivity, oneMinusReflectivity,
                                             smoothness, alpha, outBRDFData);
            }

            half3 GlossyEnvironmentReflection_SIM(half3 reflectVector, float3 positionWS, half perceptualRoughness,
                                                  half occlusion)
            {
                half3 irradiance;

                #ifdef _REFLECTION_PROBE_BLENDING
                    irradiance = CalculateIrradianceFromReflectionProbes(reflectVector, positionWS, perceptualRoughness);
                #else
                #ifdef _REFLECTION_PROBE_BOX_PROJECTION
                    reflectVector = BoxProjectedCubemapDirection(reflectVector, positionWS, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
                #endif // _REFLECTION_PROBE_BOX_PROJECTION
                half mip = PerceptualRoughnessToMipmapLevel(perceptualRoughness);
                half4 encodedIrradiance = half4(
                    SAMPLE_TEXTURECUBE_LOD(unity_SpecCube0, samplerunity_SpecCube0, reflectVector, mip));

                #if defined(UNITY_USE_NATIVE_HDR)
                    irradiance = encodedIrradiance.rgb;
                #else
                irradiance = DecodeHDREnvironment(encodedIrradiance, unity_SpecCube0_HDR);
                #endif // UNITY_USE_NATIVE_HDR
                #endif // _REFLECTION_PROBE_BLENDING
                return irradiance * occlusion;
            }

            // Computes the specular term for EnvironmentBRDF
            half3 EnvironmentBRDFSpecular_SIM(BRDFData brdfData, half fresnelTerm)
            {
                float surfaceReduction = 1.0 / (brdfData.roughness2 + 1.0);
                return half3(surfaceReduction * lerp(brdfData.specular, brdfData.grazingTerm, fresnelTerm));
            }

            half3 EnvironmentBRDF_SIM(BRDFData brdfData, half3 indirectDiffuse, half3 indirectSpecular,
                                      half fresnelTerm)
            {
                half3 c = indirectDiffuse * brdfData.diffuse;
                c += indirectSpecular * EnvironmentBRDFSpecular_SIM(brdfData, fresnelTerm);
                return c;
            }

            // Computes the scalar specular term for Minimalist CookTorrance BRDF
            // NOTE: needs to be multiplied with reflectance f0, i.e. specular color to complete
            half DirectBRDFSpecular_SIM(BRDFData brdfData, half3 normalWS, half3 lightDirectionWS,
                                        half3 viewDirectionWS)
            {
                float3 lightDirectionWSFloat3 = float3(lightDirectionWS);
                float3 halfDir = SafeNormalize(lightDirectionWSFloat3 + float3(viewDirectionWS));

                float NoH = saturate(dot(float3(normalWS), halfDir));
                half LoH = half(saturate(dot(lightDirectionWSFloat3, halfDir)));

                // GGX Distribution multiplied by combined approximation of Visibility and Fresnel
                // BRDFspec = (D * V * F) / 4.0
                // D = roughness^2 / ( NoH^2 * (roughness^2 - 1) + 1 )^2
                // V * F = 1.0 / ( LoH^2 * (roughness + 0.5) )
                // See "Optimizing PBR for Mobile" from Siggraph 2015 moving mobile graphics course
                // https://community.arm.com/events/1155

                // Final BRDFspec = roughness^2 / ( NoH^2 * (roughness^2 - 1) + 1 )^2 * (LoH^2 * (roughness + 0.5) * 4.0)
                // We further optimize a few light invariant terms
                // brdfData.normalizationTerm = (roughness + 0.5) * 4.0 rewritten as roughness * 4.0 + 2.0 to a fit a MAD.
                float d = NoH * NoH * brdfData.roughness2MinusOne + 1.00001f;
                half d2 = half(d * d);

                half LoH2 = LoH * LoH;
                half specularTerm = brdfData.roughness2 / (d2 * max(half(0.1), LoH2) * brdfData.normalizationTerm);

                // On platforms where half actually means something, the denominator has a risk of overflow
                // clamp below was added specifically to "fix" that, but dx compiler (we convert bytecode to metal/gles)
                // sees that specularTerm have only non-negative terms, so it skips max(0,..) in clamp (leaving only min(100,...))
                #if defined (SHADER_API_MOBILE) || defined (SHADER_API_SWITCH)
                specularTerm = specularTerm - HALF_MIN;
                specularTerm = clamp(specularTerm, 0.0, 100.0); // Prevent FP16 overflow on mobiles
                #endif

                return specularTerm;
            }


            half3 GlobalIllumination_SIM(BRDFData brdfData, half3 bakedGI, half occlusion, float3 positionWS,
                                         half3 normalWS, half3 viewDirectionWS)
            {
                half3 reflectVector = reflect(-viewDirectionWS, normalWS);
                half NoV = saturate(dot(normalWS, viewDirectionWS));
                half fresnelTerm = Pow4(1.0 - NoV);
                half3 indirectDiffuse = bakedGI;
                half3 indirectSpecular = GlossyEnvironmentReflection_SIM(
                    reflectVector, positionWS, brdfData.perceptualRoughness, 1.0h);
                half3 color = EnvironmentBRDF_SIM(brdfData, indirectDiffuse, indirectSpecular, fresnelTerm);
                return color * occlusion;
            }

            half3 LightingPhysicallyBased_SIM(BRDFData brdfData, half3 lightColor, half3 lightDirectionWS,
                                              half lightAttenuation, half3 normalWS, half3 viewDirectionWS)
            {
                half NdotL = saturate(dot(normalWS, lightDirectionWS));
                half3 radiance = lightColor * (lightAttenuation * NdotL);

                half3 brdf = brdfData.diffuse;
                brdf += brdfData.specular * DirectBRDFSpecular_SIM(brdfData, normalWS, lightDirectionWS,
                                                                   viewDirectionWS);
                return brdf * radiance;
            }

            half3 CalculateLambert_SIM(Light light, InputData inputData, SurfaceData surfaceData)
            {
                half3 attenuatedLightColor = light.color * (light.distanceAttenuation * light.shadowAttenuation);
                half3 lightColor = LightingLambert(attenuatedLightColor, light.direction, inputData.normalWS);
                lightColor *= surfaceData.albedo;
                return lightColor;
            }


            half4 UniversalFragmentLambert_SIM(InputData inputData, SurfaceData surfaceData)
            {
                // #if defined(_SPECULARHIGHLIGHTS_OFF)
                //     bool specularHighlightsOff = true;
                // #else
                //     bool specularHighlightsOff = false;
                // #endif
                BRDFData brdfData;


                //InitializeBRDFData(surfaceData, brdfData);
                InitializeBRDFData_SIM(surfaceData.albedo, surfaceData.metallic, surfaceData.specular,
                                       surfaceData.smoothness, surfaceData.alpha, brdfData);
                // Clear-coat calculation...
                //BRDFData brdfDataClearCoat = CreateClearCoatBRDFData(surfaceData, brdfData);
                half4 shadowMask = CalculateShadowMask(inputData);
                AmbientOcclusionFactor aoFactor = CreateAmbientOcclusionFactor(inputData, surfaceData);
                // uint meshRenderingLayers = GetMeshRenderingLightLayer();
                Light mainLight = GetMainLight(inputData, shadowMask, aoFactor);
                MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI);
                inputData.bakedGI = lerp(half3(0.5, 0.5, 0.5), inputData.bakedGI, _GIContrast) * _GIIntensity * _EnvColor;
                inputData.bakedGI *= surfaceData.albedo;
                LightingData lightingData = CreateLightingData(inputData, surfaceData);
                lightingData.mainLightColor += CalculateLambert_SIM(mainLight, inputData, surfaceData);
                /*lightingData.giColor = GlobalIllumination_SIM(brdfData,inputData.bakedGI, aoFactor.indirectAmbientOcclusion, inputData.positionWS,
                inputData.normalWS, inputData.viewDirectionWS);
                lightingData.mainLightColor = LightingPhysicallyBased_SIM(brdfData, mainLight.color, mainLight.direction,
                                    mainLight.distanceAttenuation * mainLight.shadowAttenuation, inputData.normalWS, inputData.viewDirectionWS);*/
                /*#if defined(_ADDITIONAL_LIGHTS)
                    uint pixelLightCount = GetAdditionalLightsCount();
                    LIGHT_LOOP_BEGIN(pixelLightCount)
                    Light light = GetAdditionalLight(lightIndex, inputData, shadowMask, aoFactor);

                    if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
                    {
                        lightingData.additionalLightsColor += LightingPhysicallyBased(brdfData, brdfDataClearCoat, light,
                                                                          inputData.normalWS, inputData.viewDirectionWS,
                                                                          surfaceData.clearCoatMask, specularHighlightsOff);
                    }
                    LIGHT_LOOP_END
                #endif

                #if defined(_ADDITIONAL_LIGHTS_VERTEX)
                    lightingData.vertexLightingColor += inputData.vertexLighting * brdfData.diffuse;
                #endif*/

                return CalculateFinalColor(lightingData, surfaceData.alpha);
            }


            Varyings LitPassVertex(Attributes input)
            {
                Varyings output = (Varyings)0;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
                output.uv1 = input.texcoord1;

                //add vertex animation
                VertexPositionInputs vertexInput_copy = GetVertexPositionInputs(input.positionOS.xyz);
                float3 ase_worldPos = vertexInput_copy.positionWS;
                half MotionScale60_g1892 = (ADS_GlobalScale * _MotionScale);

                half MotionSpeed62_g1892 = (ADS_GlobalSpeed * _MotionSpeed) + UNITY_ACCESS_INSTANCED_PROP(
                    Props, _ShakeMotionSpeed) * 5;
                float mulTime90_g1892 = _Time.y * MotionSpeed62_g1892;

                float2 temp_output_95_0_g1892 = (((ase_worldPos).xz * MotionScale60_g1892) + mulTime90_g1892);

                half Packed_Variation1261 = input.color.a;

                half MotionVariation269_g1892 = (_MotionVariation * Packed_Variation1261);


                half MotionlAmplitude58_g1892 = (ADS_GlobalAmplitude * _MotionAmplitude) + UNITY_ACCESS_INSTANCED_PROP(
                    Props, _ShakeMotionAmplitude) * 0.1f;

                float2 temp_output_92_0_g1892 = (sin((temp_output_95_0_g1892 + MotionVariation269_g1892)) *
                    MotionlAmplitude58_g1892);


                float2 temp_cast_0 = (ADS_TurbulenceSpeed).xx;

                float2 panner73_g1579 = (_Time.y * temp_cast_0 + ((ase_worldPos).xz * ADS_TurbulenceScale));

                float2 panner73_g1579_x = (half2(_Time.x * temp_cast_0.x, 0) + ((ase_worldPos).xz *
                    ADS_TurbulenceScale));
                float2 panner73_g1579_y = (half2(0, _Time.x * temp_cast_0.x) + ((ase_worldPos).xz * ADS_TurbulenceScale
                    * 1.2f));

                float lerpResult136_g1579 = lerp(
                    1.0, saturate(pow(
                        abs(((tex2Dlod(ADS_TurbulenceTex, float4(panner73_g1579_x, 0, 0.0)) * tex2Dlod(
                            ADS_TurbulenceTex, float4(panner73_g1579_y, 0, 0.0)))).r), ADS_TurbulenceContrast)),
                    _GlobalTurbulence);

                half Motion_Turbulence1262 = lerpResult136_g1579;
                // output.color = Motion_Turbulence1262;

                float3 ADS_GlobalDirectionOS = mul(GetWorldToObjectMatrix(), float4(ADS_GlobalDirection, 0.0)).xyz;
                //half motionMask =  1 - saturate((input.texcoord1.y * 18));
                half motionMask = saturate((input.texcoord1.y * 18));
                //output.color = input.texcoord1.y;
                float3 motionOutput = lerp(half3(temp_output_92_0_g1892.x, 0, temp_output_92_0_g1892.y),
                                           half3(temp_output_92_0_g1892.x, 0, temp_output_92_0_g1892.y) +
                                           ADS_GlobalDirectionOS * MotionlAmplitude58_g1892 * 1.5f,
                                           Motion_Turbulence1262) * motionMask;
                input.positionOS.xyz += motionOutput;

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);


                // normalWS and tangentWS already normalize.
                // this is required to avoid skewing the direction during interpolation
                // also required for per-vertex lighting and SH evaluation
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);

                half3 vertexLight = VertexLighting(vertexInput.positionWS, normalInput.normalWS);

                output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);

                // already normalized from normal transform to WS.
                output.normalWS = normalInput.normalWS;
                real sign = input.tangentOS.w * GetOddNegativeScale();
                half4 tangentWS = half4(normalInput.tangentWS.xyz, sign);
                output.tangentWS = tangentWS;

                #if defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR)
                    half3 viewDirWS = GetWorldSpaceNormalizeViewDir(vertexInput.positionWS);
                    half3 viewDirTS = GetViewDirectionTangentSpace(tangentWS, output.normalWS, viewDirWS);
                    output.viewDirTS = viewDirTS;
                #endif

                //OUTPUT_LIGHTMAP_UV(input.staticLightmapUV, unity_LightmapST, output.staticLightmapUV);
                OUTPUT_SH(output.normalWS.xyz, output.vertexSH);
                #ifdef _ADDITIONAL_LIGHTS_VERTEX
                    output.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
                #else
                #endif

                #if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
                output.positionWS = vertexInput.positionWS;
                #endif

                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                    output.shadowCoord = GetShadowCoord(vertexInput);
                #endif
                output.positionCS = vertexInput.positionCS;

                return output;
            }

            // Used in Standard (Physically Based) shader
            half4 LitPassFragment(Varyings input) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
                //return float4( input.color.rgb , 1 );
                SurfaceData surfaceData;
                InitializeStandardLitSurfaceData_SIM(input.uv, input.color, surfaceData, input.positionWS);
                InputData inputData;
                InitializeInputData_SIM(input, surfaceData.normalTS, inputData);
                half4 color = UniversalFragmentLambert_SIM(inputData, surfaceData);
                // Screen-door transparency: Discard pixel if below threshold.
                float4x4 thresholdMatrix =
                {
                    1.0 / 17.0, 9.0 / 17.0, 3.0 / 17.0, 11.0 / 17.0,
                    13.0 / 17.0, 5.0 / 17.0, 15.0 / 17.0, 7.0 / 17.0,
                    4.0 / 17.0, 12.0 / 17.0, 2.0 / 17.0, 10.0 / 17.0,
                    16.0 / 17.0, 8.0 / 17.0, 14.0 / 17.0, 6.0 / 17.0
                };
                float4x4 _RowAccess = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};
                float2 pos = inputData.normalizedScreenSpaceUV.xy;
                pos *= _ScreenParams.xy; // pixel position
                clip(_Transparency - thresholdMatrix[fmod(pos.x, 4)] * _RowAccess[fmod(pos.y, 4)]);
                return color;
            }
            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            //#pragma exclude_renderers gles gles3 glcore
            #pragma target 3.0

            // -------------------------------------
            // Material Keywords
            // #pragma shader_feature_local_fragment _ALPHATEST_ON
            // #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #define _ALPHATEST_ON

            // -------------------------------------
            // Universal Pipeline keywords

            // This is used during shadow map generation to differentiate between directional and punctual light shadows, as they use different formulas to apply Normal Bias
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment


            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"


            // Shadow Casting Light geometric parameters. These variables are used when applying the shadow Normal Bias and are set by UnityEngine.Rendering.Universal.ShadowUtils.SetupShadowCasterConstantBuffer in com.unity.render-pipelines.universal/Runtime/ShadowUtils.cs
            // For Directional lights, _LightDirection is used when applying shadow Normal Bias.
            // For Spot lights and Point lights, _LightPosition is used to compute the actual light direction because it is different at each shadow caster geometry vertex.
            float3 _LightDirection;
            float3 _LightPosition;

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 color : COLOR;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float4 positionCS : SV_POSITION;
                float4 color : COLOR;
            };


            CBUFFER_START(UnityPerMaterial)
            sampler2D ADS_TurbulenceTex;
            sampler2D ADS_GlobalTex;
            float4 _BaseMap_ST;
            float4 _DetailAlbedoMap_ST;
            half4 _BaseColor, _MaskColor, _WindColor, _GrassDarkColor;
            half4 _EmissionColor;
            half _Cutoff;
            half _OcclusionStrength;
            half _PatternRepeat, _PatternMaskRepeat, _PatternMaskIntensity;
            half _Metallic, _Smoothness;
            half _WindRepeat, _GrassRepeat, _WindSpeed, _WindIntensity, _GrassShadowRepeat;
            half _MotionScale, _MotionSpeed, _MotionVariation, _MotionAmplitude3, _MotionAmplitude, _MotionSpeed3,
                 _MotionScale3, _GlobalSize, _GlobalTurbulence;

            half _Internal_ADS, _Internal_UnityToBoxophobic;
            half _ShakeMotionAmplitude, _ShakeMotionSpeed;
            CBUFFER_END
            half ADS_GlobalScale, ADS_GlobalSpeed, ADS_TurbulenceSpeed, ADS_TurbulenceScale, ADS_GlobalSizeMax,
                 ADS_GlobalSizeMin, ADS_TurbulenceContrast, ADS_GlobalAmplitude;
            half3 ADS_GlobalDirection;

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            half4 SampleAlbedoAlpha(float2 uv, TEXTURE2D_PARAM(albedoAlphaMap, sampler_albedoAlphaMap))
            {
                return half4(SAMPLE_TEXTURE2D(albedoAlphaMap, sampler_albedoAlphaMap, uv));
            }

            half Alpha(half albedoAlpha, half4 color, half cutoff)
            {
                #if !defined(_SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A) && !defined(_GLOSSINESS_FROM_BASE_ALPHA)
                half alpha = albedoAlpha * color.a;
                #else
                half alpha = color.a;
                #endif

                #if defined(_ALPHATEST_ON)
                clip(alpha - cutoff);
                #endif

                return alpha;
            }

            float4 GetShadowPositionHClip(Attributes input)
            {
                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(input.normalOS);

                #if _CASTING_PUNCTUAL_LIGHT_SHADOW
                float3 lightDirectionWS = normalize(_LightPosition - positionWS);
                #else
                float3 lightDirectionWS = _LightDirection;
                #endif

                float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

                #if UNITY_REVERSED_Z
                positionCS.z = min(positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #else
                positionCS.z = max(positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #endif

                return positionCS;
            }

            Varyings ShadowPassVertex(Attributes input)
            {
                Varyings output;
                UNITY_SETUP_INSTANCE_ID(input);
                output.uv1 = input.texcoord1;
                //add vertex animation
                VertexPositionInputs vertexInput_copy = GetVertexPositionInputs(input.positionOS.xyz);
                float3 ase_worldPos = vertexInput_copy.positionWS;
                half MotionScale60_g1892 = (ADS_GlobalScale * _MotionScale);

                half MotionSpeed62_g1892 = (ADS_GlobalSpeed * _MotionSpeed) + _ShakeMotionSpeed * 0.1f;
                float mulTime90_g1892 = _Time.y * MotionSpeed62_g1892;

                float2 temp_output_95_0_g1892 = (((ase_worldPos).xz * MotionScale60_g1892) + mulTime90_g1892);

                half Packed_Variation1261 = input.color.a;

                half MotionVariation269_g1892 = (_MotionVariation * Packed_Variation1261);


                half MotionlAmplitude58_g1892 = (ADS_GlobalAmplitude * _MotionAmplitude) + _ShakeMotionAmplitude * 0.1f;

                float2 temp_output_92_0_g1892 = (sin((temp_output_95_0_g1892 + MotionVariation269_g1892)) *
                    MotionlAmplitude58_g1892);


                float2 temp_cast_0 = (ADS_TurbulenceSpeed).xx;

                float2 panner73_g1579 = (_Time.y * temp_cast_0 + ((ase_worldPos).xz * ADS_TurbulenceScale));

                float2 panner73_g1579_x = (half2(_Time.x * temp_cast_0.x, 0) + ((ase_worldPos).xz *
                    ADS_TurbulenceScale));
                float2 panner73_g1579_y = (half2(0, _Time.x * temp_cast_0.x) + ((ase_worldPos).xz * ADS_TurbulenceScale
                    * 1.2f));

                float lerpResult136_g1579 = lerp(
                    1.0, saturate(pow(
                        abs(((tex2Dlod(ADS_TurbulenceTex, float4(panner73_g1579_x, 0, 0.0)) * tex2Dlod(
                            ADS_TurbulenceTex, float4(panner73_g1579_y, 0, 0.0)))).r), ADS_TurbulenceContrast)),
                    _GlobalTurbulence);

                half Motion_Turbulence1262 = lerpResult136_g1579;
                // output.color = Motion_Turbulence1262;

                float3 ADS_GlobalDirectionOS = mul(GetWorldToObjectMatrix(), float4(ADS_GlobalDirection, 0.0)).xyz;
                half motionMask = 1 - saturate((input.texcoord1.y * 18));
                //output.color = 1 - saturate((input.texcoord1.y * 18));
                float3 motionOutput = lerp(half3(temp_output_92_0_g1892.x, 0, temp_output_92_0_g1892.y),
                                           half3(temp_output_92_0_g1892.x, 0, temp_output_92_0_g1892.y) +
                                           ADS_GlobalDirectionOS * MotionlAmplitude58_g1892 * 1.5f,
                                           Motion_Turbulence1262) * motionMask;
                input.positionOS.xyz += motionOutput;

                output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);
                output.positionCS = GetShadowPositionHClip(input);
                return output;
            }

            half4 ShadowPassFragment(Varyings input) : SV_TARGET
            {
                Alpha(SampleAlbedoAlpha(input.uv, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap)).a, _BaseColor, _Cutoff);
                return 0;
            }
            ENDHLSL
        }



    }

}