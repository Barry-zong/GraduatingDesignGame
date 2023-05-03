// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Universal Render Pipeline/POP/Common/Cloud"
{
    Properties
    {
      [Header(__ Cloud __)] [Space(10)]
        [HDR] _TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
        _MainTex("Particle Texture", 2D) = "white" {}
        _CloudOpacityPow("Cloud Opacity Pow", Range(0, 10)) = 1
        _CloudOpacityScale("Cloud Opacity Scale", Range(0, 10)) = 1
        _ShadowRange("Shadow Range", Range(0, 1)) = 0
        _ShadowIntensity("Shadow Intensity", Range(0, 1)) = 0
        _BrightColor("Bright Color", Color) = (1,1,1,1)
        _DarkColor("Dark Color", Color) = (1,1,1,1)
        _BrightColor2("Bright Color2", Color) = (1,1,1,1)
        _DarkColor2("Dark Color2", Color) = (1,1,1,1)
        _ShadowColor("Shadow Color", Color) = (1,1,1,1)
        [HDR]_RimColor("Rim Color", Color) = (1,1,1,1)

        [Space(20)][Header(__ CloudFlow __)][Space(20)]
        _CloudSpeedX("Cloud Speed X", Range(-1, 1)) = 0
        _CloudSpeedY("Cloud Speed Y", Range(-1, 1)) = 0

        [Space(20)][Header(__ Distortion __)][Space(20)]
        _DistortionTex("Distortion Texture", 2D) = "white"{}
        _DistortionIntensity("Distortion Intensity", Range(0, 1)) = 0
        _DistortionSpeedX("Distortion Speed X", Range(-1, 1)) = 0
        _DistortionSpeedY("Distortion Speed Y", Range(-1, 1)) = 0


    }

        SubShader
        {
            Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane"  "RenderPipeline" = "UniversalRenderPipeline"}
            Pass
            {
                Tags { "LightMode" = "UniversalForward" }
                Blend SrcAlpha OneMinusSrcAlpha
            // ColorMask RGB

             Cull Off Lighting Off
             ZWrite Off

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
             TEXTURE2D(_DistortionTex);
             SAMPLER(sampler_DistortionTex);

             CBUFFER_START(UnityPerMaterial)
             float4 _MainTex_ST;
             float4 _DistortionTex_ST;
             half4 _TintColor;
             half _CloudOpacityPow, _CloudOpacityScale, _ShadowRange, _ShadowIntensity;
             half4 _BrightColor, _BrightColor2, _DarkColor, _DarkColor2, _ShadowColor, _RimColor;
             half _DistortionIntensity, _DistortionSpeedX, _DistortionSpeedY, _CloudSpeedX, _CloudSpeedY;
             CBUFFER_END

             Varyings vert(Attributes IN)
             {
                 Varyings OUT;
                 OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                 OUT.color = IN.color;
                 OUT.texcoord.xy = TRANSFORM_TEX(IN.texcoord, _MainTex) + frac(half2(_CloudSpeedX, _CloudSpeedY) * _Time.y);
                 OUT.texcoord.zw = TRANSFORM_TEX(IN.texcoord, _DistortionTex) + frac(half2(_DistortionSpeedX, _DistortionSpeedY) * _Time.y);
                 return OUT;
             }

             half4 frag(Varyings IN) : SV_Target
             {
                 //distortion
                 half4 distortion = SAMPLE_TEXTURE2D(_DistortionTex, sampler_DistortionTex, IN.texcoord.zw);
                 half2 distortion_uv = IN.texcoord.xy + distortion * _DistortionIntensity;
                 half4 col = IN.color * _TintColor * SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, distortion_uv);
                 half3 cloudColor1 = lerp(_DarkColor, _BrightColor, col.r).rgb;
                 half3 cloudColor2 = lerp(_DarkColor2, _BrightColor2, col.g).rgb;
                 half shadowRange = saturate(1 - smoothstep(0, _ShadowRange, col.r + col.g)) * _ShadowIntensity;
                 half4 finalColor = 0;
                 finalColor.rgb = (cloudColor1 + cloudColor2);
                 finalColor.rgb = lerp(finalColor.rgb, _ShadowColor.rgb, shadowRange);
                 finalColor.rgb += col.b * _RimColor.rgb * _RimColor.a;
                 col.a = saturate(col.a);
                 finalColor.a = pow(col.a, _CloudOpacityPow) * _CloudOpacityScale;

                 return finalColor;
             }
             ENDHLSL
         }
        }
}
