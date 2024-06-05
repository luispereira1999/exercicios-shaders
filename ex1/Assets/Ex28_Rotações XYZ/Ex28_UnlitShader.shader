Shader "Unlit/Ex28_UnlitShader"
{
    Properties
    {
        [KeywordEnum(X, Y, Z)]
        _RotationSide ("Rotation", Int) = 0
        _SliderAngles ("Angles", Range(0, 360)) = 0
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature _ROTATIONSIDE_X _ROTATIONSIDE_Y _ROTATIONSIDE_Z

            #include "UnityCG.cginc"

            struct appdata {
                float2 uv: TEXCOORD0;
                float4 vertex: POSITION;
            };

            struct v2f {
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            int _RotationSide;
            float _SliderAngles;

            float convertAnglesToRadians(float angles) {
                return angles * UNITY_PI / 180;
            }

            float3 rotateX(float3 op, float rot) {
                float3x3 matrixRotX = {
                    1, 0, 0,
                    0, cos(rot), -sin(rot),
                    0, sin(rot), cos(rot)
                };

                return mul(matrixRotX, op);
            }

            float3 rotateY(float3 op, float rot) {
                float3x3 matrixRotY = {
                    cos(rot), 0, sin(rot),
                    0, 1, 0,
                    -sin(rot), 0, cos(rot)
                };

                return mul(matrixRotY, op);
            }

            float3 rotateZ(float3 op, float rot) {
                float3x3 matrixRotZ = {
                    cos(rot), -sin(rot), 0,
                    sin(rot), cos(rot), 0,
                    0, 0, 1
                };

                return mul(matrixRotZ, op);
            }

            v2f vert(appdata v) {
                v2f o;

#ifdef _ROTATIONSIDE_X
                v.vertex.xyz = rotateX(v.vertex, convertAnglesToRadians(_SliderAngles));
#elif _ROTATIONSIDE_Y
                v.vertex.xyz = rotateY(v.vertex, convertAnglesToRadians(_SliderAngles));
#elif _ROTATIONSIDE_Z
                v.vertex.xyz = rotateZ(v.vertex, convertAnglesToRadians(_SliderAngles));
#endif

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag(v2f i): SV_Target {
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}