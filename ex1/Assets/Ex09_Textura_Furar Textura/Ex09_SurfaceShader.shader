Shader "Custom/Ex09_SurfaceShader"
{
    Properties
    {
        _main_texture ("Main Texture", 2D) = "defaulttexture" {}
        _ponto_teste ("Ponto Teste", Vector) = (1, 1, 1, 0)
        _range ("Range", Range(-2, 2)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        Tags { "Queue" = "Transparent" }

        LOD 200

        Cull off

        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input
        {
            float2 uv_main_texture;
            float3 worldPos;
        };

        sampler2D _main_texture;
        float3 _ponto_teste;
        float _range;

        bool isInsideSquare(float3 worldP, float3 pontoT, float rang) {
			return (worldP.y > pontoT.y - rang
				&& worldP.y < pontoT.y + rang
				&& worldP.x > pontoT.x - rang
				&& worldP.x < pontoT.x + rang);
		}

        void surf(Input IN, inout SurfaceOutput o)
        {
            float3 base = tex2D(_main_texture, IN.uv_main_texture);

            // faz um quadrado azul na textura
            if (isInsideSquare(IN.worldPos, _ponto_teste, _range)) {
                o.Albedo = fixed3(0, 0, 1);
            }
            else {
                o.Albedo = base;
            }

            o.Alpha = 1;
        }

        ENDCG
    }
    FallBack "Diffuse"
}