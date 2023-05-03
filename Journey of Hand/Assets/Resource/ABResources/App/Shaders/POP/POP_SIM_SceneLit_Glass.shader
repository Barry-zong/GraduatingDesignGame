Shader "Universal Render Pipeline/POP/SIM/Scene/Scene Lit Glass"
{
    Properties
    {
        // Specular vs Metallic workflow
        //_WorkflowMode("WorkflowMode", Float) = 1.0

        [MainTexture] _BaseMap("Albedo", 2D) = "white" {}
        [MainColor] _BaseColor("Color", Color) = (1,1,1,1)

        //_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

        //_Smoothness("Smoothness", Range(0.0, 1.0)) = 0.5
        // _SmoothnessTextureChannel("Smoothness texture channel", Float) = 0

        //_Metallic("Metallic", Range(0.0, 1.0)) = 0.0
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
        
        [Space(20)][Header(__ Glass Property __)][Space(30)]
        _MatcapReflectMap("Matcap Reflect Map", 2D) = "white" {}
        _MatcapReflectColor("Matcap Reflect Color", Color) = (1,1,1,1)
        _MatcapReflectIntensity("Matcap Reflect Intensity", Range(0, 1)) = 1
        _MatcapRefractMap("Matcap Refract Map", 2D) = "white" {}
        _MatcapRefractColor("Matcap Refract Color", Color) = (1,1,1,1)
        _MatcapRefractIntensity("Matcap Refract Intensity", Range(0, 1)) = 1
        _RefractThickness("Refract Thickness", Range(0, 20)) = 1
        _RefractColor("Refract Color", Color) = (1,1,1,1)
        _RefractIntensity("Refract Intensity", Range(0, 1)) = 0
        
    }

    SubShader
    {
        // Universal Pipeline tag is required. If Universal render pipeline is not set in the graphics settings
        // this Subshader will fail. One can add a subshader below or fallback to Standard built-in to make this
        // material work with both Universal Render Pipeline and Builtin Unity Pipeline
        Tags
        {
            "Queue"="Transparent" "RenderType" = "Transparent" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "Lit" "IgnoreProjector" = "True" "ShaderModel"="3.0"
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

            Blend SrcAlpha OneMinusSrcAlpha
            //ZWrite Off

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

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float2 uv                           : TEXCOORD0;

                #if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
                float3 positionWS                   : TEXCOORD1;
                #endif

                half3 normalWS                      : TEXCOORD2;
                half4 tangentWS                     : TEXCOORD3; // xyz: tangent, w: sign
                float3 viewDirWS                    : TEXCOORD4;

                #ifdef _ADDITIONAL_LIGHTS_VERTEX
                half4 fogFactorAndVertexLight       : TEXCOORD5; // x: fogFactor, yzw: vertex light
                #else
                half fogFactor : TEXCOORD5;
                #endif

                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                float4 shadowCoord                  : TEXCOORD6;
                #endif

                #if defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR)
                half3 viewDirTS                     : TEXCOORD7;
                #endif

                half3 vertexSH                      : TEXCOORD8;
                float4 positionCS                   : SV_POSITION;
                float2 matCapUV                     : TEXCOORD9;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _DetailAlbedoMap_ST;
            half4 _BaseColor;
            half4 _EmissionColor;
            //half _Cutoff;
            half _OcclusionStrength;
            half _Metallic, _Smoothness;
            real4 _SHAr;
            real4 _SHAg;
            real4 _SHAb;
            real4 _SHBr;
            real4 _SHBg;
            real4 _SHBb;
            real4 _SHC;
            half _RefractIntensity, _RefractThickness, _MatcapReflectIntensity, _MatcapRefractIntensity;
            half4 _RefractColor, _MatcapRefractColor, _MatcapReflectColor;
            CBUFFER_END

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
            TEXTURE2D(_MatcapReflectMap);
            SAMPLER(sampler_MatcapReflectMap);
            TEXTURE2D(_MatcapRefractMap);
            SAMPLER(sampler_MatcapRefractMap);


            half3 SampleSHPixel_SIM(half3 L2Term, half3 normalWS)
            {
                half3 res = SHEvalLinearL0L1(normalWS, unity_SHAr, unity_SHAg, unity_SHAb);
                //half3 res = SHEvalLinearL0L1(normalWS, _SHAr, _SHAg, _SHAb);
                return max(half3(0, 0, 0), res);
            }

            inline void InitializeStandardLitSurfaceData_SIM(float2 uv, float2 matcap_uv, out SurfaceData outSurfaceData, float3 worldPos)
            {
                half4 albedoAlpha = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv);
                half4 specGloss = SAMPLE_TEXTURE2D(_MetallicGlossMap, sampler_MetallicGlossMap, uv);
                //matcap
                outSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;
                //outSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;
                outSurfaceData.alpha = albedoAlpha.a * _BaseColor.a;
                outSurfaceData.metallic = specGloss.r;
                outSurfaceData.specular = half3(0.0, 0.0, 0.0);
                outSurfaceData.smoothness = specGloss.g;
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


            half4 UniversalFragmentPBR_SIM(InputData inputData, SurfaceData surfaceData)
            {
                BRDFData brdfData;
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
                LightingData lightingData = CreateLightingData(inputData, surfaceData);
                lightingData.giColor = GlobalIllumination_SIM(brdfData, inputData.bakedGI,
                                                              aoFactor.indirectAmbientOcclusion, inputData.positionWS,
                                                              inputData.normalWS, inputData.viewDirectionWS);
                lightingData.mainLightColor = LightingPhysicallyBased_SIM(
                    brdfData, mainLight.color, mainLight.direction,
                    mainLight.distanceAttenuation * mainLight.shadowAttenuation, inputData.normalWS,
                    inputData.viewDirectionWS);
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

                half3 normalVS = mul((float3x3)UNITY_MATRIX_V, output.normalWS) * 0.5 + 0.5;
                output.matCapUV = normalVS.xy;

                return output;
            }

            // Used in Standard (Physically Based) shader
            half4 LitPassFragment(Varyings input) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(input);
                SurfaceData surfaceData;
                InitializeStandardLitSurfaceData_SIM(input.uv, input.matCapUV, surfaceData, input.positionWS);
                InputData inputData;
                InitializeInputData_SIM(input, surfaceData.normalTS, inputData);
                half4 color = UniversalFragmentPBR_SIM(inputData, surfaceData);

                half4 matcap_reflect_term = SAMPLE_TEXTURE2D(_MatcapReflectMap, sampler_MatcapReflectMap, input.matCapUV);
                half4 matcap_reflect_col =  matcap_reflect_term * _MatcapReflectIntensity;
                half fresnel = saturate(1 - Smootherstep01(dot(inputData.normalWS, inputData.viewDirectionWS)));
                half refractThickness = saturate(pow(fresnel, _RefractThickness));
                half2 refract_uv = input.matCapUV + refractThickness * _RefractIntensity;
                half4 matcap_refract_term = SAMPLE_TEXTURE2D(_MatcapRefractMap, sampler_MatcapRefractMap, refract_uv);
                half4 matcap_refract_col = matcap_refract_term * refractThickness * _MatcapRefractIntensity + refractThickness * _RefractColor;
                half4 matcap = 0;
                matcap.rgb = matcap_reflect_col.rgb * _MatcapReflectColor.rgb + matcap_refract_col.rgb * _MatcapRefractColor.rgb;
                matcap.a = saturate(matcap_reflect_col.r + refractThickness.r);
                half4 finalCol = 0;
                finalCol.rgb = surfaceData.albedo + matcap.rgb * (1 - surfaceData.alpha);
                finalCol.a = saturate(surfaceData.alpha + matcap.rgb.r);
                
                return finalCol;
            }
            ENDHLSL
        }
        
        
        /*Pass
        {
            Name "ZWrite"
            ZWrite On
            ColorMask 0
        }*/

        //         Pass
        //        {
        //            Name "ShadowCaster"
        //            Tags{"LightMode" = "ShadowCaster"}
        //
        //            ZWrite On
        //            ZTest LEqual
        //            ColorMask 0
        //            Cull[_Cull]
        //
        //            HLSLPROGRAM
        //            //#pragma exclude_renderers gles gles3 glcore
        //            #pragma target 3.0
        //
        //            // -------------------------------------
        //            // Material Keywords
        //            // #pragma shader_feature_local_fragment _ALPHATEST_ON
        //            // #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
        //
        //            //--------------------------------------
        //            // GPU Instancing
        //            #pragma multi_compile_instancing
        //            #pragma multi_compile _ DOTS_INSTANCING_ON
        //
        //            // -------------------------------------
        //            // Universal Pipeline keywords
        //
        //            // This is used during shadow map generation to differentiate between directional and punctual light shadows, as they use different formulas to apply Normal Bias
        //            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        //
        //            #pragma vertex ShadowPassVertex
        //            #pragma fragment ShadowPassFragment
        //
        //            #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
        //            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
        //            ENDHLSL
        //        }


    }

}