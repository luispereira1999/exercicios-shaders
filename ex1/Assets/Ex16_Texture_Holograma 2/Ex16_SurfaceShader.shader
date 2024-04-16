Shader "Custom/Ex16_SurfaceShader"
{
    Properties
    {
        _color ("Color", Color) = (1, 0, 0, 0)
        _range ("Range", Range(-3, 3)) = 0.5

        _color_2 ("Color 2", Color) = (1, 0, 0, 0)

        _color_3 ("Color 3", Color) = (1, 0, 0, 0)
        _main ("main", Range (0, 1)) = 0
        _adjust ("adjust", Range (0, 1)) = 0
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
            float3 worldPos;
            float3 viewDir;
        };

        // 1 - 
        fixed3 _color;
        fixed _range;

        // 2 - 
        fixed3 _color_2;

        // 3 - 
        fixed3 _color_3;
        float _main;
        float _adjust;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _color;
        }

        ENDCG
    }
    FallBack "Diffuse"
}