Shader "Custom/Ex13_SurfaceShader"
{
    Properties
    {
        _color ("Color", Color) = (1, 0, 0, 0)
        _main_texture ("Main Texture", 2D) = "defaulttexture" {}
        _thickness ("Thickness", Range(-2, 3)) = 0.4
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        Tags { "Queue" = "Transparent" }

        Cull off

        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_main_texture;
            float3 viewDir;
        };

        fixed3 _color;
        sampler2D _main_texture;
        float _thickness;

        void surf(Input IN, inout SurfaceOutput o)
        {
            float3 base = tex2D(_main_texture, IN.uv_main_texture);

            // centro claro para bordas escuras
            float dotP = dot(normalize(IN.viewDir), normalize(o.Normal));  
            // centro escuro para bordas claras
            float dotPInv = 1 - dotP;

           
            // versão 1 - criar contornos
            // adicionar "alpha" no #pragma surface
            // if (dotP < _thickness) {
            //     o.Emission = float3(1, 0, 0);
            //     o.Albedo = base * _color;
            // }
            // else {
            //     o.Albedo = base * _color;
            // }

            
            // versão 2 - criar contornos
            // adicionar "alpha" no #pragma surface
            // o.Albedo = base;
            // o.Emission = _color * dotP;
            // o.Alpha = dotP;


            // versão 3 - criar contornos
            // remover "alpha" no #pragma surface
            o.Albedo = float3(0, 0, 0);
            o.Emission = _color * pow(dotPInv, _thickness);
        }

        ENDCG
    }
    FallBack "Diffuse"
}