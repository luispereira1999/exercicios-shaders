//     "PASTA /NOME_DO_SHADER  "
Shader "Custom/Ex01SurfaceShader"
{
    Properties
    {
        // devem iniciar com "_"
        // sempre que declarar uma propriedade, redeclarar em baixo na sec��o do Shader
        _MainColor ("Main Color", Color) = (0, 0, 0, 0)
        _Intensity ("Intensity", Range (-1, 7)) = 1
        _Alpha ("Alpha", Range (0, 1)) = 1
        _EmissionColor ("Emission Cor", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        // define a renderiza��o como transparente,
        // para que seja poss�vel visualizar o objeto com "alpha" com o jogo a rodar
        Tags { "Queue" = "Transparent" }

        // desativa o culling de faces,
        // por outras palavras, renderiza por fora e por dentro
        cull off

        // indica que o c�digo ser� escrito em C for Graphics
        CGPROGRAM

        // utilizar alpha - permite o uso do alpha no shader
        #pragma surface surf BlinnPhong alpha

        // estrutura que armazena informa��es sobre os atributos dos v�rtices que s�o acedidos na fun��o surf
        struct Input
        {
            float2 uvMainTexture;
        };

        // declara��o das propriedades para que seha poss�vel manipul�-las
        fixed3 _MainColor;
        fixed _Intensity;
        fixed _Alpha;
        fixed3 _EmissionColor;

        fixed3 invertColor(fixed3 ogColor) {
            return 1 - ogColor;
            // return fixed3(1, 1, 1) - ogColor;  // � a mesma opera��o
        }

        // fun��o para renderizar shader
        void surf(Input IN, inout SurfaceOutput o) {
            // multiplicar por um escalar - aumenta/diminui a intensidade da cor
            // o.Albedo = _MainColor * _Intensity;


            // uso de if e else - altera a cor dependendo da intensidade
            // fixed3 colorBlue = fixed3(0, 0, 1);
            // fixed3 colorRed = fixed3(1, 0, 0);

            // if (_Intensity > 0.5) {
            //     o.Albedo = colorBlue;
            // }
            // else {
            //     o.Albedo = colorRed;
            // }


            // inverte a cor, aplica o alpha
            o.Albedo = invertColor(_MainColor) * _Intensity;
            o.Alpha = _Alpha;
            o.Emission = _EmissionColor;
        }

        ENDCG
    }
    Fallback "diffuse"
}