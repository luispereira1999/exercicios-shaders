Shader "Custom/Ex08_SurfaceShader"
{
    Properties
    {
        _main_texture ("Main Texture", 2D) = "defaulttexture" {}
        _secondary_texture ("Secondary Texture", 2D) = "defaulttexture" {}
        _range ("Range", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }

        Cull off

        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input
        {
            float2 uv_main_texture;
            float2 uv_secondary_texture;
        };

        sampler2D _main_texture;
        sampler2D _secondary_texture;
        float _intensity;
        float _range;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Alpha = 1;

            float base = tex2D(_main_texture, IN.uv_main_texture);
            float base2 = tex2D(_secondary_texture, IN.uv_secondary_texture);

            // if (base2.r > _range) {
            //     r.Alpha = 0;
            // }
            // if (base2.r > _range) {
            //     discard;
            // }

            clip(base2 - _range);
            o.Albedo = base;
        }

        ENDCG
    }
    FallBack "Diffuse"
}