Shader "Universal Render Pipeline/POP/SIM/Scene/ChocolateLiquid"
{
    Properties
    {
        [Header(__ Textures __)][Space(30)]
        _Caustics ("Caustics", 2D) = "white" {}
        _FoamNoise ("Foam Noise", 2D) = "white" {}
        _NrmTex ("Nomal1", 2D) = "bump" {}
        
        [Space(20)][Header(__ Normal __)][Space(30)]
        _NrmIntensity ("Normal Intensity", Range(0 ,1)) = 1.0
        _NrmFlow ("Normal Flow", Range(-10, 10)) = 1.0
        _NrmRepeat("Normal Repeat", Range(0.01, 0.5)) = 1

        [Space(20)][Header(__ Lighting __)][Space(30)]
        _EnvCubemap("Env Cubemap", Cube) = "white" {}
        _EnvRotate("Reflection Rotate", Range(0, 360)) = 0
        _ReflectionBlur("Reflection Blur", Range(0, 1)) = 1.0
        _ReflectionStrength("Reflection Strength", Range(0, 5)) = 1.0

        [Space(20)][Header(__ Under Water __)][Space(30)]
        _WaterLevel("Water Level",Range(0, 8))= 0
        _DepthExp("Depth Exp",Range(0, 40)) = 1
        _RefractPow("Refract Pow",Float) = 1
        _ShallowColor("Shallow Color", Color) = (1,1,1,1)
        _BaseColor("Base Color", Color) = (1,1,1,1)
        _FogDistance("Fog Distance", Range(0, 20)) = 1
        _FogColor("Fog Color",Color)=(1,1,1,1)
        
        
        [Space(20)][Header(__ Caustics __)][Space(30)]
        _CausticsTill("Caustics Till",Float) = 1
        _CausticsIntensity("Caustics Intensity",Float) = 1
        _CausticsFlow("Caustics Flow",Float) = 1
        
        [Space(20)][Header(__ Foam __)][Space(30)]
        [HDR]_FoamColor("Foam Color", Color) = (1,1,1,1)
        _FoamRange("Foam Range", Range(0, 1)) = 1.0
        _RipplePow("Ripple Pow", Range(0, 20)) = 1.0
        _FoamMaskBlend("Foam Mask Blend", Range(0, 1)) = 1.0
        _FoamNoiseRepeatX("Foam Noise Repeat X", Range(0,10)) = 1
        _FoamNoiseRepeatY("Foam Noise Repeat Y", Range(0,10)) = 1
        _FoamDissolve("Foam Dissolve", Range(0, 1)) = 0
        _FoamTilling("Foam Tilling", Range(0, 40)) = 1.0
        _FoamFlowSpeed("Foam Flow Speed", Range(-10, 10)) =1.0

    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "LightMode"="UniversalForward"
            "Queue"="Transparent"
            "RenderPipeline" = "UniversalPipeline"
        }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
           // #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            /*#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _LIGHT_COOKIES
            #pragma multi_compile _ _CLUSTERED_RENDERING*/

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareOpaqueTexture.hlsl"

            #define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR

            sampler2D _NrmTex;
            sampler2D _Caustics;
            sampler2D _FoamNoise;
            sampler2D _IntersectionNoise;
            sampler2D _CameraDepthTexture;
            sampler2D _CameraColorTexture;

            samplerCUBE _EnvCubemap;
            float4  _EnvCubemap_HDR;



            CBUFFER_START(UnityPerMaterial)
            float4 _NrmTex_ST;
            float4 _FoamNoise_ST;
            float _NrmIntensity;
            float _NrmFlow;
            
            float _WaterLevel;
            float _DepthExp;

            float4 _ShallowColor;
            float4 _BaseColor;
            float _RefractPow;
            float _CausticsTill;
            float _CausticsIntensity;
            float _CausticsFlow;
            float _FogDistance;
            float4 _FogColor;

            float _FoamRange;
            float _FoamMaskBlend;
            float _FoamNoiseRepeatX, _FoamNoiseRepeatY;
            float _FoamDissolve;
            float _FoamTilling;
            float _FoamFlowSpeed;

            float _EnvRotate;
            float _ReflectionBlur;
            float _ReflectionStrength;

            float _FoamTiling;
            float _FoamSpeed;
            float _FoamWaveMask;
            float _FoamWaveMaskExp;
            float _FoamSize;
            float3 _FoamColor;
            float _NrmRepeat;
            sampler2D ADS_TurbulenceTex;
            CBUFFER_END
            
            #include "lighting.hlsl"
            #include "uv.hlsl"
            #include "water_depth.hlsl"

            struct attributes
            {
                float4 posOS: POSITION;
                float3 nrmOS: NORMAL;
                float4 tangent: TANGENT;
                float2 uv: TEXCOORD0;
                float4 color: COLOR0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 posHCS                   : SV_POSITION;
                float4 screenPos                : TEXCOORD0;
                float4 uv                       : TEXCOORD1;
                float4 TtoW0                    : TEXCOORD2;
                float4 TtoW1                    : TEXCOORD3;
                float4 TtoW2                    : TEXCOORD4;
                float4 vertN_height             : TEXCOORD5;
                float4 positionCS               : TEXCOORD6;
                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                    float4 shadowCoord          : TEXCOORD7;
                #endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


            v2f vert(attributes i)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(i);
                UNITY_TRANSFER_INSTANCE_ID(i, o);
                // 必要信息
                VertexPositionInputs posInputs = GetVertexPositionInputs(i.posOS.xyz);
                VertexNormalInputs nrmInputs = GetVertexNormalInputs(i.nrmOS.xyz, i.tangent);

                float3 tngWS = nrmInputs.tangentWS;
                float3 BinWS = nrmInputs.bitangentWS;
                float3 nrmWS = nrmInputs.normalWS;
                float3 posWS = posInputs.positionWS;
                o.vertN_height.xyz = nrmWS;

                ///// UV传递 /////
                o.uv.xy = posInputs.positionWS.xz;
                o.uv.zw = o.uv.xy * _NrmRepeat;

                ///// 数据输出：TBN矩阵、裁剪坐标、屏幕坐标 /////
                o.TtoW0 = float4(tngWS.x, BinWS.x, nrmWS.x, posWS.x);
                o.TtoW1 = float4(tngWS.y, BinWS.y, nrmWS.y, posWS.y);
                o.TtoW2 = float4(tngWS.z, BinWS.z, nrmWS.z, posWS.z);

                o.posHCS = TransformWorldToHClip(posWS);
                o.screenPos = ComputeScreenPos(o.posHCS);

                ///// SSR相关 /////
                float4 screenP = o.posHCS;
                screenP.xyz /= screenP.w;
                screenP.xy = screenP.xy * 0.5 + 0.5;
                o.positionCS = screenP;
                //#if UNITY_UV_STARTS_AT_TOP
                o.positionCS.y = 1 - o.positionCS.y;
                //#endif
                float zFar = _ProjectionParams.z;

                #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                    o.shadowCoord = TransformWorldToShadowCoord(posInputs.positionWS);
                #endif

                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                ///// 必要信息 /////
                half3 N_vert_ori = normalize(i.vertN_height.xyz); // 获取世界法线(原始顶点) 
                half3 posWS = half3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w); // 获取世界顶点位置
                half3 V = normalize(GetCameraPositionWS() - posWS); // 获取视线向量

                ///// 法线纹理混合 /////
                half4 Nrm_UV = PackedUV(i.uv.zw, _Time.xx, _NrmFlow);
                half3 nrm1 = UnpackNormal(tex2D(_NrmTex, i.uv.xy/ 2 * _NrmRepeat)); // 法线纹理1
                half3 nrm2 = UnpackNormal(tex2D(_NrmTex, Nrm_UV.zw)); // 法线纹理2
                nrm1 = BlendNormal(nrm1, nrm2); // 对冲纹理混合
                nrm1 = lerp(half3(0, 0, 1), nrm1, _NrmIntensity);
                half3 N = normalize(half3(dot(i.TtoW0.xyz, nrm1), dot(i.TtoW1.xyz, nrm1), dot(i.TtoW2.xyz, nrm1))); // 获取世界法线纹理
                
                ///获取深度纹理
                half2 screenUV = i.screenPos.xy / i.screenPos.w;
                half sceneRawDepth = tex2D(_CameraDepthTexture, screenUV).r;
                half sceneDepthVS = LinearEyeDepth(sceneRawDepth, _ZBufferParams);

                //获取海底颜色
                half3 cameraColorTexture = SampleSceneColor(screenUV);

                ///计算散射深度
                half3 opaqueWorldPos = posWS;
                opaqueWorldPos = DecalSpaceWorldPos(i.screenPos, GetCameraPositionWS() - posWS, sceneDepthVS);
                half opaqueDist = DepthDistance(posWS, opaqueWorldPos, N_vert_ori);
                half AbsorptionDepth = clamp(0, 1, pow((opaqueDist / _WaterLevel), _DepthExp));

                ///计算反射
                half3 reflect_vec = normalize(reflect(-V, N));
                float theta = _EnvRotate * PI / 180.0;
                float2x2 m_rot = float2x2(cos(theta), -sin(theta),
                                sin(theta), cos(theta));
                float2 dir_rata = mul(m_rot, reflect_vec.xz);
                reflect_vec = float3(dir_rata.x, reflect_vec.y, dir_rata.y);
                //half relfect_fresnel = pow(1 - abs(dot(V, N)), 5.0); // 模拟F项
                //relfect_fresnel = lerp(0.1, 1.0, relfect_fresnel); // 模拟F0
                float4 ssr_cor = texCUBElod(_EnvCubemap, half4(reflect_vec, _ReflectionBlur));
                ssr_cor.rgb = DecodeHDREnvironment(ssr_cor, _EnvCubemap_HDR);
                ssr_cor = ssr_cor * _ReflectionStrength;
                
                //岸边泡沫
                half foamNoise01 = tex2D(_FoamNoise, i.uv * half2(_FoamNoiseRepeatX, _FoamNoiseRepeatY) + half2(_Time.x * 4, 0));
                half foamNoise02 = tex2D(_FoamNoise, i.uv * half2(_FoamNoiseRepeatX / 2, _FoamNoiseRepeatY / 2) + half2(0, - _Time.x * 4));
                half foamNoise = foamNoise01 * foamNoise02;
                half foamRange_term = clamp(0, 1, (opaqueDist) / _FoamRange);
                half foamMask = 1 - smoothstep(_FoamMaskBlend, 1, foamRange_term);
                half3 foam = sin((1 - foamRange_term) * _FoamTilling + _Time.y * _FoamFlowSpeed) + 2 * foamNoise01;
                foam = foam * foamMask;
                foam = foam - _FoamDissolve;
                foam = step(0, foam);
                foam = foam * _FoamColor.rgb;
              
                
                ///焦散部分///
                half3 caustics = SampleCaustics(opaqueWorldPos, _CausticsTill, _CausticsFlow) * _CausticsIntensity;
                half causticsMask = AbsorptionDepth;

                ///远距水雾///
                half distant_fog = saturate((sceneDepthVS - i.screenPos.w) / _FogDistance);
                
                ///基础颜色
                half4 baseColor = lerp(_ShallowColor, _BaseColor, AbsorptionDepth);
                baseColor.rgb = lerp(cameraColorTexture, baseColor.rgb, baseColor.a);

                ///主光源
                Light light = GetMainLight();
                half shadowAttenuation = GetShadows(posWS);

                half4 finalColor = baseColor;
                finalColor.xyz = finalColor.xyz * light.color * shadowAttenuation;
                finalColor.xyz  = lerp((finalColor.xyz + caustics * baseColor.a) * (shadowAttenuation + 0.6f), finalColor.xyz, causticsMask);
                finalColor.xyz  = lerp(finalColor.xyz, _FogColor.xyz * (shadowAttenuation + 0.4f), distant_fog * _FogColor.w);
                finalColor.xyz += ssr_cor;
                finalColor.xyz *= (1 - saturate(foam));
                finalColor.xyz += foam * (shadowAttenuation + 0.3f);
                finalColor.a += foam;
                
                return finalColor;
                
                
                
                
                
         
            }
            ENDHLSL
        }
    }
}