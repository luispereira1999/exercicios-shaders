Shader "Custom/Ex31_ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Side ("Side Square", Range(0, 640)) = 100
        _Center ("Center", Vector) = (0, 0, 0, 0)
        _Stretch_factor ("Stretch Factor", Range(0.1, 5.0)) = 1.5
        _SelectedColor ("Selected Color", Color) = (1, 1, 1, 1)
        _ReplacedColor ("Replaced Color", Color) = (1, 1, 1, 1)
        _Desaturation ("Desaturation", Range(0, 3)) = 1.5
        _Tolerance ("Tolerance", Range(-1, 3)) = 1
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
			float4 _MainTex_TexelSize;
            float4 _MainTex_ST;;
            float _Side;
            float2 _Center;
            float _Stretch_factor;
			fixed4 _SelectedColor;
			fixed4 _ReplacedColor;
			float _Desaturation;
			float _Tolerance;

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
                    fixed4 color2 = tex2D(_MainTex, newUv2);

                    // quão brilhante uma cor parece ser
				    fixed3 lum = Luminance(color2.rgb) * _Desaturation;
				    fixed3 col = _SelectedColor.rgb;
				  
                    if(color2.r < col.r + _Tolerance && color2.r > col.r - _Tolerance &&
					    color2.g < col.g + _Tolerance && color2.g > col.g - _Tolerance &&
					    color2.b < col.b + _Tolerance && color2.b > col.b - _Tolerance)
					    lum.rgb = _ReplacedColor.rgb;

				    return fixed4(lum.rgb, color2.a);
                }

                return color;
            }

            ENDCG
        }
    }
}