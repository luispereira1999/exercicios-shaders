Shader "Custom/Ex12_SurfaceShader"
{
    Properties
    {
        _color ("Color", Color) = (1, 0, 0, 0)
        _color_2 ("Color", Color) = (0, 0, 1, 0)
        _slider_x ("X da UV", Range(-2, 2)) = 1
        _slider_y ("Y da UV", Range(-2, 2)) = 1
        _albedo_texture ("Albedo Texture", 2D) = "defaulttexture" {}
        _bump_texture ("Bump Texture", 2D) = "defaulttexture" {}
        _range ("Range DotP", Range(-1, 1)) = 0.5
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }

        LOD 200

        Cull off

        CGPROGRAM
        #pragma surface surf BlinnPhong alpha

        #pragma target 3.0

        struct Input
        {
            float2 uv_albedo_texture;
            float2 uv_bump_texture;
            float3 viewDir;
        };

        half3 _color;
        half3 _color_2;
        float _slider_x;
        float _slider_y;
        sampler2D _albedo_texture;
        sampler2D _bump_texture;
        float _range;

        void surf(Input IN, inout SurfaceOutput o)
        {
            // obter normais do modelo para manipular a sombra
            // o.Albedo = _color;

            // fixed3 fakeNormal = o.Normal;
            // fakeNormal.x += _slider_x;
            // fakeNormal.y += _slider_y;
            // o.Normal = fakeNormal;


            // obter normais de uma textura diferente para manipular a sombra
            // o.Albedo = tex2D(_albedo_texture, IN.uv_albedo_texture) * _color;

            // fixed3 fakeNormal = normalize(o.Normal);
            // fixed3 newNormal = UnpackNormal(tex2D(_bump_texture, IN.uv_bump_texture));
            // newNormal.x *= _slider_x;
            // newNormal.y *= _slider_y;
            // o.Normal = newNormal;


            // versão 1 - modificar a cor e a sombra utilizando o produto escalar entre a direção dos pixeis do objeto em direção à câmera com as normais
            // dotP está entre 1- e 1 e o que está entre -1 e 0 não dá para ver
            // float dotP = dot(normalize(IN.viewDir), normalize(o.Normal));
            // o.Albedo = dotP;


            // versão 2 - modificar a cor e a sombra utilizando o produto escalar entre a direção dos pixeis do objeto em direção à câmera com as normais
            // float dotP = dot(normalize(IN.viewDir), normalize(o.Normal));

            // if (dotP > _range) {
            //     o.Albedo = tex2D(_albedo_texture, IN.uv_albedo_texture);
            // }
            // else {
            //     o.Albedo = _color;
            // }


            // versão 3 - modificar a cor e a sombra utilizando o produto escalar entre a direção dos pixeis do objeto em direção à câmera com as normais
            // adicionar "alpha" no #pragma surface
            // float dotP = dot(normalize(IN.viewDir), normalize(o.Normal));

            // o.Albedo = _color;
            // o.Alpha = frac(dotP) * dotP;


            // versão 4 - modificar a cor e a sombra utilizando o produto escalar entre a direção dos pixeis do objeto em direção à câmera com as normais
            // adicionar "alpha" no #pragma surface
            // float dotP = dot(normalize(IN.viewDir), normalize(o.Normal));

            // if (dotP > _range) {
            //     o.Alpha = 1;
            // }
            // else {
            //     o.Alpha = saturate(dotP);
            // }

            // o.Albedo = _color;
            // o.Emission = _color_2 * dotP;


            // versão 5 - modificar a cor e a sombra utilizando o produto escalar entre a direção dos pixeis do objeto em direção à câmera com as normais
            // adicionar "alpha" no #pragma surface
            float dotP = dot(normalize(IN.viewDir), normalize(o.Normal));

            o.Alpha = pow(frac(dotP), 4);
            o.Albedo = _color;
            o.Emission = _color_2 * (1 - dotP);
        }

        ENDCG
    }
    FallBack "Diffuse"
}