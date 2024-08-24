Shader "Custom/Ex24_Orange_Shader"
{
    Properties
    {  
        _Cor ("display name", Color) = (0, 0, 0, 0)
        _Cor2 ("display name", Color) = (0, 0, 0, 0)
        _limte ("lmi", Range (0, 8.85)) = 0
    }
    SubShader
    {
        Cull off
        
        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input {
            float4 screenPos;
            float3 worldPos;
        };

        float3 _Cor;
        float3 _Cor2;
        float _limte;

        float3 invColor(float3 ogcolor){
            return 1-ogcolor;
        } 

        void surf(Input IN, inout SurfaceOutput o) {
            float atn = 0.5;
            float4 teste = float4(1,1,0,0);
         
            float3 localPos = IN.worldPos - mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
            o.Albedo = _Cor;
         
            if (IN.worldPos.y > _limte){
                o.Alpha = 0.5;
                o.Emission = _Cor2;
            } else {
                o.Alpha = 1;
            }
        }

        ENDCG
    }
    FallBack "Diffuse"
}