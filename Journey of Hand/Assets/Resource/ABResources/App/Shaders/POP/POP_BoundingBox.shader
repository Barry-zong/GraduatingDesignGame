Shader "Universal Render Pipeline/POP/SIM/POP_BoundingBox" 
{
	Properties
	{
        // Shader properties
		_Color ("Main Color", Color) = (1,1,1,1)
        _Scale ("Scale", Vector) = (1, 1, 1, 0)
	}
	SubShader
	{
		Tags {
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
        }
        // Shader code
		Pass
        {
			Name "BoundingBox"
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Off

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderVariablesFunctions.hlsl"
            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float2 texcoord     : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float2 texcoord      : TEXCOORD0;
                float4 positionCS    : SV_POSITION;
                float4 positionOS    : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
            half4 _Color;
            float4 _Scale;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output = (Varyings)0;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionOS = input.positionOS;
                output.texcoord = input.texcoord;
                output.positionCS = vertexInput.positionCS;

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                half lineX = step(0.5 - 0.01/_Scale.x, input.positionOS.x) + step(0.5 - 0.01/_Scale.x, -input.positionOS.x);
                half lineY = step(0.5 - 0.01/_Scale.y, input.positionOS.y) + step(0.5 - 0.01/_Scale.y, -input.positionOS.y);
                half lineZ = step(0.5 - 0.01/_Scale.z, input.positionOS.z) + step(0.5 - 0.01/_Scale.z, -input.positionOS.z);
                half cornerX = step(0.5 - 0.05/_Scale.x, input.positionOS.x) + step(0.5 - 0.05/_Scale.x, -input.positionOS.x);
                half cornerX2 = step(0.5 - 0.1/_Scale.x, input.positionOS.x) + step(0.5 - 0.1/_Scale.x, -input.positionOS.x);
                half cornerY = step(0.5 - 0.05/_Scale.y, input.positionOS.y) + step(0.5 - 0.05/_Scale.y, -input.positionOS.y);
                half cornerY2 = step(0.5 - 0.1/_Scale.y, input.positionOS.y) + step(0.5 - 0.1/_Scale.y, -input.positionOS.y);
                half cornerZ = step(0.5 - 0.05/_Scale.z, input.positionOS.z) + step(0.5 - 0.05/_Scale.z, -input.positionOS.z);
                half cornerZ2 = step(0.5 - 0.1/_Scale.z, input.positionOS.z) + step(0.5 - 0.1/_Scale.z, -input.positionOS.z);

                half4 color = _Color*saturate(lineX*lineY + lineX*lineZ + lineY*lineZ + cornerX*cornerY*cornerZ2 + cornerX2*cornerY*cornerZ + cornerX*cornerY2*cornerZ);

                return color;
            }
			ENDHLSL
		}
	} 
}
