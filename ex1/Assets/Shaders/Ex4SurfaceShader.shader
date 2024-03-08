Shader "Custom/Ex4SurfaceShader"
{
    Properties
    {  
        _Cor ("Cor geral (Albedo)", Color) = (0,0,0,0)
        _Cor2 ("Emissao", Color) = (0,0,0,0)
        _Intesidade ("intensidade", Range (-1, 7)) = 1
        _LimiteBuild ("build", Range (-1, 1.3)) = 1
        [Toggle] _EmissionON ("Emission on", Int) = 1
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input
        {
            float2 uvMainTex;
            float3 screenPos;
            float3 worldPos;
            float3 viewDir;
        };

        half3 _Cor;
        half3 _Cor2;
        fixed _Intesidade;
        int _EmissionON;
        fixed _LimiteBuild;

        void surf(Input IN, inout SurfaceOutput o)
        {
            // efeito de desaparecer/aparecer na parte do shader que falta construir
            // float height = unity_ObjectToWorld[1][1] = 10;
            // float3 localPos = IN.worldPos - mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
            // o.Albedo = _Cor;
            // o.Alpha = 1;

            // float sinTime = sin(_Time.y * 2);

            // if (localPos.y >= _LimiteBuild * height * 0.1 - 0.1)
            // {
            //     o.Alpha = abs(sinTime) * 0.5;
            // }
            // else
            // {
            //     o.Albedo *= max(0.2, _LimiteBuild * 0.75);
            // }


            // efeito de desaparecer/aparecer na parte do shader que falta construir - versão 2
            o.Albedo = _Cor;

            if (IN.worldPos.y < _LimiteBuild)
            {
                o.Alpha = 1;
            }
            else
            {
                o.Alpha = 0.3;
                o.Emission = float3(0, 0, rsqrt(IN.worldPos.y) * _Intesidade);
                
                // reage à direção da luz
                // o.Emission = float3(dot(normalize(IN.worldPos), _WorldSpaceLightPos0), 0, 0);
                // o.Emission = float3(dot(normalize(IN.worldPos), normalize(_LightColor0)), _LightColor0.y, 0);
            }


            // efeito de desaparecer/aparecer na parte do shader que falta construir - versão 2
            // if (IN.worldPos.y < _LimiteBuild)
            // {
            //     o.Alpha = 1;
            // }
            // else
            // {
            //     o.Alpha = 0.3;
            //     // o.Emission = clamp(IN.worldPos, IN.viewDir, _SinTime.y);
            //     o.Emission = dot(IN.worldPos, IN.viewDir);
            // }
        }

        ENDCG
    }
    FallBack "Diffuse"
}     