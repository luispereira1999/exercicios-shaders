Shader "Custom/Ex25_SurfaceShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
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
                float2 uv : TEXCOORD0;
          
                float4 vertex : SV_POSITION;
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
                fixed4 col = tex2D(_GrabTexture, i.uv);
                
                // 1 - inverter cores
                // col = 1 - col;

                // 2 - preto e branco
                col.xyz = float3((col.r + col.g + col.b) / 3, (col.r + col.g + col.b) / 3, (col.r + col.g + col.b) / 3);

                return col;
            }
            ENDCG
        }
    }
}