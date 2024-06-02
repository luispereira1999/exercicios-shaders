Shader "Custom/Ex26_ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Slider_side ("Slider Side", Range(0, 640)) = 100
        // rotação é em radianos
        _Slider_rotation ("Slider Rotation", Range(0, 6.3)) = 1
        _Center ("Center", Vector) = (0, 0, 0, 0)
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
            float _Slider_side;
            float _Slider_rotation;
            float2 _Center;

            int isInsideSquare(float2 center, float side, float2 pixel) {
				if (pixel.x > center.x - side && pixel.x < center.x + side &&
                    pixel.y > center.y - side && pixel.y < center.y + side) {
					return 1;
				} else {
				    return 0;
                }
            }

            float2 rotate90(float2 origin) {
                float2x2 rotation = { 0, -1,
                                      1, 0 };

                return mul(rotation, origin);
            }

            float2 rotate(float2 origin, float angle) {
                float2x2 rotation = { cos(angle), sin(angle),
                                    -sin(angle), cos(angle) };

                return mul(rotation, origin);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);

                // 1 - rodar em 90 graus
                // corrigir posição do centro ao clicar
                _Center.y = _ScreenParams.y - _Center.y;

                if (isInsideSquare(_Center, _Slider_side, i.vertex)) {
                    // 1 - rotações é em radianos
                    // float2 newUv = rotate90(i.uv);
                    float2 newUv = rotate(i.uv, _Slider_rotation);

                    fixed4 color2 = tex2D(_MainTex, newUv);


                    // 2 - efeito de ondas
                    // if (isInsideSquare(_Center, _Slider_side / 2, i.vertex)) {
                    //     return color;
                    // }


                    // 3 - efeito de mover a imagem que está dentro do quadrado de cima para baixo
                    // if (isInsideSquare(_Center, _Slider_side / 2, i.vertex)) {
                    //     float2 newUv = i.uv;
                    //     newUv.y += sin(_Time.w);
                    //     fixed4 color3 = tex2D(_MainTex, newUv);
                    //     return color3;
                    // }


                    // 4 - efeito de mover a imagem que está dentro do quadrado em várias direções
                    if (isInsideSquare(_Center, _Slider_side / 2, i.vertex)) {
                        float2 newUv2 = i.uv * (1.5 * float2(sin(_Time.y), cos(_Time.y)));
                        fixed4 color3 = tex2D(_MainTex, newUv2);
                        return color3;
                    }

                    return color2;
                }

                return color;
            }

            ENDCG
        }
    }
}