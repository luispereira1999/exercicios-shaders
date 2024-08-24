Shader "Custom/Ex16_MyLambertSurfaceShader"
{
    Properties
    {
        _main_texture ("Albedo", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
      
        #pragma surface surf MyLambert
        #pragma target 3.0

        struct Input
        {
            float2 uv_main_texture;
        };

        sampler2D _main_texture;

        half4 LightingMyLambert(SurfaceOutput s, half3 lightDir, half atten)
		{
			half4 result = float4(0, 0, 0, 1);
            float dotNL = dot(normalize(lightDir), s.Normal);

            result.rgb = s.Albedo * _LightColor0 * dotNL * atten;
            result.a = s.Alpha;

			return result;
		}

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 base = tex2D(_main_texture, IN.uv_main_texture);
            o.Albedo = base;
        }

        ENDCG
    }
    FallBack "Diffuse"
}