Shader "Custom/Ex30_ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Side ("Side Square", Range(0, 640)) = 100
        _Center ("Center", Vector) = (0, 0, 0, 0)
        _Stretch_factor ("Stretch Factor", Range(0.1, 5.0)) = 1.5
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
            float _Stretch_factor;

            int isInsideSquare(float2 center, float side, float2 pixel) {
				if (pixel.x > center.x - side && pixel.x < center.x + side &&
                    pixel.y > center.y - side && pixel.y < center.y + side) {
					return 1;
				} else {
				    return 0;
                }
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);

                // corrigir posição do centro ao mover o rato na área clicada
                _Center.y = _ScreenParams.y - _Center.y;

                // 1 - reduzir / ampliar
                if (isInsideSquare(_Center, _Side, i.vertex)) {
                    float2 newUv2 = i.uv;

                    newUv2.x = (newUv2.x - _Center.x / _ScreenParams.x) / _Stretch_factor + _Center.x / _ScreenParams.x;
                    newUv2.y = (newUv2.y - _Center.y / _ScreenParams.y) / _Stretch_factor + _Center.y / _ScreenParams.y;
                    newUv2 = clamp(newUv2, 0.0, 1.0);

                    fixed4 color2 = tex2D(_MainTex, newUv2);
                    return color2;
                }

                return color;
            }

            ENDCG
        }
    }
}