Shader "Custom/Ex21_Hole_SurfaceShader"
{
    Properties
    {
        _texture ("Main Texture", 2D) = "defaulttexture" {}
    }
    SubShader
    {
        Cull off

        Stencil {
            Ref 1  // refer�ncia dentro do stencil
            Comp always  // diz como deve ser feita a compara��o quando entra no buffer
                         // e always diz para fazer sempre a compara��o
            Pass replace  // substitui o que estiver no stencil
                          // (o que deve ser feito se a compara��o passar)
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha

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