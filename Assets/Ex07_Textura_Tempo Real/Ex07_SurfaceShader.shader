Shader "Custom/Ex07_SurfaceShader"
{
    Properties
    {
        _main_texture ("Main texture", 2D) = "defaulttexture" {}
        [Toggle] _enableEffect ("Enable effect", Int) = 1
        _metallic ("Metallic", Range(0, 1)) = 0.5
        _glossiness ("Glossiness", Range(0, 1)) = 0.5
    }
    SubShader
    {
        CGPROGRAM

        struct Input
        {
            float2 uv_main_texture;
        };

        sampler2D _main_texture;
        int _enableEffect;
        half _metallic;
        half _glossiness;

        // aplicar cores em tempo real à textura
        #pragma surface surf Standard fullforwardshadows

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 mainBase = tex2D(_main_texture, IN.uv_main_texture);
            
            o.Albedo = mainBase.rgb;

            if (mainBase.r < 0.2 && mainBase.g < 0.2 && mainBase.b < 0.2 && _enableEffect) {
                o.Albedo = float3(1, 1, 0) * _SinTime;
                o.Smoothness = _glossiness;
			}

            o.Alpha = mainBase.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}