Shader "Universal Render Pipeline/POP/Common/Unlit Outline"
{
    Properties
    {

        [HDR]_BaseColor("BaseColor", Color) = (1,1,1,1)
        _BaseMap("BaseMap", 2D) = "white" {}
        [Space(18)]
        _OutlineColor("Outline Color", Color) = (0,0,0,1)

        _Outline("Outline Width", Range(.0,0.1)) = 0.01
        _OutlineOffset("Outline Offset", Range(0,0.1)) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "Lit" "IgnoreProjector" = "True" "ShaderModel"="4.5"
        }
        LOD 300

        Pass
        {
            Name "ForwardLit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
            
            Stencil
            {
                Ref 250
                Comp Always
                Pass Replace
            }

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5


            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float2 uv : TEXCOORD0;
                float4 positionHCS : SV_POSITION;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);


            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _BaseColor;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 mainTex = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);
                return mainTex * _BaseColor;
            }
            ENDHLSL
        }

        Pass
        {

            Name "Outline"

            Stencil
            {
                Ref 250
                Comp NotEqual
            }

            Tags
            {
                "LightMode" = "SRPDefaultUnlit"
            }
            Cull Front
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"


            float4 _OutlineColor;
            float _OutlineOffset;
            float _Outline;

            struct Attributes
            {
                float4 positionOS : POSITION;
                float4 normal : NORMAL;
                float4 tangent : TANGENT;
                half4 color : COLOR;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float3 normal : NORMAL;
            };


            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                float4 worldPos = half4(TransformObjectToWorld(IN.positionOS.xyz), 1);
                float4 viewPos = half4(TransformWorldToView(worldPos.xyz), 1);
                float cameraDis = length(viewPos.xyz);
                viewPos.xyz += normalize(normalize(viewPos.xyz)) * _OutlineOffset;
                OUT.positionHCS = TransformWViewToHClip(viewPos.xyz);

                //half3 worldNormal = TransformObjectToWorldDir(IN.normal);
                //half2 offset = TransformWorldToHClipDir(worldNormal).xy;

                float3 worldTangent = TransformObjectToWorldDir(IN.tangent).xyz;
                half2 offset = TransformWorldToHClipDir(worldTangent).xy;
                offset += offset * cameraDis * IN.color.g;
                OUT.positionHCS.xy += offset * _Outline * IN.color.a;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                return _OutlineColor;
            }
            ENDHLSL
        }
    }

}