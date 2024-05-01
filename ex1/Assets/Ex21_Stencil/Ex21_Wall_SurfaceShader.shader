Shader "Custom/Ex21_Wall_SurfaceShader"
{
    Properties
    {
        _texture ("Main Texture", 2D) = "defaulttexture" {}
    }
    SubShader
    {
        Cull off

        // diz quais canais de cor serão afetados/permitidos
        ColorMask RG

        Stencil {
            Ref 1  // referência dentro do stencil
            Comp notequal  // comparação diferente
            Pass keep  // mantém o que estiver no stencil
        }

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_texture;
        };

        sampler2D _texture;

        void surf(Input IN, inout SurfaceOutput o)
        {
            float3 base = tex2D(_texture, IN.uv_texture);
            o.Albedo = base;
        }

        ENDCG
    }
    FallBack "Diffuse"
}