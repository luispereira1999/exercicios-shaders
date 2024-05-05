Shader "Stencils/StencilGeometry" {
	Properties {
		_StencilMask("Stencil Mask", Int) = 0
		_Color ("Color", Color) = (1,1,1,1)
		_Texture ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Stencil
		{
			Ref[_StencilMask]
			Comp equal
			Pass keep
			Fail keep
		}

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		struct Input
		{
			float2 uv_Texture;
		};

		sampler2D _Texture;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D(_Texture, IN.uv_Texture) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
