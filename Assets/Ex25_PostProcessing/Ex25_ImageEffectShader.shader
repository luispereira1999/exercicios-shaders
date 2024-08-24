Shader "Custom/Ex25_ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Slider_x ("Slider X", Range(0, 640)) = 15

        // para usar com a solução com screen params
        // _Slider_side ("Slider Side", Range(0, 640)) = 100
        // para usar com a solução com uvs
        _Slider_side ("Slider Side", Range(0, 1)) = 0.2
     
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
            float _Slider_x;
            float _Slider_side;
            float2 _Center;

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
                fixed4 col = tex2D(_MainTex, i.uv);
                
                // 1 - verificar onde é o ponto (0, 0), que se verifica ser na canto inferior esquerdo
                if (i.uv.x < 0.05 && i.uv.y < 0.05) {
                    return 1 - col;
                }


                // 2 - desenhar um quadrado através das uvs
                // if (isInsideSquare(float2(0.5, 0.5), 0.2, i.uv)) {
                //     return 1 - col;
                // }


                // 3 - preenche o eixo x consoante a resolução do ecrã
                // i.vertex: usa a resolução do ecrã
                if (i.vertex.x < _Slider_x) {
                    return 1 - col;
                }


                // 4 - desenhar um quadrado através dos vértices,
                // usar os valores consoante o tamanho do ecrã
                // if (isInsideSquare(float2(320, 240), 100, i.vertex)) {
                //     return 1 - col;
                // }


                // 5 - desenhar um quadrado através dos vértices,
                // _ScreenParams: usar os valores através da textura que a câmera devolve
                // if (isInsideSquare(float2(_ScreenParams.x / 2, _ScreenParams.y / 2), 100, i.vertex)) {
                //     return 1 - col;
                // }


                // 6 - desenhar um quadrado através dos vértices e slider para o tamanho do quadrado,
                // _ScreenParams: usar os valores através da textura que a câmera devolve
                // if (isInsideSquare(float2(_ScreenParams.x / 2, _ScreenParams.y / 2), _Slider_side, i.vertex)) {
                //     return 1 - col;
                // }


                // 7 - desenhar um quadrado dado um centro e mudar a posição via script - solução com screen params
                // corrigir posição do centro ao clicar
                // _Center.y = _ScreenParams.y - _Center.y;

                // if (isInsideSquare(_Center, _Slider_side, i.vertex)) {
                //     return 1 - col;
                // }


                // 8 - desenhar um quadrado dado um centro e mudar a posição via script - solução com uvs
                // corrigir posição do centro ao clicar
                if (isInsideSquare(_Center, _Slider_side, i.uv)) {
                    return 1 - col;
                }

                return col;
            }

            ENDCG
        }
    }
}