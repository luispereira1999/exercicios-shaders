Shader "Custom/Ex33_ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Center ("Center", Vector) = (0, 0, 0, 0)
        _Radius ("Radius", Range(0, 320)) = 50
        _Rotation ("Rotation", Range(0, 360)) = 0
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
            float2 _Center;
            float _Radius;
            float _Rotation;

            float2 rotatePoint(float2 pixel, float2 center, float angle)
            {
                float s = sin(angle);
                float c = cos(angle);

                // translate point back to origin
                pixel -= center;

                // rotate point
                float xnew = pixel.x * c - pixel.y * s;
                float ynew = pixel.x * s + pixel.y * c;

                // translate point back
                pixel.x = xnew + center.x;
                pixel.y = ynew + center.y;

                return pixel;
            }

            bool isInsideCircle(float2 center, float radius, float2 pixel)
            {
                float2 dist = pixel - center;
                return dot(dist, dist) <= radius * radius;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);
                
                // corrigir posição do centro ao mover o rato na área clicada
                _Center.y = _ScreenParams.y - _Center.y;

                if (isInsideCircle(_Center, _Radius, i.vertex.xy)) {
                    float angle = radians(_Rotation);
                    float2 newUv2 = rotatePoint(i.uv, _Center / _ScreenParams.xy, angle);

                    fixed4 color2 = tex2D(_MainTex, newUv2);
				    return 1 - color2;
                }

                return color;
            }

            ENDCG
        }
    }
}