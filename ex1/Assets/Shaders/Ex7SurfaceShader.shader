Shader "Custom/Ex7SurfaceShader"
{
    Properties
    {
        _textura_principal ("textura princiapl", 2D) = "defaulttexture" {}
        _pontoTeste ("ponto teste", Vector) = (1,1,1,0)
        _range ("range", Range (-2, 2)) = 0
    }
    SubShader
    {
        Cull off
        CGPROGRAM
        
        #pragma surface surf Lambert alpha

        struct Input {
            float2 uv_textura_principal;
            float3 worldPos;
        };

        sampler2D _textura_principal;

        float3 _pontoTeste;
        float _range;

        bool isInsideSquare(float3 worldP, float3 pontT, float rang) {
            return    (worldP.y > pontT.y -rang &&  worldP.y < pontT.y  + rang
            && worldP.x > pontT.x -rang &&  worldP.x < pontT.x  + rang);
        }

        void surf(Input IN, inout SurfaceOutput o) {
            float3 base = tex2D(_textura_principal,IN.uv_textura_principal);

            if (isInsideSquare(IN.worldPos, _pontoTeste, _range)) {
                o.Albedo = fixed3(1, 0, 0);
                o.Alpha = 0;
            } else {
                o.Albedo = base;
                o.Alpha = 1;
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}