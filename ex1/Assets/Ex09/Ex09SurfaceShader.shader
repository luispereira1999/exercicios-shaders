Shader "Custom/Ex09SurfaceShader"
{
    Properties
    {     
        _textura_principal ("textura princiapl", 2D) = "defaulttexture" {}
        _grossura ("grossura", Range (-1, 1000)) = 0.2
        _cor1("color", Color) = (1,0,0,0)
        _cor2("color", Color) = (1,0,0,0)
    }
    SubShader
    {
        Cull off
        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input {
            float2 uv_textura_principal;
            float3 viewDir;
        };

        sampler2D _textura_principal;
        float _grossura;
        fixed3 _cor1;
        fixed3 _cor2;

        void surf(Input IN, inout SurfaceOutput o) {
            float3 base = tex2D(_textura_principal,IN.uv_textura_principal );

            float dotp =  dot(normalize(IN.viewDir), normalize(o.Normal));
            float dotpInv = 1 - dotp;
            o.Albedo =  float3(0, 0, 0);

            o.Emission = (_cor1 * dotpInv) + (_cor2 * dotp);

            o.Alpha = 1;

            if (dotp > 0.2) {
                o.Alpha = dotp * _grossura;
            }
        }

        ENDCG
    }
    FallBack "Transparent/Diffuse"
}