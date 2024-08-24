Shader "Custom/Ex20_FrontBack_SurfaceShader"
{
    Properties
    {
        _front_texture ("Front Texture", 2D) = "defaulttexture" {}
        _back_texture ("Back Texture", 2D) = "defaulttexture" {}
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }

        Cull off  // renderiza por fora e por dentro

        Blend SrcAlpha OneMinusSrcAlpha

        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input
        {
            float2 uv_front_texture;
            float2 uv_back_texture;
            float2 viewDir;
        };

        sampler2D _front_texture;
        sampler2D _back_texture;

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 base = tex2D(_front_texture, IN.uv_front_texture);
            float4 base2 = tex2D(_back_texture, IN.uv_back_texture);
            
            // 1 - virar a textura de trás para frente sem rodar
            // if (dot(o.Normal, normalize(IN.viewDir)) > 0)
			// {
			// 	o.Albedo = base.rgb;
			// }
			// else
			// {
			// 	o.Albedo = base2.rgb;
			// }

            // 2 - virar a textura de trás para frente ao rodar o x
            if (o.Normal.x > 0.1)
            {
				o.Albedo = base.rgb;
			}
            else
			{
				o.Albedo = base2.rgb;
			}

            o.Alpha = 1;
        }

        ENDCG
    }
    FallBack "Diffuse"
}