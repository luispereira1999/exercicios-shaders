Shader "Custom/Ex34_ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        _PointA ("Point A", Vector) = (200, 100, 0)
        _PointB ("Point B", Vector) = (500, 100, 0)
        _PointB ("Point C", Vector) = (400, 200, 0)
        
        _Thickness ("Thickness", Range(0, 10)) = 4

        _BorderColor ("Border Color", Color) = (1, 0, 0, 1)
        _FillColor ("Fill Color", Color) = (0, 0, 1, 1)

        [Toggle] _IsLineSet ("Is Line Set", Int) = 0
        [Toggle] _IsTriangleSet ("Is Triangle Set", Int) = 0
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
            
            float2 _PointA;
            float2 _PointB;
            float2 _PointC;
            
            float _Thickness;
            
            float4 _BorderColor;
            float4 _FillColor;

            int _IsLineSet;
            int _IsTriangleSet;

            bool isNearLine(float2 p, float2 a, float2 b, float thickness)
            {
                float2 ab = b - a;
                float2 ap = p - a;
                float2 bp = p - b;

                float2 abNorm = ab / length(ab);
                float projection = dot(ap, abNorm);
                float2 closestPoint = a + projection * abNorm;

                float distance = length(p - closestPoint);

                float lineLength = length(ab);
                bool withinSegment = projection >= 0 && projection <= lineLength;

                return distance <= thickness && withinSegment;
            }

            bool isPointInTriangle(float2 p, float2 a, float2 b, float2 c)
            {
                float2 v0 = c - a;
                float2 v1 = b - a;
                float2 v2 = p - a;

                float dot00 = dot(v0, v0);
                float dot01 = dot(v0, v1);
                float dot02 = dot(v0, v2);
                float dot11 = dot(v1, v1);
                float dot12 = dot(v1, v2);

                float invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01);
                float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
                float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

                return (u >= 0) && (v >= 0) && (u + v <= 1);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 mainColor = tex2D(_MainTex, i.uv);

                if (_IsLineSet == 0)
                {
                    return mainColor;
                }

                // corrigir posição do centro ao mover o rato na área clicada
                _PointA.y = _ScreenParams.y - _PointA.y;
                _PointB.y = _ScreenParams.y - _PointB.y;
                _PointC.y = _ScreenParams.y - _PointC.y;
                
                if (isNearLine(i.vertex, _PointA, _PointB, _Thickness)) {
                    return _BorderColor;
                }

                if (_IsTriangleSet == 0)
                {
                    return mainColor;
                }

                if (isNearLine(i.vertex, _PointA, _PointB, _Thickness) || 
                    isNearLine(i.vertex, _PointB, _PointC, _Thickness) ||
                    isNearLine(i.vertex, _PointC, _PointA, _Thickness)) {
                    return _BorderColor;
                }

                if (isPointInTriangle(i.vertex, _PointA, _PointB, _PointC)) {
                    return _FillColor;
                }
                
                return mainColor;
            }

            ENDCG
        }
    }
}