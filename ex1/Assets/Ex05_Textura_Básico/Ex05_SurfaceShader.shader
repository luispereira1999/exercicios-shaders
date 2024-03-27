Shader "Custom/Ex05_SurfaceShader"
{
    Properties
    {
        _main_texture ("Main Texture", 2D) = "defaultexture" {}
        _intensity ("Intensity", Range(-1, 5)) = 1
    }
    SubShader
    {
        Cull off

        CGPROGRAM
        #pragma surface surf BlinnPhong

        struct Input
        {
            float2 uv_main_texture;
        };

        sampler2D _main_texture;
        float _intensity;

        void surf(Input IN, inout SurfaceOutput o)
        {
            // mostrar textura
            // retorna as uvs da textura 
            float3 baseColor = tex2D(_main_texture, IN.uv_main_texture);
            o.Albedo = baseColor * _intensity;
            

            // trocar as cores da textura
            // float3 alternative = baseColor;
         
            // alternative.y = alternative.x;
            // alternative.x = 0;
            // o.Albedo = alternative;
         
            // alternative.g = alternative.r;
            // if (alternative.b < 0.2) {
            //     alternative *= _intensity;
            // }
            // o.Albedo = alternative;


            // achatar/esticar textura
            // float2 newUvs = IN.uv_main_texture;
            // newUvs.y *= _intensity; 
            // newUvs.x *= _intensity; 
            // float3 newBaseColor = tex2D(_main_texture, newUvs);
            // o.Albedo = newBaseColor * _intensity;


            // mover textura
            // float2 newUvs = IN.uv_main_texture;
            // newUvs.x += _intensity; 
            // newUvs.y += _intensity; 
            // float3 newBaseColor = tex2D(_main_texture, newUvs);
            // o.Albedo = newBaseColor;
        }

        ENDCG
    }
    FallBack "Diffuse"
}