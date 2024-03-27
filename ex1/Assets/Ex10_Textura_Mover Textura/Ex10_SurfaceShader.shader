Shader "Custom/Ex10_SurfaceShader"
{
    Properties
    {
        _color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _range ("Arrow Range", Range(0, 100)) = 0
        [Toggle] _moving ("Moving", Int) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        Cull off

        CGPROGRAM
        #pragma surface surf Standard alpha

        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _color;
        sampler2D _MainTex;
        float _range;
        int _moving;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float2 fakeUV = IN.uv_MainTex;

            if (_moving) {
                fakeUV.x -= _Time.w;
            }

            fixed4 c = tex2D(_MainTex, fakeUV) * _color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}