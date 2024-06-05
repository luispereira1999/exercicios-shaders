Shader "Custom/Ex35_UnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
      
        _TopColor ("Top Color", Color) = (1, 0, 0, 1)
        _BottomColor ("Bottom Color", Color) = (0, 0, 1, 1)
        _VerticalLimit ("Vertical Limit", Range(0, 1)) = 0.5

        _FresnelColor ("Fresnel Color", Color) = (1, 1, 1, 1)
        _FresnelPower ("Fresnel Power", Range(0.1, 5.0)) = 1

        _ChaosStrength ("Chaos Strength", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            sampler2D _MainTex;
            sampler2D _MainTex_ST;

            float4 _TopColor;
            float4 _BottomColor;
            float _VerticalLimit;

            float4 _FresnelColor;
            float _FresnelPower;

            float _ChaosStrength;

            v2f vert (appdata v)
            {
                v2f o;

                // aplicar efeito caótico
                if (v.uv.y > 0.5)
                {
                    float3 noise = float3(
                        frac(sin(dot(v.vertex.xy, float2(12.9898, 78.233))) * 43758.5453),
                        frac(sin(dot(v.vertex.yz, float2(12.9898, 78.233))) * 43758.5453),
                        frac(sin(dot(v.vertex.zx, float2(12.9898, 78.233))) * 43758.5453)
                    );
                    v.vertex.xyz += (noise - 0.5) * _ChaosStrength;
                }

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 textureColor = tex2D(_MainTex, i.uv);

                if (i.uv.y > 0.5) {
                    // aplicar efeito fresnel
                    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                    float fresnelFactor = pow(1.0 - dot(viewDir, i.worldNormal), _FresnelPower);
                    fixed4 fresnelColor = _FresnelColor * fresnelFactor;

                    return textureColor * _TopColor + fresnelColor;
                } else {
                    return textureColor * _BottomColor;
                }
            }

            ENDCG
        }
    }
}