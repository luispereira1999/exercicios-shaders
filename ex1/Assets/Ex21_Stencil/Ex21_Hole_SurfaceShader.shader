    Shader "Custom/Ex21_Hole_SurfaceShader"
{
    Properties
    {
        _main_texture ("Main Texture", 2D) = "defaulttexture" {}
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }

        // Cull off  // renderiza por fora e por dentro
        // Cull back  // o mesmo que não estar definido, ou seja, por padrão
        Cull front  // renderiza a parte de dentro

        Blend SrcAlpha OneMinusSrcAlpha

        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input
        {
            float2 uv_main_texture;
        };

        sampler2D _main_texture;

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 base = tex2D(_main_texture, IN.uv_main_texture);
            o.Albedo = base.rgb;
            o.Alpha = base.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}