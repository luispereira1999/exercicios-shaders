Shader "Custom/Ex24_Watermelon_Shader"
{
    Properties
    {
        _MainTex ("Casca", 2D) = "white" {}
        _Interior("interior",2D) = "white" {}
        _Slider("how much",Range(-0.4,0.5)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
     

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv_interior : TEXCOORD1;
                float3 posicaoLocal : TEXCOORD2;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _Interior;
            float4 _Interior_ST;

            float _Slider;
            v2f vert (appdata v)
            {
                v2f o;

                if(v.vertex.y >= _Slider){
                    v.vertex.y = _Slider;
                }

                o.posicaoLocal = v.vertex.xyz;

                o.vertex = UnityObjectToClipPos(v.vertex);
              
                o.normal = v.normal;

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv_interior = TRANSFORM_TEX(v.uv, _Interior);
              
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col2 = tex2D(_Interior, i.uv_interior);
            
                if(i.posicaoLocal.y >= _Slider-0.001){
                   return col2;
                }
                //if(i.normal.y >0.2 && i.normal.x < 0.1 && i.normal.z <0.1){
                //    return col2;
                //}
                return col;
            }
            ENDCG
        }
    }
}
