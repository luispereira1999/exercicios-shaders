Shader "Custom/Ex15_SurfaceShader"
{
    Properties
    {
        _color ("Color", Color) = (1, 0, 0, 0)
        _color_2 ("Color 2", Color) = (1, 0, 0, 0)
        _thickness ("Thickness", Range(-2, 3)) = 0.4

        _bump_map ("Bump Map", 2D) = "Bump" {}
        _rim_power ("Rim Power", Range(0, 10)) = 3
        _line_thickness ("Line Thickness", Range(0, 60)) = 30
        _line_count ("Line Count", Int) = 3
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        Tags { "Queue" = "Transparent" }

        // Cull off

        LOD 200

        CGPROGRAM

        // #pragma surface surf Lambert alpha
        #pragma surface surf noLight noambient alpha:fade
        #pragma target 3.0

        struct Input
        {
            float2 uv_bump_map;
            float3 viewDir;
            float3 worldPos;
        };

        fixed3 _color;
        fixed3 _color_2;
        sampler2D _bump_map;
        float _thickness;

        float _rim_power;
        float _line_thickness;
        int _line_count;

        void surf(Input IN, inout SurfaceOutput o)
        {
            // centro claro para bordas escuras
            float dotP = dot(normalize(IN.viewDir), normalize(o.Normal));  
            // centro escuro para bordas claras
            float dotPInv = 1 - dotP;

            // versão 1 - holograma
            // alterar para #pragma surface surf Lambert alpha
            // adicionar Cull off
            // o.Albedo = float3(0, 0, 0);
            // o.Emission = (_color * dotPInv) + (_color_2 * dotP);

            // if (dotP > 0.2)
			// {
                // o.Alpha = dotP * _thickness;
			// }


            // versão 2 - holograma
            // alterar para #pragma surface surf Lambert alpha
            // adicionar Cull off
            // o.Albedo = float3(0, 0, 0);
            // o.Emission = (_color * dotPInv) + (_color_2 * dotP);

            // if (dotP < 0.02)
			// {
                // o.Alpha = dotP * _thickness;
			// }


            // versão 2 - holograma
            // alterar para #pragma surface surf noLight noambient alpha:fade
            // remover Cull off
            o.Normal = UnpackNormal(tex2D(_bump_map, IN.uv_bump_map));
            o.Emission = _color;
            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, _rim_power) + pow(frac(IN.worldPos.g * _line_count - _Time.y), _line_thickness);
            o.Alpha = rim;
        }

        float4 LightingnoLight(SurfaceOutput s, float3 lightDir, float atten)
		{
			return float4(0, 0, 0, s.Alpha);
		}

        ENDCG
    }
    FallBack "Diffuse"
}