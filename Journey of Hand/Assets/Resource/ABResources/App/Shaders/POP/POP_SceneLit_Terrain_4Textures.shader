Shader "Universal Render Pipeline/POP/Scene/Terrian/4Textures"
{
    Properties
    {
        [HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
        [HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
        _Splat0("Layer 1", 2D) = "white" {}
        _Normal0("Normalmap 1", 2D) = "bump" {}
    	 _Smoothness0("Smoothness 1", Range( 0 , 1)) = 0.5
    	
        _Splat1("Layer 2", 2D) = "white" {}
    	 _Normal1("Normalmap 2", 2D) = "bump" {}
    	 _Smoothness1("Smoothness 2", Range( 0 , 1)) = 0.5
    	
        _Splat2("Layer 3", 2D) = "white" {}
    	_Normal2("Normalmap 3", 2D) = "bump" {}
    	_Smoothness2("Smoothness 3", Range( 0 , 1)) = 0.5
    	
        _Splat3("Layer 4", 2D) = "white" {}
    	 _Normal3("Normalmap 4", 2D) = "bump" {}
    	_Smoothness3("Smoothness 4", Range( 0 , 1)) = 0.5
    	
        _Control("Control", 2D) = "white" {}
    	
        [Toggle(ENABLE_NORMAL_INTENSITY)] ENABLE_NORMAL_INTENSITY("Normal Intensity", Float) = 1
    	
        _NormalIntensity0("Normal Intensity 1", Range( 0.01 , 10)) = 1
        _NormalIntensity1("Normal Intensity 2", Range( 0.01 , 10)) = 1
        _NormalIntensity2("Normal Intensity 3", Range( 0.01 , 10)) = 1
        [ASEEnd]_NormalIntensity3("Normal Intensity 4", Range( 0.01 , 10)) = 1

        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }

    SubShader
    {
	    Tags
        {
            "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "Lit" "IgnoreProjector" = "True" "ShaderModel"="2.0"
        }
        LOD 300

	    HLSLINCLUDE
        #pragma target 3.0
        #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal vulkan
        ENDHLSL


        Pass
        {

            Name "Forward"
            Tags
            {
                "LightMode"="UniversalForward"
            }

            HLSLPROGRAM
            #define _NORMAL_DROPOFF_TS 1
            #define _NORMALMAP 1

            //#pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
            //#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE

            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK

            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON

            #pragma multi_compile _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile _ _REFLECTION_PROBE_BOX_PROJECTION
            //#pragma multi_compile _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            //#pragma multi_compile _ _LIGHT_LAYERS

            //#pragma multi_compile _ _LIGHT_COOKIES
            //#pragma multi_compile _ _CLUSTERED_RENDERING

            #pragma vertex vert
            #pragma fragment frag

            #define SHADERPASS SHADERPASS_FORWARD

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

            #if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
			    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
            #endif
            
            #pragma shader_feature_local ENABLE_NORMAL_INTENSITY


            struct VertexInput
            {
                float4 vertex : POSITION;
                float3 ase_normal : NORMAL;
                float4 ase_tangent : TANGENT;
                float4 texcoord : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct VertexOutput
            {
                float4 clipPos : SV_POSITION;
                float4 lightmapUVOrVertexSH : TEXCOORD0;
                half4 fogFactorAndVertexLight : TEXCOORD1;
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
                #endif
                float4 tSpace0 : TEXCOORD3;
                float4 tSpace1 : TEXCOORD4;
                float4 tSpace2 : TEXCOORD5;
                #if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
                #endif
                #if defined(DYNAMICLIGHTMAP_ON)
				float2 dynamicLightmapUV : TEXCOORD7;
                #endif
                float4 ase_texcoord8 : TEXCOORD8;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
            half4 _Control_ST;
            half4 _Splat0_ST;
            half4 _Splat1_ST;
            half4 _Splat2_ST;
            half4 _Splat3_ST;
            float _Smoothness0;
            float _Smoothness1;
            float _Smoothness2;
            float _Smoothness3;
            half _NormalIntensity0;
            half _NormalIntensity1;
            half _NormalIntensity2;
            half _NormalIntensity3;
            #ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
            #endif
            #ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
            #endif
            #ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
            #endif
            CBUFFER_END
            sampler2D _Control;
            sampler2D _Splat0;
            sampler2D _Splat1;
            sampler2D _Splat2;
            sampler2D _Splat3;
            sampler2D _Normal0;
            sampler2D _Normal1;
            sampler2D _Normal2;
            sampler2D _Normal3;

            uniform  half4 _EnvColor;
            uniform float _GIIntensity;
			uniform float _GIContrast;


            float4 WeightedBlend4143(half4 Weight, float4 Layer1, float4 Layer2, float4 Layer3, float4 Layer4)
            {
                return Layer1 * Weight.r + Layer2 * Weight.g + Layer3 * Weight.b + Layer4 * Weight.a;
            }

            inline half3 MTE_NormalIntensity_fixed154(half3 Normal, half Strength)
            {
                return lerp(Normal, float3(0, 0, 1), - Strength + 1.0);
            }

            inline half3 MTE_NormalIntensity_fixed151(half3 Normal, half Strength)
            {
                return lerp(Normal, float3(0, 0, 1), - Strength + 1.0);
            }

            inline half3 MTE_NormalIntensity_fixed148(half3 Normal, half Strength)
            {
                return lerp(Normal, float3(0, 0, 1), - Strength + 1.0);
            }

            inline half3 MTE_NormalIntensity_fixed145(half3 Normal, half Strength)
            {
                return lerp(Normal, float3(0, 0, 1), - Strength + 1.0);
            }

            float4 WeightedBlend489(half4 Weight, float4 Layer1, float4 Layer2, float4 Layer3, float4 Layer4)
            {
                return Layer1 * Weight.r + Layer2 * Weight.g + Layer3 * Weight.b + Layer4 * Weight.a;
            }


            VertexOutput VertexFunction(VertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                o.ase_texcoord8.xy = v.texcoord.xy;

                //setting value to unused interpolator channels and avoid initialization warnings
                o.ase_texcoord8.zw = 0;
                #ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
                #else
                float3 defaultVertexValue = float3(0, 0, 0);
                #endif
                float3 vertexValue = defaultVertexValue;
                #ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
                #else
                v.vertex.xyz += vertexValue;
                #endif
                v.ase_normal = v.ase_normal;

                float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
                float3 positionVS = TransformWorldToView(positionWS);
                float4 positionCS = TransformWorldToHClip(positionWS);

                VertexNormalInputs normalInput = GetVertexNormalInputs(v.ase_normal, v.ase_tangent);

                o.tSpace0 = float4(normalInput.normalWS, positionWS.x);
                o.tSpace1 = float4(normalInput.tangentWS, positionWS.y);
                o.tSpace2 = float4(normalInput.bitangentWS, positionWS.z);

                #if defined(LIGHTMAP_ON)
				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
                #endif

                #if defined(DYNAMICLIGHTMAP_ON)
				o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif

                #if !defined(LIGHTMAP_ON)
                OUTPUT_SH(normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz);
                #endif

                #if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
                #endif

                half3 vertexLight = VertexLighting(positionWS, normalInput.normalWS);
                #ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
                #else
                half fogFactor = 0;
                #endif
                o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
                #endif

                o.clipPos = positionCS;
                #if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				o.screenPos = ComputeScreenPos(positionCS);
                #endif
                return o;
            }

            VertexOutput vert(VertexInput v)
            {
                return VertexFunction(v);
            }


            half4 frag(VertexOutput IN) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(IN);
                float3 WorldNormal = normalize(IN.tSpace0.xyz);
                float3 WorldTangent = IN.tSpace1.xyz;
                float3 WorldBiTangent = IN.tSpace2.xyz;
                float3 WorldPosition = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
                float3 WorldViewDirection = _WorldSpaceCameraPos.xyz - WorldPosition;
                float4 ShadowCoords = float4(0, 0, 0, 0);
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
                #elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
                #endif

                WorldViewDirection = SafeNormalize(WorldViewDirection);

                half4 localBreakRGBA115 = (float4(0, 0, 0, 0));
                half2 uv_Control = IN.ase_texcoord8.xy * _Control_ST.xy + _Control_ST.zw;
                half4 tex2DNode6 = tex2D(_Control, uv_Control);
                float4 Weight143 = tex2DNode6;
                half2 uv_Splat0 = IN.ase_texcoord8.xy * _Splat0_ST.xy + _Splat0_ST.zw;
                half4 appendResult123 = (half4(1.0, 1.0, 1.0, _Smoothness0));
                float4 Layer1143 = (tex2D(_Splat0, uv_Splat0) * appendResult123);
                half2 uv_Splat1 = IN.ase_texcoord8.xy * _Splat1_ST.xy + _Splat1_ST.zw;
                half4 appendResult126 = (half4(1.0, 1.0, 1.0, _Smoothness1));
                float4 Layer2143 = (tex2D(_Splat1, uv_Splat1) * appendResult126);
                half2 uv_Splat2 = IN.ase_texcoord8.xy * _Splat2_ST.xy + _Splat2_ST.zw;
                half4 appendResult129 = (half4(1.0, 1.0, 1.0, _Smoothness2));
                float4 Layer3143 = (tex2D(_Splat2, uv_Splat2) * appendResult129);
                half2 uv_Splat3 = IN.ase_texcoord8.xy * _Splat3_ST.xy + _Splat3_ST.zw;
                half4 appendResult131 = (half4(1.0, 1.0, 1.0, _Smoothness3));
                float4 Layer4143 = (tex2D(_Splat3, uv_Splat3) * appendResult131);
                float4 localWeightedBlend4143 =
                    WeightedBlend4143(Weight143, Layer1143, Layer2143, Layer3143, Layer4143);
                half4 RGBA115 = localWeightedBlend4143;
                half3 RGB115 = float3(0, 0, 0);
                half A115 = 0;
                {
                    RGB115 = RGBA115.rgb;
                    A115 = RGBA115.a;
                }

                float4 Weight89 = tex2DNode6;
                half3 tex2DNode16 = UnpackNormalScale(tex2D(_Normal0, uv_Splat0), 1.0f);
                half3 Normal154 = tex2DNode16;
                half Strength154 = _NormalIntensity0;
                half3 localMTE_NormalIntensity_fixed154 = MTE_NormalIntensity_fixed154(Normal154, Strength154);
                #ifdef ENABLE_NORMAL_INTENSITY
                half3 staticSwitch155 = localMTE_NormalIntensity_fixed154;
                #else
				half3 staticSwitch155 = tex2DNode16;
                #endif
                float4 Layer189 = float4(staticSwitch155, 0.0);
                half3 tex2DNode39 = UnpackNormalScale(tex2D(_Normal1, uv_Splat1), 1.0f);
                half3 Normal151 = tex2DNode39;
                half Strength151 = _NormalIntensity1;
                half3 localMTE_NormalIntensity_fixed151 = MTE_NormalIntensity_fixed151(Normal151, Strength151);
                #ifdef ENABLE_NORMAL_INTENSITY
                half3 staticSwitch152 = localMTE_NormalIntensity_fixed151;
                #else
				half3 staticSwitch152 = tex2DNode39;
                #endif
                float4 Layer289 = float4(staticSwitch152, 0.0);
                half3 tex2DNode44 = UnpackNormalScale(tex2D(_Normal2, uv_Splat2), 1.0f);
                half3 Normal148 = tex2DNode44;
                half Strength148 = _NormalIntensity2;
                half3 localMTE_NormalIntensity_fixed148 = MTE_NormalIntensity_fixed148(Normal148, Strength148);
                #ifdef ENABLE_NORMAL_INTENSITY
                half3 staticSwitch149 = localMTE_NormalIntensity_fixed148;
                #else
				half3 staticSwitch149 = tex2DNode44;
                #endif
                float4 Layer389 = float4(staticSwitch149, 0.0);
                half3 tex2DNode48 = UnpackNormalScale(tex2D(_Normal3, uv_Splat3), 1.0f);
                half3 Normal145 = tex2DNode48;
                half Strength145 = _NormalIntensity3;
                half3 localMTE_NormalIntensity_fixed145 = MTE_NormalIntensity_fixed145(Normal145, Strength145);
                #ifdef ENABLE_NORMAL_INTENSITY
                half3 staticSwitch146 = localMTE_NormalIntensity_fixed145;
                #else
				half3 staticSwitch146 = tex2DNode48;
                #endif
                float4 Layer489 = float4(staticSwitch146, 0.0);
                float4 localWeightedBlend489 = WeightedBlend489(Weight89, Layer189, Layer289, Layer389, Layer489);

                float3 Albedo = RGB115;
                float3 Normal = localWeightedBlend489.xyz;
                float3 Emission = 0;
                float3 Specular = 0.5;
                float Metallic = 0;
                float Smoothness = A115;
                float Occlusion = 1;
                float Alpha = 1;
                float AlphaClipThreshold = 0.5;
                float AlphaClipThresholdShadow = 0.5;
                float3 BakedGI = 0;
                float3 RefractionColor = 1;
                float RefractionIndex = 1;
                float3 Transmission = 1;
                float3 Translucency = 1;
                #ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
                #endif
            	

                InputData inputData = (InputData)0;
                inputData.positionWS = WorldPosition;
                inputData.viewDirectionWS = WorldViewDirection;


                #ifdef _NORMALMAP
                #if _NORMAL_DROPOFF_TS
                inputData.normalWS =
                    TransformTangentToWorld(Normal, half3x3(WorldTangent, WorldBiTangent, WorldNormal));
                #elif _NORMAL_DROPOFF_OS
					inputData.normalWS = TransformObjectToWorldNormal(Normal);
                #elif _NORMAL_DROPOFF_WS
					inputData.normalWS = Normal;
                #endif
                inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
                #else
					inputData.normalWS = WorldNormal;
                #endif

                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					inputData.shadowCoord = ShadowCoords;
                #elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
                #else
                inputData.shadowCoord = float4(0, 0, 0, 0);
                #endif
            	
                inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
                #if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
                #else
                float3 SH = IN.lightmapUVOrVertexSH.xyz;
                #endif

                #if defined(DYNAMICLIGHTMAP_ON)
				inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
                #else
                inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
                #endif

                #ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
                #endif

                inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);
                inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

                #if defined(DEBUG_DISPLAY)
                #if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
                #endif

                #if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
                #else
						inputData.vertexSH = SH;
                #endif
                #endif

            	inputData.bakedGI = lerp(half3(0.5, 0.5, 0.5), inputData.bakedGI, _GIContrast) * _GIIntensity;
            	
                SurfaceData surfaceData;
                surfaceData.albedo = Albedo * _EnvColor;
                surfaceData.metallic = saturate(Metallic);
                surfaceData.specular = Specular;
                surfaceData.smoothness = saturate(Smoothness),
                    surfaceData.occlusion = Occlusion,
                    surfaceData.emission = Emission,
                    surfaceData.alpha = saturate(Alpha);
                surfaceData.normalTS = Normal;
                surfaceData.clearCoatMask = 0;
                surfaceData.clearCoatSmoothness = 1;

            	//return half4(surfaceData.albedo, 1);
                half4 color = UniversalFragmentPBR(inputData, surfaceData);

                return color;
            }
            ENDHLSL
        }


        Pass
        {

            Name "DepthOnly"
            Tags
            {
                "LightMode"="DepthOnly"
            }

            ZWrite On
            ColorMask 0
            AlphaToMask Off

            HLSLPROGRAM
            #define _NORMAL_DROPOFF_TS 1
            #define _NORMALMAP 1


            #pragma vertex vert
            #pragma fragment frag

            #define SHADERPASS SHADERPASS_DEPTHONLY

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

           


            struct VertexInput
            {
                float4 vertex : POSITION;
                float3 ase_normal : NORMAL;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct VertexOutput
            {
                float4 clipPos : SV_POSITION;
                #if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
                #endif
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
                #endif

                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
            half4 _Control_ST;
            half4 _Splat0_ST;
            half4 _Splat1_ST;
            half4 _Splat2_ST;
            half4 _Splat3_ST;
            float _Smoothness0;
            float _Smoothness1;
            float _Smoothness2;
            float _Smoothness3;
            half _NormalIntensity0;
            half _NormalIntensity1;
            half _NormalIntensity2;
            half _NormalIntensity3;
            #ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
            #endif
            #ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
            #endif
            #ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
            #endif
            CBUFFER_END


            VertexOutput VertexFunction(VertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);


                #ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
                #else
                float3 defaultVertexValue = float3(0, 0, 0);
                #endif
                float3 vertexValue = defaultVertexValue;
                #ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
                #else
                v.vertex.xyz += vertexValue;
                #endif

                v.ase_normal = v.ase_normal;
                float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
                float4 positionCS = TransformWorldToHClip(positionWS);

                #if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
                #endif

                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
                #endif
                o.clipPos = positionCS;
                return o;
            }

           
            VertexOutput vert(VertexInput v)
            {
                return VertexFunction(v);
            }
            
            half4 frag(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

                #if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
                #endif
                float4 ShadowCoords = float4(0, 0, 0, 0);

                #if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
                #elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
                #endif
                #endif


                float Alpha = 1;
                float AlphaClipThreshold = 0.5;
                #ifdef ASE_DEPTH_WRITE_ON
				float DepthValue = 0;
                #endif

                #ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
                #endif

                #ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
                #endif
                #ifdef ASE_DEPTH_WRITE_ON
				outputDepth = DepthValue;
                #endif

                return 0;
            }
            ENDHLSL
        }


        Pass
        {

            Name "Meta"
            Tags
            {
                "LightMode"="Meta"
            }

            Cull Off

            HLSLPROGRAM
            #define _NORMAL_DROPOFF_TS 1
            #define _NORMALMAP 1


            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature _ EDITOR_VISUALIZATION

            #define SHADERPASS SHADERPASS_META

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            


            struct VertexInput
            {
                float4 vertex : POSITION;
                float3 ase_normal : NORMAL;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct VertexOutput
            {
                float4 clipPos : SV_POSITION;
                #if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
                #endif
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
                #endif
                #ifdef EDITOR_VISUALIZATION
				float4 VizUV : TEXCOORD2;
				float4 LightCoord : TEXCOORD3;
                #endif
                float4 ase_texcoord4 : TEXCOORD4;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
            half4 _Control_ST;
            half4 _Splat0_ST;
            half4 _Splat1_ST;
            half4 _Splat2_ST;
            half4 _Splat3_ST;
            float _Smoothness0;
            float _Smoothness1;
            float _Smoothness2;
            float _Smoothness3;
            half _NormalIntensity0;
            half _NormalIntensity1;
            half _NormalIntensity2;
            half _NormalIntensity3;
            #ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
            #endif
            #ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
            #endif
            #ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
            #endif
            CBUFFER_END
            sampler2D _Control;
            sampler2D _Splat0;
            sampler2D _Splat1;
            sampler2D _Splat2;
            sampler2D _Splat3;


            float4 WeightedBlend4143(half4 Weight, float4 Layer1, float4 Layer2, float4 Layer3, float4 Layer4)
            {
                return Layer1 * Weight.r + Layer2 * Weight.g + Layer3 * Weight.b + Layer4 * Weight.a;
            }


            VertexOutput VertexFunction(VertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.ase_texcoord4.xy = v.texcoord0.xy;

                //setting value to unused interpolator channels and avoid initialization warnings
                o.ase_texcoord4.zw = 0;

                #ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
                #else
                float3 defaultVertexValue = float3(0, 0, 0);
                #endif
                float3 vertexValue = defaultVertexValue;
                #ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
                #else
                v.vertex.xyz += vertexValue;
                #endif

                v.ase_normal = v.ase_normal;

                float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
                #if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
                #endif

                o.clipPos = MetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST,
                                               unity_DynamicLightmapST);

                #ifdef EDITOR_VISUALIZATION
				float2 VizUV = 0;
				float4 LightCoord = 0;
				UnityEditorVizData(v.vertex.xyz, v.texcoord0.xy, v.texcoord1.xy, v.texcoord2.xy, VizUV, LightCoord);
				o.VizUV = float4(VizUV, 0, 0);
				o.LightCoord = LightCoord;
                #endif

                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = o.clipPos;
				o.shadowCoord = GetShadowCoord( vertexInput );
                #endif
                return o;
            }

          
            VertexOutput vert(VertexInput v)
            {
                return VertexFunction(v);
            }

            half4 frag(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

                #if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
                #endif
                float4 ShadowCoords = float4(0, 0, 0, 0);

                #if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
                #elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
                #endif
                #endif

                half4 localBreakRGBA115 = (float4(0, 0, 0, 0));
                half2 uv_Control = IN.ase_texcoord4.xy * _Control_ST.xy + _Control_ST.zw;
                half4 tex2DNode6 = tex2D(_Control, uv_Control);
                float4 Weight143 = tex2DNode6;
                half2 uv_Splat0 = IN.ase_texcoord4.xy * _Splat0_ST.xy + _Splat0_ST.zw;
                half4 appendResult123 = (half4(1.0, 1.0, 1.0, _Smoothness0));
                float4 Layer1143 = (tex2D(_Splat0, uv_Splat0) * appendResult123);
                half2 uv_Splat1 = IN.ase_texcoord4.xy * _Splat1_ST.xy + _Splat1_ST.zw;
                half4 appendResult126 = (half4(1.0, 1.0, 1.0, _Smoothness1));
                float4 Layer2143 = (tex2D(_Splat1, uv_Splat1) * appendResult126);
                half2 uv_Splat2 = IN.ase_texcoord4.xy * _Splat2_ST.xy + _Splat2_ST.zw;
                half4 appendResult129 = (half4(1.0, 1.0, 1.0, _Smoothness2));
                float4 Layer3143 = (tex2D(_Splat2, uv_Splat2) * appendResult129);
                half2 uv_Splat3 = IN.ase_texcoord4.xy * _Splat3_ST.xy + _Splat3_ST.zw;
                half4 appendResult131 = (half4(1.0, 1.0, 1.0, _Smoothness3));
                float4 Layer4143 = (tex2D(_Splat3, uv_Splat3) * appendResult131);
                float4 localWeightedBlend4143 =
                    WeightedBlend4143(Weight143, Layer1143, Layer2143, Layer3143, Layer4143);
                half4 RGBA115 = localWeightedBlend4143;
                half3 RGB115 = float3(0, 0, 0);
                half A115 = 0;
                {
                    RGB115 = RGBA115.rgb;
                    A115 = RGBA115.a;
                }


                float3 Albedo = RGB115;
                float3 Emission = 0;
                float Alpha = 1;
                float AlphaClipThreshold = 0.5;

                #ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
                #endif

                MetaInput metaInput = (MetaInput)0;
                metaInput.Albedo = Albedo;
                metaInput.Emission = Emission;
                #ifdef EDITOR_VISUALIZATION
				metaInput.VizUV = IN.VizUV.xy;
				metaInput.LightCoord = IN.LightCoord;
                #endif

                return MetaFragment(metaInput);
            }
            ENDHLSL
        }


    }

    //CustomEditor "MTE.MTEShaderGUI"
    //Fallback "Hidden/InternalErrorShader"

}