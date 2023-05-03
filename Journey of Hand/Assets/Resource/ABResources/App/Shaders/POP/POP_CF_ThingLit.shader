Shader "Universal Render Pipeline/POP/CF/Thing Lit"
{
    Properties
    {
        // Specular vs Metallic workflow
        //_WorkflowMode("WorkflowMode", Float) = 1.0

        [MainTexture] _BaseMap("Albedo", 2D) = "white" {}
        [MainColor] _BaseColor("Color", Color) = (1,1,1,1)

        //_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

       // _Smoothness("Smoothness", Range(0.0, 1.0)) = 0.5
       // _SmoothnessTextureChannel("Smoothness texture channel", Float) = 0

        //_Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        _MetallicGlossMap("MetallicGloss Map", 2D) = "white" {}

        
        //_SpecColor("Specular", Color) = (0.2, 0.2, 0.2)
        //_SpecGlossMap("Specular", 2D) = "white" {}

        //[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        //[ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0

        //_BumpScale("Scale", Float) = 1.0
        _BumpMap("Normal Map", 2D) = "bump" {}

        //_Parallax("Scale", Range(0.005, 0.08)) = 0.005
        //_ParallaxMap("Height Map", 2D) = "black" {}

        _OcclusionStrength("Occlusion Strength", Range(0.0, 1.0)) = 1.0
        //_OcclusionMap("Occlusion", 2D) = "white" {}

        [HDR] _EmissionColor("Emission Color", Color) = (0,0,0)
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
    }

    SubShader
    {
        // Universal Pipeline tag is required. If Universal render pipeline is not set in the graphics settings
        // this Subshader will fail. One can add a subshader below or fallback to Standard built-in to make this
        // material work with both Universal Render Pipeline and Builtin Unity Pipeline
        Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "Lit" "IgnoreProjector" = "True" "ShaderModel"="3.0"}
        LOD 300

        // ------------------------------------------------------------------
        //  Forward pass. Shades all light in a single pass. GI + emission + Fog
        Pass
        {
            // Lightmode matches the ShaderPassName set in UniversalRenderPipeline.cs. SRPDefaultUnlit and passes with
            // no LightMode tag are also rendered by Universal Render Pipeline
            Name "ForwardLit"
            Tags{"LightMode" = "UniversalForward"}

            //Blend[_SrcBlend][_DstBlend]
           // ZWrite[_ZWrite]
            //Cull[_Cull]

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
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float4 tangentOS    : TANGENT;
                float2 texcoord     : TEXCOORD0;
                float2 staticLightmapUV   : TEXCOORD1;
                float2 dynamicLightmapUV  : TEXCOORD2;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float2 uv                       : TEXCOORD0;

                #if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
                float3 positionWS               : TEXCOORD1;
                #endif

                half3 normalWS                 : TEXCOORD2;
                half4 tangentWS                : TEXCOORD3;    // xyz: tangent, w: sign
                float3 viewDirWS                : TEXCOORD4;

                #ifdef _ADDITIONAL_LIGHTS_VERTEX
                half4 fogFactorAndVertexLight   : TEXCOORD5; // x: fogFactor, yzw: vertex light
                #else
                half  fogFactor                 : TEXCOORD5;
                #endif

                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                float4 shadowCoord              : TEXCOORD6;
                #endif

                #if defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR)
                half3 viewDirTS                : TEXCOORD7;
                #endif

                //ECLARE_LIGHTMAP_OR_SH(staticLightmapUV, vertexSH, 8);
                half3 vertexSH                 : TEXCOORD8;
                float4 positionCS               : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _DetailAlbedoMap_ST;
            half4 _BaseColor;
            half4 _EmissionColor;
            half _Cutoff;
            half _OcclusionStrength;
            half _Metallic, _Smoothness;
            real4 _SHAr;
            real4 _SHAg;
            real4 _SHAb;
            real4 _SHBr;
            real4 _SHBg;
            real4 _SHBb;
            real4 _SHC;
            CBUFFER_END

            TEXTURE2D(_BaseMap);            SAMPLER(sampler_BaseMap);
            TEXTURE2D(_BumpMap);            SAMPLER(sampler_BumpMap);
            TEXTURE2D(_EmissionMap);        SAMPLER(sampler_EmissionMap);
            TEXTURE2D(_ParallaxMap);        SAMPLER(sampler_ParallaxMap);
            TEXTURE2D(_OcclusionMap);       SAMPLER(sampler_OcclusionMap);
            TEXTURE2D(_DetailMask);         SAMPLER(sampler_DetailMask);
            TEXTURE2D(_DetailAlbedoMap);    SAMPLER(sampler_DetailAlbedoMap);
            TEXTURE2D(_DetailNormalMap);    SAMPLER(sampler_DetailNormalMap);
            TEXTURE2D(_MetallicGlossMap);   SAMPLER(sampler_MetallicGlossMap);
            TEXTURE2D(_SpecGlossMap);       SAMPLER(sampler_SpecGlossMap);
            TEXTURE2D(_ClearCoatMap);       SAMPLER(sampler_ClearCoatMap);
            


            half3 SampleSHPixel_SIM(half3 L2Term, half3 normalWS)
            {
                //half3 res = SHEvalLinearL0L1(normalWS, unity_SHAr, unity_SHAg, unity_SHAb);
                half3 res = SHEvalLinearL0L1(normalWS, _SHAr, _SHAg, _SHAb);
                return max(half3(0, 0, 0), res);
            }
            
            inline void InitializeStandardLitSurfaceData_SIM(float2 uv, out SurfaceData outSurfaceData, float3 worldPos)
            {
               
                half4 albedoAlpha = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv);
                outSurfaceData.alpha = 1;
                half4 specGloss = SAMPLE_TEXTURE2D(_MetallicGlossMap, sampler_MetallicGlossMap, uv);
                //outSurfaceData.albedo = albedoAlpha.rgb;
                outSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;
                outSurfaceData.metallic = specGloss.r;
                //outSurfaceData.metallic = _Metallic;
                outSurfaceData.specular = half3(0.0, 0.0, 0.0);
                outSurfaceData.smoothness = specGloss.g;
                //outSurfaceData.smoothness = _Smoothness;
                outSurfaceData.normalTS = SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, uv);
                outSurfaceData.occlusion = LerpWhiteTo(specGloss.b, _OcclusionStrength);
                outSurfaceData.emission = specGloss.a * _EmissionColor.rgb;
                outSurfaceData.clearCoatMask       = half(0.0);
                outSurfaceData.clearCoatSmoothness = half(0.0);
            }

            void InitializeInputData_SIM(Varyings input, half3 normalTS, out InputData inputData)
            {
                inputData = (InputData)0;
                inputData.positionWS = input.positionWS;
                half3 viewDirWS = GetWorldSpaceNormalizeViewDir(input.positionWS);
                float sgn = input.tangentWS.w;      // should be either +1 or -1
                float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
                inputData.tangentToWorld = tangentToWorld;
                inputData.normalWS = TransformTangentToWorld(normalTS, tangentToWorld);
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
                inputData.shadowMask = SAMPLE_SHADOWMASK(input.staticLightmapUV);
            }



            

            
            void InitializeBRDFDataDirect_SIM(half3 albedo, half3 diffuse, half3 specular, half reflectivity, half oneMinusReflectivity, half smoothness, inout half alpha, out BRDFData outBRDFData)
            {
                outBRDFData = (BRDFData)0;
                outBRDFData.albedo = albedo;
                outBRDFData.diffuse = diffuse;
                outBRDFData.specular = specular;
                outBRDFData.reflectivity = reflectivity;

                outBRDFData.perceptualRoughness = PerceptualSmoothnessToPerceptualRoughness(smoothness);
                outBRDFData.roughness           = max(PerceptualRoughnessToRoughness(outBRDFData.perceptualRoughness), HALF_MIN_SQRT);
                outBRDFData.roughness2          = max(outBRDFData.roughness * outBRDFData.roughness, HALF_MIN);
                outBRDFData.grazingTerm         = saturate(smoothness + reflectivity);
                outBRDFData.normalizationTerm   = outBRDFData.roughness * half(4.0) + half(2.0);
                outBRDFData.roughness2MinusOne  = outBRDFData.roughness2 - half(1.0);
            }
            
            void InitializeBRDFData_SIM(half3 albedo, half metallic, half3 specular, half smoothness, inout half alpha, out BRDFData outBRDFData)
            {
                half oneMinusReflectivity = OneMinusReflectivityMetallic(metallic);
                half reflectivity = half(1.0) - oneMinusReflectivity;
                half3 brdfDiffuse = albedo * oneMinusReflectivity;
                half3 brdfSpecular = lerp(kDieletricSpec.rgb, albedo, metallic);
                InitializeBRDFDataDirect_SIM(albedo, brdfDiffuse, brdfSpecular, reflectivity, oneMinusReflectivity, smoothness, alpha, outBRDFData);
            }

            half3 GlossyEnvironmentReflection_SIM(half3 reflectVector, float3 positionWS, half perceptualRoughness, half occlusion)
            {
                half3 irradiance;

                #ifdef _REFLECTION_PROBE_BLENDING
                    irradiance = CalculateIrradianceFromReflectionProbes(reflectVector, positionWS, perceptualRoughness);
                #else
                #ifdef _REFLECTION_PROBE_BOX_PROJECTION
                    reflectVector = BoxProjectedCubemapDirection(reflectVector, positionWS, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
                #endif // _REFLECTION_PROBE_BOX_PROJECTION
                half mip = PerceptualRoughnessToMipmapLevel(perceptualRoughness);
                half4 encodedIrradiance = half4(SAMPLE_TEXTURECUBE_LOD(unity_SpecCube0, samplerunity_SpecCube0, reflectVector, mip));

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

            half3 EnvironmentBRDF_SIM(BRDFData brdfData, half3 indirectDiffuse, half3 indirectSpecular, half fresnelTerm)
            {
                half3 c = indirectDiffuse * brdfData.diffuse;
                c += indirectSpecular * EnvironmentBRDFSpecular_SIM(brdfData, fresnelTerm);
                return c;
            }
            
            // Computes the scalar specular term for Minimalist CookTorrance BRDF
            // NOTE: needs to be multiplied with reflectance f0, i.e. specular color to complete
            half DirectBRDFSpecular_SIM(BRDFData brdfData, half3 normalWS, half3 lightDirectionWS, half3 viewDirectionWS)
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

            
            half3 GlobalIllumination_SIM(BRDFData brdfData,half3 bakedGI, half occlusion, float3 positionWS,half3 normalWS, half3 viewDirectionWS)
            {
                half3 reflectVector = reflect(-viewDirectionWS, normalWS);
                half NoV = saturate(dot(normalWS, viewDirectionWS));
                half fresnelTerm = Pow4(1.0 - NoV);
                half3 indirectDiffuse = bakedGI;
                half3 indirectSpecular = GlossyEnvironmentReflection_SIM(reflectVector, positionWS, brdfData.perceptualRoughness, 1.0h);
                half3 color = EnvironmentBRDF_SIM(brdfData, indirectDiffuse, indirectSpecular, fresnelTerm);
                return  color * occlusion;
            }
            
            half3 LightingPhysicallyBased_SIM(BRDFData brdfData,half3 lightColor, half3 lightDirectionWS, half lightAttenuation,half3 normalWS, half3 viewDirectionWS)
            {
                half NdotL = saturate(dot(normalWS, lightDirectionWS));
                half3 radiance = lightColor * (lightAttenuation * NdotL);

                half3 brdf = brdfData.diffuse;
                brdf += brdfData.specular * DirectBRDFSpecular_SIM(brdfData, normalWS, lightDirectionWS, viewDirectionWS);
                return brdf * radiance;
            }


            
            half4 UniversalFragmentPBR_SIM(InputData inputData, SurfaceData surfaceData)
            {
                // #if defined(_SPECULARHIGHLIGHTS_OFF)
                //     bool specularHighlightsOff = true;
                // #else
                //     bool specularHighlightsOff = false;
                // #endif
                BRDFData brdfData;
                
                //InitializeBRDFData(surfaceData, brdfData);
                InitializeBRDFData_SIM(surfaceData.albedo, surfaceData.metallic, surfaceData.specular, surfaceData.smoothness, surfaceData.alpha, brdfData);
                // Clear-coat calculation...
                //BRDFData brdfDataClearCoat = CreateClearCoatBRDFData(surfaceData, brdfData);
                half4 shadowMask = CalculateShadowMask(inputData);
                AmbientOcclusionFactor aoFactor = CreateAmbientOcclusionFactor(inputData, surfaceData);
               // uint meshRenderingLayers = GetMeshRenderingLightLayer();
                Light mainLight = GetMainLight(inputData, shadowMask, aoFactor);
                MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI);
                LightingData lightingData = CreateLightingData(inputData, surfaceData);
                lightingData.giColor = GlobalIllumination_SIM(brdfData,inputData.bakedGI, aoFactor.indirectAmbientOcclusion, inputData.positionWS,
                inputData.normalWS, inputData.viewDirectionWS);
                lightingData.mainLightColor = LightingPhysicallyBased_SIM(brdfData, mainLight.color, mainLight.direction,
                                    mainLight.distanceAttenuation * mainLight.shadowAttenuation, inputData.normalWS, inputData.viewDirectionWS);
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
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);

                // normalWS and tangentWS already normalize.
                // this is required to avoid skewing the direction during interpolation
                // also required for per-vertex lighting and SH evaluation
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);

                half3 vertexLight = VertexLighting(vertexInput.positionWS, normalInput.normalWS);
                
                output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);

                // already normalized from normal transform to WS.
                output.normalWS = normalInput.normalWS;
                #if defined(REQUIRES_WORLD_SPACE_TANGENT_INTERPOLATOR) || defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR)
                    real sign = input.tangentOS.w * GetOddNegativeScale();
                    half4 tangentWS = half4(normalInput.tangentWS.xyz, sign);
                #endif
                #if defined(REQUIRES_WORLD_SPACE_TANGENT_INTERPOLATOR)
                    output.tangentWS = tangentWS;
                #endif

                #if defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR)
                    half3 viewDirWS = GetWorldSpaceNormalizeViewDir(vertexInput.positionWS);
                    half3 viewDirTS = GetViewDirectionTangentSpace(tangentWS, output.normalWS, viewDirWS);
                    output.viewDirTS = viewDirTS;
                #endif

                OUTPUT_LIGHTMAP_UV(input.staticLightmapUV, unity_LightmapST, output.staticLightmapUV);
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
                SurfaceData surfaceData;
                InitializeStandardLitSurfaceData_SIM(input.uv, surfaceData, input.positionWS);
                InputData inputData;
                InitializeInputData_SIM(input, surfaceData.normalTS, inputData);
                half4 color = UniversalFragmentPBR_SIM(inputData, surfaceData);
                // color.rgb = MixFog(color.rgb, inputData.fogCoord);
                // color.a = OutputAlpha(color.a, _Surface);
                return color;
            }
            ENDHLSL
        }
        
   Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

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
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float2 texcoord     : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float2 uv           : TEXCOORD0;
                float4 positionCS   : SV_POSITION;
            };


            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _DetailAlbedoMap_ST;
            half4 _BaseColor;
            half4 _EmissionColor;
            half _Cutoff;
            half _OcclusionStrength;
            half _Metallic, _Smoothness;
            real4 _SHAr;
            real4 _SHAg;
            real4 _SHAb;
            real4 _SHBr;
            real4 _SHBg;
            real4 _SHBb;
            real4 _SHC;
            CBUFFER_END

            TEXTURE2D(_BaseMap);            SAMPLER(sampler_BaseMap);

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
