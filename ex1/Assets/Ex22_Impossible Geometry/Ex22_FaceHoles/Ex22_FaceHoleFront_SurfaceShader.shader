Shader "Custom/Ex22_FaceHoleFront_SurfaceShader"
{
    Properties
    {
        _texture ("Main Texture", 2D) = "defaulttexture" {}
    }
    SubShader
    {
        Cull off

        Stencil {
            Ref 1
            Comp Equal
            Pass Keep
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