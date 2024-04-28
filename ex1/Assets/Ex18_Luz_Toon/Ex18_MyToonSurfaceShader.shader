Shader "Custom/Ex18_MyToonSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _RampTex ("Ramp Texture", 2D) = "white" {}
    }
    SubShader
    {
        CGPROGRAM
      
        #pragma surface surf MyToon

        struct Input
        {
            float2 uv_MainTex;
        };

        float4 _Color;
        sampler2D _RampTex;

        half4 LightingMyToon(SurfaceOutput s, half3 lightDir, half atten){
            float diffuse = dot(s.Normal, lightDir);  //diffuse
            float h = diffuse * 0.5 + 0.5;  // nao � o half way
            float rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            float4 c;
            c.rgb = s.Albedo * _LightColor0 * (ramp);
            c.a = s.Alpha;  // n�o estamos a usar � just in case
            return c;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
        }

        ENDCG
    }
    FallBack "Diffuse"
}