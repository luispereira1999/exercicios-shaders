Shader "Custom/Ex15_SurfaceShader"
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

        // 1 e 2
        fixed3 _color;

        // 3
        fixed _range;

        // 4
        fixed3 _color_2;

        // 5 
        fixed3 _color_3;
        float _main;
        float _adjust;

        // função em GLSL
        // float randomJoseGLSL(in vec2 _st) {
            // return fract(sin(dot(_st.xy, vec2(12.9898, 78.233))) * 43758.473);
        // }

        // função em HLSL
        float randomJoseHLSL(float2 _st) {
            return frac(sin(dot(_st.xy, float2(12.9898, 78.233))) * 43758.473);
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            // 1
            // o.Albedo = randomJoseHLSL(_color);


            // 2
            // o.Albedo = float3(randomJoseHLSL(_color.xy), randomJoseHLSL(_color.yx), randomJoseHLSL(_color.xz));


            // 3
            // o.Albedo = float3(randomJoseHLSL(float2(IN.worldPos.x, _SinTime.x)), IN.worldPos.x, _range);


            // 4
            // o.Albedo = dot(o.Normal, normalize( IN.viewDir)) > 0.5 ? _color : _color_2;


            // 5
            o.Albedo = dot(o.Normal, normalize( IN.viewDir)) > _main? _color : 
                       dot(o.Normal, normalize( IN.viewDir)) > (_main - _adjust) ? _color_2 : _color_3;
        }

        ENDCG
    }
    FallBack "Diffuse"
}