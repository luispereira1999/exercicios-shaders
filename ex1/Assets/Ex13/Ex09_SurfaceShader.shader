Shader "Custom/Ex09_SurfaceShader"
{
    Properties
    {
        _main_texture ("Main Texture", 2D) = "defaulttexture" {}
        _secondary_texture ("Secondary Texture", 2D) = "defaulttexture" {}
        _third_texture ("Third Texture", 2D) = "defaulttexture" {}
        _range ("Range", Range(0, 1)) = 1
    }
    SubShader
    {
        Cull off

        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input
        {
            float2 uv_main_texture;
            float2 uv_secondary_texture;
            float2 uv_third_texture;
        };

        sampler2D _main_texture;
        sampler2D _secondary_texture;
        sampler2D _third_texture;
        float _range;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Alpha = 1;

            float fakeUvs = IN.uv_third_texture;
            float base = tex2D(_main_texture, IN.uv_main_texture);
            float base2 = tex2D(_secondary_texture, IN.uv_secondary_texture);
            float base3 = tex2D(_third_texture, IN.uv_third_texture);

            // o.Albedo = base;

            // if (base2.r > _range) {
            //     o.Albedo = 0;
            // }

            // if (base2.r > _range - 0.1) {
            //     o.Albedo = float3(1, 0, 0);
            // }


            o.Albedo = base;

            if (any(base2 < _range + 0.1)) {
                o.Albedo = base3;
                o.Emission = base3;
            }

            clip(base2 - _range);
        }

        ENDCG
    }
    FallBack "Diffuse"
}