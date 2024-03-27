Shader "Custom/Ex06_SurfaceShader"
{
    Properties
    {
        _main_texture ("Main texture", 2D) = "defaulttexture" {}
        _secondary_texture ("Secondary texture", 2D) = "defaulttexture" {}
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
            float2 uv_secondary_texture;
        };

        sampler2D _main_texture;
        sampler2D _secondary_texture;
        int _enableEffect;
        half _metallic;
        half _glossiness;


        // versão BlinnPhong do símbolo
        // #pragma surface surf BlinnPhong

        // void surf(Input IN, inout SurfaceOutput o)
        // {
            // float3 mainBase = tex2D(_main_texture, IN.uv_main_texture);
            // float4 secondaryBase = tex2D(_secondary_texture, IN.uv_secondary_texture);
            
            // o.Albedo = mainBase;

            // if (secondaryBase.a > 0.1 && _enableEffect) {
                // o.Emission = secondaryBase;
			// }
        // }


        // versão metalizada do símbolo
        #pragma surface surf Standard fullforwardshadows

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 mainBase = tex2D(_main_texture, IN.uv_main_texture);
            fixed4 secondaryBase = tex2D(_secondary_texture, IN.uv_secondary_texture);
            
            o.Albedo = mainBase.rgb;

            if (secondaryBase.a > 0.1 && _enableEffect) {
                o.Metallic = _metallic;
                o.Smoothness = _glossiness;
			}

            o.Alpha = mainBase.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}