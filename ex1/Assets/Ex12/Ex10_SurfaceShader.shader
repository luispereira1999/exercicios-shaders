Shader "Custom/Ex10_SurfaceShader"
{
    Properties
    {
        _main_texture ("Main Texture", 2D) = "defaulttexture" {}
        _range ("Range", Range(0, 1)) = 1
    }
    SubShader
    {
        Cull off

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_main_texture;
            float3 viewDir;
        };

        sampler2D _main_texture;
        float _range;

        void surf(Input IN, inout SurfaceOutput o)
        {
            float base = tex2D(_main_texture, IN.uv_main_texture);

            float dotP = dot(normalize(IN.viewDir), normalize(o.Normal));

            if (dotP < _range + 0.2) {
                o.Emission = float3(1, 0, 0);
                o.Albedo = base;
            } else {
                o.Albedo = base;
            }
        }

        ENDCG
    }
    FallBack "Diffuse"
}