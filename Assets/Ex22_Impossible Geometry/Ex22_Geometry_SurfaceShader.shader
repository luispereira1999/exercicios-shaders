Shader "Custom/Ex22_Geometry_SurfaceShader"
{
    Properties
    {
		_stencilMask ("Stencil Mask", Int) = 0
		_color ("Color", Color) = (1, 1, 1, 1)
		_texture ("Texture", 2D) = "white" {}
    }
    SubShader
    {
		Tags { "RenderType" = "Opaque" }
        
        Cull off
        
        LOD 200
        
		Stencil
		{
			Ref[_stencilMask]
			Comp equal
			Pass keep
			Fail keep
		}

        CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
            float2 uv_texture;
        };

        sampler2D _texture;
		fixed4 _color;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 base = tex2D(_texture, IN.uv_texture) * _color;
            o.Albedo = base.rgb;
			o.Alpha = base.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}