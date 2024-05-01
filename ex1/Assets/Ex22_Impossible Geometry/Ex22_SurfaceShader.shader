Shader "Custom/Ex22_SurfaceShader"
{
    Properties
    {
        _color ("Color", Color) = (1, 0, 0, 0)
        _color_2 ("Color_2", Color) = (1, 0, 0, 0)
        _range ("Range", Range(-3, 3)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        // Tags { "Queue" = "Transparent" }

        Cull off

        LOD 200

        CGPROGRAM

        #pragma surface surf BlinnPhong
        #pragma target 3.0

        struct Input
        {
            float2 uvMainTex;
            float3 viewDir;
        };

        fixed3 _color;
        fixed3 _color_2;
        fixed _range;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _color;
        }

        ENDCG
    }
    FallBack "Diffuse"
}