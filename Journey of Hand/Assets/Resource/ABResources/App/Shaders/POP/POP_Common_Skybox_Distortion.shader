// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Universal Render Pipeline/POP/Common/Skybox Distortion"
{
    Properties
    {
        _Tint ("Tint Color", Color) = (.5, .5, .5, .5)
        [Gamma] _Exposure ("Exposure", Range(0, 8)) = 1.0
       // _Rotation ("Rotation", Range(0, 360)) = 0
        [NoScaleOffset] _Tex ("Cubemap   (HDR)", Cube) = "grey" {}
    }

    SubShader
    {
        Tags
        {
            "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox"
        }
        Cull Off ZWrite Off

        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #define _UpperHemisphere    _FlowmapParam.x
            #define _ScrollFactor       _FlowmapParam.y
            #define _ScrollDirection    _FlowmapParam.zw

            #include "UnityCG.cginc"

            samplerCUBE _Tex;
            half4 _Tex_HDR;
            half4 _Tint;
            half _Exposure;
            float _Rotation;
            float4 _FlowmapParam; // x upper hemisphere only, y scroll factor, zw scroll direction (cosPhi and sinPhi)

            float3 RotateAroundYInDegrees(float3 vertex, float degrees)
            {
                float alpha = degrees * UNITY_PI / 180.0;
                float sina, cosa;
                sincos(alpha, sina, cosa);
                float2x2 m = float2x2(cosa, -sina, sina, cosa);
                return float3(mul(m, vertex.xz), vertex.y).xzy;
            }

            struct appdata_t
            {
                float4 vertex : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 texcoord : TEXCOORD0;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert(appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                float3 rotated = RotateAroundYInDegrees(v.vertex.xyz, _Rotation);
                o.vertex = UnityObjectToClipPos(rotated);
                o.texcoord = v.vertex.xyz;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                if (i.texcoord.y >= 0 || !_UpperHemisphere)
                {
                    half2 alpha = frac(float2(_ScrollFactor, _ScrollFactor + 0.5)) - 0.5;
                    half3 windDir = float3(_ScrollDirection.x, 0.0f, _ScrollDirection.y);
                    half3 dd = windDir * sin(i.texcoord.y * UNITY_PI * 0.5);

                    //sample twice
                    half4 color1 = texCUBE(_Tex, i.texcoord + alpha.x * dd);
                    half4 color2 = texCUBE(_Tex, i.texcoord + alpha.y * dd);
                    color1.rgb = DecodeHDR(color1, _Tex_HDR).rgb;
                    color2.rgb = DecodeHDR(color2, _Tex_HDR).rgb;

                    //blend color samples
                    half4 finalColor = lerp(color1, color2, abs(2.0 * alpha.x));
                    finalColor.rgb = finalColor.rgb * _Tint * unity_ColorSpaceDouble.rgb;
                    finalColor.rgb *= _Exposure;
                    return finalColor;
                }
                else
                {
                    half4 tex = texCUBE(_Tex, i.texcoord);
                    half3 c = DecodeHDR(tex, _Tex_HDR);
                    c = c * _Tint.rgb * unity_ColorSpaceDouble.rgb;
                    c *= _Exposure;
                    return half4(c, 1);
                }
                
               
            }
            ENDCG
        }
    }


    Fallback Off

}