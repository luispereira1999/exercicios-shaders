Shader "Custom/Ex19_SurfaceShader"
{
    Properties
    {
        _main_texture ("Main Texture", 2D) = "defaulttexture" {}
        [Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc("Blend Source", Int) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _BlendDst("Blend Destination", Int) = 10
    }
    SubShader
    {
        // https://github.com/GigalightGuy/ShaderPlayground

        // não é preciso colocar alpha no #pragma surface surf
        Blend [_BlendSrc] [_BlendDst]  // https://docs.unity3d.com/Manual/SL-Blend.html
        // BlendOp RevSub  // https://docs.unity3d.com/Manual/SL-BlendOp.html

        Tags { "Queue" = "Geometry+1" }

        Cull off

        CGPROGRAM
        #pragma surface surf Lambert

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