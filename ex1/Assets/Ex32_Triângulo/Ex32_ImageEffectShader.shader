Shader "Custom/Ex32_ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Side ("Side", Range(0, 640)) = 100
        _Center ("Center", Vector) = (0, 0, 0, 0)
        _Rotation_triangle ("Rotation Triangle", Range(0, 360)) = 0
        _Rotation_uvs ("Rotation UVs", Range(0, 360)) = 0
    }
    SubShader
    {
        // nunca renderiza para a profundidade da tela
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
				v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float4 _MainTex_ST;;
            float _Side;
            float2 _Center;
            float _Rotation_triangle;
            float _Rotation_uvs;

            float2 rotatePoint(float2 p, float2 center, float angle)
            {
                float s = sin(angle);
                float c = cos(angle);

                // translate point back to origin
                p -= center;

                // rotate point
                float xnew = p.x * c - p.y * s;
                float ynew = p.x * s + p.y * c;

                // translate point back
                p.x = xnew + center.x;
                p.y = ynew + center.y;

                return p;
            }

            bool isInsideTriangle(float2 p, float2 p0, float2 p1, float2 p2)
            {
                float2 v0 = p2 - p0;
                float2 v1 = p1 - p0;
                float2 v2 = p - p0;

                float dot00 = dot(v0, v0);
                float dot01 = dot(v0, v1);
                float dot02 = dot(v0, v2);
                float dot11 = dot(v1, v1);
                float dot12 = dot(v1, v2);

                float invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01);
                float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
                float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

                return (u >= 0) && (v >= 0) && (u + v < 1);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);
                
                // corrigir posição do centro ao mover o rato na área clicada
                _Center.y = _ScreenParams.y - _Center.y;

                float angle = radians(_Rotation_triangle);
                
                float halfSide = _Side / 2.0;
                float2 p0 = float2(_Center.x, _Center.y + halfSide);
                float2 p1 = float2(_Center.x - halfSide, _Center.y - halfSide);
                float2 p2 = float2(_Center.x + halfSide, _Center.y - halfSide);

                // rodar vértices do triângulo à volta do centro
                p0 = rotatePoint(p0, _Center, angle);
                p1 = rotatePoint(p1, _Center, angle);
                p2 = rotatePoint(p2, _Center, angle);

                if (isInsideTriangle(i.vertex.xy, p0, p1, p2)) {
                    float angle = radians(_Rotation_uvs);
                    float2 rotatedUV = rotatePoint(i.uv, _Center / _ScreenParams.xy, angle);
                 
                    fixed4 color2 = tex2D(_MainTex, rotatedUV);
				    return 1 - color2;
                }
                
                return color;
            }

            ENDCG
        }
    }
}