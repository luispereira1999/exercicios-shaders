Shader "Custom/Ex11_SurfaceShader"
{
    Properties
    {
        _main_texture ("Main Texture", 2D) = "defaulttexture" {}
        _secondary_texture ("Secondary Texture", 2D) = "defaulttexture" {}
        _cube_map ("Cube Map", Cube) = "defaulttexture" {}
    }
    SubShader
    {
        LOD 200

        Cull off

        CGPROGRAM
        #pragma surface surf Lambert

        #pragma target 3.0

        struct Input
        {
            float2 uv_main_texture;
            float2 uv_secondary_texture;
            float3 worldRefl;
        };

        sampler2D _main_texture;
        sampler2D _secondary_texture;
        samplerCUBE _cube_map;

        // mostrar cube map e refletir o simbolo do super heroi
        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 base = tex2D(_main_texture, IN.uv_main_texture);
            float4 base2 = tex2D(_secondary_texture, IN.uv_secondary_texture);
            float3 base3 = texCUBE(_cube_map, IN.worldRefl);
           
            o.Albedo = base;

            if (base.r > 0.3) {
                o.Albedo.g = o.Albedo.r * base3;
            }
        }

        ENDCG
    }
    FallBack "Diffuse"
}