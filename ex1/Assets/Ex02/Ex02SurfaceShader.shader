Shader "Custom/Ex02SurfaceShader"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _Intensity ("Intensity", Range (-1, 5)) = 0.5
        _WorldPosition ("World Position", Range (-1, 4)) = 0.5
        _ScreenPosition ("Screen Position", Range (-1, 1920)) = 0.5
        _EmissionColor ("Emission Color", Color) = (0,0,0,0)
        [Toggle] _EmissionToggle ("Emission Toogle", Int) = 0  
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }

        Cull off

        CGPROGRAM

        #pragma surface surf BlinnPhong alpha

        struct Input {
            float3 worldPos;
            float4 screenPos;
        };

        float3 _MainColor;
        fixed _Intensity;
        float _WorldPosition;
        float _ScreenPosition;
        float3 _EmissionColor;
        int _EmissionToggle;

        void surf(Input IN, inout SurfaceOutput o) {
            // desaparecer objeto consoante a posição do eixo Y do objeto no mundo
            // o.Albedo = _MainColor;
            // o.Alpha = 1;

            // if (IN.worldPos.y < _WorldPosition) {
            //     o.Alpha = 0;
            // }


            // Efeito de mudar a cor automaticamente
            o.Albedo = _MainColor;
            // o.Albedo = IN.screenPos.xyz;
            o.Albedo.x = _SinTime.w;
            o.Albedo.y = _CosTime.w;
            o.Alpha = 1;

            if (_EmissionToggle) {
                o.Emission = _EmissionColor * _Intensity;
            }
        }

        ENDCG
    }
    FallBack "Diffuse"
}