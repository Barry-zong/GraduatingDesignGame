// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Universal Render Pipeline/POP/Common/UV_Scroll_AlphaTest"
{
    Properties
    {
        [Header(__ MainTex __)] [Space(10)]
        [HDR] _TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
        _MainTex("Particle Texture", 2D) = "white" {}
    // UV Scroll Spped
    _Speed("Speed", float) = 1
    _CutOff("CutOff", Range(0,1)) = 0.5


    }

        SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane"  "RenderPipeline" = "UniversalRenderPipeline"}
        Pass
        {
            Tags { "LightMode" = "UniversalForward" }
            Cull Off Lighting Off

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            struct Attributes
            {
                float4 positionOS   : POSITION;
                float4 color        : COLOR;
                float4 texcoord     : TEXCOORD0;
            };

            struct Varyings
            {
                float4 texcoord     : TEXCOORD0;
                float4 positionHCS  : SV_POSITION;
                float4 color        : COLOR;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            half4 _TintColor;
            float _Speed;
            half _CutOff;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.color = IN.color;
                OUT.texcoord.xy = TRANSFORM_TEX(IN.texcoord, _MainTex) + frac(float2(_Speed, 0) * _Time.y);

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 col = IN.color * _TintColor * SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.texcoord.xy);
                col.a = saturate(col.a);
                clip(col.a - _CutOff);
                return col;
            }
            ENDHLSL
        }
    }
}