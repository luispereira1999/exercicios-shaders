Shader "Custom/Ex17_MyBlinnSurfaceShader"
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
      
        #pragma surface surf MyBlinn
        #pragma target 3.0

        struct Input
        {
            float2 uv_main_texture;
        };

        sampler2D _main_texture;

        half4 LightingMyBlinn(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			half3 halfWay = normalize(lightDir + viewDir);
            
            half diff = max(0, dot(s.Normal, lightDir));  // difuse
            float nh = max(0, dot(s.Normal, halfWay));  // fall off
            float spec = pow(nh, 48.0);  // specular

            float dotNL = dot(normalize(lightDir), s.Normal);

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff * spec) * atten;
            c.a = s.Alpha;

			return c;
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