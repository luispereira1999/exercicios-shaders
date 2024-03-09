//     "PASTA /NOME_DO_SHADER  "
Shader "Custom/Ex01SurfaceShader"
{
    Properties
    {
        // devem iniciar com "_"
        // sempre que declarar uma propriedade, redeclarar em baixo na secção do Shader
        _MainColor ("Main Color", Color) = (0, 0, 0, 0)
        _Intensity ("Intensity", Range (-1, 7)) = 1
        _Alpha ("Alpha", Range (0, 1)) = 1
        _EmissionColor ("Emission Cor", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        // define a renderização como transparente,
        // para que seja possível visualizar o objeto com "alpha" com o jogo a rodar
        Tags { "Queue" = "Transparent" }

        // desativa o culling de faces,
        // por outras palavras, renderiza por fora e por dentro
        cull off

        // indica que o código será escrito em C for Graphics
        CGPROGRAM

        // utilizar alpha - permite o uso do alpha no shader
        #pragma surface surf BlinnPhong alpha

        // estrutura que armazena informações sobre os atributos dos vértices que são acedidos na função surf
        struct Input
        {
            float2 uvMainTexture;
        };

        // declaração das propriedades para que seha possível manipulá-las
        fixed3 _MainColor;
        fixed _Intensity;
        fixed _Alpha;
        fixed3 _EmissionColor;

        fixed3 invertColor(fixed3 ogColor) {
            return 1 - ogColor;
            // return fixed3(1, 1, 1) - ogColor;  // é a mesma operação
        }

        // função para renderizar shader
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