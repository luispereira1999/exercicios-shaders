Shader "Custom/Ex03SurfaceShader"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (0, 0, 0, 0)
        _BuildPercent ("Build Percent", Range(0, 10)) = 0
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
       
        CGPROGRAM
        #pragma surface surf BlinnPhong alpha

        struct Input
        {
            float2 uvMainTex;
            float4 screenPos;
            float3 worldPos;
        };

        float3 _MainColor;
        float _BuildPercent;

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 localPos = IN.worldPos - mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;         
          
            o.Albedo = _MainColor;
            o.Alpha = 1;

            if (localPos.y > _BuildPercent) {
                o.Alpha = 0.5;
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}