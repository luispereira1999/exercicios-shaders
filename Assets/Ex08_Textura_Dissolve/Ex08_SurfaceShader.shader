Shader "Custom/Ex08_SurfaceShader"
{
    Properties
    {
        _texture ("Texture", 2D) = "defaulttexture" {}
        _texture_2 ("Texture 2", 2D) = "defaulttexture" {}
        _texture_3 ("Texture 3", 2D) = "defaulttexture" {}
        _range ("Range", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }

        Cull off

        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input
        {
            float2 uv_texture;
            float2 uv_texture_2;
            float2 uv_texture_3;
        };

        sampler2D _texture;
        sampler2D _texture_2;
        sampler2D _texture_3;
        float _range;

        void surf(Input IN, inout SurfaceOutput o)
        {
            float3 base = tex2D(_texture, IN.uv_texture);
            float3 base2 = tex2D(_texture_2, IN.uv_texture_2);
      
            o.Alpha = 1;

            // efeito de dissolve (para aparecer)
            // if (base2.r > _range) {
            //     o.Alpha = 0;
            // }
            // a mesma coisa que o if de cima
            // if (base2.r > _range) {
            //     discard;
            // }
            // o.Albedo = base;


            // efeito de dissolve (para desaparecer)
            // clip(base2 - _range);
            // o.Albedo = base;


            // efeito de dissolve (para desaparecer) com cor
            // o.Albedo = base;
            // if (base2.r < _range) {
            //     o.Alpha = 0;
            // }
            // if (base2.r < _range + 0.1) {
            //     o.Albedo = float3(1, 0, 0);
            // }


            // efeito de dissolve (para desaparecer) com textura
            float fakeUvs = IN.uv_texture_3;
            fakeUvs.x *= _Time.w;
            float3 base3 = tex2D(_texture_3, fakeUvs);

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