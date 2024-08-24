Shader "Custom/Ex24_ImageEffectShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Slider ("Slider", Range(-1, 2)) = 1
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
            float _Slider;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                // versão 1 - efeito SimCity
                // col.rbg = float3(col.r+(col.b+col.g)/3,(col.r+col.b+col.g)/3,(col.r+col.b+col.g)/3);


                // versão 2 - efeito SimCity
                // float gray = (col.r + col.g + col.b) / 3;

                // if (col.r > gray)
                // {
                //     col.r = 1.0;
                // }
                // else
                // {
                //     col.r = col.g = col.b = gray;
                // }


                // versão 3 - efeito SimCity
                if (col.r < col.g + _Slider && col.r < col.b + _Slider) {
                    col.rgb = float3((col.r+col.g+col.b)/3,(col.r+col.g+col.b)/3,(col.r+col.g+col.b)/3);
                }
                
                return col;
            }

            ENDCG
        }
    }
}