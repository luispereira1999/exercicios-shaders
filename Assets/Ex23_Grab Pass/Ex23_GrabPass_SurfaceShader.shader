Shader "Custom/Ex23_GrabPass_UnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        LOD 200

        GrabPass{}

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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _GrabTexture;
            float4 _GrabTexture_ST;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _GrabTexture);
            
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // textura
                fixed4 col = tex2D(_GrabTexture, i.uv);
                
                // 1 - inverter cores
                // col = 1 - col;

                // 2 - cores a preto e branco
                col.xyz = float3((col.r + col.g + col.b) / 3, (col.r + col.g + col.b) / 3, (col.r + col.g + col.b) / 3);
                
                // 3 - tudo a vermelho
                col.xyz = float3(col.r, 0, 0);

                return col;
            }
            ENDCG
        }
    }
}