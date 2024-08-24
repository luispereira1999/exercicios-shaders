Shader "Custom/Ex36_UnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Stretch ("Stretch", Range(0, 2.0)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

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
                float3 localPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Stretch;

            v2f vert (appdata v)
            {
                v2f o;

                // aplica o efeito de esticar ou espremer
                float4 stretchedVertex = v.vertex;
                stretchedVertex.x *= _Stretch;
                o.vertex = UnityObjectToClipPos(stretchedVertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.localPos = stretchedVertex.xyz;
             
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 textureColor = tex2D(_MainTex, i.uv);
                float mixFactor = step(0.0, i.localPos.x);
               
                // float mixFactor =  step(0.0, i.worldPos.x);
                fixed4 finalColor = lerp(fixed4(0, 0, 1, 1), fixed4(1, 0, 0, 1), mixFactor);
                return textureColor * finalColor;
            }

            ENDCG
        }
    }
}